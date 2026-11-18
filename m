Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015238;
	b=RrPbaIHRCudZ8jSL+4+rr9IxH/PNs4cYB8fcw9wMJLj0Zk4RjtuWhUtKjZjgmIE7AxL9
	 UFSXjMDHN/kF6TNM/E041D9vAVhDzUI/pD0aMFJiHNfSjzx6Nb6oScoNr++SkKaGTtsb6
	 Mc9d2o3OGjpc5KLryT2VB4PJYe89V3VX72BoLjWk8jR+AZVlCIRI1JdYYOgkEWNc/R1ua
	 lBMlXNJPMHdbHU7QY+bjQkcD3E2kJGdcnxRA6rc0oe7VjAEyb7RDrgt+9r5cmFIS4O6eC
	 Oprx3kKEvB2EbrLW5WrmbjKD+2y0cNxPbt5LrfIdOB1bCrwc0Vk1PpxQ+QbTc7NIItg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A/9iGUhqznaGmnD6MP3ew9P4/ZB0nTXH1HIA62iu2Gs=;
	b=cSyRy1bINDIkM5uDI3mJuhR4G8FWwucEDKphbfvRrbg3sCsCEvmNbjhyc5vPVEQ3cm3R
	 7iicMTkiJejURLJ8YMBD5WB9uz1m+iY3ITHfuvmudoQJF5ge2oWPtdC3QU+Pw3f+I9Kod
	 vne1HDuxe5rE7ImfeaUqAiiVxd3x960OlPhacti29TAWYaGBMpMq6ZMAfs8oIiaY5yrtF
	 rHD5a+6qeReaip9TUrX4QNm8n2H7m3DC3EVwsh1e58HETC5PfF4ZHt8bsTpJa2wiY36bw
	 yg0KE2NA7/DfQxYmg6om0s1YiuWJRnC5dS5lisIiIMQxSBO3LvzMNP6Y6sso1pQ0I3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U287zaUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D62606A31C;
	Wed, 18 Nov 2026 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U287zaUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCA01F000C5;
	Wed, 18 Nov 2026 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015237;
	bh=A/9iGUhqznaGmnD6MP3ew9P4/ZB0nTXH1HIA62iu2Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U287zaUpD4TBtVH2cjnTFP+g+Gw0IxL8ht+/UCAdFZhwm+EI3/enGrBrOb5xN2leW
	 1ZSX07oIOwubPULvahgi0b+CqdaLBmxhG4FAUjF2t27clLQUd5J78M+G3xUOQX7x1G
	 qRVgi8f2dt/MRPNuz5Q3a+tM7h7D/p4stcRFx50o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0101/2651] ARM: dts: armada-388-helios4: fix vmmc property name
Date: Wed, 18 Nov 2026 15:22:21 +0100
Message-ID: <20261118150251.527630755@linuxfoundation.org>
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

[ Upstream commit 008e9faadef8c0aaa9b8a3ff05a2126e3c5b08b7 ]

The sdhci@d8000 node references the 3.3V regulator through a bare
"vmmc" property, which is not part of the mmc controller DT
binding. The binding requires supply properties in the form
"vmmc-supply", so the current entry is ignored by the driver.

Rename the property to "vmmc-supply" so the fixed regulator is
correctly wired up as the card power supply.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index f5ae4bea1211f..0545452a983fc 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -269,7 +269,7 @@ sdhci@d8000 {
 					     &helios_sdhci_cd_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



