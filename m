Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF826FDA9;
	Thu, 16 Oct 2025 23:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760656446; cv=none; b=JlohZCIxan4n2v5kSXe7cDPAONmR7TdwqpvgBvsce4ULYAO6a2j+fsDBsxYedkQ3uCGnZd2E4EzYrsXG3tKlAdkGvdyZMd1UXazLQvakgzsS+RrWxBsHvxsbNT+6dpqUzez6jlcbb9jSx86BJ3TjgHutE+1WBR87HSasiuhSDVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760656446; c=relaxed/simple;
	bh=ITMqOLCtxTXwtLJfhCV2mihXr4gf+cYn7l6eHf2Y+Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=giLg2J2D2VdzprU7E/iYw0/UCPMPGvYCFRqQ4244fS6h6nB6dJOjOkEd5FRp7oAoH8QtZReNvoK9JnG3YsgQaMR9tMR5yMP+s3hfdRMMRlrX0KX6rlXRTr02XnoWA9hSDtLvDHC3MPjQ7BzkSBr2k+poihzsOYTpGUTe62TDkYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NK44aBRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NK44aBRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190C4C4CEF1;
	Thu, 16 Oct 2025 23:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760656444;
	bh=ITMqOLCtxTXwtLJfhCV2mihXr4gf+cYn7l6eHf2Y+Sk=;
	h=From:To:Cc:Subject:Date:From;
	b=NK44aBRzxaUx3lsfUitwGmoNGboFZ6cTTXMKWQI+kBOyi4NRBR8jOs4I8RsBC9DP4
	 sJC6kkjxsTkETQa0xviq0+REnY+Pw5K7gw9mpfhurtabTvk8uNMmBZ5RbIoF6fbf3H
	 FXXlS3CyShJFUtjXwSFM0163wiFIFwXRT+XXBe907ORwVBa71bBRCkxXWdgM2wxMzV
	 Nz9WiDRn8GciOkdEOI/MuQvhAi0IzGdPnzVImqp0gFrOF6ylZaUevUBLB152sUK+1X
	 fedIbFNKZlbEzxVbPCiIvqyVlOM5mta8ZD/7nhhaM6kVg/bPsEs/LI1sUzJQior1Cq
	 Zux5cFF2RJxMA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: linux-usb@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: usb: fix formatting
Date: Fri, 17 Oct 2025 01:13:50 +0200
Message-ID: <20251016231350.1418501-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We do our best to keep the repository `rustfmt`-clean, thus run the tool
to fix the formatting issue.

Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formatting
Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
Fixes: 9a55e0079258 ("Revert "USB: disable rust bindings from the build for now"")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Greg: I am sending the `rustfmt` series to Linus to see if he is OK with
getting the tree back into a clean state:

    https://lore.kernel.org/rust-for-linux/20251010174351.948650-1-ojeda@kernel.org/

And I noticed that in linux-next this is wrongly formatted (i.e. bad
sorting).

Please feel free to just fix the original commit if you rebase, of
course. I am sending this as a patch in case it helps.

Thanks!

 rust/kernel/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 9cf4ca0ae7a1..cd191686fef6 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -138,9 +138,9 @@
 pub mod tracepoint;
 pub mod transmute;
 pub mod types;
+pub mod uaccess;
 #[cfg(CONFIG_USB = "y")]
 pub mod usb;
-pub mod uaccess;
 pub mod workqueue;
 pub mod xarray;


base-commit: 2433b84761658ef123ae683508bc461b07c5b0f0
--
2.51.0
