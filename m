Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420C118C91E;
	Tue, 30 Jul 2024 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355531; cv=none; b=kfd6kC9EqU0p+fKatj8miMpJRubdvuEF1wOdNQo/FiLUF+ZANA5n6c4VICKS4Myg0eCXn+ykHSgaVGSrTpTT74c7hkyDtaVTYQ/TQc6jX049TxyHkgr9rZbVThdrgyD5/4HSAWS6QqC2HdDBV32R6saju/kEVXr/mundJySkYxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355531; c=relaxed/simple;
	bh=AaF+o7rVfGfjvXv0ya5PiT2LPGFAp6ldfTbDSWdyHsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e48HgLoFwHys2fX5hY5IjHOKOhReHZtz+437a1nAAWqEJMlRgyW4IOrdV4pnfOmqQOlcBnNJSFJFp167z9Tpopte1ELouPTemsOM0HLAbDuStQaQlaBnABxWj1a/3HA3JxBQQQutNXAi6eSzRMRRGv6atXPGwEsrzXcNDeutMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYS1imHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYS1imHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE2C4AF0A;
	Tue, 30 Jul 2024 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355531;
	bh=AaF+o7rVfGfjvXv0ya5PiT2LPGFAp6ldfTbDSWdyHsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYS1imHxWAN+KuKQPV9wZug2UmvUd29f7kcLvgAwQ64vWn+oldessC3XNok5RS2pg
	 7PsVZikLGY6MPhEgefW0WIg2/2o+HHHyXt1W/4t8jqIua8OuQncaKE5nSm+8F79DG9
	 1/1Po/VP90B1yLn51fIx2BFk9LxhYHaanMeH+4to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/568] ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode
Date: Tue, 30 Jul 2024 17:42:53 +0200
Message-ID: <20240730151642.440768901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 0df3c7d7a73d75153090637392c0b73a63cdc24a ]

The i.MX6 cannot add any RGMII delays. The PHY has to add both the RX
and TX delays on the RGMII interface. Fix the interface mode. While at
it, use the new phy-connection-type property name.

Fixes: 5694eed98cca ("ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
index 85aeebc9485dd..d8c1dfb8c9abb 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
@@ -259,7 +259,7 @@ smarc_flash: flash@0 {
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii-id";
 	phy-handle = <&ethphy>;
 
 	mdio {
-- 
2.43.0



