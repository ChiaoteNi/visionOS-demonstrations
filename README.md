# visionOS demonstrations
<img src=https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/2caf0047-17c1-4a91-a38c-40e3a0f5886f width=500 />

- This project is designed as a demonstration with the purpose of showcasing a diverse range of features and APIs related to app development for VisionOS
- The content is organized into several distinct parts, each focusing on different aspects. 
  The series will be released incrementally after several iOS@Taipei meetup events.
- As of now, the project has progressed to Part III.

### Part I:
  - There's a Notes.md file that includes the introductions regards to developing the app for the visionOS.
  - Other demonstrations are focused on the features and APIs for the Views and common UIs
    - `ToolsView.swift`:
      - The demo shows a potential way to create a button group with varying z offset.
      - You can extend the usage to create some control bar that is similar to the native keyboard in VisionOS.
    - `WindowBasedDemo`:
      - The glass background effect and z-offset are only supported from the visionOS instead of iOS.
      - Therefore, I made this demonstration to show a potential way to apply some features with these case via the ViewModifier.

### Part II:
  - Focus on features and APIs related to working with 3D models.
    - `Model3DAndRealityViewDemo`:
      - This demonstration highlights the differences between `Model3D` and `RealityView`.
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
      - To demonstrate how to apply animation to an entity in RealityView.

### Part III
  - Introduce features of 3D space drawing.
    - `Create3DPlanesDemo`:
      - It's a pre-practice demonstration for the `ThreeDimensionCanvasDemo`.
      - In this demonstration, I show how to create a plane in visionOS, which is used for making strokes in the subsequent `ThreeDimensionCanvasDemo`.
      <table>
        <tr>
          <th>
          Simplest Plate: Triangle
          </th>
          <th>
          Create a shape with triangles
          </th>
        </tr>
        <tr>
        <tr>
          <th>
          <img width="817" alt="Screenshot 2023-11-05 at 7 38 14 AM" src="https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/45f1ae74-a6e3-4800-aca3-70f00afac006">
          </th>
          <th>
          <img width="817" alt="Screenshot 2023-11-05 at 7 38 49 AM" src="https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/45ae3f96-a386-49d3-87f1-2b6d86e6fc6a">
          </th>
        </tr>
        <tr>
      </table>
    - `ThreeDimensionCanvasDemo`:
      - Demonstrations for showing how to draw lines and points in a spatial space, which include:
        - Create an entity without a USDZ file
        - SpatialEventGesture
        - Update mesh for an existing entity
        - Crate strokes in a spatial space
      - Also, I showed how to use multiple windows to create a separate control panel
      <table>
        <tr>
          <th>
          Points
          </th>
          <th>
          Strokes
          </th>
        </tr>
        <tr>
        <tr>
          <th>
          <img width="817" alt="Screenshot 2023-11-05 at 7 44 03 AM" src="https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/6839d8ab-7aef-4894-a2e6-0e4dd459fd3d">
          </th>
          <th>
          <img width="817" alt="Screenshot 2023-11-05 at 7 41 24 AM" src="https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/0e29baaa-b58c-4019-a34d-9a51f96c5b2e">
          </th>
        </tr>
        <tr>
      </table>

### Part IV:
- Immersive Space
  - Building on the implementation from Part III, extend it to use immersive space.
  - Additionally, improve the implementation of rendering the stroke in the Part IV demonstration.

<table>
        <tr>
        <tr>
          <th>
          <video src="https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/9f3320da-455d-42f0-b5ab-d498496556c0" width="300" />
          </th>
          <th>
          <img src="https://github.com/ChiaoteNi/visionOS-demonstrations/assets/40178645/4c5d0f10-ed1d-4a82-8ae3-ac9adc64b4b8" width="817" />
          </th>
        </tr>
        <tr>
      </table>

