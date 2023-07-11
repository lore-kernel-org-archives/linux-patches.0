Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD15111A4
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:36:25 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-94a355c9028so344627666b.3
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689068184; x=1691660184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tpNSgka6HOUQbghNI4iad00TiEGE4hqZSL3kST/OC3w=;
        b=Ti91ZX6MJ0NfZLQYe73Us+V/cCtLmivVf32T6Xf2KspuQN/HTcSSA9g2lebAH2TQhN
         M917g/IJ0yYA7BsuE+fY6jib84ff2BbHeYYHdD7GCus1Tood8iq9pudMXIAGApmDtGd4
         opZTY0ahW5qJWmjOk9a1uReY5/8HIlRkuYvOrXDOGLvxRlc5ETES8cHD8upbUCEwyrcV
         cmQJcqZwgLshmeP2cWEXLeRyZ6F8E1+DqwshQI+h7PS6PaokWygqwzkipVev6NfY6ooi
         xIzWgbc1lDZuygb5OF4iCT/R0P81bIE5xWiiPhwHzB8T3R1bNjKNR5n/xG+vnkTxNVEt
         5QkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689068184; x=1691660184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tpNSgka6HOUQbghNI4iad00TiEGE4hqZSL3kST/OC3w=;
        b=FtzSr4szZZ4h7G5eq2ct7VxbO7uJEHXDVcuapTvdYfJbnU73bW8n9oTJhMW15abaFk
         sf4D63qykPVrMoCv8M1P0tGi9IMZ4oFxsZ8X/SOHF/unc0l4Mwqp0OXv+7YbRCkaKFoe
         ohKaSOqjBWppzLkckekKwnrhsyK9cpM1iqTB9pEPd2LOYR5eFjls5aF87zwSFo2G2vBZ
         2MeoQMehijnInhmZEd1dsrjwK+TAjNf6SgIMVHiZuoUdhottUqcXGCpQajxA1kytVAfE
         AV8Rm7Ktrl4dV0HVyOEtnSY7FCfzQpRV1jsF7SSB2S9U5xURM+EJuSqPQEaICXHjloHW
         xLpw==
X-Gm-Message-State: ABy/qLZSqV7+3xqskB85RzrGA7Ueta9i6/uoXNY8ip1Y5FLfhBb0H46g
	/cHGLFKUNn+9rpp3N+mlswpA3Ce4DNwPNjk=
X-Google-Smtp-Source: APBJJlEXPkfvK066yngPvjteqmRRMhHSgThqq79DkRpbbWFOsk+9nVl2pGFxKPX6/WUYw7K3M70B7cmLZ6KJrJk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:763a:b0:98e:2b63:9f78 with SMTP
 id jy26-20020a170907763a00b0098e2b639f78mr48893ejc.0.1689068183762; Tue, 11
 Jul 2023 02:36:23 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:32:55 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-2-aliceryhl@google.com>
Subject: [PATCH v3 1/9] rust: add offset_of! macro
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

This macro is used to compute the offset of a field in a struct.

This commit enables an unstable feature that is necessary for using
the macro in a constant. However, this is not a problem as the macro
will become available from the Rust standard library soon [1]. The
unstable feature can be disabled again once that happens.

The macro in this patch does not support sub-fields. That is, you cannot
write `offset_of!(MyStruct, field.sub_field)` to get the offset of
`sub_field` with `field`'s type being a struct with a field called
`sub_field`. This is because `field` might be a `Box<SubStruct>`, which
means that you would be trying to compute the offset to something in an
entirely different allocation. There's no easy way to fix the current
macro to support subfields, but the version being added to the standard
library should support it, so the limitation is temporary and not a big
deal.

Link: https://github.com/rust-lang/rust/issues/106655 [1]
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
---
v2 -> v3:
 * Add comment as suggested in https://lore.kernel.org/rust-for-linux/875y862lr7.fsf@metaspace.dk/
 * Added Reviewed-by from Gary and Benno.

 rust/kernel/lib.rs     | 37 +++++++++++++++++++++++++++++++++++++
 scripts/Makefile.build |  2 +-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 85b261209977..788914fd935f 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -14,6 +14,7 @@
 #![no_std]
 #![feature(allocator_api)]
 #![feature(coerce_unsized)]
+#![feature(const_refs_to_cell)]
 #![feature(dispatch_from_dyn)]
 #![feature(new_uninit)]
 #![feature(receiver_trait)]
@@ -97,3 +98,39 @@ fn panic(info: &core::panic::PanicInfo<'_>) -> ! {
     // instead of `!`. See <https://github.com/rust-lang/rust-bindgen/issues/2094>.
     loop {}
 }
+
+/// Calculates the offset of a field from the beginning of the struct it belongs to.
+///
+/// # Examples
+///
+/// ```
+/// #[repr(C)]
+/// struct Test {
+///     a: u64,
+///     b: u32,
+/// }
+///
+/// assert_eq!(kernel::offset_of!(Test, b), 8);
+/// ```
+#[macro_export]
+macro_rules! offset_of {
+    ($type:path, $field:ident) => {{
+        // Statically ensure that the type has a field of the given name. This ensures that no
+        // deref coercion is happening.
+        let $type { $field: _, .. };
+        let tmp = ::core::mem::MaybeUninit::<$type>::uninit();
+        let outer = tmp.as_ptr();
+        // To avoid warnings when nesting `unsafe` blocks.
+        #[allow(unused_unsafe)]
+        // SAFETY: The pointer is valid and aligned, just not initialised; `addr_of` ensures that
+        // we don't actually read from `outer` (which would be UB) nor create an intermediate
+        // reference.
+        let inner = unsafe { ::core::ptr::addr_of!((*outer).$field) } as *const u8;
+        // To avoid warnings when nesting `unsafe` blocks.
+        #[allow(unused_unsafe)]
+        // SAFETY: The two pointers are within the same allocation block.
+        unsafe {
+            inner.offset_from(outer as *const u8) as usize
+        }
+    }};
+}
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 78175231c969..819510694769 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
 # Compile Rust sources (.rs)
 # ---------------------------------------------------------------------------
 
-rust_allowed_features := new_uninit
+rust_allowed_features := const_refs_to_cell,new_uninit
 
 rust_common_cmd = \
 	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
-- 
2.41.0.255.g8b1d071c50-goog

