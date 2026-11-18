Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047721;
	b=L2h/Rq2kmdOAEUwkBeL25c3RiaYS1WKcAgLHKWPfBgfmCcWNzldAZusmKsUXZLCndoca
	 LM+qC+0Mo0O8CacHxZ9pn98LJeEYX7KCwaIM95ueR8VqYMkY4x34m0j96v+5VStq4guEW
	 v2s+4LJ/AWqAP5xkRA90vF3fj/I/4MTZ3KkDBajmW56jEd3RWOytwNHGXzkZUXw33bP38
	 af4Ob+CDnwgzSAifdWtMpwEUkeSfcBOEo6f3VN858FhaerAcLRUbwNKjFNwQ/WcCxv22m
	 T1Z9Vqztdu8VL1hOM9D3SnSmyoQlYc7TY7qS+kKW7O21wfFMaMcnVXuhEWp18UUUEqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EfA1qoFSHTWaZh2fdHtJP2BjJ5l16YpwaGouE6qz/Os=;
	b=4Jpq9Rgr13QB1kRplHpZcWNk6uYpveMnnGfdnwY/P3Lokw4NtXLCK6Fc91NhizLRaG5f
	 /+7n3ZDw0kXY407Ks0ljJKEEKxo2DimwwXj/51FoN8O2sEfwYNjAQVOvg3OrCBpRyHGu7
	 Nl0FjVn0dTJheHjajrDD2mdftzt2tAJb5HMZYIP2cnfnfqyPnYPL1L/c9LXbgUHCHd4GP
	 gk1p2pZXBj1bVOmAtVxGSoaIqXhjBnCJqddToHyk+UMeLxY0BwLdav5Ecn7q0UMf795fQ
	 TlzJt1QC5PPVVlL/w40t5GQiJ51c7XH4abaWcXYpdkbSqAzjIPYL5LtdK+5bIA7uHlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cK0z53pA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16BD606A325;
	Thu, 19 Nov 2026 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cK0z53pA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C9C1F000CC;
	Thu, 19 Nov 2026 00:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047721;
	bh=EfA1qoFSHTWaZh2fdHtJP2BjJ5l16YpwaGouE6qz/Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cK0z53pASZw9mr9rbheloj+sbDKDiId4UhTgKxC6uu2xWhPV/LxLut3XJSF6PsGp7
	 RU9QzjMvoTgUQO2fkwazOu3D0nBM8F79uwCsfNMBJEA3eLu3hxLPcEmGhaiiq4J1Je
	 aClvkOWXPeXWy1xh3OsH+X7XqkCYsdVeE1quyI0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1741/2857] ARM: dts: armada-388-helios4: fix vmmc property name
Date: Wed, 18 Nov 2026 15:46:15 +0100
Message-ID: <20261118150303.990622822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index f5ae4bea1211f..0545452a983fc 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
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



