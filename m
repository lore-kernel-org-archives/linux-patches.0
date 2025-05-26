Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6CE2144C4;
	Mon, 26 May 2025 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748273365; cv=none; b=Wo1hMoGVl060dvk/I1FliMp6gylko2rmqy/0wIryvb3/iR5hRgO3tsMBh7QdQl6KyONfK7bW8C1ZLM8c1ZhECa+0aome2JhDrnHfHOpa8WlLGVirD4MD8HdWmun98HTrDPVGQ5jgg+arrMC7gIWM81AvhO1lnlSyu3F25yLIlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748273365; c=relaxed/simple;
	bh=U7QOqpRx+N2jQBnmftD+NGcDt7nYI8slsw0TzFChfvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON4jQMH22chx6Cco/344kV6VQlW+8cDKo9tfexjZIy7NRkGt/yqM5WPszseoclxvz4Ijiv5zCPAyb9YUmrFQENtwEPoaxyrlWieaU3eWor642662rFDR/MM/cA8L+HEB12WFPNyUvzkjuX0n6qM4sYx2weujJLVKAgtpWO3cgYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOnzxFID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOnzxFID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDB6C4CEE7;
	Mon, 26 May 2025 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748273365;
	bh=U7QOqpRx+N2jQBnmftD+NGcDt7nYI8slsw0TzFChfvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOnzxFIDS9iAnSP0B1qEPSRjcrAcyE23SjVJ5YhgY2JAvl7QJyRuSDt7UpLDtH/Su
	 ESqeBEkiSoAg2WEWbqtbBtDmErgFPajf1OAfG6IZ3n8dWkHv7HrNFZwGk8U8D3y7Qo
	 SLxSD+f2Xszc6JOozk6APsNZtpvIV4AUap8tnPkCvtnHmujCfm9YOT17chhqOhZzTG
	 Ezr1PeBpwFg38LInE2KOHQWSHVoFrPQBERMabclbZuvZV/BLIDRh8rjbJTipYUEQLQ
	 epyeqkq/oahD5eDwHHfdNrRLo/DJ5InB42Q7QNiZ+cBoaR0yzb07HowgxlLlkUlapm
	 l7jtfd/8BgaZA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/2] rust: init: remove doctest's `Error::from_errno` workaround
Date: Mon, 26 May 2025 17:29:14 +0200
Message-ID: <20250526152914.2453949-2-ojeda@kernel.org>
In-Reply-To: <20250526152914.2453949-1-ojeda@kernel.org>
References: <20250526152914.2453949-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 5ed147473458 ("rust: error: make conversion functions
public"), `Error::from_errno` is public.

Thus remove the workaround added in commit a30e94c29673 ("rust: init:
make doctests compilable/testable").

Suggested-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 78cadfcd4392..e57a30a5d20c 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -77,14 +77,6 @@
 //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn enable_foo(_ptr: *mut foo, _flags: u32) -> i32 { 0 }
 //! # }
-//! # // `Error::from_errno` is `pub(crate)` in the `kernel` crate, thus provide a workaround.
-//! # trait FromErrno {
-//! #     fn from_errno(errno: core::ffi::c_int) -> Error {
-//! #         // Dummy error that can be constructed outside the `kernel` crate.
-//! #         Error::from(core::fmt::Error)
-//! #     }
-//! # }
-//! # impl FromErrno for Error {}
 //! /// # Invariants
 //! ///
 //! /// `foo` is always initialized
-- 
2.49.0

