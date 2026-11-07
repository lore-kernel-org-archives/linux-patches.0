Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063842;
	b=3PHvObz5h2EhBrqUp2lXl97DEjQvyybkmnps/SshslF1SWI4XXLr7vTp/K0M6feyy74l
	 +3EBugsoOSfCuKSEKCIdj/2wyIu2YYbmG/e07hm1e8Rv0rIvAG9SIvI3ZVEPmHPkB+dGk
	 gDDxp5y1pY0Y2tGspVQyOqr3Jb0++fBq6GBDaFxK2c5FjnUl5UUMaGgUeJNKzSu5uIbRN
	 lb60tWaOqyG61EbR1WoXMI8BxMjk4iOyRwUu2xOndtgSee15ETVuQzGZl+GOGS2momdUJ
	 Gq42IXAgmo9Xd3QwspnlWR1DTtjaN1p/bcrlUbu57vxDbo4D2zb5NWOeYrVOAG5UvCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/5funkBZFxr13uOeDTCtYlSlQkDmD+HoBR/RZXN5b1U=;
	b=Qef54ct9yJvlKKRIoiW3Pz9mqYju+1yXBRFKzirhh8SoyoF0AbJWafCHLNorP5eaEW1i
	 HC6JIAzLdIEZVeNKv7GdhUFo5ZyzxViMhHKFsoHuMUsCObLYmIrSpivSquhDwjCEVcoqb
	 sMv4Fs0Pm6/QJ4HmAM5BPuw3/J/FQfmVU/zCD8QIjUUsZ2HuFl/4zjgjuCpGx94n6WDYs
	 xz45DRovAf4xEgQojAdYTEOsMCWJ64ekBaxgGAtY6qiXDdBCiVPttSn8oRnGLuFjk7p3H
	 5YS4Y/lg+xf/XocRLVJeYhY/bKUVejAxRu1j0anocmy5174v1p43h/SWcnZ7ie6uokg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pE+Wyrou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A3260A6F48;
	Sat,  7 Nov 2026 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pE+Wyrou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2651F008A2;
	Sat,  7 Nov 2026 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063841;
	bh=/5funkBZFxr13uOeDTCtYlSlQkDmD+HoBR/RZXN5b1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pE+Wyroump+Gitj+NM/emB0UuhbyzRugIhexvyc9x3IzbUHefPOk1hhMQAscNXrEw
	 1CjbzhU8FOLZJQ0BZVu65snSz5y76ls1DUqyRJu4WT/phO3HJPo0ApHG66/+Jy0/h+
	 U7xcmXsidSUB/krimsXUJsCYIDw8md0rMKpOuFss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0054/1257] memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset
Date: Sat,  7 Nov 2026 08:39:10 -0500
Message-ID: <20261107134940.898274712@linuxfoundation.org>
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
 drivers/memory/brcmstb_dpfe.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 08d9e05b1b338..66343205f585b 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -182,6 +182,8 @@ struct brcmstb_dpfe_priv {
 	void __iomem *regs;
 	void __iomem *dmem;
 	void __iomem *imem;
+	resource_size_t regs_size;
+	resource_size_t dmem_size;
 	struct device *dev;
 	const struct dpfe_api *dpfe_api;
 	struct mutex lock;
@@ -401,9 +403,14 @@ static void __iomem *get_msg_ptr(struct brcmstb_dpfe_priv *priv, u32 response,
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
@@ -415,6 +422,12 @@ static void __iomem *get_msg_ptr(struct brcmstb_dpfe_priv *priv, u32 response,
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
@@ -858,6 +871,7 @@ static int brcmstb_dpfe_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct brcmstb_dpfe_priv *priv;
+	struct resource *res;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -869,17 +883,21 @@ static int brcmstb_dpfe_probe(struct platform_device *pdev)
 	mutex_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
 
-	priv->regs = devm_platform_ioremap_resource_byname(pdev, "dpfe-cpu");
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dpfe-cpu");
+	priv->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->regs)) {
 		dev_err(dev, "couldn't map DCPU registers\n");
 		return -ENODEV;
 	}
+	priv->regs_size = resource_size(res);
 
-	priv->dmem = devm_platform_ioremap_resource_byname(pdev, "dpfe-dmem");
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dpfe-dmem");
+	priv->dmem = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->dmem)) {
 		dev_err(dev, "Couldn't map DCPU data memory\n");
 		return -ENOENT;
 	}
+	priv->dmem_size = resource_size(res);
 
 	priv->imem = devm_platform_ioremap_resource_byname(pdev, "dpfe-imem");
 	if (IS_ERR(priv->imem)) {
-- 
2.53.0



