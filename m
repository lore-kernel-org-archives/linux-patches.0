Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BF40B112;
	Tue, 21 Jul 2026 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655505; cv=none; b=NXjkSOZRvwRKAR7HWpUcUCG6pkOyiI5+qlUgp5IrIjHcwoKKjQjhhIdchIs5btfkl5f+tZDD0VNkGUhlaAeExhehD5RxmNnSoZ4MprfnF3rngnUH5aTATJ6CQi459VNqG0OsDjMS/o8N/OizVmkmJmy44U7YCYfoigQMji9E/Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655505; c=relaxed/simple;
	bh=UhU64TAAIPkJc5ZoIVWnSR+Yo81k8hjNyui3637i6HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHo3UZgtYTRNAZEGlDzWJwZhfUIlzhP6+LzVSVadkqSrNYxMNnVbSnYhQRgAUA5uz+803Z211upJKOVWjmNxRSPXdjjTWNmGdMvmh+ppsOlPDJLkN+jbdgGg3q0TgrYl/DHMt6JM6UV/FA/BW2EWal5XBA5x4HkJRk60giDpxxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nksgFAbF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nksgFAbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD221F000E9;
	Tue, 21 Jul 2026 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655504;
	bh=WgrHRH9e9JaBmM3BYoSjWTqsW4KOcj3wlb0nFKQZYBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nksgFAbFS9fOCNzvJeWXnxlYzqZoMZpm/vnLCcfkwxb5/lbZEkdm9i6gpLs0k0DmZ
	 ZEFcXzmH+ouL5qbNG0CSFKdci1gX3lmzY2xBvnO204WiEG91LC29sYiYB7RRFWLktF
	 obR2pZC7KbYlkkdC+LFolxX1UgUZc01AqPRr3i74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 0033/1611] dt-bindings: power: imx93: Add MIPI PHY power domain
Date: Tue, 21 Jul 2026 17:02:29 +0200
Message-ID: <20260721152515.558469246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


