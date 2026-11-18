Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058194;
	b=YNUpONBqNO1kbKSIVa3WJZ1pw1YDZD9/Da9+gPITfc5aH313+R7W9kBad6sdYpgSzX/J
	 VjNfbi+gHoEIvLyfPR8B2dkZGvPC71vJ8w85w/PZFjfelTSp8PpuPZQOQdxHebzLVghs1
	 K71FA3/VelMV/0QmAb+bB0qeowIHfPhzCMNhDLcz5K16LhTFCEu0y8VH0EF0j2dGxbWFi
	 wBL1v5jme0ghJIo4SmFs9jgbUnngtf0BSESlfessJajMQzo89z9apg6jc4QFzuN8A5lyn
	 XTdWMN76eWpPr7V4I2qCQQjbPvQT2c2NEiaX6ZyhiYwm/ZMqnjk7w6kff7D0xNtC6Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+lVNVsfAV4h2xRCHvv2Q5TizFBV1luTHYBFZbEBrtTY=;
	b=e2WAOgEkd3djAFYp8KL+24kjfTMylez05UUcHejJFL8OTqdYk03xFQMKmlXMHdgihXPI
	 kDqf4BX9XTGQSbad4dvmOjFJhtU/hSF5VzHt8DJ0iTYgywTdTWY8O6ndiN98CXq26js3m
	 1pCeYlGGpQsP68UkIHC1K5DKQMfmCT9P7rKPTO/7wqDPgB0McnvFp75ra7Ymno7VqzmjD
	 fpAzScWAiha3vASexMoF/STXcSZd0CGIIk1Ac48bs+yKqIOzy94WPenRkjqZt/DHsqjHk
	 k0bNLzieLPHXuSGfuv2SgdEbkmYb36xhqoJh9840il4EtwxP0VpLbY+NLmi27wCYoVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VzT0/e5T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC38606A326;
	Thu, 19 Nov 2026 03:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzT0/e5T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369BE1F000C4;
	Thu, 19 Nov 2026 03:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058194;
	bh=+lVNVsfAV4h2xRCHvv2Q5TizFBV1luTHYBFZbEBrtTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzT0/e5T4x0lN65UiyCVuML2LTFdg1vdkMca+2yqN+SCXijVakXgx1Ein2/ea1C4i
	 uOS3O0aGda7xszpvCwUWFcshhLe+njRNkJ9qnE5mk/hJp9oOReeQzJSsYQFzawXdRh
	 +nmU/Eoo9auJT4oXrpWbVt/dEep9Rz4vYaHajGPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0357/1848] memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset
Date: Wed, 18 Nov 2026 15:39:55 +0100
Message-ID: <20261118145927.886746602@linuxfoundation.org>
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



