Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054723;
	b=P8CNyxEr6MLeA+3c+b7vgkYZG/V+Q6+cDLo5CDc+mz0ACtBL85cUD2PGNjZZYW0Wx4BU
	 EQGww+eMTrpwI0wil/XMeIWaFenqZDSEd8bw8F3H3o4osbAojcOHi2OtNqHPJl7mkXlho
	 WTdUpVUibd5UvdXU8CAdzD5I84u3hn2FAIor7M48sPybMx9BgdIL4RXof4NE3vbrrYSrm
	 niViSPh5fQBMQ8wOwXs+piR54ZjvzMNmB72YT/x0cfGzWEdOyBvPpOuUVlg4HjJ86iyy9
	 IihftvHb3fDCktvvJgPt67XBt5mX9fFsodj2NodiqxBPk989RWLLdk2QnJdbj8TZlxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQJBu4Bw6+hgwSQHg/VKYeq1hZXiPHB6Coqk4hzBlKY=;
	b=e9YspkwrOAzd/dILNnx/nxuX2jsNne/soBUJdRlUppzjFR1rlCmFNU2p6/CyAKQ6qjZK
	 dHM4X/6AAp2eze3C989/cxtiN3Z+AV9FKIfjwYu1ENk/PQnGxIpNKV5BiEb7q2U9o5QGr
	 7MgsvoIHFzgOpHwvBYxBAQbuQGjtowRAYym091/EZ+L14BYNStAl0nTYzIW/fGdTZf+1U
	 fKqFWiL/shYXn/0E4xsMNGEBIN8D4S8C6izZ1GJKrpWPhWbR6CDH48dNn0sReWRxmtNNJ
	 XnxWX07xX8qNlOobdUPtQrGeG9SUHDxTWTaGTOkPjaFQtZ33krqjG7UhgDxHUU2VuYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrrh+K2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6F606A31C;
	Thu, 19 Nov 2026 02:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrrh+K2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43FC1F000C5;
	Thu, 19 Nov 2026 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054723;
	bh=tQJBu4Bw6+hgwSQHg/VKYeq1hZXiPHB6Coqk4hzBlKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrrh+K2OyErUcA3XiMkS73aw4ejXRap3fRcGdIu757NTpX9QEtaaarItYRObdHvPc
	 ktupNmrPvheGfnrafqTwkiPvjhQ/omno/E6Q7FB6Ht/tSXWAIX7qM88iyjjHPgbWNQ
	 6E1cUOclH+ZnBBK3JNFyYApt+d1XRvDD2V1j9Y7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1335/2214] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:50:11 +0100
Message-ID: <20261118150104.792164196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 003b0708e9656..f5ae4bea1211f 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
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



