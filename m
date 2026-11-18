Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054178;
	b=RJgPUW7yCJUaQgW0O+Bki+Sxp9NUfQ67KFKRR2nL+//e5MEukjyFzpsGb5Fcl2JlgLSI
	 OtaZzSQpafrKM+gHwo+zEDeO35XsYl2ASXIewb0gdNxV3oXyV6Q4i2sulOOEQpRyCfJFf
	 9/Y8F9/5QrYfGpRrQk+4kTzgefvUTuw0qpWbBpFiT/PHP3Nf0NZ5YLnL+Eka/eQi/yUxO
	 NUMtRBd1QF3vGI4h35wQ+WGJt7sdkV3UDan6SkoqbtFrVRbg3SwdKS7P7YnO9YDuvPWcf
	 c3z2HM0wCJ0KO8IsqhYRbXo52Yz0UL1tno1mYJrL98p5L0bwGpY689DlF8TPx+pTiIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0XIw6IjO1TDJxJ25yRfzKIJmXdj6Fa7+KWNkj/o6mic=;
	b=1Rz++ysQ6H3RL9/ou8/Psu8lKqsZJlhaRMs8/2ZNHIncP4OWGvSmxOzA3+kcYvQiQSxe
	 NIFbqhMIHPJmhNA7mbkcXBbYozM2kX7b0YJ8t5HixgsNJHo2rdx4Cfysr6YSi/AVyCWt/
	 eYjyR9otRUcTVNga4+RWUBK0fAqx6ft4s1yihZ2QwJyclHu9DvCnlU08lvwOkHufHFXz9
	 X5lqD0Ck1BdHOoKSu4iGGdLjLJw1QujjMsGYvaewiMSaTCvUZod+1hMM22/0ylujyg3+Z
	 438/9vjoT85yMth16bcoI8JILtHDjJC5D/tpAJJB9aOLmQGm4kgDweS0v0qRBZioVRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkY1gjHz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8CA606A31C;
	Thu, 19 Nov 2026 02:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkY1gjHz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D2F1F000C4;
	Thu, 19 Nov 2026 02:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054177;
	bh=0XIw6IjO1TDJxJ25yRfzKIJmXdj6Fa7+KWNkj/o6mic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkY1gjHzrPd5yaezK5XpV4kpsw0bOPcnjQ6emmfkJgXbti0lBmnoVfv5yqn8rIn1A
	 inak81+6/smbch6Xuz1nWPydcXcwhOsfz/fZY2MruphMkIIfil5LdswmzzaBSyAeOA
	 aywYyF/rYUh6/DYx+dtcsh6XwEZiWSjMgV6/JPDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1182/2214] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Wed, 18 Nov 2026 15:47:38 +0100
Message-ID: <20261118150059.222933593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 874aea6c24585..990a5c2780392 100644
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



