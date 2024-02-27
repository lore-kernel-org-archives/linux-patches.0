Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A86213B29C;
	Tue, 27 Feb 2024 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043050; cv=none; b=KBiN2zVlaMGtFRdPDVIqCPzy70rYG+SK19/xtkA+ne9WGJeWUM9w6kcZa6US063HJd9AfBQZzIBWQSeWXNx8nUKM1NjvwDXv0w9JSqE0RattR4HXGC9mWW4SrgF2TeHlS1VmpYv+QU+A18FBwf85L4SmMVP55oaeCMzp6bxSToY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043050; c=relaxed/simple;
	bh=XZOVmUX1v7wW5oZzim0Sau018fuEVh7rJBHOLuR6ECI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uDdAQcBMgNwvFAjV/eBAoZcRFxogz4sToldnhpa8jUCkmddLItvezIKpv/2BcItqV5nOZNXoIOfOKZKTOrp7j1Mv3rEzOPgA+Peixwerapg60EI9rSxdEhqf284XcsFQcBvNuif6us3H4Ejnx7XVyKswAfE0Hstem3qsrElct9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SV0yFADb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SV0yFADb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A175AC433C7;
	Tue, 27 Feb 2024 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043050;
	bh=XZOVmUX1v7wW5oZzim0Sau018fuEVh7rJBHOLuR6ECI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SV0yFADbglWVCfRt8bB6rjZh30DmctAmQeQGdpE//eozfSxH2MyicIa4E+o080IFd
	 0EZp2s4iWLG9h3ghJ2o7qSYM5YUUe7glNnDWKvEOkcusrHVbGD+2oev1eSAej+DEnk
	 ipMW+0AlkIRmUYid57b1n42JY/iLPPF8QQ2IP7NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/245] ARM: dts: BCM53573: Describe on-SoC BCM53125 rev 4 switch
Date: Tue, 27 Feb 2024 14:26:15 +0100
Message-ID: <20240227131621.276850526@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 9fb90ae6cae7f8fe4fbf626945f32cd9da2c3892 ]

BCM53573 family SoC have Ethernet switch connected to the first Ethernet
controller (accessible over MDIO).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm53573.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/bcm53573.dtsi b/arch/arm/boot/dts/bcm53573.dtsi
index 85a23dc52423c..eed1a6147f0bf 100644
--- a/arch/arm/boot/dts/bcm53573.dtsi
+++ b/arch/arm/boot/dts/bcm53573.dtsi
@@ -181,6 +181,24 @@ ohci_port2: port@2 {
 
 		gmac0: ethernet@5000 {
 			reg = <0x5000 0x1000>;
+
+			mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				switch: switch@1e {
+					compatible = "brcm,bcm53125";
+					reg = <0x1e>;
+
+					status = "disabled";
+
+					/* ports are defined in board DTS */
+					ports {
+						#address-cells = <1>;
+						#size-cells = <0>;
+					};
+				};
+			};
 		};
 
 		gmac1: ethernet@b000 {
-- 
2.43.0



