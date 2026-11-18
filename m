Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045133;
	b=v6OWSgasNVlmJb9gmptbjFxCVomd06BRQy4dE2JPLEpqQ1c+X6a6aeahEkwiweqcLGhB
	 fs+bWK8t82nOGs73GI12vANQj/sMQHyL3RK5D0GKIroEHXqnWuwlrXr1Oj4w9yBecdqDr
	 z1nUHkJEP24WYIT1qHXutGKF+ynasdSLdvpnzSnMn6CV6DIQz07c0KB04IRp52NCHJtfc
	 IJB21T3LaL5Eeio8N21MbvOaYnB/GSjgKcpWuNLNZreQJ4ugasaNOntYMNnranhuy3E2H
	 FgSIEMBjbLeU6YiVmzWCxzZYSByODORLgiKvTyFw94wv1qkGMa+CnPADU8IwHpPcd4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i6B1oKShRd6lmO2WdmLzUvm3tNGLz3g2HyI+cJX9fkY=;
	b=I9vGrDKK1QgKsh06/ZFR1GLfKuWHAWSXWbzBliFER7+ajC+4WUA/b1hETcxb/ELAIrKg
	 KrIoZOK1EMAXuCVoNTAVxCONCRICu0C2gMjHZnq73IT7QrldRAGiTgoFpxTrZBCvVdXAr
	 BAYGO5/pm4vK+2tZ5t34EhppDrIFVwnU7zrlv+6+yWx26e37JtG8QH8RFpEePqY/pAW8M
	 JtnNHTqtOX+eunxfWh5X/8hucU8x3HtYBYb89rJyEy+YDwG56arGC+on4VtyMvaKBx2M3
	 PLuy83gfe7JcC6AckTDdnrfFXYockq/3c8QrI5TCDhZ/SSfQD2agofaKPF8JxzCmNcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXCQzJ9s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFC7606A331;
	Wed, 18 Nov 2026 23:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXCQzJ9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976FF1F000C4;
	Wed, 18 Nov 2026 23:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045133;
	bh=i6B1oKShRd6lmO2WdmLzUvm3tNGLz3g2HyI+cJX9fkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXCQzJ9sc9UskIJitQb8eBRF7wPTGHPW1i2mE7/wnscmFnPLhZhXWffCqnywTc5qr
	 HyT6BuSfX73FMr2oyRPwBikVZLqq+JSkpv9RQxUra2tAoj6svwF6L5ZHxvre2kMAxX
	 OyxkYxPoVEse3wug2wxpVm3foKTcpMYyy2w28ed0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0814/2857] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Wed, 18 Nov 2026 15:30:48 +0100
Message-ID: <20261118150230.887124012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit b296be1dc008fe3a536341afae01f66bb302e67f ]

The wcd934x MFD parent (a slim_device) never initializes its
dma_mask/coherent_dma_mask. When the DT-aware children pass through
of_dma_configure() this triggers the "DMA mask not set" warning for
each child.

Cc: stable@vger.kernel.org
Fixes: f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")
Assisted-by: tencent:hy3
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260903-wcd-dma-v2-1-189cff560a28@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 32ed2bd863758..6f4b1f1c4a787 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019, Linaro Limited
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -212,6 +213,11 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	struct gpio_desc *reset_gpio;
 	int ret;
 
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "Failed to set DMA mask\n");
+
 	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
 		return	-ENOMEM;
-- 
2.53.0



