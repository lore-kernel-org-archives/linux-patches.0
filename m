Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42EF315D49;
	Sat, 12 Sep 2026 12:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217755; cv=none; b=QO79eJQznsN5/xcb7AvhyeXf3kWGByLjAYHRcSu23mLtMVeUN9X3XkjXr5TtPSkbY7Bujf+yVXG/L8tQJgf0c847jab6I/9dt19SQBYnyDHWfQEdgqBMhURmqQuXDwzfoTdfBFVx/gCVJibLKuNSUZt0kN9z2ORqflFW7Bas7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217755; c=relaxed/simple;
	bh=LvJrdL7JuFqWzo4fYPd3P/0zTuexW4JhWLHt0iSm4qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr2FUcGawpv3O5RXsLVms4LKzBDdWkAlipq8t5GLhWKFljYhe/DXhaHYwzkbGTNGrY5SN9//OCOrbLoTSUwh3zSUtWRutHI82QTqZQO05X9yv7x8+nZwX2zibLFCd1FMLwC6ZhKeZJpCJsQAgrw4bNUGRBPhCk7QLzYh5lcB9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AalmvwCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AalmvwCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899961F00893;
	Sat, 12 Sep 2026 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217754;
	bh=5Op5zB839Wzj6R1RSmR/moCKLHtw0Lb3xiP8V1UP1mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AalmvwCfQ1yEIEMP58172PWpSbjTZ5e1vHj6HOhfaZXMoAAu+Ax9x8lvH9JXjeiux
	 oStZ1NivDLgQhmVtb2DQKPbVSw0JL4INa83EnNX4H1dmJAnvrxZPilFvboKe0OgGdE
	 EqM2sae2dl7a/Yum3M5Rtb4yUtwnrD3I1zlO7r+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1003/1376] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 08:57:09 +0200
Message-ID: <20260912065629.918766963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



