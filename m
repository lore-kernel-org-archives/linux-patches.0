Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879C18D656;
	Wed,  5 Feb 2025 14:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766945; cv=none; b=apMWOqjcQT1+1IPR3DQhem4gj8RCAkJFsRb2owXe2Ktb5a6z+sxUjbHysM5td0usEYLeVFCSDKU2qLcl9/0mms7bLsYeg6ZwOIn+GPSny9PzcETSHCGx2AMKmEWNC84ibu+ZHqdWDMOxqsRgO8Q/+EAmnlcLP8gidpLulO/xIMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766945; c=relaxed/simple;
	bh=rqNB9L9Vy/JXDfEmUsdu/c/KdTgq9K7/HQAb1UK/xx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYWB6EDZy89g4TqFCxPuL8tgltaxU6WLdi1eOAhgvWVadHXMoamwpAzTo3Jc9nBWi5B3OmSBHJRpT0rUZbRoXZXk6JSWhEAIlnCs5VhaVkVlemSIqGpWBUwOgBTzZ8W2zCgUaLXQ+V1QzvH4ZWgvfa1+6P9CP8yGC5BsCMD2IqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=es0EODdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="es0EODdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0177C4CED1;
	Wed,  5 Feb 2025 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766945;
	bh=rqNB9L9Vy/JXDfEmUsdu/c/KdTgq9K7/HQAb1UK/xx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=es0EODdb+7LKbO3xNARx19bbvo9xZlIyaLWZ0QRj8pbZSEtdT4la9a9X2lP/91GwL
	 Ij+7TVI0xPNIb6oVVV+Mo04E6J3NRmW3bDeuFdB0jTwpzo3xfWGaZpZU6Y/G3Qvxa3
	 YLDAxzFogDplYwUzhfKhsVRLclJMbHdeaqPibOKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Markus Niebel <markus.niebel@ew.tq-group.com>,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 332/623] ARM: dts: imx7-tqma7: add missing vs-supply for LM75A (rev. 01xxx)
Date: Wed,  5 Feb 2025 14:41:14 +0100
Message-ID: <20250205134508.924848237@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 78e08cebfe41a99d12a3a79d3e3be913559182e2 ]

Add missing supply for LM75. Fixes the kernel warning:
  lm75 0-0048: supply vs not found, using dummy regulator

Fixes: c9d4affbe60a ("ARM: dts: imx: tqma7: add lm75a sensor (rev. 01xxx)")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Markus Niebel <markus.niebel@ew.tq-group.com>
Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
index 028961eb71089..91ca23a66bf3c 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
@@ -135,6 +135,7 @@
 	lm75a: temperature-sensor@48 {
 		compatible = "national,lm75a";
 		reg = <0x48>;
+		vs-supply = <&vgen4_reg>;
 	};
 
 	/* NXP SE97BTP with temperature sensor + eeprom, TQMa7x 02xx */
-- 
2.39.5



