Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EC4847C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 20:14:23 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id n12so31038456eja.11
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aB7D80CH8cdnLZm/7P85TJstRm3skUAzIKd4hpiZ7CM=;
        b=AwroikXUJBvGijxNsh6Gyvm9r4vqrTGpk8hO66t5QX44Ia2w47wA3y3zEq8/7uJ/kO
         CGHlgHt4qfQHPI7xeGijLLSZHYaSnZILlQJqiPaP1ang1PrN6Atan5O4Mji4F8/0tIjR
         vwGlFCCfajWjT/YGScTNSOVDF9BCfRspFexpHqHoQuVWlVTdv4vL2Ye7raIdf5nVjQqi
         nRMX2kQH88+jnOC+tnT3zr8bzXDaRIvIAb3iyykFG4eJQjY48Mcho5j5w2Xb6yVtcEcC
         bHYJT5CxVn7jjEwpNF4KkdEGiaWVZrrSHtil7gryBYdwlcCRLp2QDQ3pBl7qXa0pw/H3
         FOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aB7D80CH8cdnLZm/7P85TJstRm3skUAzIKd4hpiZ7CM=;
        b=5lJLwTwxGUEjflc6TnNNJa+Qni01u4Xw576f6D8gB4wzZz2jIygif9aBUpiGVgnXar
         OpVhmmIvGSXmy7Yj2lkQGDZpPzUGyKCq6jSaYA2zjhoummnjBPn+wY8h7cY97pHPnXVS
         /zHXhuiw5JSD4dWW2jlGFoybS73FXT7fgZNBsBW8D4wT/4svaRIbqGXyV8y3M6cHEoXr
         rE1WGef4axyogWjFX0lOcC/Z4P2xmKJKfajlKxzKVW0f10oyxhq29WgtnEY9VgSMrQE4
         ADqsrbD7y5JeBXDsBvxNOEcbkzPmT8GTlndAj975OtPRvbeUoJK4biogbqMvY7W46aEs
         gMLA==
X-Gm-Message-State: ANoB5pmkBSko4Ceqo60y3hVbkouK+635olQaxKjp4t8ncOnhUvcQe38t
	XVX+GKTKFiqhhlDoe2wi8gBjYR9No7u20SQoqvM=
X-Google-Smtp-Source: AA0mqf4wBFZ1d0lWU2xsAABrG0uAML4bUGOpWsEwAykL63iuG8KCuj3fnEHe1Cc6fUO0kUSg6H0v2HYKoiEKdpgYbog=
X-Received: by 2002:a17:906:3ac3:b0:7af:da0:aebe with SMTP id
 z3-20020a1709063ac300b007af0da0aebemr2741054ejd.723.1668456861854; Mon, 14
 Nov 2022 12:14:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-7-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-7-ojeda@kernel.org>
From: =?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>
Date: Mon, 14 Nov 2022 10:06:32 -0500
Message-ID: <CAA76j92rwioWC9j5+O-ekkz_p1Afp3m2zGMTtPF_4wip+T2iuw@mail.gmail.com>
Subject: Re: [PATCH v1 06/28] rust: macros: add `#[vtable]` proc macro
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2022 at 11:43, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> From: Gary Guo <gary@garyguo.net>
>
> This procedural macro attribute provides a simple way to declare
> a trait with a set of operations that later users can partially
> implement, providing compile-time `HAS_*` boolean associated
> constants that indicate whether a particular operation was overridden.
>
> This is useful as the Rust counterpart to structs like
> `file_operations` where some pointers may be `NULL`, indicating
> an operation is not provided.
>
> For instance:
>
>     #[vtable]
>     trait Operations {
>         fn read(...) -> Result<usize> {
>             Err(EINVAL)
>         }
>
>         fn write(...) -> Result<usize> {
>             Err(EINVAL)
>         }
>     }
>
>     #[vtable]
>     impl Operations for S {
>         fn read(...) -> Result<usize> {
>             ...
>         }
>     }
>
>     assert_eq!(<S as Operations>::HAS_READ, true);
>     assert_eq!(<S as Operations>::HAS_WRITE, false);
>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/prelude.rs |  2 +-
>  rust/macros/lib.rs     | 52 +++++++++++++++++++++++
>  rust/macros/vtable.rs  | 95 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 148 insertions(+), 1 deletion(-)
>  create mode 100644 rust/macros/vtable.rs
>
> diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
> index 6a1c6b38327f..7c4c35bf3c66 100644
> --- a/rust/kernel/prelude.rs
> +++ b/rust/kernel/prelude.rs
> @@ -15,7 +15,7 @@ pub use core::pin::Pin;
>
>  pub use alloc::{boxed::Box, vec::Vec};
>
> -pub use macros::module;
> +pub use macros::{module, vtable};
>
>  pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, =
pr_notice, pr_warn};
>
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index 15555e7ff487..e40caaf0a656 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -5,6 +5,7 @@
>  mod concat_idents;
>  mod helpers;
>  mod module;
> +mod vtable;
>
>  use proc_macro::TokenStream;
>
> @@ -72,6 +73,57 @@ pub fn module(ts: TokenStream) -> TokenStream {
>      module::module(ts)
>  }
>
> +/// Declares or implements a vtable trait.
> +///
> +/// Linux's use of pure vtables is very close to Rust traits, but they d=
iffer
> +/// in how unimplemented functions are represented. In Rust, traits can =
provide
> +/// default implementation for all non-required methods (and the default
> +/// implementation could just return `Error::EINVAL`); Linux typically u=
se C
> +/// `NULL` pointers to represent these functions.
> +///
> +/// This attribute is intended to close the gap. Traits can be declared =
and
> +/// implemented with the `#[vtable]` attribute, and a `HAS_*` associated=
 constant
