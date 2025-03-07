Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7250618BC36;
	Fri,  7 Mar 2025 22:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387839; cv=none; b=QNxjz/opJJz8ezrMc+bzg+T4uROjfVClA7D27yhrOELjK//ozyQMmaUgEf8sk9Dpvnfyi5vNnuUFRGunX6YfKcfzPmwXK1HcuC7bt6E8p4vGVtXPcTWV7IzLa7/IZFpNDrI9o5zQa3Psoernp8Y0HQfaT3JA/0PrP55rF9jAyVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387839; c=relaxed/simple;
	bh=EO4f7Ie6hAqc4cI1H/zwn+IzvGW+V4Pxg+9gok0lwb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd9qoIboYJ/icPWBW2l1SWpWaGDH2UdBGSX1Kznncssr7+ujO5HdrkZS/5M6QT3OSQVLYq/XQNd1mtlPRFwP4e61+K5Ikc6mx0MjSUiE8cpz58ip+fim+Z7fLIgjzfXib7KXxwEILFMEd8XQgl+kz/qgnZFaRnfpbjEHjfjNgEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zf/c3XVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zf/c3XVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9063C4CEE8;
	Fri,  7 Mar 2025 22:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387839;
	bh=EO4f7Ie6hAqc4cI1H/zwn+IzvGW+V4Pxg+9gok0lwb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zf/c3XVzzjHtsSPvVVoKaLeVDON1D2nuId8w5ePhrJwhSZMqLYrY9FUZc/V6YYh8y
	 z/mpgdtOr06UbYHzSLyFGg+qfEDsXhhs6FnmMrjcnzF/IxDnPOEuG199YL+ImVWk/m
	 MkFLEBKqYmY3DC6pjWJGKNb1gDnusR81t0oQEdpgSNxR6Vv6F8tlpTv+FNXgr/nBIl
	 E2QvOU7+GfxT38kaw+eEkbnQ1kZ1o7c0g4TGfYLfGn/tZZmg8uK237WjyUqo90a8F3
	 q99shf1Ifw14/xL6aHai9GcTT23l4BnfMqX1gRM/vXFCAzRD96mqi5Ci6/jkBXRquh
	 iWaHQeMxhz/kg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 01/60] rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
Date: Fri,  7 Mar 2025 23:49:08 +0100
Message-ID: <20250307225008.779961-2-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 024f9676a6d236132119832a90fb9a1a9115b41a upstream.

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

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-2-ojeda@kernel.org
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
2.48.1

