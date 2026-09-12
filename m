Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E9F32824B;
	Sat, 12 Sep 2026 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231140; cv=none; b=AZpGwlBb/lDjFMCduRk1+hGvYHm7GtjNFeTdasi3Shxpi1ukocrGdQroyZsrsZ/7S6xWlPeN1epXaqX0jI4Ng9zY5omAq+31jRzihdkLUUAdwWgmzvOY3YHi8AkoMbafdFtyqK7ex+foR5vyR+byLWbW8r4M2p8UOsiIiExRtcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231140; c=relaxed/simple;
	bh=9p2YYQTpsM9PE7tq3YLeoh+O5rlv28r1nnvf7VCcMIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNsVw7vJaqc11CEzHGdgECvoYV+Rlk1cnd8o2o64nFNRO5HG31HhLyTH2K7wUMjcGChlZMpOD4ZTCf4EGl2B0VqCuR/bfJvfC7T6I/9jrbqIrZbX0NL83WiEvyaYJqk301Y+U6FNMgE0YNSB16V2FArZMNVbtKsQGGeTTSlxK20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yo3KV25+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yo3KV25+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B351F000FF;
	Sat, 12 Sep 2026 16:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231136;
	bh=q2WHbtbMZB74q1z8WMuHAHpjv7OuMIEVB5JeJxLwIsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yo3KV25+nSPVyhRjw8xVN0SvJ93rV73e6XsoGpSz/y2UmfdN7vPms7irgommwUtWG
	 umatQNtrCroG9wrS0Et3BAGF2Sbfm0V4RURfe59kXpGdR6l9+TS3H+K+BsKzvnPBgw
	 Ntd5IXRzk9C+PCEp1KrkTfBYdOkyzc77C1wKqH8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0938/1191] ARM: dts: helios4: add vcc-supply to EEPROM
Date: Sat, 12 Sep 2026 09:01:06 +0200
Message-ID: <20260912065609.294666733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



