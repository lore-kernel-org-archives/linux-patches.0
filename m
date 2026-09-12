Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF147CC92;
	Sat, 12 Sep 2026 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220604; cv=none; b=nxFfb/l/yAQnLsWkDbx1r+cLPjRNlBjtVXOE6CQZJHrQtWWCqRKajCwINBG5dp8zpX9a8Yjg3ZFnrWl6GaKHv9L62UwSEMLjSdrxSBPFDYtzsS78BciHN/zT0mCYaEEAT1llwNLf/ROBV1NcAqfEw5Qm9Wf6KelHKSi0dv74Lbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220604; c=relaxed/simple;
	bh=xj4BooYH/5pooQLoaEnPqJM5Gdyi3vEnzJGiSJxxs9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2amJHuD7zx39zExJFnHDtBX/AqLPQ8ReMl2xycqJTWfrtAW+kSpY5/yiVzLdNGvNf8s3gzlQhIThQFh/AGkVFT/D5BUx+nbY7s2gC+BfmftNwYjDaId0kBpF9L0q8uwJGUECVGYK5HN+Rlm3kKOJazfJ8Yen1HJwt+lxq2i1ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYjjtduO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYjjtduO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5621F000FF;
	Sat, 12 Sep 2026 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220602;
	bh=2XeSh2mMbpYufX0Fl1BFmNEAdPeSRJDFjC/4zPNADV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYjjtduO2+M+mKo1t8UrUsy7iXqXsdVxp2fFx2seVAn+rusKCtZzUPX1+gNItCe4s
	 cf5JLGco7aWwLuNKTi+dr3Q4iYg4t9T/0k0KMT1Uk+vSBBsJd/lu59Y/COrOQmj+ci
	 tDKqdfyFM1yd/kDNiVLd7jpv4BcvnWVBwREohHuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 0168/1424] arm64: dts: rockchip: fix eMMC reset polarity on PX30 Ringneck
Date: Sat, 12 Sep 2026 08:43:20 +0200
Message-ID: <20260912065611.054082656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit dfe078755706ed50651ebbe0442843ecd4ae8389 upstream.

According to the Jedec 5.1 specification, the device is held in reset
when RST_n is low, therefore the polarity of the line must be that, as
specified in the Device Tree binding (mmc/mmc-pwrseq-emmc.yaml).

Due to the wrong polarity, eMMC devices with RST_n_FUNCTION[162]
bitfield [1:0] set to 0x1 (the default is 0x0) will be held in reset
forever.

Cc: stable@vger.kernel.org
Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260626-ringneck-emmc-polarity-v1-1-90cefe57b316@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -19,7 +19,7 @@
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	leds {


