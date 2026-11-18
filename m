Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042793;
	b=j5EASI6Tv3hFb/xG44fRn4OhMotqJvuT2gTb92DN3EZ/85afGCgz1T/cUVIidP7rkts0
	 mX1hBOXgehIP7gwwLPBc6fYeEHJt3AKv6HVygaFbAV8dnYLmKaGUZyrMINC7CVurcK73f
	 Wp4BypdM/2I8PZ2nh3tIV95Eh4F6k0ik6Y9/uBe8u+czQfy5M5CO1YvYLWImg3Wb5VDfB
	 AYypzKWRksEu/gLO5CX2VPdL8aPa5hBTHDpmWtxUS9I6IZuQDsY1qPd0q/UIel6JdjcI+
	 9Z+VHum2SaCk0Fqx8x8Dki3ltf2KIPF1/5M5a/L4RZB0j5fymOHrcxk5cHdPFLz2qSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eNo2WpJOzkvv6lSjE2M+xQ1UVUgWPyHXYTVseH8Oho4=;
	b=uym+FNYGTnoZdDQJrij7tEcWxgqSoVlztmzc06h5iduvrQ76yYbJqwdYo88xFjiXXLJi
	 BnO6IqSLj2Rj8dqUCxT18OAOWOTXy+CZsjonRxIIDBg5aA3QsYPkUQuGJFZ80h0+2xh9W
	 zVlClkXHr/WdKAN5t8JyzwQNaGr2L9W0s+r78b4/niV4pTkPC73YBUsVqamKO7yvvzkNl
	 4ieqY2ciD6cIbxDUPH784irH8y0ZLV0doZ8qpvkLgL1lzUwEMKHv8ZLx0RTCfB+1Quh1w
	 zUigjRtfIVma10WjyXywoqHOibL+QHq3Vu/bMC/oMmqkfT2iC8q3uX9HzSR7/F/fTzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNXy8EjQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EBA606A31C;
	Wed, 18 Nov 2026 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNXy8EjQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AA11F000C4;
	Wed, 18 Nov 2026 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042793;
	bh=eNo2WpJOzkvv6lSjE2M+xQ1UVUgWPyHXYTVseH8Oho4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNXy8EjQSpLv4+FXEt4A4m5sMQryfRGsagYwplvJPa9whvP+jKfXIwG23rlwKF/3l
	 wIkt4GiNgm1vKf4c/r+8ew88floJDIIDKFllzbHtqXQB0fnqVqC5BZ1gVbRUjJkVRs
	 Rscg6GZ9jMHklJ7bVW5S7vL58Lw1Bn4k+HYoKOi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 3298/3318] vdpa_sim: disable page faults around vringh_need_notify_iotlb()
Date: Wed, 18 Nov 2026 16:05:20 +0100
Message-ID: <20261118150458.532713421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 05fb07c40e0013ba5ae373c6ea1bcc622eaea7f0 ]

When vdpa_sim runs with use_va (the default), its rings live in user
memory, and vringh reads the ring's flags and event index with
__get_user() through the user address.  The net and block simulators
call vringh_need_notify_iotlb() with bottom halves disabled, so those
reads happen in atomic context.

That only works today because __get_user() has no might_fault() check: a
fault is not handled in atomic context and simply comes back as -EFAULT.
Make that explicit with pagefault_disable() around the call, so vringh
can use the normal user accessors without complaint.  Only the
notification check needs this: the rest of the ring processing runs in
the same kthread without bottom halves disabled, and can fault normally.

Tested-and-acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 9 ++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 770a40a20be9d..0d5922ba05bcb 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/uaccess.h>
 #include <linux/blkdev.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -343,11 +344,17 @@ static void vdpasim_blk_work(struct vdpasim *vdpasim)
 			continue;
 
 		while (vdpasim_blk_handle_req(vdpasim, vq)) {
+			bool notify;
+
 			/* Make sure used is visible before rasing the interrupt. */
 			smp_wmb();
 
 			local_bh_disable();
-			if (vringh_need_notify_iotlb(&vq->vring) > 0)
+			/* The ring may be in user memory, and we can't take faults here */
+			pagefault_disable();
+			notify = vringh_need_notify_iotlb(&vq->vring) > 0;
+			pagefault_enable();
+			if (notify)
 				vringh_notify(&vq->vring);
 			local_bh_enable();
 
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 2a997b0ae3a84..1fd298bb808ce 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/uaccess.h>
 #include <linux/etherdevice.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -68,6 +69,8 @@ static struct vdpasim_net *sim_to_net(struct vdpasim *vdpasim)
 
 static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 {
+	bool notify;
+
 	/* Make sure data is wrote before advancing index */
 	smp_wmb();
 
@@ -77,7 +80,11 @@ static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 	smp_wmb();
 
 	local_bh_disable();
-	if (vringh_need_notify_iotlb(&vq->vring) > 0)
+	/* The ring may be in user memory, and we can't take faults here */
+	pagefault_disable();
+	notify = vringh_need_notify_iotlb(&vq->vring) > 0;
+	pagefault_enable();
+	if (notify)
 		vringh_notify(&vq->vring);
 	local_bh_enable();
 }
-- 
2.53.0



