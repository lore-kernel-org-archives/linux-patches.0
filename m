Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBAD415F14;
	Tue, 21 Jul 2026 19:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661506; cv=none; b=eHh2wNb/B7lfdSyzGxOJSAzke8j4qpuDyPLhmLLnWVPY0s8yec+BqV6qNZMFmli7xFY0NimFnObmUb038lfQNtLORFmK1YnKRUBxi9cHCAQGWnLlqUAb3bNGolD+5pAXdGrwLqm5rcYVe8prpk4WVwUNda2su8s/d529AOEJ3wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661506; c=relaxed/simple;
	bh=caDBt25+sctv0dveQ2j+4dPAsYoVEHF7y9F5a7mOeJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL4kR3Y/Ii68DcEIEns/AIBw8p41zTUV8ke2AynRDlj/dqxk3gkq5dgIhu3Gx1zroiNTd4+7rQW3vBimlmUw9AnOhGzW7MEikVZQ2083YwPXwZlbEgFw8Zj4v21G9oX4hhXdhb9+J2RTyGE2CaMl1lF9mwGRDBEX2XVgP5ZWZRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH7ImaVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH7ImaVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25E81F000E9;
	Tue, 21 Jul 2026 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661505;
	bh=JvccXyL1OsMQtbINMCEjRifONOlsZip7CQe0VUG9zBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bH7ImaVUUlpeVyz7pn52p69fkl6aEb4PEGjVHezP5oIQu5yF/A5o/CFyKXAG0bjz8
	 LkIjEouCZsy0koM2yGt7luZvctqhCe4yQOTYn658ZnMO3GI7vB65pPjoTRP56AWpJY
	 wAWRHZgpXxj0efwJjgdFTXnBUG9HGSCzsQMrl6o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 0048/1276] dt-bindings: power: imx93: Add MIPI PHY power domain
Date: Tue, 21 Jul 2026 17:08:11 +0200
Message-ID: <20260721152447.161691374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit 6aa38ef0eab32df5409b72d62509de6ba09cea50 upstream.

Add MIPI PHY power domain for shared PHY resources used by both
MIPI DSI and CSI blocks.

Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/power/fsl,imx93-power.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/dt-bindings/power/fsl,imx93-power.h
+++ b/include/dt-bindings/power/fsl,imx93-power.h
@@ -11,5 +11,6 @@
 #define IMX93_MEDIABLK_PD_PXP			2
 #define IMX93_MEDIABLK_PD_LCDIF			3
 #define IMX93_MEDIABLK_PD_ISI			4
+#define IMX93_MEDIABLK_PD_MIPI_PHY		5
 
 #endif


