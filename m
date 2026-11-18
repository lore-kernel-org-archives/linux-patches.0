Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016584;
	b=fTrNjr5IME+DgTddFMEGqXQwf8Jxtcc9vK+n3CzfSzyJvkUBAidw4sWM840ya0xJYPr8
	 oCnY0JsbHhnalYG3bEJXF/xK7y+O43ayltwKpAjix0vNPybXTzubgzR5TksJDGza+LBPI
	 MFCCR+83QYkrdZEMGVgHOn4IKsVBmSgJet99m5UR0gQ7CGbdClTV5Hi4QwVpLNJUX9QmE
	 mrk8/uDZftT2+T6m79s/TMk/mB3Xl1ps11F0/x7cfTvz0St903PF7tQma2HJGfHcdXJSV
	 wa2e5Esu+ILHrGUDe5Nu+CxlCZY+crrfntPaA5tD4Ulxx2PJmeC+E17Xl1DuCfiAiXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qZ+uBNhcRj+qd/vtC/ih8E1QOF41+bW9+0mG/uzsz+A=;
	b=mRqDo7fMYqCzrONiq5NO3MQJYRxQrVjWbZvPrsLsoX2JFF1pAfI4X/S6JHnTQYCIl/BA
	 zFxbdRRE4Prb2OkF8fRCndpZiEXe7OC6w1TA16ImYjkHBl6dgJS6sjpBNbkgXxo9I2+xi
	 bsLZey6x0Zwtespj/2ndIDOvqwTfnThWskVH3JuiQndJSGqbUtQ1kYCYwSrjSohwq3SDr
	 egalPV0wZ7rmoIZfQLaRf/dE1dqZtyNvmQkfU6mSxG7ckb5fFqhghN3LvBY72QyssOKOM
	 Rnx2kupnsM7ErAiMPXyJZUessiNfFKCAlo5LWWBZn7meByKLeKSL1igasHFe6sWgtWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0zgaZHz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1341C60A2605;
	Wed, 18 Nov 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0zgaZHz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1061F000C6;
	Wed, 18 Nov 2026 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016583;
	bh=qZ+uBNhcRj+qd/vtC/ih8E1QOF41+bW9+0mG/uzsz+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0zgaZHzLaA6QI6ybBWlNY8mJ9oim5htUluprNTE336rI+pgszvrDX3KpHTDOS7m6
	 +KU1ik2ophDccjvpKdAWFMf2mZ71hyhwi0H+aUi6yocfqfcd9iW7CvN4etqLnuv1Rg
	 bcWZpd0eeuiZIxD4D0nR7BwZxdDuWyEjGLICEKIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0580/2651] rust: pin-init: internal: init: emit `slot` using mixed site hygiene
Date: Wed, 18 Nov 2026 15:30:20 +0100
Message-ID: <20261118150308.608466638@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit e30decc3f9a0ded621d5b0f19a5253b84d21be0c ]

Syn/quote's default is the call site hygiene. If user provides a field
named `slot`, it will conflict with pin-init generated `slot` identifier.
Change it to use mixed site hygiene instead.

Fixes: 4883830e9784 ("rust: pin-init: rewrite the initializer macros using `syn`")
Link: https://patch.msgid.link/20260916-dev-hygiene-v1-1-dfb6ae2588ba@garyguo.net
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/pin-init/internal/src/init.rs | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/pin-init/internal/src/init.rs b/rust/pin-init/internal/src/init.rs
index dc5dfb2ca1142..6ade192d27e60 100644
--- a/rust/pin-init/internal/src/init.rs
+++ b/rust/pin-init/internal/src/init.rs
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
 use proc_macro2::{Span, TokenStream};
-use quote::{format_ident, quote, ToTokens, TokenStreamExt};
+use quote::{format_ident, quote, quote_spanned, ToTokens, TokenStreamExt};
 use syn::{
     braced, parenthesized,
     parse::{End, Parse},
@@ -269,7 +269,7 @@ fn expand(
         },
         |(_, err)| Box::new(err),
     );
-    let slot = format_ident!("slot");
+    let slot = Ident::new("slot", Span::mixed_site());
     let (has_data_trait, get_data, init_from_closure) = if pinned {
         (
             format_ident!("HasPinData"),
@@ -302,7 +302,7 @@ fn assert_zeroable<T: ?::core::marker::Sized>(_: *mut T)
     };
     let this = match this {
         None => quote!(),
-        Some(This { ident, .. }) => quote! {
+        Some(This { ident, .. }) => quote_spanned! { Span::mixed_site() =>
             // Create the `this` so it can be referenced by the user inside of the
             // expressions creating the individual fields.
             let #ident = unsafe { ::core::ptr::NonNull::new_unchecked(slot) };
@@ -312,7 +312,7 @@ fn assert_zeroable<T: ?::core::marker::Sized>(_: *mut T)
     let data = Ident::new("__data", Span::mixed_site());
     let init_fields = init_fields(&fields, pinned, &data, &slot);
     let field_check = make_field_check(&fields, init_kind, &path);
-    Ok(quote! {{
+    Ok(quote_spanned! { Span::mixed_site() => {
         // Get the data about fields from the supplied type.
         // SAFETY: TODO
         let #data = unsafe {
@@ -512,7 +512,7 @@ fn make_field_check(
             ..::core::mem::zeroed()
         }),
     };
-    quote! {
+    quote_spanned! { Span::mixed_site() =>
         #[allow(unreachable_code)]
         // We use unreachable code to perform field checks. They're still checked by the compiler.
         // SAFETY: this code is never executed.
-- 
2.53.0



