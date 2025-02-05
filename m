Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCB61547D8;
	Wed,  5 Feb 2025 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767096; cv=none; b=JpfzmRH2yZSfdaBca0FPW+a+YdKl7GWp8QNXUmXK6SADcsFIt7oJlCoU+Dg66k1RLDlAXcr8RsbSMLijB/aBvNUIQLVZlXDYfyl2l+TMSfuu6F4zQmPN4N4trASOGR+hZDVOoszE+rk5pkRCCo7017q8/iwu+ymUtBEZMV1O1eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767096; c=relaxed/simple;
	bh=V9ujD61cXX2a3RvNGI13jMUQxI7vxdNTfGqxY7mfdvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXAKAMS1v6pUX2Sx/xDnY8eMUn4P9mtPM1LR1Uh8XGZtpJ1HWVufbZdrOhXZ5v3JKQrfwYDIWRpga5Q1fHFKmQeDTZMmkDHA3S/aSMaaAwT0RxDqOrwGPOjbT4WD6487StIKGlGYxni85mKFJ4+OY2M3TayztuSk7XJ5wriZjKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lylF+fKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lylF+fKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE66C4CED1;
	Wed,  5 Feb 2025 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767095;
	bh=V9ujD61cXX2a3RvNGI13jMUQxI7vxdNTfGqxY7mfdvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lylF+fKeBExRhx1yPP+ZoV6du5qTDcdVfr2oitRCCCiStF6BeI8mFnzVcsAqhhY/y
	 l39Kj5xOmy0q4Z1Fg6m7atIwJ6Jz6mU2Ukum0NswjgjmVdCkQ5ct51A8+NcEXS/iB8
	 F9OsdDTfYZxHIEv4vs0VysooxSrAPh/6X/x979fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 356/623] ARM: dts: aspeed: yosemite4: correct the compatible string for max31790
Date: Wed,  5 Feb 2025 14:41:38 +0100
Message-ID: <20250205134509.844617809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 331578b24c204..14d1751031068 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
@@ -461,10 +461,8 @@
 			};
 
 			pwm@20{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x20>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			gpio@22{
@@ -475,10 +473,8 @@
 			};
 
 			pwm@23{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x23>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			adc@33 {
@@ -513,10 +509,8 @@
 			};
 
 			pwm@20{
-				compatible = "max31790";
+				compatible = "maxim,max31790";
 				reg = <0x20>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 
 			gpio@22{
@@ -527,10 +521,8 @@
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



