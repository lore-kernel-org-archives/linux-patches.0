Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023173;
	b=Z/dJBVuzb2NBcNUd4OKUcgviyseQHSVxLtScKi1+FEvsAh3SU2DgdpdcbN4UP/VcSfHM
	 mTSoq60caZ4BVlQLE/UqQGYsqLe2MReuFPqabqQLG4ZegBrqmWufsMeCjowE61ohv58hj
	 Itp1pnBKRFvh6A+0LdYxIGDRRenmLwMWQ75rcUhnqTHGJIMO3/y1ZFGliUzYUK7ylHC9F
	 XtPhbajmodQJXM+eXl2/06iiS96+fEWY6rMQwN9vMOzjW7lSC3df6osMPCD/sv/9QDMww
	 mOBMtaw1+26w4ts2u7X2Dn9iXXNTb81iTuErczhSXhDvh9SKyDdY6AoRbRktiJLn7Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrDinabDi66V7W5PtRG0SoV9aGvKdj/kz+SxEIkfu/4=;
	b=2sWX31OT+GHjnZjrzV/FUOHHLEhzdzKEvonSWU28SHWgrfEGAFTxw7sn0yN8UCQX10Gy
	 r4Q4j9UF+KPg2NtN65MBlg2i9RoIPfIPKemiyMNs2Los+sd9ZgJ1kDkt5V7dCk9K+qquj
	 XIiT0cr4tf0SuNU9dssZs0fGGB8RxuBWnRJW+QrcC78mZLWQzFiHSccZMydwPwnTf7jhx
	 svR6sf6SqO9jUFvxvxHQS7aVXO+64ClMhEApRREKM3tf46v40mXiC8fUDZdBbOBxLhzF9
	 QownAkqcDN34m76ZFZjly6yQsGs3cXb1/rDXC4Bf5Jo+hC56cSJJnDifb8DlSKrJCUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVE8Xxvd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD93606A325;
	Wed, 18 Nov 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVE8Xxvd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788011F000C4;
	Wed, 18 Nov 2026 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023173;
	bh=LrDinabDi66V7W5PtRG0SoV9aGvKdj/kz+SxEIkfu/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVE8XxvdVwaQBMMFsTF00Kk8mFa+46Nj2evygCb7Yxj+GT0/Opt5Vebk1JFhwSL25
	 4oQEG2ZH9DOGYLglo5bbSoFV503S7HjZgY3Cy1YkcaY+BLcACXIC/aUZFtuAWYUW1F
	 vnglIH4/xHXcbSFAm3o+9/oQaSWYb/JBLt9yjYlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0274/2151] virtio_ccw: fix synchronize_cbs() after interrupt fallback
Date: Wed, 18 Nov 2026 15:33:29 +0100
Message-ID: <20261118150131.842860943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6e484b870b71eb6acb3fa7a10b8e71098e242033 ]

virtio_ccw_synchronize_cbs() assumes the device uses adapter interrupts
when vcdev->airq_info is not NULL. If registering adapter indicators
fails, virtio_ccw_find_vqs() falls back to classic interrupts but can
leave airq_info set.

With VIRTIO_HARDEN_NOTIFICATION enabled,
virtio_ccw_int_handler() invokes callbacks under vcdev->irq_lock.
synchronize_cbs() instead takes the indicator area lock, so it does
not synchronize with those callbacks.

Use vcdev->is_thinint, which the fallback clears, to select the lock.
Keep the airq_info check because is_thinint can be set before the
first find_vqs() call, when airq_info is still NULL.

Fixes: 3a232277c1ac ("virtio-ccw: implement synchronize_cbs()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908053817.26065-2-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 4904b831c0a75..98b62bc18228b 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1061,7 +1061,7 @@ static void virtio_ccw_synchronize_cbs(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct airq_info *info = vcdev->airq_info;
 
-	if (info) {
+	if (vcdev->is_thinint && info) {
 		/*
 		 * This device uses adapter interrupts: synchronize with
 		 * vring_interrupt() called by virtio_airq_handler()
-- 
2.53.0



