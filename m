Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E05813B2A4;
	Thu, 27 Mar 2025 21:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743110002; cv=none; b=KWpluXLgQZDoFYyCmcqKFXgumQyyoY02Wwd/d8oFYWiQEcKeqrl9D0mPhrgEgHLnLhHstIwlRPVUFvcAqP3+wu3R1No0UMPZZPG8JDN7roDq8ExNsAxrK/VlWuLd5SKHYrCoB5FDZeUjK4cZ/rLfHFfGojet37n1kRvitfZGC7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743110002; c=relaxed/simple;
	bh=+DUyoXuhqT4PPfZDRewna3BdpkfBTCdpkJDTLMXYvTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VTeUqvxNQA3ScBCctr3v8bbXG8ENOBvpAswqEAmzGjBmQ4B26WNDyBBd/JtYPSZqvmwZf6uPvGRU0yGVfOgKlEYa9gZ+hBFgDmlusDbosPShfJB7rv4STIdKnk4E8ao+PQAV04x/tKBQrD7cXatNqg3DyYLoa+OPrwncb2zzarQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Up+O3Ti7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Up+O3Ti7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0736C4CEDD;
	Thu, 27 Mar 2025 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743110001;
	bh=+DUyoXuhqT4PPfZDRewna3BdpkfBTCdpkJDTLMXYvTE=;
	h=From:To:Cc:Subject:Date:From;
	b=Up+O3Ti70jPCseslsJ6azTnhp8su5BQPYHE362OtwGCVUQR1IbM/utgCgr7eLPRpG
	 779Dh3ixB9lug1xTpNuhCBfAfmBR29ec80CeFcO0LJAZ29TfSEr/v23+kGjXg2p9Cb
	 3CSYrcxFLAC/8PbLI30qIrKsOHwzPrO/hbvM6WVsSZh6bnMnDk0Dl9s8ITGAVRrn3R
	 7WYzteS6tahJKflO8Z/SUzeT61w1RdiLJ6v1+Oo1PSnSM9EpKQTmcSYuYefcs5rKTN
	 wRqGsNMasZUDLnseBmYBSzugt8uZLvuzj1bpEa+e6BgoHbLQ1dYjewSOZq0seDrnp2
	 m8e+dVojdsLaQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: clarify the language unstable features in use
Date: Thu, 27 Mar 2025 22:13:02 +0100
Message-ID: <20250327211302.286313-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We track the details of which Rust features we use at our usual "live
list" [1] (and its sub-lists), but in light of a discussion in the LWN
article [2], it would help to clarify it in the source code.

In particular, we are very close to rely only on stable Rust language-wise
-- essentially only two language features remain (including the `kernel`
crate).

Thus add some details in both the feature list of the `kernel` crate as
well as the list of allowed features.

This does not over every single feature, and there are quite a few
non-language features that we use too. To have the full picture, please
refer to [1].

Link: https://github.com/Rust-for-Linux/linux/issues/2 [1]
Link: https://lwn.net/Articles/1015409/ [2]
Suggested-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/lib.rs     | 27 ++++++++++++++++++++-------
 scripts/Makefile.build |  8 ++++++++
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index ba0f3b0297b2..660a3ab6f9d4 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -12,21 +12,34 @@
 //! do so first instead of bypassing this crate.
 
 #![no_std]
-#![feature(arbitrary_self_types)]
-#![cfg_attr(CONFIG_RUSTC_HAS_COERCE_POINTEE, feature(derive_coerce_pointee))]
-#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(coerce_unsized))]
-#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(dispatch_from_dyn))]
-#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(unsize))]
+
+// Please see https://github.com/Rust-for-Linux/linux/issues/2 for details on
+// the unstable features in use.
+
+// Stable since Rust 1.79.0.
 #![feature(inline_const)]
+
+// Stable since Rust 1.81.0.
 #![feature(lint_reasons)]
-// Stable in Rust 1.82
+
+// Stable since Rust 1.82.0.
 #![feature(raw_ref_op)]
-// Stable in Rust 1.83
+
+// Stable since Rust 1.83.0.
 #![feature(const_maybe_uninit_as_mut_ptr)]
 #![feature(const_mut_refs)]
 #![feature(const_ptr_write)]
 #![feature(const_refs_to_cell)]
 
+// Expected to become stable.
+#![feature(arbitrary_self_types)]
+
+// `feature(derive_coerce_pointee)` is the one expected to become stable.
+#![cfg_attr(CONFIG_RUSTC_HAS_COERCE_POINTEE, feature(derive_coerce_pointee))]
+#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(coerce_unsized))]
+#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(dispatch_from_dyn))]
+#![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(unsize))]
+
 // Ensure conditional compilation based on the kernel configuration works;
 // otherwise we may silently break things like initcall handling.
 #[cfg(not(CONFIG_RUST))]
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 56be83024851..41a640990cfa 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -226,6 +226,14 @@ $(obj)/%.lst: $(obj)/%.c FORCE
 # Compile Rust sources (.rs)
 # ---------------------------------------------------------------------------
 
+# The features in this list are the ones allowed for non-`rust/` code.
+#
+#   - Stable since Rust 1.81.0: `feature(lint_reasons)`.
+#   - Stable since Rust 1.82.0: `feature(asm_const)`, `feature(raw_ref_op)`.
+#   - Stable since Rust 1.87.0: `feature(asm_goto)`.
+#
+# Please see https://github.com/Rust-for-Linux/linux/issues/2 for details on
+# the unstable features in use.
 rust_allowed_features := asm_const,asm_goto,arbitrary_self_types,lint_reasons,raw_ref_op
 
 # `--out-dir` is required to avoid temporaries being created by `rustc` in the

base-commit: e6ea10d5dbe082c54add289b44f08c9fcfe658af
-- 
2.49.0

