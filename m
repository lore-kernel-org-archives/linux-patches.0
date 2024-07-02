Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B6539847;
	Tue,  2 Jul 2024 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940616; cv=none; b=oozoRpSGyHlkkmwYkuY83PFcy94QAIete2R55k34NCGI0yjxzbfqr8PdgkZoMnNWNHz815zrzSFzs3eqX9/4OOuJSWe1GqT3/FTwn4K1JOnTAnzF+87iWKyErHq3G5UzULS5QjGNIEiH7c9V6/dEQRIeZhhBMTztNkOkFDHPi8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940616; c=relaxed/simple;
	bh=tYOBszBEH59lATrRPTxZKsAkj0P+82MHBDpHt46tLa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr79scfXku4ByfAWo8XCaI/AEvlWQi2OqcS5c30O+RbiRg4cVXs6uOyVzoHhdAHLeFSiddEH2qHmy5oxXos+1+jOJZGNOUGHC3G6fWY+gNZ2s4Cj1E8YrYKYgvvVrZBvVO5jObMm57U1bOetGFktrDPWJKd8jh/y/kzVbzqBspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezCvj2fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezCvj2fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8EDC116B1;
	Tue,  2 Jul 2024 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940616;
	bh=tYOBszBEH59lATrRPTxZKsAkj0P+82MHBDpHt46tLa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezCvj2fUurBW0nfSqxmTUliTSarPPKXMXowwcULNxY7pk56KK1YIviz2Y+sWneg4e
	 YA6zexztnNaVVY8BXjYtvREVtfhDoyS6C+fPQ5KRdi1B3CnCaq+anp2y6V9O0At7cT
	 XH8NejV8MzdZpsrn7M19T08xVVbZzULhRqQiG+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 208/222] arm64: dts: rockchip: Fix the value of `dlg,jack-det-rate` mismatch on rk3399-gru
Date: Tue,  2 Jul 2024 19:04:06 +0200
Message-ID: <20240702170251.937523462@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit a500c0b4b589ae6fb79140c9d96bd5cd31393d41 ]

According to Documentation/devicetree/bindings/sound/dialog,da7219.yaml,
the value of `dlg,jack-det-rate` property should be "32_64" instead of
"32ms_64ms".

Fixes: dc0ff0fa3a9b ("ASoC: da7219: Add Jack insertion detection polarity")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20240613-jack-rate-v2-2-ebc5f9f37931@chromium.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index 789fd0dcc88ba..3cd63d1e8f15b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -450,7 +450,7 @@ ap_i2c_audio: &i2c8 {
 			dlg,btn-cfg = <50>;
 			dlg,mic-det-thr = <500>;
 			dlg,jack-ins-deb = <20>;
-			dlg,jack-det-rate = "32ms_64ms";
+			dlg,jack-det-rate = "32_64";
 			dlg,jack-rem-deb = <1>;
 
 			dlg,a-d-btn-thr = <0xa>;
-- 
2.43.0



