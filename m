Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B60014D703;
	Wed,  4 Sep 2024 20:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482686; cv=none; b=hQQqj9jwA6bHNUcgSQ6CjLjxRwhzHn0+4IU4I0ek5TPWkttyZXtmeXvDeTGbmtoH6KWdBs2UFhp7FDMLBLLC1S0/IpbFk9zWJ74rbsUwbjKT9QB0UYXoXoX0sw9Imjw77wQG2d8wGDF0fgH1sDYSrBW87DsMv1OzFdacT61uPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482686; c=relaxed/simple;
	bh=vANsDtYmWGHFZ2IuDU/7W7TVVPKtroKugzofcbnxEJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9xCHvSACK9RvOmBZYNukLEH5FFN5Gk2yPFqM1AP8wi17TXxgjzRCt1q4RGkvEgN8/90Yrj4j8yufFXTdbggemRQnIclZruGx1U655ij3IqqI9acpmiMizX7F1kCGlA1KUdB5wyQINA6T3FxKx1iq2xK8q5b7VWhWv1wDrQgV1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIcs2NOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIcs2NOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A894C4CEC5;
	Wed,  4 Sep 2024 20:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482685;
	bh=vANsDtYmWGHFZ2IuDU/7W7TVVPKtroKugzofcbnxEJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIcs2NOtwaR0voinJjko/gjpXM3MWLUkOQZVv0Okm+AiSP5VwW+1FEEAUaEJ6fHkX
	 wSGa/X2xNI4bprCWqmf5gpPuTuy1Rjb62mxRHLNdbHu5bThGlZFjvsaH6xvEpeBero
	 RDoYnkYKvLgdwcRgf15VAzFAhshs4OkU0qRpnVfQKjC01L/+HDh4r3USoA3dC/6kTE
	 AvU9BvQuYdZ8+QuR5pgA38vb9BAxbYLjhb3ahSepvHQO7GofiviMFLOkiyhhA09Oi4
	 mNfMeFTREGbm2aptSeTthhmAuaPRP7O5VTPpw6iTlznHUAjDMFNl2qzxcsAh0WrSll
	 XZcDFtEbXho+Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 01/19] rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
Date: Wed,  4 Sep 2024 22:43:29 +0200
Message-ID: <20240904204347.168520-2-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Perform the same clean commit b2516f7af9d2 ("rust: kernel: remove
`#[allow(clippy::new_ret_no_self)]`") did for a case that appeared in
workqueue in parallel in commit 7324b88975c5 ("rust: workqueue: add
helper for defining work_struct fields"):

    Clippy triggered a false positive on its `new_ret_no_self` lint
    when using the `pin_init!` macro. Since Rust 1.67.0, that does
    not happen anymore, since Clippy learnt to not warn about
    `-> impl Trait<Self>` [1][2].

    The kernel nowadays uses Rust 1.72.1, thus remove the `#[allow]`.

    Link: https://github.com/rust-lang/rust-clippy/issues/7344 [1]
    Link: https://github.com/rust-lang/rust-clippy/pull/9733 [2]

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/workqueue.rs | 1 -
 1 file changed, 1 deletion(-)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 553a5cba2adc..493288dc1de0 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -366,7 +366,6 @@ unsafe impl<T: ?Sized, const ID: u64> Sync for Work<T, ID> {}
 impl<T: ?Sized, const ID: u64> Work<T, ID> {
     /// Creates a new instance of [`Work`].
     #[inline]
-    #[allow(clippy::new_ret_no_self)]
     pub fn new(name: &'static CStr, key: &'static LockClassKey) -> impl PinInit<Self>
     where
         T: WorkItem<ID>,
-- 
2.46.0

