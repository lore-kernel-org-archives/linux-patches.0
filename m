Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015227;
	b=T4EXiblUp4UR1Qbtkvn1qxcEfym5mijmmCIG1BrsCRViqLtDJGhV5B1PnjtqmVBPxEdW
	 DrJarEVh04qNOE0Rj/tvy/mMsJZem5KZRQ/apiFToAybkvMdkKgqGajvBepOyKgeDWdb5
	 5QoPq1jw1lM8303nMVR6Rk6nQFlCCXgIsVnl8hf3NDA/of5pyWVqFzevrM3MO15rvsGAR
	 vGODFlg5sQUrvH54QDwuGUBLzpZMwDSlIMBgvO5CZEmoY2P2vlyIRzInQupYXCH0Q8pdz
	 GILGyMgXJXyYSVIMCCjHQMoaV3ziOaSXorGzgnqIS0CzbzM3NgqiKD+GX503HHNNgrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uywO8ajT18nd7iJw8DXV5Vt6fOeD6bM/YpvwrKiq4s=;
	b=zxAujJKZYWqLsEg9o1S135DQV0BFcHAZZybRs7UvCT4I9ijMx8yMSqTctpSUOH/Eo3zH
	 YvaDNR+LYLZLDHyIwIPL8TLHd40QZwtjHrouG8jj6piB0xi38HQcUVQqKzZEv74KXlPQv
	 7j2D76JeGEPFaDrPZX7gHKDYgppwOF7iM//p64demQN5xROo0jXKCFIGNQGVzneNPZSIT
	 UVEzkIuicDxMAeD/UrOpAKAP+py2JxtiXVu0nTlofLhjyPvc0ZBSstTjAOV/tT0+Al8Nt
	 Mk2Ns/izbSUkJo3hpbeJUGQUqdbZ/yu4Sx05rwh4uwnsc2itausQ+eq8RKm2KJ5we0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTaeaP6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE2560A261E;
	Wed, 18 Nov 2026 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTaeaP6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC801F000C8;
	Wed, 18 Nov 2026 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015226;
	bh=4uywO8ajT18nd7iJw8DXV5Vt6fOeD6bM/YpvwrKiq4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTaeaP6g7OhHNjbQkd9MlMM71Cu7qOc9Fh7Fhz7RPSy4JLTPLjgk7isXRKZiNnIvP
	 pbEM69wZRlx0ZGk3iRStewop1tcsv9aTfRtbr3K5uwcKm0jD5mJDHciWtbPeftWFZ0
	 zeJf0ain31UWtLBVnhVeL9ln4SSklpK5P7bDixrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0098/2651] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:22:18 +0100
Message-ID: <20261118150251.425755016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ef473a83c63e3173ac472e42727e990b923b99db ]

The lm75 driver requests a regulator named "vs" (the +VS power pin
of the chip).  The Helios4 DTS incorrectly used vcc-supply instead
of vs-supply, causing the regulator core to emit:

  lm75 0-004c: supply vs not found, using dummy regulator

Fix the property name to match the binding and the driver.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 003b0708e9656..f5ae4bea1211f 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -200,7 +200,7 @@ usb3-ilimit-hog {
 				temp_sensor: temp@4c {
 					compatible = "ti,lm75";
 					reg = <0x4c>;
-					vcc-supply = <&reg_3p3v>;
+					vs-supply = <&reg_3p3v>;
 				};
 
 				eeprom@53 {
-- 
2.53.0



