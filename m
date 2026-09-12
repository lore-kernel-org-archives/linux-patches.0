Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327AC443ABE;
	Sat, 12 Sep 2026 08:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202764; cv=none; b=oilaeL4haFp4Jcw1fXQUAaRrYch+0YdYQVPryKbvpHwVQI0DyhhD3Mbc4la05Qnr+YeB3SZUhl7Hj0CH828NwXN24tSqcJ8WpYEWIWI2DudGMcA9NsF8OLwfmtZquCejOrPlSczM+L/+io1c0pM6dkFL/8moZgUMpqQ/MoeMypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202764; c=relaxed/simple;
	bh=aUXQK5OMkZRnQVtgVD1l9t2Bwt+xseSNkGvEF+G8oKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwjAhN83HVIN1Nkycrln/ib0fwWP3mYHSLbgy3sW0B1vtDCn+jtI0s3QgHs5D/P4jokl3HUw5VwlE36YU9AxrPrSMb1+9zl6dEqg1EDKgVdN8Xbiz4cjJ9rBI16ggzHne15Tf7D1Cy5nxmkv82YkTdRtihqqKjTC29q+5Gu8KIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzTLaPRi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzTLaPRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982201F000FF;
	Sat, 12 Sep 2026 08:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202762;
	bh=iOVZoiW4KyR0qKyZanE5Ex7LNrHJvPCtQ4gLObk9vP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzTLaPRiUUb21xkp+YqLVgIJdxj9KMSFQXMiShLlpx1w1NhL+kySM6QdQ6X+MIiES
	 j6JXD4pf6+ZY3j1O6tBE1inYYjmNAdl0syl7dhEP9BDk09dYwB6QnggB4Oj2un+yXC
	 CQSsrg/3h5JbeeGH4eh1iXtMnuG8lBAf0dTnI1lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1269/1815] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 08:50:19 +0200
Message-ID: <20260912065718.808854257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



