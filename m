Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044882;
	b=QYvTB0Zdt+3wwdnpf733tvNGsK6DsBlDsFXjHoOM5agWIHYrrH7ceD8OaucWTLHi5ie5
	 EKN/5TI7/F9tfC/an7KWQ4+tFG/+BBwWOfKudHVGez0MqDpUynHAQ1hbLdUnGr09coiRN
	 Ls/n8C/U8jgsDAu3H51pphIlqer3NprB8rcUzzUK7pYnmHmeh9NvhK4x8Sdh8KGath6mF
	 FN8CU5w8aktFuekxUWR1FmmFCsfTppcoOW6PrLMaxv+rCWYzVr5f/kxxnYeSg5GQZawsg
	 PRQMoAkehNHVYTsEWFxZu6n17XAJgZy2elBgW2yNVXpmvOKTiGeLqoCJWIKLloTxALQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ckkYLi8EzGjnDPEYmv+yM+R/WpC1lGwnyqLrha/vac=;
	b=MQv+YOxrCdp+lPYd5bDq6wee97WixOGuX0ubc2tv5vYyCGBSoGH0FevMZm8o9UZmL+zO
	 t60sYBshMOaDL8TCEfqcqpIHDP+/RpTnnKK6VKHIdIqrQ+T6sn0vJDZ8/SAdbkn07av8P
	 5FCGOz2O+aiEmv+l89KhhPvG2uKuFhqEE1iKGCbBKsEgy9JSvgqhVbbREajXP0jcKfqkq
	 VtJk6ERKsfLSffABlLiIBUoCVT+PkRtoDU5A3/MjMbw3HGyxwE2dQ7+6Z67+ECsedCkGc
	 qr63UxFSvmBpJYgCFvY03bwJmHJtcCGNwdXXMOFozCwQ1+eySZLxYFF4Hbd0wX3Zomg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0yxWJUEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B08606A332;
	Wed, 18 Nov 2026 23:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0yxWJUEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F251F000C4;
	Wed, 18 Nov 2026 23:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044882;
	bh=7ckkYLi8EzGjnDPEYmv+yM+R/WpC1lGwnyqLrha/vac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0yxWJUEWxo4eGpjX8ZhMi99VozPlt19WDGFDNDtNlJRi7jUTZy+KqIY+b6FUlCvFC
	 pt87gJAtwVmIjhd7nT6a+JciDCxHudSJWzIT7AwuOrK1BZWker70YDA79GZDs53FB7
	 STCc6IzkAJAnJI9ekja7Y6R1+aNCUd5u+DvLxAGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0723/2857] memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset
Date: Wed, 18 Nov 2026 15:29:17 +0100
Message-ID: <20261118150227.578450548@linuxfoundation.org>
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
index 9339f80b21c50..c2da86e37d679 100644
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
@@ -859,6 +872,7 @@ static int brcmstb_dpfe_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct brcmstb_dpfe_priv *priv;
+	struct resource *res;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -870,17 +884,21 @@ static int brcmstb_dpfe_probe(struct platform_device *pdev)
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



