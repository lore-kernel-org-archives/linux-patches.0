Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5638A4369A;
	Wed, 25 Feb 2026 01:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982973; cv=none; b=Zu27d5rvfmdTejTqoPTD2ikFIQvpg0BdvuZZ8EzPBtyfPPMdUYsg6NOdEubhqRey+MWoi83weY36hrdJ2by7j6nbthYRFi8ZX27Fy6Wt2LxZkeqrsrSsQYfcncV4hT1NXBdB1SK06NlUouqAkEfGnQxydc3tdYrwKqrgl8zGCa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982973; c=relaxed/simple;
	bh=G7rogQMYhYPuA8oqai0NhDlQmNNCKj2K6SMV0eYW45U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0XTWNLExAnNiS17JsdRlOG9MCnZFcjWKy/lfdTjeusl+9NkK7pW5LaPIDo37D+qGMA25GMI0hvfhnuhRjmaWhr+9UVqfrbV4gcib5ceTNs5vigsrZ5hiWKIWbTyd8css047LdluINwUDBFe8bR2MoUhrxqFuyFh+sWtksul6TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQF4j4dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQF4j4dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A63DC116D0;
	Wed, 25 Feb 2026 01:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982973;
	bh=G7rogQMYhYPuA8oqai0NhDlQmNNCKj2K6SMV0eYW45U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQF4j4dcYfHPWjfdOyqfn4cZnrqiwc1dHYzmrHT1HF89hC7Ance8eh1JFpQeUT/YD
	 OIeslmjYX7eSWzXGhcsLr+EwsDFaR0JQgzYype0sg+mqOpJ30uODe1Lz5jSxRBPK0r
	 O+QAH6b3kjTpf9Z/OWWGa58hxWm22RW7ajv3usu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 147/781] arm64: dts: tqma8mpql-mba8mp-ras314: Fix HDMI CEC pad control settings
Date: Tue, 24 Feb 2026 17:14:16 -0800
Message-ID: <20260225012403.269262743@linuxfoundation.org>
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



