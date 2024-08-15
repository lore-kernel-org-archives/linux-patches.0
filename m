Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2430019E7F5;
	Thu, 15 Aug 2024 13:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729238; cv=none; b=TBzOMQg1Pf2cq/p1TMZvezCtcSrhABxgpnRjTPKqqIUaedEJUCULRxKT6JmmRsre+XqZm+SFkBeo0HHAt0RJ5/eA6EZg9t3qVCpw4ZbNqDVfl8zCJrSXaDqBH3iypb35sgjR4x+PvR2XlIxRVZtodVApsjalzxuId8xhEc26Ihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729238; c=relaxed/simple;
	bh=gl4dd5G4mX5jISA0Wi5Snu+eNuD465piBCqpFqRxX8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVLwvkTahIJfho72AVDAP3P4b1pboAmqVU7DOKx+2yFTa60an3imWSnKPVyrg0pjBViq0gi9a6iksoeoIlytNljegDGAbGWER9Ob6XcJzlFKzAHTBaE1PY0LazvKkUKUYt0jRVNoFih8L6OAGwbVCIK3eQ24KEZl0zcg210GoAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QA5JOg+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QA5JOg+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDC8C32786;
	Thu, 15 Aug 2024 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729238;
	bh=gl4dd5G4mX5jISA0Wi5Snu+eNuD465piBCqpFqRxX8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QA5JOg+13HCE76d747GKFTxBpujvvHWgfL/AVHxBH2GAS3r6IhHqBEwQMHiTiPQJ6
	 0QGI0Pl9iIgYEMEXHFK59GLZHJ9msR6zJ3gPckAPsXmXWVfCILtn3P93NQFC5NpLyw
	 wvj2rD7SM6CvfHOjAcg6RMz6iybenZp3qylCL1O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/484] ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node
Date: Thu, 15 Aug 2024 15:18:05 +0200
Message-ID: <20240815131942.324726988@linuxfoundation.org>
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 5694eed98cca5c164ebb5b831b65b4c9eee4b2d5 ]

Add ethernet-phy node so we can drop the deprecated fec phy-reset-gpios
property. The reset-assert-us value is taken from the existing logic
since the fec driver will add an 1ms assert delay per default if
phy-reset-gpios is used and phy-reset-duration is not specified.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: edfea889a049 ("ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 683f6e58ab230..85aeebc9485dd 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -260,7 +260,19 @@ &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
-	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+	phy-handle = <&ethphy>;
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy@1 {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			reg = <1>;
+			reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <1000>;
+		};
+	};
 };
 
 &hdmi {
-- 
2.43.0



