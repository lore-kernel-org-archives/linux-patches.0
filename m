Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052115;
	b=gfOke0Tt6Rtsg5qW1aRiUJU2qp4tVCHxOFmz8u1xP8jfPlK7yVq+gE3lmY2um3H+rR4P
	 knQEJQx/lWFoFT6cMdvFUQiRRf8Z1MPJJBYyOGybNk2mWawf0FmPQEPDxx8B0facXeB8d
	 phoRZXOT4fi0FbPA3aoFgP2vSGls2QePg9UGTFCSiQMzGObaa/qhSasNQG5pRqvPsq2fn
	 MzXckLhH6ODXXz5ztbGcvGTSlUCm0oeLABCF8MtncH4NzIPdWD42QvK7nBIL8AzlPd6hx
	 fUPzhmUK4DQSTDVnl5udMhTmCOQy4SRJYHW+VljWJzRgExwO8dE5D07xFovbcPP2D4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6EgfhFxxp09ZpIxgOCWG8i7twoa/gsTLRb7psTAx4HA=;
	b=xRBBNhDYtrpnX90wHxFy5Qli6u+rrZ/DBT56TFrzrIvw/rvZp0Eg50jNUckkpafGfwwB
	 VMh8DyK68TaGbvVcKDfdhEF1Hpi5uOxyWyZtT2O/yK5GbncOD6yqjWeFTQRLUyoz05P8k
	 3/ya++JuHBDju0fVBTjFy/xpldi3lWyShgcp0xJ5J3SqEQx0CFaV4cJljx7CXM5n0hv1N
	 rCEYigfuSHZhceIovFnWnFkcPzLjkh48OZkO16+ZAqbapyJLMeag5Wzvkpio5EkpGwP55
	 oATM4WRstaU+JQytdpy7MVAE1sRZ4wDqWp85+GUWFz3u/SYuRqnCA156ckQrWhats7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzqZdC6k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAF4606A320;
	Thu, 19 Nov 2026 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzqZdC6k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01A81F000C4;
	Thu, 19 Nov 2026 01:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052115;
	bh=6EgfhFxxp09ZpIxgOCWG8i7twoa/gsTLRb7psTAx4HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzqZdC6kM1jyMDY/URbq/A/ujffasTwt1DZzxjTFJaJukObnF5ICgUatU4iv3BipS
	 fnYl+z0JRlM8AwTJSHxALPHJVzUiDwNc/+BLAvPWCDAYaDTXM2nHTRfW8xJv4U9KaP
	 iJY9Btk/xxmauZU4hfDOkqESQv1IbdxVA5KXiRfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0448/2214] memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset
Date: Wed, 18 Nov 2026 15:35:24 +0100
Message-ID: <20261118150028.990816643@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 7c0b82d087908765c6c7daeb06943e21b78d523e ]

On API v1/v2 boards, the DCPU coprocessor can steer kernel readl_relaxed()
and writel_relaxed() to any address within 256 MB of the ioremapped DPFE
dmem or regs base. The DCPU firmware provides a 28-bit offset which the
driver adds to the ioremap base without any bounds checking in
get_msg_ptr().

This allows a compromised DCPU firmware to trick the host kernel into
reading or writing arbitrary memory-mapped I/O registers in vmalloc
space. When combined with a root-writable sysfs file like dpfe_refresh,
it provides an arbitrary MMIO write primitive. Similarly, world-readable
sysfs files can be used to leak other devices' register contents.

Fix this by recording the resource_size() of the dmem and regs ioremaps
at probe time, and rejecting any offset that, along with the largest
field accessed (DRAM_VENDOR_ERROR + sizeof(u32)), exceeds the recorded
mapping size.

Fixes: fee5f1ef6cf7 ("memory: brcmstb: dpfe: support new way of passing data from the DCPU")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Assisted-by: Gemini:gemini-3.1-pro-preview cursor
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260826201500.3000125-2-danesh.petigara@broadcom.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 2daae2e0cb19e..86aed3a31e3a0 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -183,6 +183,8 @@ struct brcmstb_dpfe_priv {
 	void __iomem *regs;
 	void __iomem *dmem;
 	void __iomem *imem;
+	resource_size_t regs_size;
+	resource_size_t dmem_size;
 	struct device *dev;
 	const struct dpfe_api *dpfe_api;
 	struct mutex lock;
@@ -402,9 +404,14 @@ static void __iomem *get_msg_ptr(struct brcmstb_dpfe_priv *priv, u32 response,
 	 */
 	switch (msg_type) {
 	case 1:
+		if (DCPU_MSG_RAM_START + offset + DRAM_VENDOR_ERROR +
+		    sizeof(u32) > priv->regs_size)
+			goto bad_offset;
 		ptr = priv->regs + DCPU_MSG_RAM_START + offset;
 		break;
 	case 0:
+		if (offset + DRAM_VENDOR_ERROR + sizeof(u32) > priv->dmem_size)
+			goto bad_offset;
 		ptr = priv->dmem + offset;
 		break;
 	default:
@@ -416,6 +423,12 @@ static void __iomem *get_msg_ptr(struct brcmstb_dpfe_priv *priv, u32 response,
 	}
 
 	return ptr;
+
+bad_offset:
+	dev_err(priv->dev, "DCPU returned out-of-range offset %#x\n", offset);
+	if (buf && size)
+		*size = sprintf(buf, "ERROR: DCPU offset out of range\n");
+	return NULL;
 }
 
 static void __finalize_command(struct brcmstb_dpfe_priv *priv)
@@ -877,6 +890,7 @@ static int brcmstb_dpfe_probe(struct platform_device *pdev)
 		dev_err(dev, "couldn't map DCPU registers\n");
 		return -ENODEV;
 	}
+	priv->regs_size = resource_size(res);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dpfe-dmem");
 	priv->dmem = devm_ioremap_resource(dev, res);
@@ -884,6 +898,7 @@ static int brcmstb_dpfe_probe(struct platform_device *pdev)
 		dev_err(dev, "Couldn't map DCPU data memory\n");
 		return -ENOENT;
 	}
+	priv->dmem_size = resource_size(res);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dpfe-imem");
 	priv->imem = devm_ioremap_resource(dev, res);
-- 
2.53.0



