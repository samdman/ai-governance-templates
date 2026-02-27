# Project Configuration

## Tech Stack
- .NET 9
- Modular Monolith
- Minimal APIs
- MediatR (free version)
- MassTransit (free version)
- EF Core (standard queries)
- Dapper (performance queries)
- OpenTelemetry
- .NET Aspire
- Central Package Management
- Redis

---

## Design Principles

### SOLID Principles
- **Single Responsibility (SRP)**: Each class/handler should have one reason to change
  - Handlers orchestrate, domain entities contain business logic
  - Validators only validate, repositories only handle data access
  - Avoid "god classes" that do too much

- **Open/Closed (OCP)**: Open for extension, closed for modification
  - Use strategies and policies for varying behavior
  - Extend via composition and configuration, not by modifying existing code
  - New features should add new classes, not modify existing ones

- **Liskov Substitution (LSP)**: Derived types must be substitutable for base types
  - Avoid breaking base class contracts in derived classes
  - If using inheritance, ensure child classes honor parent expectations
  - Prefer composition over inheritance when possible

- **Interface Segregation (ISP)**: Clients shouldn't depend on interfaces they don't use
  - Keep interfaces focused and minimal
  - Split large interfaces into smaller, role-specific ones
  - No "fat interfaces" with many unrelated methods

- **Dependency Inversion (DIP)**: Depend on abstractions, not concretions
  - High-level modules shouldn't depend on low-level modules
  - Both should depend on abstractions (interfaces/contracts)
  - Infrastructure implements domain/application interfaces

### DRY (Don't Repeat Yourself)
- **Avoid code duplication**: Extract common logic into reusable methods/classes
- **Single source of truth**: Each piece of knowledge should exist in one place
- **Shared utilities**: Use shared projects for cross-cutting concerns
- **BUT**: Don't over-abstract prematurely — duplication is better than wrong abstraction
- **Rule of Three**: Wait until code is duplicated 3 times before abstracting

### KISS (Keep It Simple, Stupid)
- **Prefer simple solutions**: Don't over-engineer for hypothetical future needs
- **Avoid clever code**: Clarity beats cleverness
- **Minimal abstractions**: Only add layers that solve real problems
- **Incremental complexity**: Start simple, add complexity only when needed

### YAGNI (You Aren't Gonna Need It)
- **Build for today**: Don't implement features you might need later
- **No speculative generality**: Solve current requirements, not imagined ones
- **Refactor when needed**: Add flexibility when requirements actually change
- **Challenge "future-proofing"**: Most predicted futures never arrive

### Composition Over Inheritance
- **Prefer composition**: Build behavior by combining objects, not inheriting
- **Avoid deep hierarchies**: inheritance chains beyond 2-3 levels get brittle
- **Use interfaces**: Define contracts, implement via composition
- **Inheritance only when**: "is-a" relationship is truly fundamental

### Fail Fast
- **Validate early**: Check preconditions at method entry
- **Throw exceptions**: For invalid states that shouldn't happen
- **Return results**: For expected business failures
- **No silent failures**: Always surface or log errors

### Convention Over Configuration
- **Use standard patterns**: Follow .NET and team conventions
- **Minimal XML/JSON config**: Prefer code-based configuration
- **Sensible defaults**: Require configuration only for what varies
- **Explicit when needed**: Override conventions when they don't fit

---

## Architectural Preferences

### Code Organization
- **Feature folders**: Group by business capability, not technical layer
- **Vertical slicing**: Each feature contains its handler, validation, models in one folder
- **Clean architecture layers**: Domain → Application → Infrastructure → API (strict dependency flow)
- **File naming**: `{Feature}.{Type}.cs` (e.g., `CreateOrder.Command.cs`, `CreateOrder.Handler.cs`)
- **One class per file**: Except for tightly coupled value objects or DTOs
- **Global usings**: Define common namespaces in `GlobalUsings.cs` per project
- **Record-based models**: Prefer `record` for DTOs, commands, queries, and value objects (immutability by default)

