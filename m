Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9377263F44;
	Sat, 30 May 2026 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161615; cv=none; b=jatDQjZXf9RltEy5MczADj8RQ8rS9gqLKZ2RAxlp4OP/zz8pUxYM+uaWElaiakjSY8RVm8ozkzWyHeDpmVNJWhKDjaAZiTyOSmFWoe3iT0UrY8k9p9C1S/MvnfSG4cejM/KXH+rJp7MeIs1zdmlTd/czg4hQhK3mry35SN7T9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161615; c=relaxed/simple;
	bh=Mjc4K5EQ1WsJ9AYPZG2nMSYpmKBT8uAC5Qz5b3Fle30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYE4YAW9RdMxRkYJivQvnOtcqqci4v4We7gfDIzvEGYCm1VP4hGODY6E4bZ1812kREwC/NnY7M0AQ7r1/kI66YbNl3VHuQUAZsrbxWixrdrqwK9ki3TWBJUKxr8qw/jbiKjxPudKsZfOQDd30/xRz9DdvCRgJD/T+qK0PWKey4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3Kixaxj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3Kixaxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217261F00893;
	Sat, 30 May 2026 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161614;
	bh=OwwgR7PIpy2XnM5NceXuP+sCtJpYD0zTG+/pq7GFnmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3KixaxjDBsd/L2CBzy0SbKAU/QChGnAxSjujDbjD7OqN1EiRP4AwO9YLo36UjQs+
	 OPouRX3I7rbRoiMdN1MGiQN/UNTNdv0cGQagZGB9CTh2hYVjY1vz2L6Ln9iV/E570b
	 4Neiz2llw/ekAzvM22sNde5MhTwuGWz37tq5blYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 676/969] arm64: dts: imx8mp-dhcom-som: Correct PAD settings for PMIC_nINT
Date: Sat, 30 May 2026 18:03:20 +0200
Message-ID: <20260530160319.164343603@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f9ed5afc988da3e22543725e35be6addbb0497bc ]

PMIC_nINT is low level triggered, but the current PAD settings is
PE=0,PUE=0,FSEL_1_FAST_SLEW_RATE=1,SION=1. So PAD needs to be configured
as PULL UP with PULL Enable, no need SION. Correct it.

Fixes: 8d6712695bc8e ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index 0b81b85887f40..9379a5b08e6dd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -807,7 +807,7 @@ MX8MP_IOMUXC_HDMI_DDC_SDA__GPIO3_IO27		0x84
 	pinctrl_pmic: dhcom-pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0



