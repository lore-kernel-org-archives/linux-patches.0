Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063109;
	b=XF4XY2MIrLnesGzEtCGfQ+4Ow25Ci1qLtbdYEyEhzOQ4rDWmWcyG2n+/cPSxMvrh8UPq
	 MakMvB/oMgI8VlkXntO/f2jXq6/FagjnAHA1vR6PEPMVKc+Z2Dd/hawa9xY7vLWMmHxhl
	 szy7S2FoHvw6OsitL8V1jUdHW8uQV+D6PKqK86WQYNlWmTaBFmVXrHTyAu+9uwsv/irld
	 X7xeLadxUBmBbY7I8edeWMdEg1+hBFnUkovTZaEe7nlch+wsCHGjIbTuob4m1mgB/BveQ
	 1jmm30eZGPZJUI7l75Sf+cbZXnXyfccM4r6rZqF46F3JwPnKTv+UkVqk9nc+hTpGe3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydCQ4RFhhvwKhUMRGmueJXOQq+QA9J2N2/TPTCHpof4=;
	b=K42WjrJCZYf6vxb2D0cNew1VcSRuOZpqAqjl9nReWazY4B1BPvtse/B+reJO0ytZb3Ws
	 aLZnoAeAVWO9JlSv0wjZmI976+vupE8awsgMP0A9gttDutmarRLwOex31Sp8pxPC94LH6
	 U6e0l+cBLpT5iJ45ZLvxSiWvauUUKIVGpdRopBYwmoo41VF6CC5KeIbFmaztyoCeTDbMS
	 XmVcPPdZsHX1iNAj1LIuSxBgivFmM6q2u41HpGVCkrJHZtAjEkdY00vR8IT0g6UEYlsBj
	 xq7EJBXiQ0cFOnfBhslJTiXCl/ASf+SyPC00/ak9ieqFpBQAWPBAJRJD7LABxdDEXKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wn3SkzHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6205F606A33B;
	Sat,  7 Nov 2026 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wn3SkzHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109B91F0089F;
	Sat,  7 Nov 2026 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063109;
	bh=ydCQ4RFhhvwKhUMRGmueJXOQq+QA9J2N2/TPTCHpof4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wn3SkzHkV1rSqYEGhxk9fN4sgHoIXYQ+WdR9wNvaDPu9zRLOvXFpy8hTqKMMSFJpP
	 etG5EvQnD7r/DzDV7NKry6fXIYOW6nrTKsjKrgLRUzisX+GbknHVDRtv5wOxcZCdMW
	 bDmGWQQwowvDcI7Z9TGNag4k0J9c/zGapVbVfRgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/869] media: chips-media: wave5: Handle polling IRQ thread failure
Date: Sat,  7 Nov 2026 08:50:23 -0500
Message-ID: <20261107134903.947564838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 3216b49976447..6fa2ff1cbf128 100644
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



