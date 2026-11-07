Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062691;
	b=2jgsB/4cCbLXK7euWq57MUOyP+66dOc3fC5LH43Mq9qXVKg+1RV9FcwGZzuaRUYb35yy
	 GQv5MnpDm62KWK8HDTc9045W8L+2d9Q7oYTA1j/ujYWc3x31avWiF85NByhLU1z6e1H+0
	 Fy+9yx8/NHA3+j0TYZGXAgaVNYsFsfEuq60Q5/4E3eKER6sybPOnI8dUIIrpZ9TqYGcbU
	 yFgV1CI6xykD3q9Tl99QxlW6h82Q9j2ahbsahYQdM+kdlBzBcY9pycXKmB14jGfCIVG+0
	 UAjhL25N+vDG3D+F6egKsUAzZBhA1n0IXfKlj7fk+h8aENMRy6KjTbZzMLxrb0jQTKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/s72kLqAnwh8oqhhhnxEMwZQoLmlAHYe4nyP0RNCAL4=;
	b=IOCp9H2/a1XCaCieqHReNtuqUYmxGJxpKX0k/VZn0zwY294IyQ7KCVHqOK2j3+uBCXEg
	 YlT8Mgpcrc83glT7cRWJOFAzXTKFGxW1cjZpWf8Tm+nFgT6mRRqT68v+bf6pN7aEKqCdj
	 JJKuncX5AhCx0nbXA/5hc48yt7b7xaNxPS3dNbKriFpivSfV/hvYAhAtzs1DeNEaAnnbW
	 ZqadSJVIChkABF1qaRnmaHQ95na7SjN97jSq8hXO2hsHXlNBR4l4W4avNdq1Yo1l48bj4
	 ZCmpn/l1LM/GKpXhAfNa2Txu3Ve3sUJjobkmj4ETxr1LruWX635Jm4tRm3yLoUek4UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFRZtXGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC19606A32D;
	Sat,  7 Nov 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFRZtXGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5E21F0089F;
	Sat,  7 Nov 2026 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062691;
	bh=/s72kLqAnwh8oqhhhnxEMwZQoLmlAHYe4nyP0RNCAL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFRZtXGx+Y1gKF/GLsOUNE4FKJFHJ/5MgFJBfEApRc/Cz7BPoE7djN4aNZWb6um1u
	 Ovn6EcegCvnYwA6RS+LoUxosbTszgH4FZ6Dlhchkn15Mtxep6vSqLIYEnBKfKWFG3f
	 ukMgL7wP9aZt/2KYpLEwcAAd+uwidQvceSN8OxwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/869] rust: dma: declare cfi_encoding for dma_data_direction
Date: Sat,  7 Nov 2026 08:45:00 -0500
Message-ID: <20261107134852.593799012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sami Tolvanen <samitolvanen@google.com>

commit 7d109178cd644268326cd31702ed46c7ac8bb300 upstream.

bindgen generates bindings::dma_data_direction as an integer by default,
while C callback tables such as dma_buf_ops declare the parameter as
enum dma_data_direction. kCFI encodes enum types by name even with
integer normalization, so the type ids would not match when C calls into
a Rust callback taking bindings::dma_data_direction.

Generate dma_data_direction as a newtype with a cfi_encoding, as is done
for lru_status, and convert DataDirection through the newtype's
constants.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c2437c43cfb1 ("rust: dma: implement DataDirection")
Link: https://patch.msgid.link/20261019-rust-cfi-fixes-v1-3-9503472ba738@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ Replaced bindgen's custom enum attribute option with sed
  post-processing to support older bindgen. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile           |  1 +
 rust/bindgen_parameters |  1 +
 rust/kernel/dma.rs      | 21 +++++++++++----------
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 3f1abad648e66..d6429e68949fe 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -368,6 +368,7 @@ $(obj)/bindings/bindings_generated.rs: private bindgen_target_flags = \
     $(shell grep -Ev '^#|^$$' $(src)/bindgen_parameters)
 $(obj)/bindings/bindings_generated.rs: private bindgen_target_extra = ; \
     sed -Ei 's/pub const RUST_CONST_HELPER_([a-zA-Z0-9_]*)/pub const \1/g' $@; \
