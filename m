Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA70846A61A;
	Tue, 21 Jul 2026 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647954; cv=none; b=kzmHitPmUGOO0mCh/dNWTNxlZ1rhdKM5a8UsP9rhlRhqu1Sdv2FW7J+0uVF0rcgeacdfczMF6iJJPLcChuJIRAkdMqKfElmQibsJ/+bW0f9kJER+HJT2K1rrKK5BEL3ER1rpgzhwphKuwHCbGTGFTYYPLL1z9zVea3YYwD/V3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647954; c=relaxed/simple;
	bh=Tsrf8CEfErv0IF9DEt2Y4T3BfcsQS0srChS92ae2pno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3KRVfA1L14u2Io7juYKLTsHQaTecOkh25NfZIa3wuQV2oHZthscQwjSd4ubFxjYxGzwMeBZ6DiHy9lbQNT3dIMM3zWREfZv6eCG+/3u+7hkPEQ+26d7YXVgZTZA7DxLu29H+OTd90yYEAxO70L5bnktZLR3LaiTt9jGURKK2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za5vMtFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za5vMtFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2813F1F00A3A;
	Tue, 21 Jul 2026 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647952;
	bh=1NOryXgzMTHnrZz1xsxkRLPYlxYnPFOv8AofCdL/1vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Za5vMtFDIkPfNcCgvkFMxH5SgbjcdvHM0wK+hNUOtoeq6ewyh3LSxP1/dEt0gH4Zw
	 +sUOwwKJCr42FcaHegdUIba23lptked1r03fq25jepmgL0XSxD8cD35mPVZ7YXY6rU
	 U+D3PB7A1AeajSVM1xigCkp/vdpF1u64kaW/tQO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 0017/2077] dt-bindings: power: imx93: Add MIPI PHY power domain
Date: Tue, 21 Jul 2026 16:54:50 +0200
Message-ID: <20260721152553.074428698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


