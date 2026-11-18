Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016581;
	b=lqK8cyxWZuMGi9BshkEFgvQLkTF89tEvTMMKM5BRnJQjWKI3JpnoerG9sYPyf1I0EGk3
	 DHiL9lOrdPIPi5O7vpibcPNMJEHEmFgd/BRUwcjtf3ox53FNS2lIYteqmVKGWSN0dIqsA
	 wVSkQE8IjS3DhkZhru4XcQNQjrn9FOMJt7dPEKLIhCCPDvTpqkkpLq/r7Ya297dnrBQ0U
	 nuKHUc/nW9g8Skrk0n0QE//MxJtQrtHqdiyiirmtU6+POpOue6A3qcxXhzsA/rzbFDImb
	 k2ZE8a1GI4o/6cP3aoRIKn3L6u2VGC6eDM0/M4Z/uV/ypenhNpU3KVGFuHPExoMEhwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CEoZ52DHjxKtvAMWi68JjGalM+LHAXkOs8dAEEygXcI=;
	b=hC62lUV5nvYs9FvXXkEXokJWX5pSVySqwRllM7ThIKhe7CrciTAdeexRwpefF+vjJ+VL
	 IfMY6pHn8YWMyKfU1qnPiogEm+/nzPKj9nS7mE7F44qUD0jmTYU3Gq3xJtv6UuhaN07h0
	 zR71GXbWYkv3wRT+fcHzES+9lOW3CQ9bRkGGWYXxx49SHY1CD2jNs4NjsQDZJZtJ/gWuj
	 zD+7R+1Rn5JgLDh+Di3dY4bxcbbPyL2XApnYWSuRkSDSTZtSFhKyOI5GI2muHUx6ObmBa
	 dz+UKdrbv+P+eHz2AH1KukS5zE7tQ8mU7u65w/SPITr7dkox3y1w9oldFi9rMyuNGlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSEy6273;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B18606A33F;
	Wed, 18 Nov 2026 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSEy6273
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22461F000C5;
	Wed, 18 Nov 2026 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016581;
	bh=CEoZ52DHjxKtvAMWi68JjGalM+LHAXkOs8dAEEygXcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSEy6273u4NtEXrHrfqXkMv27VYJLjEBzQn2T5VhxdLgLfKVVaglvLTXp0+iMKBDm
	 3GfPpeQn7h/GXBXIyjM/vX6UBt5ZfLA30x8yVMiJXWvaUABBCdsnjAOmHlhAc5owIb
	 N5sE38EgdZzyL6IpQZ266H3W0+2Gr9qxMKWwNf2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Mohamad Alsadhan <mo@sdhn.cc>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0579/2651] rust: pin-init: internal: init: support tuple struct constructor syntax
Date: Wed, 18 Nov 2026 15:30:19 +0100
Message-ID: <20261118150308.574020217@linuxfoundation.org>
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

[ Upstream commit 3b3ff9034a497fb3b8429f6fe8ba5697bc7dcebd ]

A tuple struct whose fields are all set to a value reads better written
like a call to its constructor than with the indices spelled out:

    pin_init!(Foo(value, value))

Parse the two forms into separate types and rewrite the constructor
arguments into the indexed fields they are shorthand for, so that only the
parser has to know about the second form.

The arguments have no names, so they cannot use `<-`. Parse it anyway and
reject it afterwards, which reports the position of every offending `<-`
rather than stopping at the first one.

