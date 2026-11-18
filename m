Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059844;
	b=CBpMBoTBwtz0seR24DlwbsusrnP1K5lVud1/xMCTxWQeZZR/lKNM4HafMs7Quoj+1jUk
	 dr2f1+OlX8j6jXcQCbq++w9P6tK48HMc3i4Ngums3svWvBRYKdEKGauesYR2g6Rm61ZQk
	 +5IG90LsPSQ0UCKVMt8IyAxJ2MiXZa5XrdLO8LDTAzijf1x3sRT127XOTKt7O9dcVsyhf
	 SyfuYpQDxxZP5gGC1QPdJFb/3PLUcpE9wwZ8p+dbsK/+EPRUHIM8YZ+kHHVDJV9zE8Bc9
	 qGDKs7XE9x5LSI75gUU1mtPXkTazVdheR0jd5fDNlPpR+QaUzdLgAKeqgjS5X0+Gkug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t+CSbpZkzVwkqWbGaMN+95T/j1WDOYvLtMRNYbkibqw=;
	b=IvEyEMEbh/Y1gd+VX79S+R32Xsx0dcvsKiJ2S72JMdh/o4pXyYovv85ZFS3H13XW/+Bk
	 DDuCA5SWWBIya0My1PHR5rDVhn9BSZc23Pi8yywDEGTAIzIVGytIYZp4wMX0Xf/K7+TgE
	 ygUlrZCDgKWHJSasI2ggIrE+TXpQ9U4PRj6lO+HYoD/sp/dtzlvzkot7T054jBWr7g47Q
	 OJckjzwpeP6Rh2S9+MbP0Hg/4KPcu+NOE9CIvHQzxe+fZItn4eFykBCEJeIroLZ/65D7/
	 6cusDF4lGVk2Pj6YyPkbs4kGZERKRdLy4R+8Qk+BddcFOFfUyD/DLhghnaSoAz1LJuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0hsuJql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A634F606A326;
	Thu, 19 Nov 2026 03:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0hsuJql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004DE1F000C4;
	Thu, 19 Nov 2026 03:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059844;
	bh=t+CSbpZkzVwkqWbGaMN+95T/j1WDOYvLtMRNYbkibqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0hsuJqlM+JaAo7RDtVaHAsQket7od1DNBI+p7GQzxTwehbJzPLIh8EssIBOfpqgl
	 gGzzSB7WcbDXZaqtgH26s8S/8Dmq8M3AeVBg11wjI/DuAhWk97Mk1uvZKxVvCD5i71
	 CHv5CFBpvl1/MYdFJnwoo3Dnzlou78dKYOfT+OT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0988/1848] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118145958.253146315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 83f84f929a405..410e7ab482d2b 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019, Linaro Limited
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -214,6 +215,11 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
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



