Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A265A20D503;
	Fri,  7 Mar 2025 22:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387915; cv=none; b=Ai1C76yh5vDzPj855ME3N4o9mkngecE6VR//Kx+legiwluXxLCaCNFQfhPcM53FiGWKRWSzF0sGBSSZBvTPr5CGL2E4nmrnZ/or7o5hd4q2IKp47BI7JKrSQQtrCvJwhaI/RNRHeykAlRp4Ax5qZ7OIzI9poZg2ahlOJNO9/2C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387915; c=relaxed/simple;
	bh=qc4QrBNJesFQBeuDTq10bX6lOYQzlOA7Rre+242h7mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7Qls2L01NT+C1e8AJ33EIco+2OT3gNhzoGyQoI9tsSnNoGXPpt788N36UshhjqIyu4woufbOs4DbC7p/2nOj0y9K0+HbYdvS62KIEluApRdsIQS9nspY5tx559Gp5MzOtiYVACbWx0fT90SlXHKqPiyjJplHZwsF9XMvX12k4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDVZWjAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDVZWjAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA542C4CED1;
	Fri,  7 Mar 2025 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387915;
	bh=qc4QrBNJesFQBeuDTq10bX6lOYQzlOA7Rre+242h7mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDVZWjAlVRgzC5U4P9anccYT/yDbCvWaKBVXh7cJSOBVbXHNl31PJT1MzOqan/XRj
	 hLhjBfxZimLdbGLpsLaIVcqT5wCyintede5aIkAxoiNGmknCCNO+vxjA2zOmWpgPgC
	 OQl+2z2U9LkczotZ6XKE/0OYn/aEBLWAMUeKEBX0irkzzULnE1SYrRfnsoj4HvJm9H
	 Hwux32osuX3WBrewatTroXw7kMaNQ7h9G47fjwFq4TlTb7B9TjD46DQyJqOrUqZfsD
	 CW0uSIBn5z4IImnfsNeKmd52KWXdmMuhg2wzTA9sCjqs+uT7G4LxaTgolBlVqYd66u
	 dvQ5U7vZ8Ulug==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 29/60] rust: alloc: add __GFP_NOWARN to `Flags`
Date: Fri,  7 Mar 2025 23:49:36 +0100
Message-ID: <20250307225008.779961-30-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 01b2196e5aac8af9343282d0044fa0d6b07d484c upstream.

Some test cases in subsequent patches provoke allocation failures. Add
`__GFP_NOWARN` to enable test cases to silence unpleasant warnings.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-11-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindings/bindings_helper.h | 1 +
 rust/kernel/alloc.rs            | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index ae82e9c941af..a80783fcbe04 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -31,4 +31,5 @@ const gfp_t RUST_CONST_HELPER_GFP_KERNEL_ACCOUNT = GFP_KERNEL_ACCOUNT;
 const gfp_t RUST_CONST_HELPER_GFP_NOWAIT = GFP_NOWAIT;
 const gfp_t RUST_CONST_HELPER___GFP_ZERO = __GFP_ZERO;
 const gfp_t RUST_CONST_HELPER___GFP_HIGHMEM = ___GFP_HIGHMEM;
+const gfp_t RUST_CONST_HELPER___GFP_NOWARN = ___GFP_NOWARN;
 const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL;
diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index b5605aab182d..8172106a1423 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -91,6 +91,11 @@ pub mod flags {
     /// use any filesystem callback.  It is very likely to fail to allocate memory, even for very
     /// small allocations.
     pub const GFP_NOWAIT: Flags = Flags(bindings::GFP_NOWAIT);
+
+    /// Suppresses allocation failure reports.
+    ///
+    /// This is normally or'd with other flags.
+    pub const __GFP_NOWARN: Flags = Flags(bindings::__GFP_NOWARN);
 }
 
 /// The kernel's [`Allocator`] trait.
-- 
2.48.1

