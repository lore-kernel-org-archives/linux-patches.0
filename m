Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062806;
	b=fVCsVCHdRzNkR46w5yiAQ/rh+dmpD8dd+V6NxEqtwHtatEu9+g+0pVRm0IDHGAhuXFRZ
	 xMVGFfDMzUS+VXpxchIMnWGBU2RbhBqXhZ/+FlKS0Byn+dX2lVCuvLOy8nhtJf9Wyt50p
	 LsVSbiyx+pMpmYdHmdX+K3f+Qkxze19Y3QAbjOkWRkgiPVgKCL5w6AWAiVp7s+nUiFrbS
	 r4Lk1EfYJRa3hpQiSbZdrZUG3/rQpsAlKGSlr3q43X4B4chOdaZmwQnLWUWONb6wUttIp
	 1hqfQAP1aWdgf4QprAvelfiSms9MYt4wTdHZ2ntuZi2VyalSMe3mJ0FVPWFiuixMBSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9XG63cyNP+7Y1koh32Ke49wOb7gyHfDr+KSVOHEViRg=;
	b=s0NY8HjDd+8Cdvk71sjh2Q0SSrwUoSU3cfvdXfFKcmX9kPTOkiiuiYncpwCTOYNePQq6
	 XXrbdxgpgEGSI15Yg7dBs/9F7NR5VaERdU4BOgqeSQLoS05TUsdaZ/mu4hp2ra3xuZUH5
	 Pt5FqiOimC9NUzBFQjlabDBQ7ENaXTemjEpgHY3dfY2VZ3fExSfC3ntIjn62QORC4tFs4
	 8OQhlAsn5MvmHX4yvDcDKjJqzwyJZfUBwMVmDb6bFRGFHcEcPjF36RAQ1xMUOPVBf6zex
	 mRS4swHXSxjYSgE0UZlbw0x3QBZiQkGSyNHnMp7A+GIaEcELLtF96gvy7Iv/TIiM4Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pON7uTd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E76E606A338;
	Sat,  7 Nov 2026 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pON7uTd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE041F0089F;
	Sat,  7 Nov 2026 14:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062806;
	bh=9XG63cyNP+7Y1koh32Ke49wOb7gyHfDr+KSVOHEViRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pON7uTd5UgLsf7Jh3xupf3zkBxpP7VpGPtIeVJgV4WVbB2sH70hx1cbtF4ibqK6Sg
	 7Z3OBDATxNWQ6P3OCPZm6xDy+/6ZNDegJ+3FLAGya/PQq0fwdAqyptF+0ChqM2yyzF
	 vEe1GwLZIypg+zXd6MctiLvbr7djWcRnptTgfJNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/869] media: synopsys: hdmirx: use request_any_context_irq() for 5V detection IRQ
Date: Sat,  7 Nov 2026 08:46:29 -0500
Message-ID: <20261107134856.236002004@linuxfoundation.org>
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

From: Alexander Shiyan <eagle.alexander923@gmail.com>

[ Upstream commit fce1e4fa3867c0ff19a31f9977741696710855a6 ]

Replace devm_request_irq() with devm_request_any_context_irq()
for the 5V detection interrupt handler. This allows the kernel
to choose the appropriate execution context (hardirq or threaded)
depending on the underlying interrupt controller. On some platforms,
the interrupt may be nested or require a threaded handler, and
using the fixed hardirq version can cause probe failures.
Switching to the more flexible function improves driver portability
without affecting functionality.

Fixes: 7b59b132ad43 ("media: platform: synopsys: Add support for HDMI input driver")
Cc: stable@kernel.org
Signed-off-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
index 8e6f452f76c73..dbbd33f5908e5 100644
--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -2532,10 +2532,11 @@ static int hdmirx_setup_irq(struct snps_hdmirx_dev *hdmirx_dev,
 	irq_set_status_flags(irq, IRQ_NOAUTOEN);
 
 	hdmirx_dev->det_irq = irq;
-	ret = devm_request_irq(dev, irq, hdmirx_5v_det_irq_handler,
-			       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
-			       "rk_hdmirx-5v", hdmirx_dev);
-	if (ret) {
+	ret = devm_request_any_context_irq(dev, irq, hdmirx_5v_det_irq_handler,
+					   IRQF_TRIGGER_FALLING |
+					   IRQF_TRIGGER_RISING,
+					   "rk_hdmirx-5v", hdmirx_dev);
+	if (ret < 0) {
 		dev_err_probe(dev, ret, "failed to request hdmirx-5v irq\n");
 		return ret;
 	}
-- 
2.53.0



