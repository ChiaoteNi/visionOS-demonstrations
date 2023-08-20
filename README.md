# visionOS demonstrations
- This project is designed as a demonstration with the purpose of showcasing a diverse range of features and APIs related to app development for VisionOS
- The content is organized into several distinct parts, each focusing on different aspects. 
  The series will be released incrementally after several iOS@Taipei meetup events.
- As of now, the project has progressed to Part II.

### Part I:
  - There's a Notes.md file that includes the introductions regards to developing the app for the visionOS.
  - Other demonstrations are focused on the features and APIs for the Views and common UIs
    - `ToolsView.swift`:
      - The demo shows a potential way to create a button group with varying z offset.
      - You can extend the usage to create some control bar that is similar to the native keyboard in VisionOS.
    - `WindowBasedDemo`:
      - The glass background effect and z-offset are only supported from the visionOS instead of iOS.
      - Therefore, I made this demonstration to show a potential way to apply some features with these case via the ViewModifier
### Part II:
  - Focus on the features and APIs related to working with 3D models
    - `Model3DAndRealityViewDemo`:
      - In this demonstration, we'll focus on the difference between `Model3D` and `RealityView`
      - There're 2 previews in this demonstration. 
        The other one is a simple demo about the potential usage for the Model3D since we control it in detail.
    - `InteractWithEntityDemo`:
      - It shows 2 different ways to add the entities to the RealityView:
        - add the entire scene with all entities inside the scene
        - add entities separately, so we can decide which entities we want to add instead all of them in a usda file
      - It also shows the way how we can interact with entities, and how to define which entity is allowed users to interact with
        - In this part, you'll find out that the venus entity is not interactable. 
          It's because I didn't add the `collision` component to it intentionally to mention what we should do if we want an entity to be touchable for users.
    - `AttachmentDemo`:
      - To show how to add an attachment to an entity.
      - Thanks to the discussion from the sharing session, we added a gesture to the entity in this demonstration to check the behavior of attachment.
        Please try moving the entity, and you'll notice that the attachment moves with it.
    - `AnimationDemo`:
      - To demonstrate how to apply animation to an entity in RealityView
