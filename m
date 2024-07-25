Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6418F20EB;
	Thu, 25 Jul 2024 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721933218; cv=none; b=mUFi5GIMpVXDxHQgtWHKmYUM2pTVVfIEt+zM0Bo0nsOL1ld7GgsIOJoy9ijl98xUjZE9cMvmwCiP9K5zUj5Je3VvEW/X+EmR46YS1k8AfXlSunEoE9bxi8WjG6c83/VgevQxf+ihoLX6PHTEchu5dCMFa1TIehYAZMX1QHuSmVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721933218; c=relaxed/simple;
	bh=CanL8tlTTbXxjanDdzzQH1XD8iuK5CGAU8dVuUCdHNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rNzOZ3QmCuwGqwzaanNVWZCk2Cn0VMLRd6MHX8vaoOutRJqiJF6TuI1CptPSj1v4mL6TbKxud20qIRNq7EcYhoPjDB2knKWtrpXpJU1OuAd8fNE2iE7eM2YPpuSBC3Oi31XRS39KxpbKwPchldnejQE6ky9F/eM/Of7b5Ao7sl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtLd+06c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtLd+06c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E6CC116B1;
	Thu, 25 Jul 2024 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721933218;
	bh=CanL8tlTTbXxjanDdzzQH1XD8iuK5CGAU8dVuUCdHNM=;
	h=From:To:Cc:Subject:Date:From;
	b=AtLd+06czQgj8D2G0JD1wrOO9L5/WwM7hhGNKtU6jNsCj3UmIaAHI6oS/CuYPq4Lg
	 IpXiOYe3+S2INUYumrhbcjaS5KOwnFyfY8g0nKIQrsHD/H8mLbfh3gg0xZPq5XJTcq
	 YHSR5rt2M1DyIgtQxds3PjizgQqhYWWdoVlJTfx7einVEDd8gapZAMJ1WFMSmZXWK1
	 wRV/GYkY0LZOcWxKULnL3RVn28SDxKR0T8AKLet25H4n/wtM4EUKW7Om0OKf3WbOkQ
	 n57s5GoaI/zkHyz6KfcY5G3f5XFbPhHTmp+XGJhikcj/V4D3h2XuCErvt4Q3tu5lZ2
	 X3/McmTfcZZ3g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: macros: indent list item in `module!`'s docs
Date: Thu, 25 Jul 2024 20:46:44 +0200
Message-ID: <20240725184644.135185-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like commit e516211f615f ("rust: macros: indent list item in `paste!`'s
docs"), but for `module!`.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/macros/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 159e75292970..5be0cb9db3ee 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -94,7 +94,7 @@
 ///   - `license`: ASCII string literal of the license of the kernel module (required).
 ///   - `alias`: array of ASCII string literals of the alias names of the kernel module.
 ///   - `firmware`: array of ASCII string literals of the firmware files of
-/// the kernel module.
+///     the kernel module.
 #[proc_macro]
 pub fn module(ts: TokenStream) -> TokenStream {
     module::module(ts)

base-commit: b1263411112305acf2af728728591465becb45b0
--
2.45.2
