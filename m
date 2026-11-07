Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064133;
	b=dRXMlslnaV6rWnBesOr0N1mOkBsxCut6wxaZoLlC1DvL979GItxOxxAT3vpvbzYkR7sw
	 zSCWMRn4klmc7jrpJkVLIl2lxokPh76uuKFkzJSJ3joGBzb8TX/essuiph7NnLFFaz209
	 wbNyRSgXBlAs3itiGD1GmpWL5+R5Db6rYBi7xd81mek0myU1TqtuMX5ByhmzdyZvMeWC/
	 6PmveuoHpSWrGDsoVnwd+aT8nuwhpMWUXbKFN9Pq5AV6pxPEA5VoEf2CgViUoeDrfGqy1
	 UbTCvesTrRSAOJ8RtEMHWyAqqrumEXmL008CRGccxCTniChtcyOTNUAZBBL6JzDol9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrQpNco3kMuGNQtHYiBj9bT9iBvnUwQnIny6b0lgFQI=;
	b=z/NDw8HAa9hLeby5nRU1b3VoFbYbK011lNsAAUATODZRXAHsk3rvSW3kxv73+6tHb7wZ
	 hMIUQgN7noioOuqmPl+EqFmiqiJqI/NVmMafqZ1PLV314VEYjJTwzN8ft4p2D4scjwhBG
	 qAbdWFmZUGMQ6X/PSqWh4+Sl2VE2hZ4+cxUiG5XIr0+ESjioXahY8jvNy3iiGofTbczpH
	 X9ot+FUYFUUNToKDt44Vh58xl84/sn9U2wBHdbsib14Gtd+nfiJAVB9drJT4NCuBGEH+Q
	 UTRUucgJuJS+ojg4S2t7wcaWcv6eqsbMwII1v/g52ebBLYYPGWvMpCVBWnWyR67B+Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j7PjpuZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CA7606A33B;
	Sat,  7 Nov 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j7PjpuZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B354D1F0089F;
	Sat,  7 Nov 2026 15:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064132;
	bh=JrQpNco3kMuGNQtHYiBj9bT9iBvnUwQnIny6b0lgFQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1j7PjpuZT3EZzF/WJhOKwn3OCncn0YphjUymUWWgeG8YTVpOLtdV7FKm1XzxBTprl
	 B4+DzBkFJJrV3dnGYuH8D21ol6axSpX9aHNxKe9aHgwKPzzSPL6e9VKC3mq8zQ+va3
	 f0KZcaA2YtQlOvH7KbkLZ9i0vpyfG/iKksfzxPzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0284/1257] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Sat,  7 Nov 2026 08:43:00 -0500
Message-ID: <20261107134947.320242570@linuxfoundation.org>
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
index 3c3080e8c8cf7..7bea64fc09562 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019, Linaro Limited
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -217,6 +218,11 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
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



