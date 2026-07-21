Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847EB472559;
	Tue, 21 Jul 2026 20:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665563; cv=none; b=Oa9uddgDaNegHKRstnojCb5ys0sO0ecUCBMK3u/1SzU7cgTABaCC/146D+03kJL3Te5586imJZiWUE6sQyubWsMPZmLf4gkvBL05jKjAikl/1vu6eYjT5YZGPJfzvapR0AjGivY4twRYSKUzb/KBR5dM8oQNRfbAK1UjdnCMZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665563; c=relaxed/simple;
	bh=x8uDoBQPuQsA7ox6VvU02pYZOm81nfOnIqsCoYXoDJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTdEOfnyRYz9AR+4fPnE4KEvafEM3igH5E/Kh438PgCAEGMQXnhFJIQuz/X1+//iRx++Xss2pvcSXSqRGXXtUBGwAgHJwT74Gf/KiHiJVcOtj3rxdProHX0efntrLczZ1jdrDWJ7h18TuPzX3PsQtAVMwIq1GRg6uQs4xkcZYoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js+V0n7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js+V0n7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6766E1F000E9;
	Tue, 21 Jul 2026 20:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665559;
	bh=3dry+Rc8+Emhg2waoFOaiEtSQYQjOjcPI3EEtmJ+aE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=js+V0n7te/CgPQFiDZZpBDZWTesPutRvXpNZlxcnulAK1EsHkvGPtayIl2C3giQ6q
	 NU3dIVgBfli6LizXJimslALHEC+aC8jACCsYULdPw/3IBNyI9JQwcgMf/L4pp/Pqqd
	 s3cDjeOe8zTF0jpA0NPC+/es9MJ3yhdM1xP5ZW08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0349/1266] dt-bindings: power: imx93: Add MIPI PHY power domain
Date: Tue, 21 Jul 2026 17:13:06 +0200
Message-ID: <20260721152449.640121566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


