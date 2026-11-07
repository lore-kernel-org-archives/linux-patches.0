Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063820;
	b=Sp9xEHo02qsxnNXXQ8LKYdTO/P9aakoDtA6BWtbijr/GS5U/Xx9rbqWwGsAhjIVPeii8
	 XGcS19Rc8HFvtBedui2DDmmb6aTb/DjkXB8EfeEaEMw1BLVDj5MtlbXkhlK+hqM4Lqzye
	 JsCJaADY8F6pfD0zMJ+bIKyMIpQK6CvraXW63lBnUw4z9cTbwAdXK+aYlRfMPi+WJw2j/
	 MfrcGKMY/JC2iW7BzbLWSIJFqPBiZnjbx8XQ2NNqlOb9nF9Db8+VKrR6+YmX5OpKC2Ljr
	 lytqUmMERV2a1iBx08pGMojwyF+lvyBSieB3QnVi6RPJBVHIUXlH15SyX/wmRj0mvxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sADATc2ResSVDSDVcGHbsrvjedP/deCGjQ1iibVFyh8=;
	b=bi1lnDseyxebrmDGqTy9g5NJ9seV7buqSbLlk4MkPt+e82HxRlM6nIYRSupxarhiN1MW
	 9VLYph7hMYMN/MEDbBH6/JUyGw1+e7KAihj88O8jtqNjgveUp1zWOLcDBk+QUiCZkjG3u
	 +Fd8YXv+blSgLU1Gh5vdGPJvHV05ZteiJuUhhJyvs2c4RXS5e5Z7HvHgSR6Z3p359p9KJ
	 DyvmU2Xm7a7u63NKNGwhOzjVx/OblFLal0trob3U+VS82IjGlkSbJ6nNh6OxELhjAQ73Q
	 ND/snkzQ5OoQ2CQBS71zd2K3hEEbDvxzhCnMm2AgfveTvK9l83ojiZHlWK5967CF23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wp+oMZiI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020AD606A326;
	Sat,  7 Nov 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wp+oMZiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842891F0089F;
	Sat,  7 Nov 2026 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063819;
	bh=sADATc2ResSVDSDVcGHbsrvjedP/deCGjQ1iibVFyh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wp+oMZiISJrWF2e/7iDkpG2NmX3iMDcYVWlAeJk52VPt9HqfFGj+ZFrasIiv8TZ81
	 OSwuN+1FMBxHMEoJOXrVa12znue/GcbRwYZEd1cFkNbADoxgZlBPR9FYUTs7eoiaoS
	 kIhLRZWKhDpnpbuWsb6t3SPyCH4tJNEp7KpAq02c=
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
Subject: [PATCH 7.3 0009/1257] rust: dma: declare cfi_encoding for dma_data_direction
Date: Sat,  7 Nov 2026 08:38:25 -0500
Message-ID: <20261107134939.688409105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ Adjusted insertion context. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/bindgen_parameters |  2 ++
 rust/kernel/dma.rs      | 21 +++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index 45f6eb56a1f73..5bab3cf063360 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -29,6 +29,8 @@
 # enums that appear in indirect function calls should specify a cfi type
 --newtype-enum fwctl_rpc_scope
 --with-attribute-custom-enum=fwctl_rpc_scope='#[cfi_encoding="15fwctl_rpc_scope"]'
+--newtype-enum dma_data_direction
+--with-attribute-custom-enum=dma_data_direction='#[cfi_encoding="18dma_data_direction"]'
 --newtype-enum hrtimer_restart
 --with-attribute-custom-enum=hrtimer_restart='#[cfi_encoding="15hrtimer_restart"]'
 --newtype-enum irqreturn
diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index 2ce09f8e90c69..2ec5fe7d56bc4 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -310,25 +310,25 @@ pub enum DataDirection {
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
@@ -340,7 +340,7 @@ const fn const_cast(val: bindings::dma_data_direction) -> u32 {
         // CAST: The C standard allows compilers to choose different integer types for enums.
         // To safely check the value, we cast it to a wide signed integer type (`i128`)
         // which can hold any standard C integer enum type without truncation.
-        let wide_val = val as i128;
+        let wide_val = val.0 as i128;
 
         // Check if the value is outside the valid range for the target type `u32`.
         // CAST: `u32::MAX` is cast to `i128` to match the type of `wide_val` for the comparison.
@@ -358,11 +358,12 @@ const fn const_cast(val: bindings::dma_data_direction) -> u32 {
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



