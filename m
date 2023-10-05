Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15A2134B6;
	Thu,  5 Oct 2023 21:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pTVigqeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E193C433C7;
	Thu,  5 Oct 2023 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696539989;
	bh=IgnQ6UponHD7jSbFHw/8nSE/0v3lOdZL01VrkmoEWNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTVigqePQVgAUvofgawoF4pXU1khefVIcRhUaE6EHw8QVre55UrKUxmvtvPsRn0TN
	 r9c2a1hZQXYcwB4kDn5MpFuqITHIE3m1mYZlVoOibIxq9ISrbWKLQhh7dJUh7djA2F
	 XVUCTXYAei48w+IWUlhMZlcFUYNgSNFGAmv0U3AzaaVNSCnorI61XMEQuQfAPBjybZ
	 jALxqZ2TsDrogKhpRykPUK1xLhxlxw3RlOTegKboVip5QMTJ0jjJM5GGfYxXzFKMTc
	 /PQ6A7AWO099ZFZLraaIllvNOedS03hlmQAR35aDJT82Rh5+wFzkzFOS7Rajmvd4Bv
	 jomQrL5ePPWhQ==
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
Subject: [PATCH 2/3] rust: print: use explicit link in documentation
Date: Thu,  5 Oct 2023 23:05:54 +0200
Message-ID: <20231005210556.466856-3-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-1-ojeda@kernel.org>
References: <20231005210556.466856-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future `rustdoc` in the Rust 1.73.0 upgrade requires an explicit
link for `pr_info!`:

    error: unresolved link to `pr_info`
       --> rust/kernel/print.rs:395:63
        |
    395 | /// Use only when continuing a previous `pr_*!` macro (e.g. [`pr_info!`]).
        |                                                               ^^^^^^^^ no item named `pr_info` in scope
        |
        = note: `macro_rules` named `pr_info` exists in this crate, but it is not in scope at this link's location
        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`

Thus do so to avoid a broken link while upgrading.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/print.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index 8009184bf6d7..f48926e3e9fe 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -399,6 +399,7 @@ macro_rules! pr_debug (
 /// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
 /// `alloc::format!` for information about the formatting syntax.
 ///
+/// [`pr_info!`]: crate::pr_info!
 /// [`pr_cont`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_cont
 /// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
 ///
-- 
2.42.0

