Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062963;
	b=iuRVJihbxeTtl2sACfImSUJJHtkUglGdSuh/XCms8IbkoJg1I92O24NoDgUyPBJkxjJi
	 kpvbpQFoCjCxYJmlT0WumZB6Jt4tXUKwzPT9JdNRd6tbzZXVL2QmPcqABVC7Qg7I19A98
	 Ru2turaH0DnKHxpNjjfMk+5BVThEY2NhkGxZku6/9YbqwIofNlO6fYdByy/itM6kyyaCa
	 OwLMo/4A0z7gVLEsVM/2rVsHtUvUSkhK9wNduJvNKk/ZnxtdYSaKtc2KD7yCg3Cc9x4WB
	 HrMcamnuO6Gsuq7Q6d8GCLcnhcQHRIFnTNn+SHtLLFJVvQbadxdMSK/nycFqmsT229w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OMNq+Y6cG7A/iIM7S5K3DYJelKD4QZCkzEuikpth6Ww=;
	b=InnfKBtBKEy3hp2SyK8ScyofNbQQYKOtW7Ub4n4+DlqegECHfFVI7jNZzl1G8MfesGwN
	 AfNP2R0/bnbg23m6nmkXsrx3SpUAGiI59IWBaHqISuKEBkcT6xurBcTii9vJKZUqtmGsl
	 FEvlmEYr88p6mdyAJICKr2wKlC0B0s88anF/vOJjnxReCOgV7YiCg09wFlGVlCX/G11cG
	 frvGKqUDVIGt+YvYAIfWKKv7mC7paEDZGn2HCz0hdoZjJ7P1uZmOE6ch/yzLF3HIujKbV
	 5NhJP2KgSKYCqBQ9iqFU/TuhLHs53v9r+81AQmg3fm0PDkJ/DoiXSVt9mGgfM0+78wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=unSS167W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56807606A32C;
	Sat,  7 Nov 2026 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=unSS167W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045821F0089F;
	Sat,  7 Nov 2026 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062963;
	bh=OMNq+Y6cG7A/iIM7S5K3DYJelKD4QZCkzEuikpth6Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unSS167WjNl7N4STHHJLdnXO7jMVWva58LvV+i1rQsNTL+ekcshiyFXmEPnqU6DD4
	 8u2gpcUlFRWajnXYnidQMLY8+BpPPYUPKGNW7tmbnxALzMwveXe6pbjGxubFFLok9U
	 7QsHMcy37d/w9R75gqksirHghnwwGnT+66L7kJ1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/869] arm64: dts: freescale: imx8mp-toradex-smarc: fix SMARC_SLEEP# gpio-line-names typo
Date: Sat,  7 Nov 2026 08:48:26 -0500
Message-ID: <20261107134859.477992798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 90bc5a53c7f0733ec37a5c041b4e1aefa3d8d965 ]

gpio3's gpio-line-names has "SLEEP#" instead of "SMARC_SLEEP#" for the
SMARC SLEEP# connector signal, while the gpio-keys node driven by the
very same GPIO line already labels it "SMARC_SLEEP#", and the imx95
Toradex SMARC variant names the equivalent line "SMARC_SLEEP#" too.

GPIO line names are meant to be stable across the whole Toradex SMARC
family, using the official SMARC-connector signal names from the
SMARC specification and the SoM datasheet's pin assignment table, so
userspace GPIO tooling that looks up a line by name works the same on
any Toradex SMARC board.

Fixes: 97dc91c04558 ("arm64: dts: freescale: add Toradex SMARC iMX8MP")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
index bebe19eb360f8..576da7875601f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
@@ -323,7 +323,7 @@ &gpio3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_lvds_dsi_sel>;
 	gpio-line-names = "ETH_0_INT#", /* 0 */
-			  "SLEEP#",
+			  "SMARC_SLEEP#",
 			  "",
 			  "",
 			  "",
-- 
2.53.0



