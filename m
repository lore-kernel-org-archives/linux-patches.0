Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578CC1854
	for <patches@lists.linux.dev>; Sat,  8 Apr 2023 12:25:37 +0000 (UTC)
Date: Sat, 08 Apr 2023 12:25:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680956729; x=1681215929;
	bh=Li9vFOtyOn1yzZsM8xsVc5+dXMyMO7EVK2qob/N7lA8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=TRYjC4gVMn/a6jq0zUpOGC9+Us99TXZ3EPJ9M/Q0Zr+iqSmQHT7eicBvYtlZ/cyES
	 /e7gKccqGecOFm+XJgttupJD2mTcYygdSkR8nR+pInbH0zXY5Q9VL2i21cxRS9kJNP
	 H+g69O7PNbPIlvR0lkH5+ivWTn4IcM44Nj4SSAOYQCV2+tJuXWgMGGwG6sAcy72CMv
	 HCoV785h+6h/zg+2KrCYSUrHGIG+p8oby5HbBotBDaB6Mq4ox5ox2ZEMTEOQXwTUw8
	 bNM2MnwCzj47+E3yviTYfZwKCtdEr+AlpOkt/7iGSEe8LYCYeSJ4xRvPQS3cc5OSxa
	 4yCmUz7YhAWfg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@samsung.com>
Subject: [PATCH v7 01/15] rust: enable the `pin_macro` feature
Message-ID: <20230408122429.1103522-2-y86-dev@protonmail.com>
In-Reply-To: <20230408122429.1103522-1-y86-dev@protonmail.com>
References: <20230408122429.1103522-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This feature enables the use of the `pin!` macro for the `stack_pin_init!`
macro. This feature is already stabilized in Rust version 1.68.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
---
 rust/kernel/lib.rs     | 1 +
 scripts/Makefile.build | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 223564f9f0cc..4317b6d5f50b 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -17,6 +17,7 @@
 #![feature(core_ffi_c)]
 #![feature(dispatch_from_dyn)]
 #![feature(generic_associated_types)]
+#![feature(pin_macro)]
 #![feature(receiver_trait)]
 #![feature(unsize)]

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 76323201232a..ba4102b9d94d 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
 # Compile Rust sources (.rs)
 # ------------------------------------------------------------------------=
---

-rust_allowed_features :=3D core_ffi_c
+rust_allowed_features :=3D core_ffi_c,pin_macro

 rust_common_cmd =3D \
 =09RUST_MODFILE=3D$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
--
2.39.2


