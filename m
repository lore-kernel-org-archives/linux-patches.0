Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618077;
	b=R3EMaimTDT/aa8YFESs+TnSxDXJ4CFNhr/qLjDuYQXO58t2w6X4ekMS9utVAtTWc6Vtr
	 YfKkX3HmxF6ejHV38ME6dPt4M/A595Zr5MIOOg9vudZZHuXFDG22DAX7FzZHLgVrc6Mnu
	 ZUvVGLTv//OF1G/repqSt7Ljp0u6U7Wm4MrRSIC/whetlM4TCzUu3zdVqBatqkzbliNN2
	 2NNCHhvB4WcYCk6vj19/hM1aaWhUVbet1BkLyzUg6VOkCE3hnFVjo2/69NTElhcqRYDBz
	 IzYMWLZn0Kpnx5FmOkwPQfbGZ+E6D0c20+M5K/sMp3n0zviCLrqdpUGi6GxhcFLEdyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h5dfHULPkyqiKF1sag7sfgbodz1r8lvC2+UNA1GbfpE=;
	b=T1qjXB3UfcuodYeznuvh6EYqb6J47qUGHrP4vUt3Bv8tQ6KO3+xQLhIbRCiqmU8DY5xw
	 4wK3XufsGliSeskeFJb8ReQffZReYQDzPTneQilucNOM+19UlGKIf2KZxDbdQCE1I8Rk4
	 y9u0nv4yfO4ngNTTHdm2baHsUB+/71SuwqJspJg924JWVW69aVHycZ74eFhGuDK/KC/YJ
	 RZNbgzFwPlF7da2QDPLrhZEF86GnQfWUmzpkMwoxluTKXOV6tuIOJaGBhAaDYGgxxE8MA
	 3Uk9ZmapTL47Sof4gj5qdFwBGoe3LmhPJCcuOaQ5jRCCW+fz/XYqQVzW+7G0Qc1TYlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LU9m/D+n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2AD606A31E;
	Wed, 25 Nov 2026 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU9m/D+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37B81F000CF;
	Wed, 25 Nov 2026 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618077;
	bh=h5dfHULPkyqiKF1sag7sfgbodz1r8lvC2+UNA1GbfpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LU9m/D+ncDWzgZFFLa+S7OGhP86GuQvDnasUeUQ3WvrziW1zj/jXTyeKiPorTlUD3
	 fIVlsxR9lQDmel1XvT7FXLHitJNDmUVuvRCY9DGS3czlKOCgHc3nA+wiA/Pk00/Flj
	 wF4VGrdihhb/fPQLnXg8wfrbOcw194eTCWCcYzmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0163/1005] vduse: avoid infinite loop when no affinity CPU is online
Date: Wed, 25 Nov 2026 15:25:01 +0100
Message-ID: <20261125143825.560444106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit cf0a5805d43236e308f14188f9737ddcf83fb53a ]

If all CPUs in vq->irq_affinity are offline, cpumask_next() walks to the
end of the mask, and the loop then resets the cursor to IRQ_UNBOUND and
restarts the scan. When VDUSE_VQ_INJECT_IRQ is issued, the intersection of
vq->irq_affinity and cpu_online_mask is empty, so the caller busy-loops in
kernel context on its current CPU (e.g. CPU2).

Replace the while loop in vduse_vq_update_effective_cpu() with
cpumask_next_and_wrap() to find the intersection of vq->irq_affinity and
cpu_online_mask in a single wrapped scan. If the intersection is empty, set
curr_cpu to IRQ_UNBOUND and let the existing unbound workqueue handle
injection, avoiding repeated rescans when all CPUs in the affinity are
offline. Use cpus_read_lock()/cpus_read_unlock() to keep the selected CPU
online.

Fixes: 28f6288eb63d ("vduse: Support set_vq_affinity callback")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260919083933.104437-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 49a231bdf9489..f953353b50b4a 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/cdev.h>
 #include <linux/device.h>
+#include <linux/cpu.h>
 #include <linux/eventfd.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
@@ -1430,14 +1431,10 @@ static void vduse_vq_update_effective_cpu(struct vduse_virtqueue *vq)
 {
 	int curr_cpu = vq->irq_effective_cpu;
 
-	while (true) {
-		curr_cpu = cpumask_next(curr_cpu, &vq->irq_affinity);
-		if (cpu_online(curr_cpu))
-			break;
-
-		if (curr_cpu >= nr_cpu_ids)
-			curr_cpu = IRQ_UNBOUND;
-	}
+	curr_cpu = cpumask_next_and_wrap(curr_cpu, &vq->irq_affinity,
+					 cpu_online_mask);
+	if (curr_cpu >= nr_cpu_ids)
+		curr_cpu = IRQ_UNBOUND;
 
 	vq->irq_effective_cpu = curr_cpu;
 }
@@ -1672,10 +1669,12 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 		ret = 0;
 		index = array_index_nospec(index, dev->vq_num);
 		if (!vduse_vq_signal_irqfd(dev->vqs[index])) {
+			cpus_read_lock();
 			vduse_vq_update_effective_cpu(dev->vqs[index]);
 			ret = vduse_dev_queue_irq_work(dev,
 						&dev->vqs[index]->inject,
 						dev->vqs[index]->irq_effective_cpu);
+			cpus_read_unlock();
 		}
 		break;
 	}
-- 
2.53.0



