Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD994F5F2;
	Sat,  3 Feb 2024 04:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933836; cv=none; b=YV8HuRDfxk0vfMNhX3XSzMtW2AWqszEqmf2Qk0kl5EofIDSa2IQCmtTbFcev8ppbFaF+j+VEnXIHOc2If5HOy1m2SyRET3vMfbga/F/TftSRScWvNLj5CaujZu1xrpZ7p3u12VaYyHEC1Fulok0WAgofjimkPa9QxBuSBJKbm+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933836; c=relaxed/simple;
	bh=9Do7iVHwTVlEkU9ULDDAVOMOavYIbg3a9cWlVT39SYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCD1LLOVe2YVZ+WmqmDMtWFXJ1GtsGb5jj/sMS0t9/JaKX8xNoJqh2vImS2GbbaVS5L+s9Z9m4Vqmotz9M8/crenHUFVnPgNpVXkN08ayMCho46KVrmONOGXhch9q8mmDW4CHbRp8hww3VV5C/xXFCoVHiPRZJdn9qf2C2g7DWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHUoF+tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHUoF+tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C17C433F1;
	Sat,  3 Feb 2024 04:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933836;
	bh=9Do7iVHwTVlEkU9ULDDAVOMOavYIbg3a9cWlVT39SYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHUoF+trnlf7APE3IvSL6THxT8WguvqRqIK3E5oNKn5GgWwk/OL7zJ/L5/nNv6+DY
	 iFPt7xllO6nPz3xZv8r/UXfeMjkDzmtK09sIRsA9DgKOVKbQk8rqz0nEBu8FQzm5mV
	 0ov9ftJDew+M9i2NMKXsnMk+1LkVkJ4KIYAjcjKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 160/353] ARM: dts: usr8200: Fix phy registers
Date: Fri,  2 Feb 2024 20:04:38 -0800
Message-ID: <20240203035408.712291770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 18a1ee9d716d355361da2765f87dbbadcdea03bf ]

The MV88E6060 switch has internal PHY registers at MDIO
addresses 0x00..0x04. Tie each port to the corresponding
PHY.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20231020-ixp4xx-usr8200-dtsfix-v1-1-3a8591dea259@linaro.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ixp/intel-ixp42x-usrobotics-usr8200.dts   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/intel/ixp/intel-ixp42x-usrobotics-usr8200.dts b/arch/arm/boot/dts/intel/ixp/intel-ixp42x-usrobotics-usr8200.dts
index 90fd51b36e7d..2c89db34c8d8 100644
--- a/arch/arm/boot/dts/intel/ixp/intel-ixp42x-usrobotics-usr8200.dts
+++ b/arch/arm/boot/dts/intel/ixp/intel-ixp42x-usrobotics-usr8200.dts
@@ -165,6 +165,24 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 
+				/*
+				 * PHY 0..4 are internal to the MV88E6060 switch but appear
+				 * as independent devices.
+				 */
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
+				phy2: ethernet-phy@2 {
+					reg = <2>;
+				};
+				phy3: ethernet-phy@3 {
+					reg = <3>;
+				};
+
+				/* Altima AMI101L used by the WAN port */
 				phy9: ethernet-phy@9 {
 					reg = <9>;
 				};
@@ -181,21 +199,25 @@
 						port@0 {
 							reg = <0>;
 							label = "lan1";
+							phy-handle = <&phy0>;
 						};
 
 						port@1 {
 							reg = <1>;
 							label = "lan2";
+							phy-handle = <&phy1>;
 						};
 
 						port@2 {
 							reg = <2>;
 							label = "lan3";
+							phy-handle = <&phy2>;
 						};
 
 						port@3 {
 							reg = <3>;
 							label = "lan4";
+							phy-handle = <&phy3>;
 						};
 
 						port@5 {
-- 
2.43.0



