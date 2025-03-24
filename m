Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54001F4739;
	Mon, 24 Mar 2025 21:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850272; cv=none; b=eikch1UIxCrE/msp2zivbDlrFnSrowtVXmSFSutTxSxejQb3ptAMnqqYRVdqXqOhuRHz2XflsrbANnfo8jxvgcnUWcjpSefLq18QvHnx7LdaV65YlOB13hwtln1PY5KQ/zNsdQMNOSG3rr58CFrzlgHg/oCgtqfMzsQvuocdflc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850272; c=relaxed/simple;
	bh=0enSYOwK08uB3YnLYrHQQ3uuBPHb0fjo6/NAEt+1y+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHf+TVcC4eV6Bz+g9PWJHHpe9yZP4wdZiesaW53EOYETa/3kWmoSZ8z/StD2wLdMaHnJ57pfXykCAyHckLZpOIytOf+A/BYEAqnJm8jlDmg1pk0CMPefST14XiLquxcLX+BmKg6l9ObI4YF6jc4u+bbPmi97Wbx7L3k1TUpJQm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spl0Fgsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spl0Fgsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC742C4CEDD;
	Mon, 24 Mar 2025 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850272;
	bh=0enSYOwK08uB3YnLYrHQQ3uuBPHb0fjo6/NAEt+1y+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spl0FgsvLeA4Nkl3liUcUnrM5Bv5Qrhr7J+CtS6tnLIj1W+GKeIO1FBa0fIDP/Zqq
	 fxYUkKa5mu2q8j5J4/M7p/K6YJd+pfMZa5yY0SyGSjemn6SC7ev1farinhUL2rs61m
	 sRq/i/yxlIyNJe4ZoNw80vzDfQ6IgprtTTGSUbQ9w/BkrcvXPZIJWrhvoLaSGtm8M3
	 9wqw6dGuaEjycfRNakj7cx8b72AyxEEothSjXqBZAiDht2s3ZrehY4xEgcdumPPfp7
	 HNmyCr4WwasIKdlPpWA6iv6i0XHewo9zN/RvWwDu/n0jgezRZ1ENBD5gq7xcbygXhz
	 58XBPfiPaeqmQ==
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
	patches@lists.linux.dev,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 05/10] rust: dma: add missing Markdown code span
Date: Mon, 24 Mar 2025 22:03:52 +0100
Message-ID: <20250324210359.1199574-6-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing Markdown code span.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: ad2907b4e308 ("rust: add dma coherent allocator abstraction")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/dma.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index 8cdc76043ee7..35fd8a638473 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -94,7 +94,7 @@ pub mod attrs {
     pub const DMA_ATTR_ALLOC_SINGLE_PAGES: Attrs = Attrs(bindings::DMA_ATTR_ALLOC_SINGLE_PAGES);
 
     /// This tells the DMA-mapping subsystem to suppress allocation failure reports (similarly to
-    /// __GFP_NOWARN).
+    /// `__GFP_NOWARN`).
     pub const DMA_ATTR_NO_WARN: Attrs = Attrs(bindings::DMA_ATTR_NO_WARN);
 
     /// Used to indicate that the buffer is fully accessible at an elevated privilege level (and
-- 
2.49.0

