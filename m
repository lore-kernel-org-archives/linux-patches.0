Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEEDEED7;
	Wed,  5 Feb 2025 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764906; cv=none; b=Fju3SDs1Hg8FrSjvdo1Nb0tviOc6hlCjSSh7/ZQURFt5ldIb2cd0GwMHh/UDAVqJ0jUyh6Rccgs2RTO9dFI3nQjDwFKjasd6TiL2pffHtp4vA/XQv4ESvkn79OQnVWAHUqv2qJQUE5GaRWWmUZY8/w1HNEoOhShgJGstrVZETSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764906; c=relaxed/simple;
	bh=UJBBMJ9oE6fcYHJeu5sXt4sSg87fADNPkiBU7t8WyxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/ZS2v4EQImD34fMTt67rAwYvTuS2n4eWGvLyJcTwyzEJl1KXFPoGXbryZ0EII0CU6+0mfyj8shJZkxrn4xhr2PFb7XGw53iXv/DU8arIFIx/WO7Ln9EPRSN3W6Gb118/xAiuMCz5RrX5FBs84YezG0wxIsYelLJbETg4C1g/W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mchNAlZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mchNAlZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF529C4CED1;
	Wed,  5 Feb 2025 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764906;
	bh=UJBBMJ9oE6fcYHJeu5sXt4sSg87fADNPkiBU7t8WyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mchNAlZeISpuOVT7wB2aXsJmnpoxJjBgMvXrA/pnOoF1Wf4MGo0ruUJ4d+mU9aDcV
	 aO8M3bqcw1kAMF0DmhFrrmFTZ5eUnJkNnCQVOy2etWSSuja6nLKu2ZysCkO64zFAy0
	 Md3GYTX9x5kcRJ9rH3wLnAyJvEO6FMsSsQR6/P80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/393] ARM: dts: aspeed: yosemite4: correct the compatible string for max31790
Date: Wed,  5 Feb 2025 14:42:13 +0100
Message-ID: <20250205134428.487688308@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>

[ Upstream commit b1a1ecb669bfa763ee5e86a038d7c9363eee7548 ]

Fix the compatible string for max31790 to match the binding document.

Fixes: 2b8d94f4b4a4 ("ARM: dts: aspeed: yosemite4: add Facebook Yosemite 4 BMC")
Signed-off-by: Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
Signed-off-by: Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Link: https://patch.msgid.link/20241003074251.3818101-6-Delphine_CC_Chiu@wiwynn.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/aspeed/aspeed-bmc-facebook-yosemite4.dts | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
index e9eaffa9b504e..f5d38a9f47638 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
@@ -454,10 +454,8 @@
 			};
 
 			pwm@20{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x20>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			gpio@22{
@@ -468,10 +466,8 @@
 			};
 
 			pwm@23{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x23>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			adc@33 {
@@ -506,10 +502,8 @@
 			};
 
 			pwm@20{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x20>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			gpio@22{
@@ -520,10 +514,8 @@
 			};
 
 			pwm@23{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x23>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			adc@33 {
-- 
2.39.5