> +/// will be generated for each method in the trait, indicating if the im=
plementor
> +/// has overridden a method.
> +///
> +/// This attribute is not needed if all methods are required.
> +///
> +/// # Examples
> +///
> +/// ```ignore
> +/// use kernel::prelude::*;
> +///
> +/// // Declares a `#[vtable]` trait
> +/// #[vtable]
> +/// pub trait Operations: Send + Sync + Sized {
> +///     fn foo(&self) -> Result<()> {
> +///         Err(EINVAL)
> +///     }
> +///
> +///     fn bar(&self) -> Result<()> {
> +///         Err(EINVAL)
> +///     }
> +/// }
> +///
> +/// struct Foo;
> +///
> +/// // Implements the `#[vtable]` trait
> +/// #[vtable]
> +/// impl Operations for Foo {
> +///     fn foo(&self) -> Result<()> {
> +/// #        Err(EINVAL)
> +///         // ...
> +///     }
> +/// }
> +///
> +/// assert_eq!(<Foo as Operations>::HAS_FOO, true);
> +/// assert_eq!(<Foo as Operations>::HAS_BAR, false);
> +/// ```
> +#[proc_macro_attribute]
> +pub fn vtable(attr: TokenStream, ts: TokenStream) -> TokenStream {
> +    vtable::vtable(attr, ts)
> +}
> +
>  /// Concatenate two identifiers.
>  ///
>  /// This is useful in macros that need to declare or reference items wit=
h names
> diff --git a/rust/macros/vtable.rs b/rust/macros/vtable.rs
> new file mode 100644
> index 000000000000..34d5e7fb5768
> --- /dev/null
> +++ b/rust/macros/vtable.rs
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +use proc_macro::{Delimiter, Group, TokenStream, TokenTree};
> +use std::collections::HashSet;
> +use std::fmt::Write;
> +
> +pub(crate) fn vtable(_attr: TokenStream, ts: TokenStream) -> TokenStream=
 {
> +    let mut tokens: Vec<_> =3D ts.into_iter().collect();
> +
> +    // Scan for the `trait` or `impl` keyword.
> +    let is_trait =3D tokens
> +        .iter()
> +        .find_map(|token| match token {
> +            TokenTree::Ident(ident) =3D> match ident.to_string().as_str(=
) {
> +                "trait" =3D> Some(true),
> +                "impl" =3D> Some(false),
> +                _ =3D> None,
> +            },
> +            _ =3D> None,
> +        })
> +        .expect("#[vtable] attribute should only be applied to trait or =
impl block");
> +
> +    // Retrieve the main body. The main body should be the last token tr=
ee.
> +    let body =3D match tokens.pop() {
> +        Some(TokenTree::Group(group)) if group.delimiter() =3D=3D Delimi=
ter::Brace =3D> group,
> +        _ =3D> panic!("cannot locate main body of trait or impl block"),
> +    };
> +
> +    let mut body_it =3D body.stream().into_iter();
> +    let mut functions =3D Vec::new();
> +    let mut consts =3D HashSet::new();
> +    while let Some(token) =3D body_it.next() {
> +        match token {
> +            TokenTree::Ident(ident) if ident.to_string() =3D=3D "fn" =3D=
> {
> +                let fn_name =3D match body_it.next() {
> +                    Some(TokenTree::Ident(ident)) =3D> ident.to_string()=
,
> +                    // Possibly we've encountered a fn pointer type inst=
ead.
> +                    _ =3D> continue,
> +                };
> +                functions.push(fn_name);
> +            }
> +            TokenTree::Ident(ident) if ident.to_string() =3D=3D "const" =
=3D> {
> +                let const_name =3D match body_it.next() {
> +                    Some(TokenTree::Ident(ident)) =3D> ident.to_string()=
,
> +                    // Possibly we've encountered an inline const block =
instead.
> +                    _ =3D> continue,
> +                };
> +                consts.insert(const_name);
> +            }
> +            _ =3D> (),
> +        }
> +    }
> +
> +    let mut const_items;
> +    if is_trait {
> +        const_items =3D "
> +                /// A marker to prevent implementors from forgetting to =
use [`#[vtable]`](vtable)
> +                /// attribute when implementing this trait.
> +                const USE_VTABLE_ATTR: ();
> +        "
> +        .to_owned();
> +
> +        for f in functions {
> +            let gen_const_name =3D format!("HAS_{}", f.to_uppercase());
> +            // Skip if it's declared already -- this allows user overrid=
e.
> +            if consts.contains(&gen_const_name) {
> +                continue;
> +            }
> +            // We don't know on the implementation-site whether a method=
 is required or provided
> +            // so we have to generate a const for all methods.
> +            write!(
> +                const_items,
> +                "/// Indicates if the `{f}` method is overridden by the =
implementor.
> +                const {gen_const_name}: bool =3D false;",
> +            )
> +            .unwrap();
> +        }
> +    } else {
> +        const_items =3D "const USE_VTABLE_ATTR: () =3D ();".to_owned();
> +
> +        for f in functions {
> +            let gen_const_name =3D format!("HAS_{}", f.to_uppercase());
> +            if consts.contains(&gen_const_name) {
> +                continue;
> +            }
> +            write!(const_items, "const {gen_const_name}: bool =3D true;"=
).unwrap();
> +        }
> +    }
> +
> +    let new_body =3D vec![const_items.parse().unwrap(), body.stream()]
> +        .into_iter()
> +        .collect();
> +    tokens.push(TokenTree::Group(Group::new(Delimiter::Brace, new_body))=
);
> +    tokens.into_iter().collect()
> +}
> --
> 2.38.1
>
Reviewed-by: Sergio Gonz=C3=A1lez Collado <sergio.collado@gmail.com>
