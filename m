Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064120;
	b=G7xuGKNPRmvjLHUMOsu283Ur18wwK8GrNZB/M6uqVluorFTC2nYz4+p7z8e6ljJYOhg7
	 3jtKBX7/Jnv3GcfuRRMlQjvXQL75xIHhF25Sxscs+9utWlJ5nLZJZ2Y5Q313Yg6w6MgXX
	 Ky3RaWgMuO2QkeWcKW0z3f7SoVC2Y9B2g1hszb7XgaRr3n4iwqgicuKKwg5VAljgB3kJB
	 snp5Bfwk8sMC60lCcVlboIkIPPA6Ig4OfXw+f2TXeYgGYwPSkdi8RTUTMnZl4WIL7ACK5
	 cIMcB1PJ6ZqnS/26fv1QruErEeP+gCB7Ptu4W86Ogq83K5VtveCYYzVhf9ebOJ/JUCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKiRfQHwmXZFR5QIaZkLpWUsnWVtjgfbBNnJMdzz6ig=;
	b=Q1lFv9TAnSDhiASm2ozQZsSp9nlE8IgGvL5863ZiAssLl/S0dkZIfgS/G1Iwpav9ZR6E
	 6q6nTaYNkKSiYaNKjCyL5Km7Pu+6Ah78tsW423V8T08jHm5z6diOU1+l4zGTVKOrlPE0O
	 9waUCJ1p8ewtqPehdv4hqmz6x6lihGvVFHjd0b+eiNlP2sVDs7Kc5UhcK/immW5vXdbDu
	 TRzinR6osYzBIxh46ILZ9x8u/hQ4Rt097LayxCHoDyaqshZBP9odtScSmFWwrapTvQkD8
	 /t3nDexe8GPgGyEyinz3s6EeEEzrnxaOA+4c3mtsHhu6L0x8lwfypg/DcBan0uH0GOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9ekPTRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4398A60A6F45;
	Sat,  7 Nov 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9ekPTRv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53C91F0089F;
	Sat,  7 Nov 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064120;
	bh=JKiRfQHwmXZFR5QIaZkLpWUsnWVtjgfbBNnJMdzz6ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9ekPTRvNmcIn2j2BBPgC7/Ct5Wneu2WPQTfLaY+jgDqQOIUbtHzFBW4gT5acrp6F
	 SHg/YSnH5PTA2gZVGrRQCoRRCikE6StM5XajooBNurr1U2RMYhCZEDGdzwuJrJWLJE
	 nT3T+HxWKwPyEXOUZ2fBEXXSsxfcyrQTmAVExhDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0276/1257] arm64: dts: freescale: imx95-aquila: fix gpio-line-names padding
Date: Sat,  7 Nov 2026 08:42:52 -0500
Message-ID: <20261107134947.102444881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 66a5b2bf9d217668ae683eecfaba38bcd61cfe94 ]

som_gpio_expander_1's gpio-line-names use "AQUILA_C1".."AQUILA_C4"
instead of the zero-padded "AQUILA_C01".."AQUILA_C04" used by every
other Cxx entry in this file and by k3-am69-aquila.dtsi, a different
board implementing the same Aquila Family Specification. The
zero-padded form is the official pin naming per the Aquila Family
Specification and the Aquila iMX95 module datasheet.

GPIO line names are meant to be stable across the whole Aquila
family, so userspace GPIO tooling that looks up a line by name works
the same on any Aquila SoM.

Fixes: d5c082ba23db ("arm64: dts: freescale: add Aquila iMX95 support")
Cc: stable@vger.kernel.org
Link: https://docs.toradex.com/116801-aquila_family_specification.pdf
Link: https://docs.toradex.com/117671-aquila_imx95_datasheet.pdf
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-aquila.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-aquila.dtsi b/arch/arm64/boot/dts/freescale/imx95-aquila.dtsi
index 69dc962a24a1d..4a809e1a840e4 100644
--- a/arch/arm64/boot/dts/freescale/imx95-aquila.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-aquila.dtsi
@@ -406,10 +406,10 @@ som_gpio_expander_1: gpio@21 {
 		#gpio-cells = <2>;
 		gpio-controller;
 		gpio-line-names =
-			"AQUILA_C1", /* 0 */
-			"AQUILA_C2",
-			"AQUILA_C3",
-			"AQUILA_C4",
+			"AQUILA_C01", /* 0 */
+			"AQUILA_C02",
+			"AQUILA_C03",
+			"AQUILA_C04",
 			"AQUILA_C36",
 			"AQUILA_B74",
 			"AQUILA_B75",
-- 
2.53.0



