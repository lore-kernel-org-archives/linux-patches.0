Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052627;
	b=nM5QBF+EaRr13hek7YO4nX9PgvZRROzWmmhsfAq4I9hb+qzSXRwHBp7lhWKyCNIyykBP
	 3biXBpGJ0Sb+ytfwAGBoIoZeMl0utYICIs6AHYNVHUJzMxwjK8WR4JFxuZcU3pJuL6T0M
	 BgvpXeoP19L3La2kZf45CTZSj7USNTuWxISPhWsYj3mlpQmQJxB+lozOVqGjWWs32bTYb
	 4dQ0W3PNQxwIQZn1LhAs1mJCYbST6e+lchCOr5nEhI21k/wSVehoeqkodyRy/TQIHcBhf
	 nFavlNrHQoyhl4ZWClx6o7bXGZ6YuIyM37DETrLS1uI8WN6P/HXDsx7GRtH9wvfm00w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IG077oAC1cDqjzulBdMJ3QhNKYuxpwxZ7aeYpQfLGn8=;
	b=4ICh7jBwkRmpv5v8LDt2nqcnw5hU+FHj9ApCIpNAqxb3oP8wmyUYvpiXz+L9Y2rEWn21
	 Q1LPsNFvxFoska5C66kdPdav6riDyevNEyWkN84X4MRfyuNLDgnnYhta13QRV0+TWGozu
	 CvYxm98lGzlMtDs9CJioMg5/Yd4D/AKVfpJR8hZTzFuiFBZiD80HBkdusdFkTyCJbDQRk
	 Q0etKsYibe3UsDunht2gATANqxj6e0wBnhSHBPZ4d+HrBujinBM7EgGN2EHrjkm+FSl0T
	 8ULR+Z/fd+bx08SY9MRWWDsddHEj8OTyKjArJS5B6m907/8vaxHEvqgqyiEawMhBhiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogpQ+Se6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544A1606A31C;
	Thu, 19 Nov 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogpQ+Se6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C241F000C4;
	Thu, 19 Nov 2026 01:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052627;
	bh=IG077oAC1cDqjzulBdMJ3QhNKYuxpwxZ7aeYpQfLGn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogpQ+Se6A4MpegZYQqYo2efEsE9sCq9zc0DuSupE6PXOLp0NMeO15qKeL8dxX6h7D
	 vRuQzSP4Ug9Hv6DLVdwjwf70enY9xMbbx+OfsezdKXJunZCZUrULp/sFeyN2E6y15D
	 U82J5vZRRFS+azDCbKObjPQ4202w9XWU/eCNN+BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DAI RENJIE <drj19981414013@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Mark Brown <broonie@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0581/2214] resource: fix lost wakeup when waiting for a muxed region
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118150034.173963722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DAI RENJIE <drj19981414013@gmail.com>

[ Upstream commit 405c00e43a9c72a0b9b318cc2d2e298386ffb58e ]

A task waiting for a muxed region can sleep forever in
TASK_UNINTERRUPTIBLE even though the region it waits for is already free.
__request_region_locked() queues itself on muxed_resource_wait and drops
resource_lock before setting TASK_UNINTERRUPTIBLE, while
__release_region() wakes the queue after dropping the same lock.  A wakeup
landing in between finds TASK_RUNNING, does not match TASK_NORMAL and is
discarded; callers hold a muxed region only across a bounded transaction,
so no further release is coming.  The task is unkillable and its caller
never returns.

The window is one store wide, but an interrupt is enough to hold the
waiter in it, and the machine this was seen on runs PREEMPT_DYNAMIC in its
voluntary default.  Since v6.11 spd5118 exports the DDR5 sensors of AMD
boards through i2c-piix4, which takes a muxed region per SMBus
transaction; a third of the in-tree users of request_muxed_region() are
hwmon drivers, so reading a world-readable attribute is all an
unprivileged user needs to drive the contention.  The blocked task sleeps
holding the i2c adapter bus lock, and 27 more piled up behind it.

Reproduced by building a kernel with the two orderings selectable at
runtime and a 2ms delay inside the window.  Switching only that knob, a
two-thread barriered reproducer loses the wakeup 200 times out of 200
before the fix and 0 out of 200 after it; without the delay it goes 20000
times through the wait path and loses none.

Fix it by setting the task state before dropping resource_lock, as
prepare_to_wait() does: the releasing side needs resource_lock to unlink
the resource, so it cannot reach the wakeup before the state is published.

Link: https://lore.kernel.org/20260821-b4-resource-muxed-lost-wakeup-v1-1-37eb6473a76c@gmail.com
Fixes: 8b6d043b7ee2 ("resource: shared I/O region support")
Signed-off-by: DAI RENJIE <drj19981414013@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Mark Brown <broonie@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index acba73cea61bd..894fa9ba17e07 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1214,8 +1214,8 @@ static int __request_region_locked(struct resource *res, struct resource *parent
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
 			add_wait_queue(&muxed_resource_wait, &wait);
-			write_unlock(&resource_lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
+			write_unlock(&resource_lock);
 			schedule();
 			remove_wait_queue(&muxed_resource_wait, &wait);
 			write_lock(&resource_lock);
-- 
2.53.0



