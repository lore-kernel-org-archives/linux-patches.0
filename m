Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2D63A453B;
	Wed, 20 May 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296319; cv=none; b=rcd30/ErQgfWRdW8PF3CVUngmyQp5mNXftqdOfS1dh/w3c40CQO7jTj1IevbhXnfdRfAUenbdQSBe/rCjUfa+WWbpOvpzLqjyHrFuGl3gGl3uMTNHGU49w3C4ox57ZXb9ZmHNuE4yax6BXv1FeOz6gsfH4oMjPduO1I39xavH20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296319; c=relaxed/simple;
	bh=XZsRmlxI63AvNIH1fSjXkfPiEqL/OYACXiE7/gf0HW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lV4J0ilLt93dtV4/ou5TfuLE53mxch/0a+GOQAYx0diHrFGQ+ckRoR7U0XTqpcdJowgN6REnKDQeSJQ0uBsZgovvzshhsa2gs9Q6ratGQqDiAwNjdsNhD8H2fNMQ4HoQMwLr25MJjDbw8lbXRoT1RM9gM+iLfwx/CZCimgOssSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyXAxFno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyXAxFno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BEF1F000E9;
	Wed, 20 May 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296318;
	bh=jd06fkk+lW5DOakCw1j4EpHwaV4z19/0XviEnMZ7TJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyXAxFnoWN0J+6dFwZ21O+vytt+CVGOOl2efdEyQVPxalkhoSSI733lj1PLQiHWNe
	 6yFjK6+Z58HNVPsC3aL9HZffb/rGls0imX8YuncumJE4ePSxJBhlrgM3Nm2Z8L/uN0
	 c8mBepbET4YceLNNjqjySs01pEljQXRV4zwR9J/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0754/1146] arm64: dts: imx8mp-edm-g: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:44 +0200
Message-ID: <20260520162205.274862791@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c46c5a54443440ce0f71de9f4df9dd860f5c2afd ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: 95e882c021c8b ("arm64: dts: imx8mp: Add TechNexion EDM-G-IMX8M-PLUS SOM on WB-EDM-G carrier board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi
index 3f1e0837f349f..91b87a7248dd1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi
@@ -563,7 +563,7 @@ MX8MP_IOMUXC_GPIO1_IO01__GPIO1_IO01	0x41 /* PCIE RST */
 
 	pinctrl_pmic: pmicirqgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x1c0
 		>;
 	};
 
-- 
2.53.0



