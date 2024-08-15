Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B28B1AB53D;
	Thu, 15 Aug 2024 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733028; cv=none; b=IhiFhdpLcplVL5suSkJMnjhmzkFK/Wj/G2kC3/ANJC924fcV6A5+8WXXpGeVPOTZjSKgWL7d/YUzdMO73g3RgQAUwPF+TMlXbrHPxDVPl3OXFVEH3weNYwAzV4KaDTMhQ79guXx7vBdnfT5reHyryYssMIv5dSevoyo35M1Xyh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733028; c=relaxed/simple;
	bh=ZX7k131l/vfQC19nqiX3eDOlF/DLrEzj0BTJ7E+BfD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g52zGHk2cyPshL0NBY3lyW78NecuGMJ6P1rO/57lwkNuq9O9tt9iRX8MyVKsf+7wwIdhqW2XynGnqeO61Uy/3Cp8KoSWH+Epxrr/o503ml6kaFcimpIEc1PYe7K81llTLiVVNyarBMIrY1CipGwjpj171NIOxC64IrsWpJt8x48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPWJhJWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPWJhJWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C848C32786;
	Thu, 15 Aug 2024 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733027;
	bh=ZX7k131l/vfQC19nqiX3eDOlF/DLrEzj0BTJ7E+BfD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPWJhJWhd9Lw/7ik3B/FSY9Hiwrh4ywejnrLCC+uQMqm0Kbo/RwtAKJk1v19j5HQg
	 iVWCoQgB2HDZfcKNCCVURaid7iFHNOwO3PECRuTkuSFAoSFFfXPM0OM+nabxNEOyqf
	 6ZdRy6ffq1ueuVt0ZNfpiK6yE04GLwaZIuokZeDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 352/352] ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode
Date: Thu, 15 Aug 2024 15:26:58 +0200
Message-ID: <20240815131933.073835795@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

commit 0df3c7d7a73d75153090637392c0b73a63cdc24a upstream.

The i.MX6 cannot add any RGMII delays. The PHY has to add both the RX
and TX delays on the RGMII interface. Fix the interface mode. While at
it, use the new phy-connection-type property name.

Fixes: 5694eed98cca ("ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -260,7 +260,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii-id";
 	phy-handle = <&ethphy>;
 
 	mdio {