+    sed -Ei 's/^pub struct dma_data_direction\(/#[cfi_encoding="18dma_data_direction"]\n&/' $@; \
     sed -Ei 's/^pub struct hrtimer_restart\(/#[cfi_encoding="15hrtimer_restart"]\n&/' $@; \
     sed -Ei 's/^pub struct irqreturn\(/#[cfi_encoding="9irqreturn"]\n&/' $@
 $(obj)/bindings/bindings_generated.rs: $(src)/bindings/bindings_helper.h \
diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index 6f76fdcffd58d..a5d547dc8e8ea 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -24,6 +24,7 @@
 --opaque-type spinlock
 
 # enums that appear in indirect function calls should specify a cfi type
+--newtype-enum dma_data_direction
 --newtype-enum hrtimer_restart
 --newtype-enum irqreturn
 
diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index 4ce9e5d7f3dd0..b6c73db358ced 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -267,25 +267,25 @@ pub enum DataDirection {
     ///
     /// This is used when the buffer can be both read from and written to by the device.
     /// The cache for the corresponding memory region is both flushed and invalidated.
-    Bidirectional = Self::const_cast(bindings::dma_data_direction_DMA_BIDIRECTIONAL),
+    Bidirectional = Self::const_cast(bindings::dma_data_direction::DMA_BIDIRECTIONAL),
 
     /// The DMA mapping is for data transfer from memory to the device (write).
     ///
     /// The CPU has prepared data in the buffer, and the device will read it.
     /// The cache for the corresponding memory region is flushed before device access.
-    ToDevice = Self::const_cast(bindings::dma_data_direction_DMA_TO_DEVICE),
+    ToDevice = Self::const_cast(bindings::dma_data_direction::DMA_TO_DEVICE),
 
     /// The DMA mapping is for data transfer from the device to memory (read).
     ///
     /// The device will write data into the buffer for the CPU to read.
     /// The cache for the corresponding memory region is invalidated before CPU access.
-    FromDevice = Self::const_cast(bindings::dma_data_direction_DMA_FROM_DEVICE),
+    FromDevice = Self::const_cast(bindings::dma_data_direction::DMA_FROM_DEVICE),
 
     /// The DMA mapping is not for data transfer.
     ///
     /// This is primarily for debugging purposes. With this direction, the DMA mapping API
     /// will not perform any cache coherency operations.
-    None = Self::const_cast(bindings::dma_data_direction_DMA_NONE),
+    None = Self::const_cast(bindings::dma_data_direction::DMA_NONE),
 }
 
 impl DataDirection {
@@ -297,7 +297,7 @@ const fn const_cast(val: bindings::dma_data_direction) -> u32 {
         // CAST: The C standard allows compilers to choose different integer types for enums.
         // To safely check the value, we cast it to a wide signed integer type (`i128`)
         // which can hold any standard C integer enum type without truncation.
-        let wide_val = val as i128;
+        let wide_val = val.0 as i128;
 
         // Check if the value is outside the valid range for the target type `u32`.
         // CAST: `u32::MAX` is cast to `i128` to match the type of `wide_val` for the comparison.
@@ -315,11 +315,12 @@ const fn const_cast(val: bindings::dma_data_direction) -> u32 {
 impl From<DataDirection> for bindings::dma_data_direction {
     /// Returns the raw representation of [`enum dma_data_direction`].
     fn from(direction: DataDirection) -> Self {
-        // CAST: `direction as u32` gets the underlying representation of our `#[repr(u32)]` enum.
-        // The subsequent cast to `Self` (the bindgen type) assumes the C enum is compatible
-        // with the enum variants of `DataDirection`, which is a valid assumption given our
-        // compile-time checks.
-        direction as u32 as Self
+        match direction {
+            DataDirection::Bidirectional => Self::DMA_BIDIRECTIONAL,
+            DataDirection::ToDevice => Self::DMA_TO_DEVICE,
+            DataDirection::FromDevice => Self::DMA_FROM_DEVICE,
+            DataDirection::None => Self::DMA_NONE,
+        }
     }
 }
 
-- 
2.53.0



