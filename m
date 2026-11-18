Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016575;
	b=rp2bJq7tpgCI1O6gRt2Xo5Jz3MyUKBwg24L6tSejSWbu1HpkiCNhF9Ik/QIDLzde4J/N
	 uqy9wC3sjfQiV/vOF4AeTWi2CymTjSIYqS8Vsq40fVKVXjZo9qTGiZ+Ivs39fwAuH+qqG
	 xvuiB5rT4f1LEjl09fmxjB6lAMJPFilMFft3Khlda4I03ZlI2ESKjt/WZjv6fPAtv5+Xm
	 VwQraspRSv2QpSiedNxWb5HMLYF/kISGvORZr+YMuxpHAs7zoOC5K90QLPIY5e5LOYulg
	 34TwMehRzY3d/VYNTGs6axITWtD+mrbkloILD5L55UnOfEr4ADQeO0wpjWs3qeMlP2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GuBpYuGVjgM13OSdcExaud2FzBsD5hRRQo8FHMihgxA=;
	b=UIIKuyo78zETooewsvsIRnjPjPJtsDELq14I3jdfae/IeWisWXclkMas7JPQ8fB6UmTP
	 JJSjfYHFI10Ulk/V5X4LtS1hjbF6X2BUuSazQpsCKPSiADIzmDusAOO1HCH9rw+Ya5kyc
	 7x4JjyMqUljZJG/vi8U6ihkwgvNJIzscXwzlEloRtaWuTyHVV79YShETsXML6TXs5j4ZM
	 WpSS2ybfImGHj3MAhRkvjxJ/jrG7OMLHSwTrw7rYuf9NlNc47i1W8M3S2lzbTEH1K67Zq
	 RILp9SCgm+fKbktijdXCf7OnDucDZBLE77ab63L9C7rxsFeAmjflPXa7bsHFJyk8Iug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=haRlRReH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FCA60A261C;
	Wed, 18 Nov 2026 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=haRlRReH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058F61F000C4;
	Wed, 18 Nov 2026 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016575;
	bh=GuBpYuGVjgM13OSdcExaud2FzBsD5hRRQo8FHMihgxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haRlRReHAVJqxbQxH77zv6VRw475iDn4Grrm7nSkchZxxAMXROz3ygN0aOL29eRrx
	 6rTx/RJLqVf90/qlFPY1TEUP2AeHLU4KAnNWHId42if/vGwtEds+hdEb6HWsjPhfiZ
	 pvFjyIwCjnNjqIpW+7iV72DOrD5l5DzeNKlTkxcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Alsadhan <mo@sdhn.cc>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0578/2651] rust: pin-init: internal: init: support tuple structs in `[pin_]init!`
Date: Wed, 18 Nov 2026 15:30:18 +0100
Message-ID: <20261118150308.536638917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Mohamad Alsadhan <mo@sdhn.cc>

[ Upstream commit d48aa955cb91745ef2e5089f9277a7a95060cce3 ]

Extend the initializer syntax so that a field can be named by an index,
addressing tuple struct fields the same way a struct expression does:

    pin_init!(Foo { 0: value, 1 <- initializer })

Tuple fields are not exposed by a `let` binding to the fields after them,
since they have no name to bind; `_0` would shadow a user variable.

Signed-off-by: Mohamad Alsadhan <mo@sdhn.cc>
[ Fixed incorrect index calculation and cleaned up the code - Gary ]
Link: https://patch.msgid.link/20260904-tuple-struct-v1-3-72c50bd037fd@garyguo.net
Signed-off-by: Gary Guo <gary@garyguo.net>
Stable-dep-of: e30decc3f9a0 ("rust: pin-init: internal: init: emit `slot` using mixed site hygiene")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/pin-init/internal/src/init.rs | 115 +++++++++++++++++------------
 rust/pin-init/src/lib.rs           |  32 +++++++-
 2 files changed, 95 insertions(+), 52 deletions(-)

diff --git a/rust/pin-init/internal/src/init.rs b/rust/pin-init/internal/src/init.rs
index fd0b5ea4a0a30..5920bb281a500 100644
--- a/rust/pin-init/internal/src/init.rs
+++ b/rust/pin-init/internal/src/init.rs
@@ -8,10 +8,13 @@
     parse_quote,
     punctuated::Punctuated,
     spanned::Spanned,
-    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, Path, Token, Type,
+    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, LitInt, Member, Path, Token, Type,
 };
 
