Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831438;
	b=q8n6vzEGbDLMvDUgtLuuRZr1zTktA65Zp/eTwMB0Q0DSxGCMzgrO4HcQ5lXMJ/u9ZK8W
	 hHJ7LwLkM8b0NrVY5sFgVFekJGHgJrJTWA7J9QY4OHKZKDVqk5F3g+URa1HtWEDDYAi/f
	 i9ul6aWnO8Y/p+xCJhFM3w5G9oaX1OOX39+gS6oImDrbCMwynoH1/maH1XAqLrXwBazDp
	 ptGM2hAJHHw2f74T5B3l4aXun7IPPO2BWS2X/r8On9cqFe38aIENhjQbsRnZZh5c25gWe
	 VnlkBXMel33ljXnzvmLHj2E+AyC2fRTG84DgEN8EU0tM/lM7X3sDoH+AihFimPGX8BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VLiX+sQyoKBSJV3Gcyf2ZToSFi65RDtHUhhPJ8S/S9U=;
	b=1P9le8KsbAJYyVeE4JUBImI1ZMi3q5lXG+4nKS0dMP6VAp3xxwWY/pTW70G8K1XOscR9
	 H2p6PViQNISemIyk72Jlznr/sJQ+P3VZ8oid6wwfTLL72maOOdT36Jc8n57xp+XsgC6vW
	 AWHibOQwHwq96CGfc+TSwdPAy+xl4TYvnu3d57YpkrlzGH8UxkouyBaqs2gf4V3F0xtb7
	 1L3xTUah2guUvBIl0MAIQLyQt17MAV3dOWaRgJDvuOtCROgQSym77ieP2r9GChFzjhDT+
	 BqDyWCoAbc9+W5m/2/+7ZX5mweFdCEQ2utIeH2Ki6oF8Fz2yvGRBarBazKhguLZC60w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yY6ISSz9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E357606AC00;
	Wed,  4 Nov 2026 22:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yY6ISSz9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C351F000C1;
	Wed,  4 Nov 2026 22:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831438;
	bh=VLiX+sQyoKBSJV3Gcyf2ZToSFi65RDtHUhhPJ8S/S9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yY6ISSz9c/8ds1XxFZuJCymGAsYIQusg1MRC9xGsBXgYj4pHq63Xzl5QuGgnU0CG3
	 jxdiY4tBehEpmm0pTBF0cFnkgnP0KwfGCwTFU1r3aZKh22WtUrGpULf0QwqJuHj7vh
	 nNOsNpt3Yq7hUrSP2Lb4+vF3VNxpxDIWe6sn7FEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0701/1005] rust: block: require `Sync` for `Operations::QueueData`
Date: Wed,  4 Nov 2026 16:07:14 -0500
Message-ID: <20261104211103.225403995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Hindborg <a.hindborg@kernel.org>

commit 67b7a2728e4873e64405c5564fe50f7123012b71 upstream.

The queue data installed in a `GenDisk` is stored in the request queue and
handed back to the driver as a shared borrow through the `queue_rq` and
`commit_rqs` callbacks. Both callbacks obtain that borrow via
`ForeignOwnable::borrow` and may execute concurrently on several CPUs,
since the block layer runs one hardware queue per CPU. That means a shared
reference to the same queue data can be live on multiple threads at once,
which is only sound when the referent is `Sync`.

The initial `GenDisk` private data support omitted this bound, so a
driver could install a non-`Sync` type as queue data and then access
it concurrently from multiple CPUs without synchronization. Add a
`Sync` bound to the `QueueData` associated type to rule that out.

Fixes: 90d952fac8ac ("rust: block: add `GenDisk` private data support")
Cc: stable@vger.kernel.org
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://msgid.link/20260608-queue-data-sync-v1-1-0efff051aaf3@kernel.org
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://patch.msgid.link/20260929-rust-block-for-v7-4-rc1-b4-v1-9-642a4c1aebd7@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/block/mq/operations.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -30,7 +30,7 @@ type ForeignBorrowed<'a, T> = <T as Fore
 pub trait Operations: Sized {
     /// Data associated with the `struct request_queue` that is allocated for
     /// the `GenDisk` associated with this `Operations` implementation.
-    type QueueData: ForeignOwnable;
+    type QueueData: ForeignOwnable + Sync;
 
     /// Called by the kernel to queue a request with the driver. If `is_last` is
     /// `false`, the driver is allowed to defer committing the request.


