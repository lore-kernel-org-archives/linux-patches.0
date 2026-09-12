Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C01399351;
	Sat, 12 Sep 2026 20:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243275; cv=none; b=cxlPsFEZ8sNsrd4SODhEvogMN9eB+/jleYUcghOD9wkVQxPfEjxfChUtPhm/vwPDS8wxAsqLhWnWtPI5cvRWesHPk11xAD3G+9Tjj2edCL1YgmzJsT8qAC2nxfF6Nptf6MBz6fPq6G5XiiJ2PYultI0bHMK4QeVNfhj9NWO5brY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243275; c=relaxed/simple;
	bh=UPTZLjjIXl3AG0AN74S5Xvm2gRghz/vCCCAnZQdByuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMx/mTNeWbgt4qwJT0OaEu0rqIh5qOgnxVt5bOkry3DzJhwOs7MZ/KQCOjB0VDnfMuObfGt18ZMZNqSwgHnqntHBMQcNaHMuX/FT88nNbytmPA1sf6eWQEiKbI6nyVC9uEJpPhct0qgMrvqJVsXOLN3GwMsYlVx2elU+n7mdHlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgpxlXXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgpxlXXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450671F000FF;
	Sat, 12 Sep 2026 20:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243273;
	bh=pxpH56Y5A+w6ZcP0+BXQunTMssDKX9Cp20sKv/tUSOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgpxlXXAUe1ejJbYiGFO4P1/7BS+t5fxOIhnCZ3LSEE57odHjHp+sqmqmmU6kUlEw
	 mUtqRTFPUJ7Bk6pBgcmsVfIlc0PkSFzWu757GEcVCCZcmIBvXlK7AR1PEkhtUlV1Ky
	 64ggvrxQb6AgIiY+mWIq/XzYqJiBwGNAEAS7xHFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 655/798] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 09:04:43 +0200
Message-ID: <20260912065532.126062241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ef65cf08bd1aa723de2854d02fb8eb8cca273c90 ]

The at24 driver requests a 'vcc' supply for the EEPROM, producing
'supply vcc not found, using dummy regulator' at boot when the
property is missing.

The EEPROM sits on the Helios 4 and is powered by the
same always-on 3.3V rail used by other on-board I2C devices.
Add vcc-supply = <&reg_3p3v> to silence the warning.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index a7ff774d797c8..c335a44d24824 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -201,6 +201,10 @@ temp_sensor: temp@4c {
 					reg = <0x4c>;
 					vcc-supply = <&reg_3p3v>;
 				};
+
+				eeprom@53 {
+					vcc-supply = <&reg_3p3v>;
+				};
 			};
 
 			i2c@11100 {
-- 
2.53.0