-use crate::diagnostics::{DiagCtxt, ErrorGuaranteed};
+use crate::{
+    diagnostics::{DiagCtxt, ErrorGuaranteed},
+    util::*,
+};
 
 pub(crate) struct Initializer {
     attrs: Vec<InitializerAttribute>,
@@ -36,11 +39,11 @@ struct InitializerField {
 
 enum InitializerKind {
     Value {
-        ident: Ident,
+        member: Member,
         value: Option<(Token![:], Expr)>,
     },
     Init {
-        ident: Ident,
+        member: Member,
         _left_arrow_token: Token![<-],
         value: Expr,
     },
@@ -52,9 +55,9 @@ enum InitializerKind {
 }
 
 impl InitializerKind {
-    fn ident(&self) -> Option<&Ident> {
+    fn member(&self) -> Option<&Member> {
         match self {
-            Self::Value { ident, .. } | Self::Init { ident, .. } => Some(ident),
+            Self::Value { member, .. } | Self::Init { member, .. } => Some(member),
             Self::Code { .. } => None,
         }
     }
@@ -229,9 +232,9 @@ fn init_fields(
             cfgs
         };
 
-        let ident = match kind {
-            InitializerKind::Value { ident, .. } => ident,
-            InitializerKind::Init { ident, .. } => ident,
+        let member = match kind {
+            InitializerKind::Value { member, .. } => member,
+            InitializerKind::Init { member, .. } => member,
             InitializerKind::Code { block, .. } => {
                 let stmt = &block.stmts;
                 res.extend(quote! {
@@ -243,27 +246,28 @@ fn init_fields(
                 continue;
             }
         };
+        let ident = member.as_ident();
 
         let slot = if pinned {
             quote! {
                 // SAFETY:
                 // - `slot` is valid and properly aligned.
-                // - `make_field_check` checks that `&raw mut (*slot).#ident` is properly aligned.
-                // - `make_field_check` prevents `#ident` from being used twice, therefore
-                //   `(*slot).#ident` is exclusively accessed and has not been initialized.
+                // - `make_field_check` checks that `&raw mut (*slot).#member` is properly aligned.
+                // - `make_field_check` prevents `#member` from being used twice, therefore
+                //   `(*slot).#member` is exclusively accessed and has not been initialized.
                 (unsafe { #data.#ident(#slot) })
             }
         } else {
             quote! {
                 // For `init!()` macro, everything is unpinned.
                 // SAFETY:
-                // - `&raw mut (*slot).#ident` is valid.
-                // - `make_field_check` checks that `&raw mut (*slot).#ident` is properly aligned.
-                // - `make_field_check` prevents `#ident` from being used twice, therefore
-                //   `(*slot).#ident` is exclusively accessed and has not been initialized.
+                // - `&raw mut (*slot).#member` is valid.
+                // - `make_field_check` checks that `&raw mut (*slot).#member` is properly aligned.
+                // - `make_field_check` prevents `#member` from being used twice, therefore
+                //   `(*slot).#member` is exclusively accessed and has not been initialized.
                 (unsafe {
                     ::pin_init::__internal::Slot::<::pin_init::__internal::Unpinned, _>::new(
-                        &raw mut (*#slot).#ident
+                        &raw mut (*#slot).#member
                     )
                 })
             }
@@ -273,11 +277,11 @@ fn init_fields(
         let guard = format_ident!("__{ident}_guard", span = Span::mixed_site());
 
         let init = match kind {
-            InitializerKind::Value { ident, value } => {
+            InitializerKind::Value { value, .. } => {
                 let value = value
                     .as_ref()
                     .map(|(_, value)| quote!(#value))
-                    .unwrap_or_else(|| quote!(#ident));
+                    .unwrap_or_else(|| quote!(#member));
 
                 quote! {
                     #(#attrs)*
@@ -294,14 +298,23 @@ fn init_fields(
             InitializerKind::Code { .. } => unreachable!(),
         };
 
+        // A tuple field has no name that could be bound here (the `_0` identifiers are considered
+        // implementation detail and not user-facing).
+        let binding = match member {
+            Member::Named(ident) => quote! {
+                #(#cfgs)*
+                // Allow `non_snake_case` since the same warning is going to be reported for the
+                // struct field.
+                #[allow(unused_variables, non_snake_case)]
+                let #ident = #guard.let_binding();
+            },
+            Member::Unnamed(_) => quote!(),
+        };
+
         res.extend(quote! {
             #init
 
-            #(#cfgs)*
-            // Allow `non_snake_case` since the same warning is going to be reported for the struct
-            // field.
-            #[allow(unused_variables, non_snake_case)]
-            let #ident = #guard.let_binding();
+            #binding
         });
 
         guards.push(guard);
@@ -326,9 +339,9 @@ fn make_field_check(
 ) -> TokenStream {
     let field_attrs: Vec<_> = fields
         .iter()
-        .filter_map(|f| f.kind.ident().map(|_| &f.attrs))
+        .filter_map(|f| f.kind.member().map(|_| &f.attrs))
         .collect();
-    let field_name: Vec<_> = fields.iter().filter_map(|f| f.kind.ident()).collect();
+    let field_name: Vec<_> = fields.iter().filter_map(|f| f.kind.member()).collect();
     let zeroing_trailer = match init_kind {
         InitKind::Normal => None,
         InitKind::Zeroing => Some(quote! {
@@ -376,7 +389,8 @@ fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
             let lh = content.lookahead1();
             if lh.peek(End) || lh.peek(Token![..]) {
                 break;
-            } else if lh.peek(Ident) || lh.peek(Token![_]) || lh.peek(Token![#]) {
+            } else if lh.peek(Ident) || lh.peek(LitInt) || lh.peek(Token![_]) || lh.peek(Token![#])
+            {
                 fields.push_value(content.parse()?);
                 let lh = content.lookahead1();
                 if lh.peek(End) {
@@ -450,31 +464,36 @@ fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
 impl Parse for InitializerKind {
     fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
         let lh = input.lookahead1();
-        if lh.peek(Token![_]) {
-            Ok(Self::Code {
+        let member = if lh.peek(Token![_]) {
+            return Ok(Self::Code {
                 _underscore_token: input.parse()?,
                 _colon_token: input.parse()?,
                 block: input.parse()?,
+            });
+        } else if lh.peek(Ident) || lh.peek(LitInt) {
+            input.parse::<Member>()?
+        } else {
+            return Err(lh.error());
+        };
+
+        let lh = input.lookahead1();
+        if lh.peek(Token![<-]) {
+            Ok(Self::Init {
+                member,
+                _left_arrow_token: input.parse()?,
+                value: input.parse()?,
+            })
+        } else if lh.peek(Token![:]) {
+            Ok(Self::Value {
+                member,
+                value: Some((input.parse()?, input.parse()?)),
+            })
+        } else if matches!(member, Member::Named(_)) && (lh.peek(Token![,]) || lh.peek(End)) {
+            // Short-hand syntax, available for named fields only.
+            Ok(Self::Value {
+                member,
+                value: None,
             })
-        } else if lh.peek(Ident) {
-            let ident = input.parse()?;
-            let lh = input.lookahead1();
-            if lh.peek(Token![<-]) {
-                Ok(Self::Init {
-                    ident,
-                    _left_arrow_token: input.parse()?,
-                    value: input.parse()?,
-                })
-            } else if lh.peek(Token![:]) {
-                Ok(Self::Value {
-                    ident,
-                    value: Some((input.parse()?, input.parse()?)),
-                })
-            } else if lh.peek(Token![,]) || lh.peek(End) {
-                Ok(Self::Value { ident, value: None })
-            } else {
-                Err(lh.error())
-            }
         } else {
             Err(lh.error())
         }
diff --git a/rust/pin-init/src/lib.rs b/rust/pin-init/src/lib.rs
index f1463be9479d6..1aa3973bca347 100644
--- a/rust/pin-init/src/lib.rs
+++ b/rust/pin-init/src/lib.rs
@@ -569,7 +569,7 @@ macro_rules! stack_try_pin_init {
     };
 }
 
-/// Construct an in-place, fallible pinned initializer for `struct`s.
+/// Construct an in-place, fallible pinned initializer for structs, including tuple structs.
 ///
 /// The error type defaults to [`Infallible`]; if you need a different one, write `? Error` at the
 /// end, after the struct initializer.
@@ -603,6 +603,28 @@ macro_rules! stack_try_pin_init {
 /// # Box::pin_init(demo()).unwrap();
 /// ```
 ///
+/// The fields of a tuple struct are addressed by their index:
+///
+/// ```rust
+/// # use pin_init::*;
+/// # use core::pin::Pin;
+/// #[pin_data]
+/// struct Pair(usize, Bar);
+///
+/// #[pin_data]
+/// struct Bar {
+///     x: u32,
+/// }
+///
+/// # fn demo() -> impl PinInit<Pair> {
+/// let initializer = pin_init!(Pair {
+///     0: 42,
+///     1 <- Bar { x: 64 },
+/// });
+/// # initializer }
+/// # Box::pin_init(demo()).unwrap();
+/// ```
+///
 /// Arbitrary Rust expressions can be used to set the value of a variable.
 ///
 /// The fields are initialized in the order that they appear in the initializer. So it is possible
@@ -721,9 +743,11 @@ macro_rules! stack_try_pin_init {
 ///
 /// # Syntax
 ///
-/// As already mentioned in the examples above, inside of `pin_init!` a `struct` initializer with
-/// the following modifications is expected:
+/// As already mentioned in the examples above, inside of `pin_init!` a struct initializer with the
+/// following modifications is expected:
 /// - Fields that you want to initialize in-place have to use `<-` instead of `:`.
+/// - Tuple struct fields are named by their index, as in `0: value` or `0 <- initializer`. They
+///   are not exposed by a `let` binding, since they have no name to bind.
 /// - You can use `_: { /* run any user-code here */ },` anywhere where you can place fields in
 ///   order to run arbitrary code.
 /// - In front of the initializer you can write `&this in` to have access to a [`NonNull<Self>`]
@@ -762,7 +786,7 @@ macro_rules! stack_try_pin_init {
 /// [`NonNull<Self>`]: core::ptr::NonNull
 pub use pin_init_internal::pin_init;
 
-/// Construct an in-place, fallible initializer for `struct`s.
+/// Construct an in-place, fallible initializer for structs, including tuple structs.
 ///
 /// This macro defaults the error to [`Infallible`]; if you need a different one, write `? Error`
 /// at the end, after the struct initializer.
-- 
2.53.0



