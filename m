Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060236;
	b=ti2pgStEuZ0M83UPqBK8ZpkGircDwslKP5+rPgJ4YKMqumuGQIYGAEva3HHVr58Se3Eq
	 JEXpS/BTbcOVDo7Raiwifu44LrE526HXIRkgwj073GS8lo9lIexbwOrCFz03D4pRKcUEd
	 4XE1TIReiEVbOdnm5U2xzkxzM/H5c9maCCKl3oImIP0aUQqR1d1aEXXsufohdf5W6el9i
	 tk41Dw7Cxj74JLQc5nHAWabC0iR8RTtddHAwKVDn4OxoyMjO1LSINDyLTKPJuW7K7Esc7
	 p9UkOCbdUXpWgrs1XXWBX9ZW3/ZYRx1tEP7YaS9i2KeRC56Fdwx8GCyLCTxvVL+qpRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FoQCjcy6PL4AiSMG2B/U71I1LUYrrCSJGw01U1zFxiQ=;
	b=kucEj4Lqb62WWWPTaxKUbEBQ2MB0qgHZQpx9JHDoIbKyL/ucRIlMVB4TMiYEM87hjnJB
	 K6tjR7BBS0Mz+XNqSnlkviWrh55wwAMXUUhKl+zSwdXi7cudo6mkSSV4V6/rU5UP437wq
	 r3P/TdkWJTZvmEOFAB+Q9VOsyihdwIJ0CTL+UYrD9EsX/c+4pS3fBmWLSZ3u3GZvr+UDR
	 FhGW95UI7TrMX09QjpFDDQiHpCUH1aIlUS/XpgCwgXQi6laLHuuDuP5c7OZAMFdK/IoDw
	 tBnxTTEAQyDHRrGCGj2CXbuttHcHJgp9xdyUUOzxZdhKUksWMoH+eCcs22l1l67B0ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6QvOJVL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0883E606A320;
	Thu, 19 Nov 2026 03:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6QvOJVL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5633C1F000C4;
	Thu, 19 Nov 2026 03:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060235;
	bh=FoQCjcy6PL4AiSMG2B/U71I1LUYrrCSJGw01U1zFxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6QvOJVLoh1lYl97/7/j6NB4URM0VqqGHykCHil2FDypOHDnCRY7uKSroCcd+hDJQ
	 7yRznbb7LXbe5YarjWdULRQUsegEtkvNP87GNxrvh5G3oOFsI3yuZ8VwWDebgnPDNy
	 GhLK4KfkWjtNm2lru7sQtjvhby0mGe0lEKPFta4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1126/1848] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150006.431462383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 1ba824f6fb206..654840425ae97 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -200,7 +200,7 @@ usb3_ilimit {
 				temp_sensor: temp@4c {
 					compatible = "ti,lm75";
 					reg = <0x4c>;
-					vcc-supply = <&reg_3p3v>;
+					vs-supply = <&reg_3p3v>;
 				};
 
 				eeprom@53 {
-- 
2.53.0



