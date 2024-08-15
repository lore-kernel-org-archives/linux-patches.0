Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174E518D627;
	Thu, 15 Aug 2024 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729308; cv=none; b=Zrt+XIGoVj4iy9TnNz8QGyNtbHrMHtMgavzhTkOFW1vb9VhsyUAm+W6BStv3RsfYkLZUA8s8Yi14mWFz36R8BBPxPZmem9WOnCBvDf+ymvH+oPMqKaxXC0WvKurkzSBuMBj40ZESVKAOuBKW+YGd2Bhzw6Bgoh89Ch9gTkxpu9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729308; c=relaxed/simple;
	bh=R7iRD62EOvW9VIc6cUg5J0C25E5krCHiuHbQdZjchR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCzDcPuixSAdz3nro3H+fTAsgIOiAKrsQ+Z9xQRslGam0J5zHqusXUdbhPX1LASP8vr18KeUlHB7DR/ImM/koikQpeIIsqJjuhORqBOfYElgXtoSwv68TaH4jsPfmR9VtRnMQaeOjMM2CdOONq5lkDY2xGECbWi/TSn5dfnNwKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8LW+/37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8LW+/37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92358C32786;
	Thu, 15 Aug 2024 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729308;
	bh=R7iRD62EOvW9VIc6cUg5J0C25E5krCHiuHbQdZjchR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8LW+/37WZThWufTh7IJsvATWue+RA7SSvzChWqOIqWTWpktMDKXLnsGrLudMAqS2
	 RxhULBrfgOJk+FOAp3ghvaG3z9Sk37qLtafI+lMKebjJOEIEKppeo/pghKpUK4/auL
	 yED6juOxsaCm2q7IFxvzN/z4Z3DC/xRrk/Pr3EIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/484] ARM: dts: imx6qdl-kontron-samx6i: fix board reset
Date: Thu, 15 Aug 2024 15:18:07 +0200
Message-ID: <20240815131942.401483796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 0ff80a5013f20..c420a3b80943e 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -817,5 +817,6 @@ &wdog1 {
 	/* CPLD is feeded by watchdog (hardwired) */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog1>;
+	fsl,ext-reset-output;
 	status = "okay";
 };
-- 
2.43.0



