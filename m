Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB03939B3;
	Sat, 12 Sep 2026 19:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239914; cv=none; b=u7h8731GOWWzoOo2slz4APbM2M4DvOojz21NvUosZZSWrxtW1b2Ucdygemy0mNvJtRYo6ci3BoOSnnV68LHjOh9Rgb0G41a/6zgg3UhotXaR7hfnDYPecm8pvkiQDsKuYIkn39UaPejquuPkrDZ9WkGeV+mXt37PGuenXCTBjyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239914; c=relaxed/simple;
	bh=aKQbOdFg9DKZNtHWAoF+fVP88xIWH0n8AWlkHXmpIMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djswnxWHKXCAbwlGuS4iaqx5tW6Yr0oFboeB1dhO6YuVRsisoIKBa4GQSGW371G/xxU8c1a73YWLDaliFXr3UlJKBPmJAofAELMDt4zPQ9REDJblntSdgCx0FD1LNhvfuSK5pA9tn6ZtFlCn0dtZz9r3A6XLq2m0731bmnd3DMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmjDyfWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmjDyfWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD9A1F000FF;
	Sat, 12 Sep 2026 19:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239913;
	bh=c0/C4ifTpLsUHoLNh47/ELHUg6+XmwsxxbkgS96WsIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmjDyfWFpJXPv16RvW7PKbd+SJtGk/Go9Wb2glMawVlQdYVzNI1+xQiXVaHeRszjq
	 CZcqCJHL/vLd5ZAqil5U+kimTUqnSQwoJ2+XNQpfOHJn/uShw9so7pbH+PXAmm+6rK
	 jSbHK3ardfcO3KWhn8GC55Se+Mruu8Ypjhgvn5+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 759/935] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 09:03:09 +0200
Message-ID: <20260912065544.240751437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec134e22bae3e..61fc3adab54bb 100644
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



