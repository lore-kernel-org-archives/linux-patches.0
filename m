Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CDE3AC17;
	Sat, 12 Sep 2026 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225273; cv=none; b=CjQHBxqtJFx1PZfu0KyR3XOtsiu1tDWHSqK2U7zfPZl2qE2+D0A0ElihDj2KhhHxdNCe2N08pvKLhFT9AfFwFc3jFPYDfYzxaSVlUJ224MPyK9d6mTtZtxPY5TNqFrnaaa7eKBXsY8KAyIxoB6KupQ5Rtj1gNrYmTLRk+Rja5vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225273; c=relaxed/simple;
	bh=EQW6mcfQflKRJmY0g1U+9ag46cIzhHgUCcoVxQBdhFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gb0aGmYZDwU2wdGdZTgj0DlbNjr/0dZp1EZ2CITQMPYlqFZLgxnimn0DLUxfhLsrMvEbgaRd3FCm0Klz01udD4zViqs3/rBYLDs1ZesJY6QasADQEO7639vIsV9eJugdgpHoD1JGqTjq5G7zx+64G9hpqzgV82jsiLp2OuqWdMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLTq5LbV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLTq5LbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA671F000FF;
	Sat, 12 Sep 2026 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225272;
	bh=3+XN7EeX2i8A0Ut9Z1bxGisdNA5Cw0DNkwZfYStc/xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLTq5LbVabKhmWeR3sb1ks12CZF7la2IhMnpW3Gzg5uUfXOwts06hvqGx3Eczw9tG
	 zerjeQ3lm7Hg8r+ObtHCA3nEt5V/QkMCXfm8fptecNY0Jj7P6OnysSJg1byeEoEd3s
	 fH1ZkF7Ayt2F858cG5IHr0fXPePqgv0apwX4oj10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1137/1424] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 08:59:29 +0200
Message-ID: <20260912065632.762010538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



