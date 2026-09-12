Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01992D0C94;
	Sat, 12 Sep 2026 10:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210547; cv=none; b=OP28Z4TS2y7f7YiHFBwzuVwEV3j6lWP3qu8PDnEt1T/fLKKv5urHMPkexBgf73i8eM3pVFCNtCZqOfLdNWS6cArUb65t0oiJRhGWLhSdPpiNRaw0eMiUBIb90b3oB27Jngfuq6tdvqX3rs55ANBcenk6llPIWrphStvA7DmDUUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210547; c=relaxed/simple;
	bh=kRrFdoR60+BwpEpGmwnrWng6kU6jHL25kF9RDJYaRow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha4dfdWzzF/Yog4g0BtmxxSOdIoQFG4A4WBn6s/uiMXIn1xQqeP1dim4dle+Vwc3PKmQrOJBQQCOWaV06AsKJcVT9a143f5c1OUZj4ETxPMPMmQE4melBlbf0vK91RfxFTdytJSQVyesjOL5ZgKaB+vs9VIL+BF3VIsTitjM/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pchXuLzy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pchXuLzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D891F000FF;
	Sat, 12 Sep 2026 10:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210546;
	bh=N8FPJfnM2Qm91NCd2yOFLQJ+rJC5jwOV64fy4CV+huQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pchXuLzyd9BI5zk7/qGY8RrErioOqYhIAFOGtiGdMja3uJ1rzcex2emROog1cZ5ai
	 0ucgoeu/mURvvW9HU1tvfjoAdXyyuF2CiAGvoe1TfmI+INqTTjdk96Rv+Yh35awZln
	 r4cAIqI0PK+jEwoxM5xNTBB80lzv7Vl5Eji1qA1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1047/1518] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 08:53:36 +0200
Message-ID: <20260912065647.136549430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index ec134e22bae3e..61fc3adab54bb 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
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



