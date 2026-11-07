Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064369;
	b=0i7VngMCBFP7hPehI/W93817KyZH0xfSeh7Pj5GQpl7EsLQdmTAZBOu0RM/WAeu1+BHa
	 18J2eFoG9waL0s5yrZGQt+r5gQc3xs9YNPATP/bnAzsU+fipbd0mcVy3x7DFm+YrU1VSs
	 CcMmoBwkfXuXxNkGMdXIlWD4/EWO+l8MlISjOcFnluuylY0B7FulvKE1tuY2gSGwyAXMS
	 tAuqD0bsJZOtjwmNnS7XUeIZPXoB8VQBB4rXAPZb8gfZLupl9Dv0rTwr44hFyV08ZCAnT
	 TlzwNK9OgrGpHakY11kk013mV3k2BWKdR/7OiMaEDrp5ejwDuzi2no5/uajKO6tI+ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=izAWCN4bOhlhEE9/yvaiEkvIMUXU4cqTG1q56P0ho5I=;
	b=RgM8jgCHSoThLCETn/my1pb5LQerQ1Vnqkko8H2DzJ8x9qlLMUeOGJ6bpsf3vBWmfnyq
	 jDASLuvUnN//HSlNvA1WnkcB0Yz0knpFmvmXYgu9yHglCheCSOGP2+JmrfJ7xnLzAB6EU
	 WcksL+NaTBELMleDBv9NnLi+IQY8wL9dgBlRv19yBZEIQoNicMyyoz4bipsvHeYzpChRy
	 Mctj+B0nn+Od4Np8ogJmg1twqIR4EjQg5jz6smA353Qx+HD6SPMA8RggCrv9/KHHMkLNI
	 HuKYiPqzTbEnj+LVTeBTh0Jj9Nx58hBX1k0YmltDEL0yW3reHrghAaA7FKi9qEH0cgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+r0lMlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED79606B8AE;
	Sat,  7 Nov 2026 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+r0lMlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9AB1F008A4;
	Sat,  7 Nov 2026 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064368;
	bh=izAWCN4bOhlhEE9/yvaiEkvIMUXU4cqTG1q56P0ho5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+r0lMlMcvTrzMsVNzodUPR11kks68CyV0Q0I/Y9biK32Lqn5vc+pj56Hqx7SFQNH
	 /GYEI7kxUe+/ASYzn56ytJFPjIBBEnqi/jO2W4cPuNTEp4Z/dJfEAPqKh/jL0ZnOyi
	 bsKMDm5qX6rskikItUjR85mz72kpXGoP8PWUvBO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0448/1257] media: chips-media: wave5: Handle polling IRQ thread failure
Date: Sat,  7 Nov 2026 08:45:44 -0500
Message-ID: <20261107134951.853154217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 1d563e3d718a1c7c16355843374fbdd4c798ac66 ]

When falling back to polling mode, wave5_vpu_probe() does not check the
return value of kthread_run().  On failure, dev->irq_thread holds an
error pointer instead of a valid task pointer.

Both the probe error path and the remove path only check
dev->irq_thread against NULL before calling kthread_stop() on it, so an
error pointer passes the check and kthread_stop() crashes on it.

Check the kthread_run() result, clear dev->irq_thread and unwind the
probe on failure.

Fixes: e66ff2b08e4e ("media: chips-media: wave5: Fix Null reference while testing fluster")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu.c b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
index 76d57c6b636a2..37df270b5f991 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
@@ -340,6 +340,13 @@ static int wave5_vpu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to get irq resource, falling back to polling\n");
 		sema_init(&dev->irq_sem, 1);
 		dev->irq_thread = kthread_run(irq_thread, dev, "irq thread");
+		if (IS_ERR(dev->irq_thread)) {
+			ret = PTR_ERR(dev->irq_thread);
+			dev_err(&pdev->dev, "failed to create irq thread\n");
+			dev->irq_thread = NULL;
+			goto err_vdi_release;
+		}
+
 		hrtimer_setup(&dev->hrtimer, &wave5_vpu_timer_callback, CLOCK_MONOTONIC,
 			      HRTIMER_MODE_REL_PINNED);
 		dev->worker = kthread_run_worker(0, "vpu_irq_thread");
-- 
2.53.0



