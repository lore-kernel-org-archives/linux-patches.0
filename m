Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D1821E087;
	Mon, 10 Mar 2025 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627188; cv=none; b=GKctsqEK/YilKUK5XrBuWFlZFeNVK+6XeRmxZLu77/k6H7v8aB7usod4bKF1Ow+EyLDJk+HgieCksbRTG2DJ3H1oK42SSybsUN8ASx9tSjhpg20/CJhLPdfxbcsTcHWfnI/9aIdKnZitPhYZ8QeDiExV/DcKGj2cGPOzGVi4OEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627188; c=relaxed/simple;
	bh=h5ICg7jMtEIrzFNkWynIYbmFvM2efuoxsbYLeGlr+E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMV4OwZPLb0FIuY4AppNwT23O35fWfG+2fwlxxnnmzyznwBSMIwuYlgde65k7IPeMChXzk6hG1YKzALTnraieLPLf6SdAFhFHcJgRZDPUvx6FY9AsBliHjyuUVjbh2SSIztX9ZEbcLS+RHe1tV8Bw96TwInk2Z/12NPYQIKrGyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02tK3kwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02tK3kwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2E2C4CEE5;
	Mon, 10 Mar 2025 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627188;
	bh=h5ICg7jMtEIrzFNkWynIYbmFvM2efuoxsbYLeGlr+E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02tK3kwPclugzOo7XhyLhwX4KVDsGBW1/p5EF1+MeeS5p88kkIB6Pfj85YhPGIqus
	 PvuCu0jlz6BUn5E9mngzRSJ3bftcU0PcoOEejHy9mYL7pWlPUTIetpB7MqvcuBtYJN
	 XKS7eB4nFoagiURRMcJ8z9xJJN5ous9oSDlDxG58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 012/269] rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
Date: Mon, 10 Mar 2025 18:02:45 +0100
Message-ID: <20250310170458.194458227@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/workqueue.rs |    1 -
 1 file changed, 1 deletion(-)

--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -366,7 +366,6 @@ unsafe impl<T: ?Sized, const ID: u64> Sy
 impl<T: ?Sized, const ID: u64> Work<T, ID> {
     /// Creates a new instance of [`Work`].
     #[inline]
-    #[allow(clippy::new_ret_no_self)]
     pub fn new(name: &'static CStr, key: &'static LockClassKey) -> impl PinInit<Self>
     where
         T: WorkItem<ID>,


