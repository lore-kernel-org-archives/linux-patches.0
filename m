Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213363;
	b=HqSShWZMWFdYuFS0Q5A9S2PORkQkD1zdO0Ao3PW3gY+aISWDGwQDDGUpifHhH49uNe6Q
	 MNu3cmMf+gr3AFFswMYUmgT+TwgX49Z+M36M9/oxMonq9M3xIO9sd+bS1JISppM75heMC
	 oqP3VA/sGuBMOHaKXJvcalutBIXLwSTnYv1hrhViVdBGe5KSGLgeA2drZUjrZO0H0MgAL
	 X8RoRvHKXE1rRkW2pVi9WRwA6xVzy3ZFbgxwtivQ2TOir3BDq9vDn5VIPNxE0xDd0fjyT
	 PYLNCiitMT4tH0jxj0+oonDmAYG/JQJbuODxuIzU/lYXTVuz6lMns/4yNaBYCHzvfAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EwaWyxzAcMip938tYPQSTdjtGuyW8xEbLpEwEiXGtnw=;
	b=3NS8CRKrXWP6N79FMMWLTt1KuCNoW5ka0IukKAsaYH0NIw3rPkWac3sIXzovc7E4zLms
	 p+1cWvYMj2F3KLfX8RHlbXwkqbkpfOwdjHvixIyDEamkj8RNFBB9BIvyPSmsTmLRY5TL3
	 ViRKM3z+IlPifMyR8MeaGNb7m0j8o8fipY5PNzmUz1BnaHsvacu2v0IUPF/2xTN0s3UXl
	 nWTCHoC1FjTCZedATMud2MG98P67dII9bL4z/NVMWltmedaDYi9drh9VBX+fXG29rwLd6
	 WiqVoFimBjGW11nok6QD9gjiRT6aZfgEyZHVvFyFrxBUE0ssr+XmcMpG9tB9p9zGlvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLIKcdr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD787606A31C;
	Wed, 28 Oct 2026 18:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLIKcdr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2DE1F01825;
	Wed, 28 Oct 2026 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213362;
	bh=EwaWyxzAcMip938tYPQSTdjtGuyW8xEbLpEwEiXGtnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLIKcdr8ve7Yp7AIxyatDTGytthclVxqmCUcMCJXZKAAOI2Y4MH3Uf8g5IHdVhkHg
	 RoSQRZiYic/uSEREQnEGXUug3nE0f2ciFu8VBYiWU0w3X5HJYCY0Wp9s1zHsQTL5iA
	 AfquA3hbHWTIL0cGZ+2JyzgK2cHFOSHiIbB/uwE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.1 0477/1887] drm/vc4: drain the hangcheck timer and works on V3D unbind
Date: Wed, 28 Oct 2026 17:42:53 +0100
Message-ID: <20261028170510.103940093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 94cf5971b1d04c6382437387c4dc3836cc7a1437 upstream.

Nothing stops the hangcheck timer that submitted jobs arm, or the
job_done_work that the render-done interrupt queues, at teardown:
vc4_irq_disable() cancels only overflow_mem_work, and vc4_gem_destroy()
runs from the drm-managed release, after vc4_v3d_unbind() has already
uninstalled the V3D interrupt and cleared vc4->v3d. A timer still armed
by then reads V3D registers through the NULL vc4->v3d pointer, and the
late callbacks run on the vc4_dev embedding them after it has been
freed.

Drain them in vc4_v3d_unbind(): shut the timer down and cancel
reset_work before the interrupt is taken down, because its
vc4_irq_reset() re-enables it, then flush job_done_work so that
completions queued at teardown still release their jobs.

This issue was found by an in-house static analysis tool.

Fixes: d5b1a78a772f ("drm/vc4: Add support for drawing 3D frames.")
Cc: stable@vger.kernel.org # 6.2+
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260915095103.156007-1-fanwu01@zju.edu.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_v3d.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -9,6 +9,7 @@
 #include <linux/component.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/timer.h>
 
 #include "vc4_drv.h"
 #include "vc4_regs.h"
@@ -513,8 +514,15 @@ static void vc4_v3d_unbind(struct device
 	struct drm_device *drm = dev_get_drvdata(master);
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
+	/* A straggler vc4_reset() re-enables the interrupt. */
+	timer_shutdown_sync(&vc4->hangcheck.timer);
+	cancel_work_sync(&vc4->hangcheck.reset_work);
+
 	vc4_irq_uninstall(drm);
 
+	/* Flush rather than cancel, so queued completions release their jobs. */
+	flush_work(&vc4->job_done_work);
+
 	/* Disable the binner's overflow memory address, so the next
 	 * driver probe (if any) doesn't try to reuse our old
 	 * allocation.


