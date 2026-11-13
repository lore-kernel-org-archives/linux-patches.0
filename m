Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591598;
	b=BpiKsJSgilquF/0/8CI1k/W80rgwaW15aCTDoyEd1jJIoyKQl/ZpjsicJ0jNN1oiqR0w
	 q1boQQMh9bU1KOejhCZN8Y0KmANi4r51jtJZqMDZcSrCMdbgKN+Aj3qTJ4aB1busxvD2O
	 1LfqG1a9lmRhpeZc4Rf336vF/eEHSXolljTg1NeYdRMpi2xPhr+vsO82YEbhH5wxwhwQ+
	 aIMkJDurS6V6jjqkP2hRVjGT8E+8u+6brF+WeXpjdQGNqS/O0Bwj4AUKcFangaBl3aig+
	 HzpVdtmu+FTsAqvaBQQJz5zKP/Ynozyx4nL5YXubDcBW9n0vcAXSornqf11kUGexeLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8jnfjVcRWYa53mD94mhTgUTufMuyf2Hq7peRfFV0hDQ=;
	b=aM9P63xAiDeqS1LSG7B+9Wh+burLf80Qely/wHh8xyb1pPBJWmqQ/0jKZPjM8201zRDZ
	 sXe3x+LpELhpn2qEU7VO3idGd7st0chwMvwOS9GLi9N0AhPFSIVsz/E4PZ9SuX6CcpzBI
	 rDpZ356hW2B3n/rvN/m8LthHdDmVhHEUIvAAxcQuolsV6Jwq9kNay68D/dsP1V9e9u0f+
	 LofOW2fRUIqLDrVV+J4rE0Q+Ht7jhqvbqN6chwJJ8LV2HoexJI0r+RzEPKeDbVdv/PtDx
	 T8LAwqMuTwLjTn3Vr5TDCHdZdfJbfdWJnQnZ4+2AvlkWKrkjbRyM2/Tii//V79jSuYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yIajRQkH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ADC606A8A0;
	Fri, 13 Nov 2026 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yIajRQkH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82581F000C5;
	Fri, 13 Nov 2026 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591598;
	bh=8jnfjVcRWYa53mD94mhTgUTufMuyf2Hq7peRfFV0hDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIajRQkHPFFYxT2Rne5meIk4is0nCcd93YD5ok0zWdu47ccCLRTQ0DFesZBQc6bcD
	 eMcbEgjxPVKpLSl0Ys2BHvsmwITii2RKuqhKNqOnuI/Vp43KNekAniitm9T/eh+G8Q
	 gASGo0B1f3nWB4se368U0c+zBVqlt7AFm+xK5X2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 641/670] dt-bindings: clock: ma35d1: Add missing WDT/WWDT parent clocks
Date: Fri, 13 Nov 2026 10:53:25 -0500
Message-ID: <20261113153833.517324635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8c7453cb0b01bee47ec2f902a9ac1872d3b77f3d ]

The WDT and WWDT muxes have PCLK3/4096 and PCLK4/4096 among their
possible parents, but these fixed factor clocks are currently not
defined, even though they are needed to properly describe the clock
tree. Add them to the bindings.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-4-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
index 2d6a44a7e55c4..764d837d6162a 100644
--- a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
+++ b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
@@ -248,5 +248,7 @@
 #define ADC_GATE	233
 #define EADC_DIV	234
 #define EADC_GATE	235
+#define PCLK3_DIV4096	236
+#define PCLK4_DIV4096	237
 
 #endif /* __DT_BINDINGS_CLOCK_NUVOTON_MA35D1_CLK_H */
-- 
2.53.0