`cfg` needs different treatment for tuple constructor syntax. As non-derive
proc macros are invoked before cfg is resolved, the macro cannot know
whether a field survives, and dropping a tuple field renumbers every field
after it. That cannot be expressed by attaching a `cfg` attribute to the
initializer of a single field. Thus, resolve tuple field cfgs up front
instead, by generating two cfg-gated invocations of the macro with one
field resolved in each. This is the approach of commit 5bbf2b2deb94 ("rust:
pin-init: internal: rework how `#[pin_data]` handles cfg"), and it is
linear time because only one of the two branches is ever expanded. Struct
expression syntax do not renumber, so using tuple structs with struct
syntax can keep using the existing attribute-based handling.

Suggested-by: Gary Guo <gary@garyguo.net>
Link: https://github.com/Rust-for-Linux/pin-init/pull/165
Signed-off-by: Mohamad Alsadhan <mo@sdhn.cc>
[ Pre-expand cfgs for tuple init syntax. Use generics instead of separate
  types for normalization - Gary ]
Co-developed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260904-tuple-struct-v1-4-72c50bd037fd@garyguo.net
Signed-off-by: Gary Guo <gary@garyguo.net>
Stable-dep-of: e30decc3f9a0 ("rust: pin-init: internal: init: emit `slot` using mixed site hygiene")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/pin-init/internal/src/init.rs | 381 +++++++++++++++++++++++++++--
 rust/pin-init/internal/src/lib.rs  |  11 +-
 rust/pin-init/src/lib.rs           |  16 ++
 3 files changed, 383 insertions(+), 25 deletions(-)

diff --git a/rust/pin-init/internal/src/init.rs b/rust/pin-init/internal/src/init.rs
index 5920bb281a500..dc5dfb2ca1142 100644
--- a/rust/pin-init/internal/src/init.rs
+++ b/rust/pin-init/internal/src/init.rs
@@ -1,14 +1,15 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
 use proc_macro2::{Span, TokenStream};
-use quote::{format_ident, quote};
+use quote::{format_ident, quote, ToTokens, TokenStreamExt};
 use syn::{
-    braced,
+    braced, parenthesized,
     parse::{End, Parse},
     parse_quote,
-    punctuated::Punctuated,
+    punctuated::{Pair, Punctuated},
     spanned::Spanned,
-    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, LitInt, Member, Path, Token, Type,
+    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, Index, LitInt, Member, Path, Token,
+    Type,
 };
 
 use crate::{
@@ -16,14 +17,87 @@
     util::*,
 };
 
-pub(crate) struct Initializer {
+pub(crate) struct Initializer<Kind = InitExprKind> {
     attrs: Vec<InitializerAttribute>,
     this: Option<This>,
+    kind: Kind,
+    error: Option<(Token![?], Type)>,
+}
+
+pub(crate) struct InitExprStruct {
     path: Path,
     brace_token: token::Brace,
     fields: Punctuated<InitializerField, Token![,]>,
     rest: Option<(Token![..], Expr)>,
-    error: Option<(Token![?], Type)>,
+}
+
+pub(crate) struct InitExprTuple {
+    path: Path,
+    paren_token: token::Paren,
+    fields: Punctuated<InitTupleField, Token![,]>,
+}
+
+pub(crate) enum InitExprKind {
+    Struct(InitExprStruct),
+    Tuple(InitExprTuple),
+}
+
+struct InitTupleField {
+    attrs: Vec<Attribute>,
+    /// `<-` is not valid in constructor syntax; it is parsed anyway so that it can be rejected
+    /// with a proper diagnostic instead of a parse error.
+    left_arrow_token: Option<Token![<-]>,
+    value: Expr,
+}
+
+impl InitExprTuple {
+    fn normalize(self) -> InitExprStruct {
+        let InitExprTuple {
+            path,
+            paren_token,
+            fields,
+        } = self;
+        InitExprStruct {
+            path,
+            brace_token: token::Brace {
+                span: paren_token.span,
+            },
+            fields: fields
+                .into_pairs()
+                .enumerate()
+                .map(|(index, pair)| {
+                    let (field, comma) = pair.into_tuple();
+                    let span = field.value.span();
+                    let field = InitializerField {
+                        attrs: field.attrs,
+                        kind: InitializerKind::Value {
+                            member: Member::Unnamed(Index {
+                                index: index.try_into().unwrap(),
+                                span,
+                            }),
+                            value: Some((Token![:](span), field.value)),
+                        },
+                    };
+                    Pair::new(field, comma)
+                })
+                .collect(),
+            rest: None,
+        }
+    }
+
+    fn validate(&self, dcx: &mut DiagCtxt) -> Result<(), ErrorGuaranteed> {
+        let mut result = Ok(());
+        for field in &self.fields {
+            if let Some(left_arrow_token) = &field.left_arrow_token {
+                result = Err(dcx.error(
+                    left_arrow_token,
+                    "`<-` is not supported in tuple constructor syntax; name the fields by index \
+                     instead, e.g. `Type { 0 <- initializer, 1: value }`",
+                ));
+            }
+        }
+        result
+    }
 }
 
 struct This {
@@ -71,16 +145,103 @@ struct DefaultErrorAttribute {
     ty: Box<Type>,
 }
 
-pub(crate) fn expand(
+pub(crate) fn expand_with_cfg(
+    initializer: Initializer,
+    default_error: Option<&'static str>,
+    pinned: bool,
+    dcx: &mut DiagCtxt,
+) -> Result<TokenStream, ErrorGuaranteed> {
+    let initializer = match initializer.kind {
+        InitExprKind::Tuple(expr) => {
+            expr.validate(dcx)?;
+
+            let mut initializer = Initializer {
+                attrs: initializer.attrs,
+                this: initializer.this,
+                kind: expr,
+                error: initializer.error,
+            };
+
+            // Removing a tuple field renumbers every field after it, which cannot be expressed with
+            // a `cfg` attribute on the initializer of a single field. Therefore, resolve tuple
+            // field cfgs before continuing. Struct expression syntax uses explicit numbers, so
+            // there is no need to pre-expand them and we only need to emit their cfgs on generated
+            // code.
+            for (field_idx, field) in initializer.kind.fields.iter_mut().enumerate() {
+                let cfg = field.attrs.extract_cfg_attrs();
+
+                if cfg.is_empty() {
+                    continue;
+                }
+
+                let true_initializer = initializer.to_token_stream();
+                initializer.kind.fields = initializer
+                    .kind
+                    .fields
+                    .into_pairs()
+                    .enumerate()
+                    .filter(|&(index, _)| index != field_idx)
+                    .map(|(_, pair)| pair)
+                    .collect();
+
+                let false_initializer = &initializer;
+
+                let macro_name = if pinned {
+                    quote!(::pin_init::pin_init)
+                } else {
+                    quote!(::pin_init::init)
+                };
+
+                // Resolve one field at a time until we've got no more tuple field cfgs.
+                //
+                // This is linear time because macro invocations with false cfg will not be
+                // expanded.
+                return Ok(quote! {
+                    {
+                        // Use `{}` delimiter here so semicolon is not required, otherwise the
+                        // expression becomes unit type.
+                        #[cfg(all(#(#cfg,)*))]
+                        #macro_name! { #true_initializer }
+
+                        #[cfg(not(all(#(#cfg,)*)))]
+                        #macro_name! { #false_initializer }
+                    }
+                });
+            }
+
+            // No cfgs left, we can normalize the initializer to the struct kind.
+            Initializer {
+                attrs: initializer.attrs,
+                this: initializer.this,
+                kind: initializer.kind.normalize(),
+                error: initializer.error,
+            }
+        }
+
+        InitExprKind::Struct(expr) => Initializer {
+            attrs: initializer.attrs,
+            this: initializer.this,
+            kind: expr,
+            error: initializer.error,
+        },
+    };
+
+    expand(initializer, default_error, pinned, dcx)
+}
+
+fn expand(
     Initializer {
         attrs,
         this,
-        path,
-        brace_token,
-        fields,
-        rest,
+        kind:
+            InitExprStruct {
+                path,
+                brace_token,
+                fields,
+                rest,
+            },
         error,
-    }: Initializer,
+    }: Initializer<InitExprStruct>,
     default_error: Option<&'static str>,
     pinned: bool,
     dcx: &mut DiagCtxt,
@@ -99,7 +260,10 @@ pub(crate) fn expand(
             } else if let Some(default_error) = default_error {
                 syn::parse_str(default_error).unwrap()
             } else {
-                dcx.error(brace_token.span.close(), "expected `? <type>` after `}`");
+                dcx.error(
+                    brace_token.span.close(),
+                    "expected `? <type>` after initializer",
+                );
                 parse_quote!(::core::convert::Infallible)
             }
         },
@@ -377,11 +541,8 @@ fn make_field_check(
     }
 }
 
-impl Parse for Initializer {
-    fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
-        let attrs = input.call(Attribute::parse_outer)?;
-        let this = input.peek(Token![&]).then(|| input.parse()).transpose()?;
-        let path = input.parse()?;
+impl InitExprStruct {
+    fn parse_with_path(path: Path, input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
         let content;
         let brace_token = braced!(content in input);
         let mut fields = Punctuated::new();
@@ -408,6 +569,51 @@ fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
             .peek(Token![..])
             .then(|| Ok::<_, syn::Error>((content.parse()?, content.parse()?)))
             .transpose()?;
+        Ok(Self {
+            path,
+            brace_token,
+            fields,
+            rest,
+        })
+    }
+}
+
+impl InitExprTuple {
+    fn parse_with_path(path: Path, input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
+        let content;
+        let paren_token = parenthesized!(content in input);
+        let mut fields = Punctuated::new();
+        while !content.is_empty() {
+            fields.push_value(InitTupleField {
+                attrs: content.call(Attribute::parse_outer)?,
+                left_arrow_token: content.parse()?,
+                value: content.parse()?,
+            });
+            if content.is_empty() {
+                break;
+            }
+            fields.push_punct(content.parse()?);
+        }
+        Ok(InitExprTuple {
+            path,
+            paren_token,
+            fields,
+        })
+    }
+}
+
+impl Parse for Initializer {
+    fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
+        let attrs = input.call(Attribute::parse_outer)?;
+        let this = input.peek(Token![&]).then(|| input.parse()).transpose()?;
+        let path = input.parse()?;
+        let kind = if input.peek(token::Brace) {
+            InitExprKind::Struct(InitExprStruct::parse_with_path(path, input)?)
+        } else if input.peek(token::Paren) {
+            InitExprKind::Tuple(InitExprTuple::parse_with_path(path, input)?)
+        } else {
+            return Err(input.error("expected curly braces or parentheses"));
+        };
         let error = input
             .peek(Token![?])
             .then(|| Ok::<_, syn::Error>((input.parse()?, input.parse()?)))
@@ -426,10 +632,7 @@ fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
         Ok(Self {
             attrs,
             this,
-            path,
-            brace_token,
-            fields,
-            rest,
+            kind,
             error,
         })
     }
@@ -499,3 +702,137 @@ fn parse(input: syn::parse::ParseStream<'_>) -> syn::Result<Self> {
         }
     }
 }
+
+impl<Kind: ToTokens> ToTokens for Initializer<Kind> {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        let Self {
+            attrs,
+            this,
+            kind,
+            error,
+        } = self;
+        tokens.append_all(attrs);
+        this.to_tokens(tokens);
+        kind.to_tokens(tokens);
+        if let Some((question, ty)) = error {
+            question.to_tokens(tokens);
+            ty.to_tokens(tokens);
+        }
+    }
+}
+
+impl ToTokens for InitExprKind {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        match self {
+            Self::Struct(init) => init.to_tokens(tokens),
+            Self::Tuple(init) => init.to_tokens(tokens),
+        }
+    }
+}
+
+impl ToTokens for InitExprStruct {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        let Self {
+            path,
+            brace_token,
+            fields,
+            rest,
+        } = self;
+        path.to_tokens(tokens);
+        brace_token.surround(tokens, |tokens| {
+            fields.to_tokens(tokens);
+            if let Some((dotdot, expr)) = rest {
+                dotdot.to_tokens(tokens);
+                expr.to_tokens(tokens);
+            }
+        });
+    }
+}
+
+impl ToTokens for InitExprTuple {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        let Self {
+            path,
+            paren_token,
+            fields,
+        } = self;
+        path.to_tokens(tokens);
+        paren_token.surround(tokens, |tokens| fields.to_tokens(tokens));
+    }
+}
+
+impl ToTokens for InitTupleField {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        let Self {
+            attrs,
+            left_arrow_token,
+            value,
+        } = self;
+        tokens.append_all(attrs);
+        left_arrow_token.to_tokens(tokens);
+        value.to_tokens(tokens);
+    }
+}
+
+impl ToTokens for InitializerAttribute {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        match self {
+            Self::DefaultError(DefaultErrorAttribute { ty }) => {
+                quote!(#[default_error(#ty)]).to_tokens(tokens);
+            }
+        }
+    }
+}
+
+impl ToTokens for This {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        let Self {
+            _and_token,
+            ident,
+            _in_token,
+        } = self;
+        _and_token.to_tokens(tokens);
+        ident.to_tokens(tokens);
+        _in_token.to_tokens(tokens);
+    }
+}
+
+impl ToTokens for InitializerField {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        let Self { attrs, kind } = self;
+        tokens.append_all(attrs);
+        kind.to_tokens(tokens);
+    }
+}
+
+impl ToTokens for InitializerKind {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        match self {
+            Self::Value { member, value } => {
+                member.to_tokens(tokens);
+                if let Some((colon, expr)) = value {
+                    colon.to_tokens(tokens);
+                    expr.to_tokens(tokens);
+                }
+            }
+            Self::Init {
+                member,
+                _left_arrow_token,
+                value,
+            } => {
+                member.to_tokens(tokens);
+                _left_arrow_token.to_tokens(tokens);
+                value.to_tokens(tokens);
+            }
+            Self::Code {
+                _underscore_token,
+                _colon_token,
+                block,
+            } => {
+                _underscore_token.to_tokens(tokens);
+                _colon_token.to_tokens(tokens);
+                block.to_tokens(tokens);
+            }
+        }
+    }
+}
diff --git a/rust/pin-init/internal/src/lib.rs b/rust/pin-init/internal/src/lib.rs
index 60d5093f3128e..53e754a93afca 100644
--- a/rust/pin-init/internal/src/lib.rs
+++ b/rust/pin-init/internal/src/lib.rs
@@ -48,12 +48,17 @@ pub fn maybe_derive_zeroable(input: TokenStream) -> TokenStream {
 #[proc_macro]
 pub fn init(input: TokenStream) -> TokenStream {
     let input = parse_macro_input!(input);
-    DiagCtxt::with(|dcx| init::expand(input, Some("::core::convert::Infallible"), false, dcx))
-        .into()
+    DiagCtxt::with(|dcx| {
+        init::expand_with_cfg(input, Some("::core::convert::Infallible"), false, dcx)
+    })
+    .into()
 }
 
 #[proc_macro]
 pub fn pin_init(input: TokenStream) -> TokenStream {
     let input = parse_macro_input!(input);
-    DiagCtxt::with(|dcx| init::expand(input, Some("::core::convert::Infallible"), true, dcx)).into()
+    DiagCtxt::with(|dcx| {
+        init::expand_with_cfg(input, Some("::core::convert::Infallible"), true, dcx)
+    })
+    .into()
 }
diff --git a/rust/pin-init/src/lib.rs b/rust/pin-init/src/lib.rs
index 1aa3973bca347..95beaa7a7e03c 100644
--- a/rust/pin-init/src/lib.rs
+++ b/rust/pin-init/src/lib.rs
@@ -625,6 +625,20 @@ macro_rules! stack_try_pin_init {
 /// # Box::pin_init(demo()).unwrap();
 /// ```
 ///
+/// A tuple struct whose fields are all set to a value can also be written like a call to its
+/// constructor:
+///
+/// ```rust
+/// # use pin_init::*;
+/// #[pin_data]
+/// struct Pair(usize, usize);
+///
+/// # fn demo() -> impl PinInit<Pair> {
+/// let initializer = pin_init!(Pair(42, 64));
+/// # initializer }
+/// # Box::pin_init(demo()).unwrap();
+/// ```
+///
 /// Arbitrary Rust expressions can be used to set the value of a variable.
 ///
 /// The fields are initialized in the order that they appear in the initializer. So it is possible
@@ -748,6 +762,8 @@ macro_rules! stack_try_pin_init {
 /// - Fields that you want to initialize in-place have to use `<-` instead of `:`.
 /// - Tuple struct fields are named by their index, as in `0: value` or `0 <- initializer`. They
 ///   are not exposed by a `let` binding, since they have no name to bind.
+/// - A tuple struct can also be initialized with constructor syntax, as in `Type(value, value)`.
+///   Since its arguments are not named, they cannot use `<-`; write them out by index instead.
 /// - You can use `_: { /* run any user-code here */ },` anywhere where you can place fields in
 ///   order to run arbitrary code.
 /// - In front of the initializer you can write `&this in` to have access to a [`NonNull<Self>`]
-- 
2.53.0



