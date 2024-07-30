Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF501A6160;
	Tue, 30 Jul 2024 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356115; cv=none; b=Q5lLM6e7Nn5MlSTo9Tuf3K4JTl7mFfLG3dd6wVQSiUxaTDQ2cezbWc5k12T5YjSEz6kCd4e61CQW7UqFdQcnpMW4NbmRmN6/9DlwP4bSuqswKQCIYHQKZamF5IuC/0/WQPUn+1NH+rarW/xHfG/UemtXx3tgsVVyb5IqyQkZlXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356115; c=relaxed/simple;
	bh=+HZBvK2WAqtsiVEfmDVpdOCx/QS8Z29pSnUCguyddnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmJRkcdpLSpn73nsGegBWJaARMuo/piClgHbTx2lF4jFVoApv/KSf/HSLmk4mtaq4iNrM1oVelR+wiRjKTDgsqSwxNxIsYMrR92IWyTu8e93V1EppvFtXAwi00AI9+hUc6NCs4U9/GR3hBbbyVIzdKCNchpRnF/N/weCQxZO8L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RY/L7nDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RY/L7nDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A626C32782;
	Tue, 30 Jul 2024 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356114;
	bh=+HZBvK2WAqtsiVEfmDVpdOCx/QS8Z29pSnUCguyddnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RY/L7nDinyHKkkFQ9DOOmYAdbO7XuW8v0aXjhaZ0yVGVBfxShoJs0YDgPmeh7+3Ks
	 mAVfcaBQwc/X9z69bZLuzhyf7BBVpzKwbyH2zVGdm/ENAObQ3BgkVeQA5+YH+i02pj
	 UuZyJo+HABfWb4OwktT6lEp6ATdj5xo4TJ12pBIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 094/809] ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode
Date: Tue, 30 Jul 2024 17:39:30 +0200
Message-ID: <20240730151728.350117849@linuxfoundation.org>
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



