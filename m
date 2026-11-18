Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022825;
	b=MdDwyqAsobkhYPcnAUF7gbB7AN9H7VlisKxAcKcGJiUnDca4Z++T5vJs3bsG9weylkRh
	 PCxqkttaFQFnC7DvK9UYH4LgJ+Qwgvl7aGnvin9Mh8plQ6S6ZHY/MioCjAoQwSry7Ax7G
	 Y7l2QqVUdWeOpr0bVCn8ZiAfrhazC3esQjQp04FPL6iXboS7cQ78l+gr/Sivl8S1u0zzj
	 KXw4U8FcfmtGgnqR6HhMVqcO9UUPRVHOGfZECAvphehjJV557G3v647m/l3vWPvOOLmix
	 3xckR9mo+AiWegOztsfUSzSBCU+4aLhmmSy9CgxrfQ1VZSrP6xmBjNeH4W4r+x9msfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qrA/NPAe/HnHKDG+889GMd8BTb/eDqgVH9tFZSVPbTQ=;
	b=AWQZzJxpkyO/hQopM+RtSVJpH00DxnZlN43tQHtVmPWWEqNr7nDuUnLPV9K6b+WPiv5L
	 Cyl8Kp3bNY27O3ydQW7jeND6nics4PEulFfwg33iLqK1k5OVTYTW310QQPUNgLpti/8k5
	 htXQWB9t5nh0SfER+Nn0IxoYvCZWDYuAaxMF7rJ1XmN5fZCUJvkpQbqp1YmNZS4aN9kfc
	 bdLQP69XqgGFQJlIz6KKOffDqM/YKGP6VjFFghOmvWC7BaC3AnOt3U+mjM68hROK4soAF
	 okjFKa14iNvXQjyBBlA8Bfifs2Di7SlnY97/pYBhp9LhQf1hsn6ioXjFxb6pHqPev1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZCnxDPUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2037C606A775;
	Wed, 18 Nov 2026 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZCnxDPUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299291F000C5;
	Wed, 18 Nov 2026 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022824;
	bh=qrA/NPAe/HnHKDG+889GMd8BTb/eDqgVH9tFZSVPbTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCnxDPUoy6/TT2kMFYSTmJcgWjjxxRNABzMKSTWq0GtKRMZNZLbtmdpfBKEfnyQ43
	 ztNPX1rvDDqYVUr4qYsK8+t9cE7xALQC0JI7bp+qNvfyeMJ8LqZ/+v5tpqPKGzsNLH
	 /k7G+b0lwijfxB3x5fEOUP6YHw5309j69XqXPjx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0152/2151] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:31:27 +0100
Message-ID: <20261118150127.299813614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



