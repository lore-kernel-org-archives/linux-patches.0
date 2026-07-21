Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9603BE154;
	Tue, 21 Jul 2026 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669331; cv=none; b=rVf8TYDNODeElxdOUrzwDkUfQTul1cyqL7qGINKAZ/P+y+ZAd/eUwbdb4Uvv9Dgc4SR8nW5t9KOOj+JNCdEccI6+HPwxryDPrPRBrxRqbHoQkkwiaeRB4kxjnmyfMmo3HdfsMe4GETWXm29AbhPqOWUjNuHME9Z3217pdRcykKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669331; c=relaxed/simple;
	bh=pjBpyU6C0tRmL16NPA49mVRzUEsg7NiOF7z9VqbyD8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bmi3EXful96Vp4SmCYeuzLyacWoqHp+hgjybrJUKsf0rM29aj/Bq59nf7t5T2C7lyFU6a6w5i/M2Let3ofTTOtjFnzRhhkFpdI5vf96GLIOlShsfEnERk1pIi1QXGrhyuNn0jONiYgCzVWG2nJ/CKul48QMnL349VODiMMe17t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQc/eg8K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQc/eg8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0101F00A3D;
	Tue, 21 Jul 2026 21:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669321;
	bh=lK6pxe2xdW7dzwAJvIUL56VfzdKaZnqukrJrKOho1cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQc/eg8KFtuzI2eD6Dh2IpkkDu+Hu6qkPhuDlWJNuUh+JHvStD9A8rSwLnjWGBuJ5
	 eCWYfzqwMRCnB+TosN7A3p0C7uDvv1W9VZvWS+hYbwO9KVJlpONnrWEwA2NECGp+Ba
	 fwd4t/jDyVZMQ95MM16j4wI5MtggSNa5MSRFhU7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0509/1067] dmaengine: qcom: gpi: set DMA_PRIVATE capability
Date: Tue, 21 Jul 2026 17:18:30 +0200
Message-ID: <20260721152436.002551319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

[ Upstream commit 4e351f408743354d54ee1af5193fc78234f2044e ]

The GPI DMA controller is only responsible for QUP peripherals, and
cannot work as a general-purpose DMA accelerator.

Set DMA_PRIVATE capability for it.

This fixes error messages about GPI being shown when an async-tx
consumer is loaded.

Fixes: 5d0c3533a19f ("dmaengine: qcom: Add GPI dma driver")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260602070344.3707256-1-zhengxingda@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/gpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/qcom/gpi.c b/drivers/dma/qcom/gpi.c
index 846b532d77a568..ccf781b6c05f1d 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -2253,6 +2253,7 @@ static int gpi_probe(struct platform_device *pdev)
 	/* clear and Set capabilities */
 	dma_cap_zero(gpi_dev->dma_device.cap_mask);
 	dma_cap_set(DMA_SLAVE, gpi_dev->dma_device.cap_mask);
+	dma_cap_set(DMA_PRIVATE, gpi_dev->dma_device.cap_mask);
 
 	/* configure dmaengine apis */
 	gpi_dev->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-- 
2.53.0



