Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023026;
	b=H3UchIGtwIxivpeeMShx62h6pGUGBiSuyOtAew/RJfoEpfyjKXo216B7D+Q0kqbCudNH
	 C7+vmKD2xFqoWuLDh6CVLIuAxZqlDx+1MfcMa37Tm5s8ayhJpudZ55TOOSi1CQSQZutiD
	 gEilkdUsNac+jPzD6Ict63qkLnu5k+i3rQk1E6Pk/+mVGgWu3kSI65+iRNR3Xzbzp7TkO
	 dqdyMydm+jweWHly28atOW0lhL2kJjl+Si5r4QSBzrAN+WsEeaocqXHabuOZfNW/cci6Z
	 3W3CQjmaDJ+s3wFDf2vyfLDyAddHw6CAYHsjvjTk7PnDlJbmUkBJ7pd0d270ahHfVYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NbmaAs69flIn5yIrFR1OYf8Aq5nUl0MRzA2wWzjTPZw=;
	b=a2kNnAlg4h1joFW54vigQrKpWjULOsTqp3869jj3JAAFVk1taLERyX5spmLpUaRQEsJu
	 50HD6PdS7If1lUiwUdosEoClhg0B+JLwJS/5aYYnhZ6P+L3pFwyr3kix2RMQn350lgW0u
	 OY1JoQpvkOMgTfGvZMqKcGHstaG5yXTFe1NtlxzGfuKh2MTU3QzgG12kiEmKE/+5c7TYF
	 KouJMTaW+plU5M74vR0xRL0errbschV/zPQ8KOxf8w5tl81dudbRcBgtL5+TEM3etLIEx
	 UxMVDuuMoAzWDPMiTSGkYfbsQSy4GTkHojT3h/sFcs1yECluY0CM71s0+Pg15SPz1Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkZvQVin;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23846606A33E;
	Wed, 18 Nov 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkZvQVin
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772EE1F000C6;
	Wed, 18 Nov 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023026;
	bh=NbmaAs69flIn5yIrFR1OYf8Aq5nUl0MRzA2wWzjTPZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkZvQVinsXdGsPvSqRWvU465ttJKiyWkSEi7B/bojtohCCsR1uIrufCsvepXVs+t9
	 LSYG70dLnSGltZCWnHCp31zjqo2Sg1QQySYDfQsjHALAKOymXzXlPZk/EomTRo6hpR
	 48QqhQCgVqCAZ8n4kW8k/5laAZef3+gR8u9HmKko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	Stefan Wahren <wahrenst@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0221/2151] arm64: dts: broadcom: bcm2712-d-rpi-5-b: add compatible
Date: Wed, 18 Nov 2026 15:32:36 +0100
Message-ID: <20261118150129.836727573@linuxfoundation.org>
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

From: Gregor Herburger <gregor.herburger@linutronix.de>

[ Upstream commit ef76568f51914937d22e5efd05874bd42f478903 ]

The bcm2712 found on the Raspberry Pi 5 is available in the d Stepping
and in a c Stepping. There are two separate dts files. The
bcm2712-rpi-5-b.dts for the c Stepping and the bcm2712-d-rpi-5-b.dts for
the d Stepping. The d stepping does not set its own compatible/model
string but uses "raspberrypi,5-model-b" through its include.

These two steppings are not compatible. Booting with the wrong dtb file
causes a crash at boot.

Add a compatibles string "raspberrypi,5-model-b-d0" together with a
"bcm2712-d0" string to allow us to distinguish between those two
steppings.

Fixes: 44839e2ac8ec ("arm64: dts: broadcom: Add DT for D-step version of BCM2712")
Signed-off-by: Gregor Herburger <gregor.herburger@linutronix.de>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260810-bcm2712-d-stepping-compatible-v4-2-73f74479539c@linutronix.de
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts b/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
index 127be0fc27c22..ae4b7c587dbc5 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
@@ -3,6 +3,11 @@
 
 #include "bcm2712-rpi-5-b.dts"
 
+/ {
+	compatible = "raspberrypi,5-model-b-d0", "brcm,bcm2712-d0";
+	model = "Raspberry Pi 5 d0 Stepping";
+};
+
 &gio_aon {
 	brcm,gpio-bank-widths = <15 6>;
 
-- 
2.53.0



