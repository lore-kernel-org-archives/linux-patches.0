Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35646242D9B;
	Wed, 25 Feb 2026 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982972; cv=none; b=CqxmwiGNodErG4vP/2LqCfoRtkPRr7+15Hnkun1BFExMug8eVs0dwKwknXWvm8igQ//Y2xc7ZcY1MlPFL789ycvnGOoA9G4z8x8PUB6bt7vYJnKPfU9IIO5NdE0u+pagMqnAifYuvB3F62KYopRIzrOuHg1hyzW9OdhnLD52uOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982972; c=relaxed/simple;
	bh=ZB+CTRUrghPMz+y8Y1av6OQMZtzn+jUc0dILgtcyqHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g33rXQ1gh22NH/mi0GYNcdsb1cRzRYmX1L0E68ag8L54RYLIv7C1+e8+4jDiCDuR3QoCe4Rfqsu9rJzUJBBINx3UZAt9kIcrF6MwVgn0IUMRsBPNRzd6d8KB2XqX2o1UQoKdonCZjwC/R/bP8KL52JYomASO7KzoX9uQJKEHIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wrs5zzDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wrs5zzDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ECDC116D0;
	Wed, 25 Feb 2026 01:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982972;
	bh=ZB+CTRUrghPMz+y8Y1av6OQMZtzn+jUc0dILgtcyqHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wrs5zzDhqAUrUZNnXk4iZreZ5mzej9V3z58F9PEELmH1cn4ZTY4J20gAUWasZqqC8
	 /oEYypY/EG/Cp+yATctOFaaVo1t+97qKOZ4sAZrUFI0O1/Y5R1Y2vwcqZy6ZcnuGQP
	 PpQE5j4OA3Rk7uEnEVXqIh2ev5xO93Tru+Gt6yEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 146/781] arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings
Date: Tue, 24 Feb 2026 17:14:15 -0800
Message-ID: <20260225012403.243966073@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 8401527abb5e3a00c867b6597b8e1b29c80c9824 ]

As per datasheet of the HDMI protection IC the CEC_IC pin has been
configured as open-drain.

Fixes: 418d1d840e42 ("arm64: dts: freescale: add initial device tree for TQMa8MPQL with i.MX8MP")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 59642a8a2c445..c73d40fb789f6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -867,7 +867,7 @@ pinctrl_hdmi: hdmigrp {
 		fsl,pins = <MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_HPD__HDMIMIX_HDMI_HPD	0x40000010>,
-			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000010>;
+			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000030>;
 	};
 
 	pinctrl_hoggpio2: hoggpio2grp {
-- 
2.51.0



