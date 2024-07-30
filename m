Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3A1A616E;
	Tue, 30 Jul 2024 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355897; cv=none; b=EHyN6jXUmKawCZi6RA69tip8sxybkREfXx7klTiXX1vHvP9/kuug63NjZaCv0Ou9YDerHWZR6h8JUZA+3RZREeNc2zuXzPt6sDImRC7JQpS+S2ovG2pA/56OEizneepEzro03XKr+aVzi1Dp8nRic+273JOKBGVc5yA+KI84Rh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355897; c=relaxed/simple;
	bh=jPhC5ffCH55ThZJ+o8B+6ZZnbYYf8sLFBnQTrYhNdjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTjYu/oZ+/o0G4n7hawPg0FK8CUclxK/bSJM1WEScYk0qq6F6ThEHEbLlYmL8PT9NpTbI5wUbnROeZW2udBgHU2e8zfnUBD3BuGEfxt4AYtnJ66vjrmY4LbDWc6en7Vsokl3lGx9myj00tnMclkobpp2i1k/pHT/Ije3qJAOEdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fJVi0Ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fJVi0Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E91C4AF0C;
	Tue, 30 Jul 2024 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355897;
	bh=jPhC5ffCH55ThZJ+o8B+6ZZnbYYf8sLFBnQTrYhNdjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fJVi0DsCngzkCt6G3ket9+AxwQjiyjpXhfJR8wd5X/DmV7c2uQnkfMsWPGWPGqOB
	 x/WxloSxHdUbm1OJUQWIE+6IZkGSRUcGHYLw/5yCi5iVBL+9AzqIcF8vYcLIVzuSlM
	 qu42c4WhV/9L5k1TyuKaB5h72WHSJHygJt/TVxhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 096/809] ARM: dts: imx6qdl-kontron-samx6i: fix board reset
Date: Tue, 30 Jul 2024 17:39:32 +0200
Message-ID: <20240730151728.426850952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit b972d6b3b46345023aee56a95df8e2c137aa4ee4 ]

On i.MX6 the board is reset by the watchdog. But in turn to do a
complete board reset, we have to assert the WDOG_B output which is
routed also to the CPLD which then do a complete power-cycle of the
board.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
index d6c049b9a9c69..700780bf64f58 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
@@ -817,5 +817,6 @@ &wdog1 {
 	/* CPLD is feeded by watchdog (hardwired) */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog1>;
+	fsl,ext-reset-output;
 	status = "okay";
 };
-- 
2.43.0