### Naming Conventions
- **Commands**: Verb-noun format (`CreateOrder`, `UpdateCustomer`)
- **Queries**: Get/List prefix (`GetOrderById`, `ListActiveCustomers`)
- **Events**: Past tense (`OrderCreated`, `PaymentProcessed`)
- **Handlers**: `{Feature}Handler` (e.g., `CreateOrderHandler`)
- **Validators**: `{Feature}Validator` (e.g., `CreateOrderValidator`)

### Minimal API Standards
- **Route patterns**: `/api/v{version}/{resource}` (e.g., `/api/v1/orders`)
- **Endpoint files**: Group related endpoints in `{Module}.Endpoints.cs`
- **Parameter binding**: Use `[FromBody]`, `[FromRoute]`, `[FromQuery]` explicitly
- **Return types**: Use `Results<T>` for typed responses when possible
- **Filters**: Define at endpoint level, not globally (except auth/cors)

### Domain Design
- **Rich models**: Domain logic in entities, not handlers
- **Value objects**: For concepts with equality by value (Money, Email, etc.)
- **Aggregate boundaries**: Keep small (1-3 entities max)
- **ID types**: Strongly typed IDs (`OrderId`, `CustomerId`) to prevent mixing
- **Invariants**: Validate in constructors and domain methods, not setters

### Abstraction Rules
- **No interfaces** unless 2+ implementations exist or planned
- **No repositories** over EF Core DbSets
- **No base classes** unless reused 3+ times
- **No marker interfaces** (use conventions instead)
- **No service layers** (use MediatR handlers directly)

### Transaction Boundaries
- **One command = one transaction**: Scoped to handler execution
- **Read queries**: No transactions needed
- **Cross-module changes**: Use eventual consistency via events
- **Long-running processes**: Use saga pattern or workflow engine
- **Idempotency**: Command handlers must be idempotent for retries

### Async Patterns
- **All I/O operations**: Must be async
- **Cancellation tokens**: Required on all public async methods
- **No async void**: Except event handlers
- **No Task.Result/Wait**: Use await everywhere
- **ConfigureAwait**: Not needed in ASP.NET Core

### Data Access Patterns
- **EF Core for writes**: Aggregates, CRUD, business logic
- **Dapper for reads**: Heavy queries, reporting, analytics
- **Raw SQL**: Only when performance gains proven (with benchmark)
- **Stored procedures**: Avoid unless legacy integration required
- **Migrations**: Code-first only, no manual SQL in migrations

### Testing Strategy
- **Unit tests**: Handler logic, domain logic, validators
- **Integration tests**: API endpoints with TestContainers
- **Test naming**: `{Method}_{Scenario}_{ExpectedResult}`
- **Arrange-Act-Assert**: Clear separation in all tests
- **Test data builders**: For complex object graphs

### Dependency Injection
- **Constructor injection**: Only, no property/method injection
- **Service lifetimes**: Scoped for DbContext, Singleton for config
- **Avoid factories**: Unless complex initialization required
- **Registration**: Use extension methods per module (`AddOrdersModule()`)

### Configuration
- **Strongly typed options**: Use `IOptions<T>` pattern
- **Validation**: Use `ValidateDataAnnotations()` or `ValidateOnStart()`
- **Secrets**: Never in appsettings.json, use user-secrets/KeyVault
- **Environment-specific**: appsettings.{Environment}.json

### API Versioning
- **URL-based**: `/api/v1/`, `/api/v2/`
- **Breaking changes**: Require new version
- **Deprecation**: Minimum 6 months notice before removal
- **Version headers**: Optional for metadata, not primary mechanism

### Documentation Standards
- **XML comments**: Public APIs and domain models only
- **ADRs (Architecture Decision Records)**: For significant design choices
- **README per module**: Purpose, dependencies, key decisions
- **API documentation**: Auto-generated from code (Swagger/OpenAPI)
