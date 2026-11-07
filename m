Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063928;
	b=YhC2soMwWddJbhP0yA48pNbK5heAyuw+RcvmjjS37rF3XfUpnP73uhAV2fVRkNbwLSOR
	 4DCyT204wTQjZ0/w6Wjzk7jMOUf1xQT8kvVzmT/PhyncDYaKjKlY8YZHMG65FmrMgqXag
	 mxRI8Zw7eOtqB1UsNPUWg/QM5rT7iHNTgmRRLEF1RgEdp4Ul+8D8R+YShrNxLoYvbwqjN
	 NrlIOJUIcuwmLexScbNHrZ+Z8WUBR8hlLnakyJMXvlEo8Stk4w/rGekZ75bhjiz7QTRjb
	 igecliGmpEfXONfwZkcCm66aLMt+Pf/nC67Efg8pISRxcr1+L51qrT7Tghsp0vVBtyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7W6zn0QL6/fQLBm8SmWJRSFykORQSDK+RZZaTUyH7Cw=;
	b=Zp+GfaESedTZ+F7m9giP4pPf0mp1A4exI3q6cBrO5ioKqWyK2k+8dHF5/e3VVv7FFV4y
	 YuOSNoaCe9Coe0pHxYPde5BqM5ChmaBrexEiJ4v5Cz1UoUa4oReDVxX0paXrCuvMRO0Kl
	 EAyISoah+4Qv7s3PNhPHtecWto5vlb1XwgPA1mTuXxeS75N5IwmjHqs85/Av8Cfj+eEYX
	 bbiKFLal9Q7HrcizMW7fQw08OcLrsoyBJPK8dZtvp+rzOq0Dl6kk4zcZps3Jk8VeZPNTP
	 9Qr2c9PDfZhPZEQPSe9gHT/46sbMiTVlwi2Te8QUlJ/RhUOQWF1cWKD1hl0JJ6jy61g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAziBhOM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE436606D802;
	Sat,  7 Nov 2026 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAziBhOM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEFC1F0089F;
	Sat,  7 Nov 2026 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063927;
	bh=7W6zn0QL6/fQLBm8SmWJRSFykORQSDK+RZZaTUyH7Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAziBhOMHzUthNJI1liE9zMuJ9iZTn9Ko0pillTn8JSNdm/BetaqCrQ2iuJDDqQNl
	 QUG6PXG4Gvq7Ixf6VgKNpUZH34jS31HuwDbmra5v0g3bTf928olpLYLm/kpf6ZHycQ
	 yhli4iPXlN0ZMVyrEeqT+ydE+Ua6YAMV8OJDLXLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0122/1257] media: synopsys: hdmirx: use request_any_context_irq() for 5V detection IRQ
Date: Sat,  7 Nov 2026 08:40:18 -0500
Message-ID: <20261107134942.699916120@linuxfoundation.org>
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
index 25f8ca0d6d946..e84d4418c530e 100644
--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -2609,10 +2609,11 @@ static int hdmirx_setup_irq(struct snps_hdmirx_dev *hdmirx_dev,
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



