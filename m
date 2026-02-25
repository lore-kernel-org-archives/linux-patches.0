Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8771E2834;
	Wed, 25 Feb 2026 01:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983919; cv=none; b=Q6/2TN1yAu/FZV/jV8XRnLmvt7e3StY+xhOvw5yLUtYBmsn6cO8MAcQC1L5BxutQTjIwZWB7PxfN3SPzZd0hcIKRkYo9nTzQR6d5I7L8JexlQiAmKkneRyVCerDv5lGLdxIThdfv8NGXs2sTIU26H0I54tFfOUxda7kc7uBZZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983919; c=relaxed/simple;
	bh=R3z3t7jqWv+/XhDpH7A/upBYMRn2zsJaiyiFlWnRvp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCUxb+Hy9uH55SfhLR925EujFenZ+pb6+sKOMkQuLWDopNaoeKvBBA9/UsLPlP6gKbObJ+cGY3aa+TveGfcLxWodKTWr1NwGA47znjDolQz3mZ8ZxEYnZ9H69dxAZ45ap842brdWKephEactbOTeyublOhExMKzwtMaABupYw+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGZLf0K+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGZLf0K+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED8AC116D0;
	Wed, 25 Feb 2026 01:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983919;
	bh=R3z3t7jqWv+/XhDpH7A/upBYMRn2zsJaiyiFlWnRvp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGZLf0K+/dXHLSLH/T2moU+Z2lNolnRpN+ioFQcRi/sO2sfRqQxv6uqnu8GiqyZyF
	 F/wAFiGPpUj5NQFeF/iN3sKtb4jvIGBtWeRNzeeVC1fX+8lpV0mxa3QPXAVuRPBIvr
	 yPBeT+/MHxbopHjy6Y3tt6i4F2+6JbXGdfUyzdew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/641] arm64: dts: tqma8mpql-mba8mp-ras314: Fix HDMI CEC pad control settings
Date: Tue, 24 Feb 2026 17:17:38 -0800
Message-ID: <20260225012352.344509021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 53a5c1d98d1155ece4c9446c0fea55e17d08774a ]

As per datasheet of the HDMI protection IC the CEC_IC pin has been
configured as open-drain.

Fixes: ddabb3ce3f90 ("arm64: dts: freescale: add TQMa8MPQL on MBa8MP-RAS314")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
index f7346b3d35fe5..a122f2ed5f531 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
@@ -704,7 +704,7 @@ pinctrl_hdmi: hdmigrp {
 		fsl,pins = <MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_HPD__HDMIMIX_HDMI_HPD	0x40000010>,
-			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000154>;
+			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000030>;
 	};
 
 	pinctrl_gpt1: gpt1grp {
-- 
2.51.0



