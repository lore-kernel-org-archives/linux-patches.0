Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015664;
	b=fQD6YplOpcp5Kj5wwFxlbLrCFuFT2QczSw1Sil4bcVoza+GM2Zgx56iuez2E43ZUlAuH
	 ZvQ+vvX6kEfH89rp+C/WQlkJGZKhv7R8SkB+/nWrniROvZcTWcwC4ptE4TXwNJdTDetZZ
	 ujNrelHeVrpG4sImG7G5aYU29eggYcsDvdYLe5P0OAza8t/V7awowqalIUxXD8UL/fWlM
	 OegCbfqiaAQgkdRBZW0vqkwLMYt2HSp8R48adlnObceIeTp3k/TFyeLjDzomTOmms8g3z
	 EuFMBGyCtR0Quxvs/QziROvfz6T16XHhKUtGhu9Lkoud9YLBKDc9frhiooxux/axAuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sQ5hBq4QUkxaQAXKPCKnSknNv4YnY0QU7SBfkqFzZ7o=;
	b=AuRRvR7ADXYMgnBMCG07CZrFmaXwFg+OWUq3K+wRgUdgJsX639UicQTcl+OH+/Xx8eAl
	 i9uqjMNzo6whzfURZlpw3IWHGgOia9E7c8I+saXFw+IhC5l9qlr3hSl5P4V/GqQrD9S9w
	 ZkOZrDtJiz17KS/7tC6X3hZoUDVlLk4TJicLoW9DpYqVWNMytqyy86m5dYSa6s54z2fCx
	 NYtiJ7+l76HfzhdJKgYuOBwPH24O3ayPQH2lEZyhMNLFDQqqyeq83J4d5OjtJLM5pR/a1
	 WzLHsInkIbD5o4ef26nF8aEhWQnmMT+blbPQGvzPGoWi8kzMnnh+cd/fSCyVwZsV64Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1QwJcLZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A9960A2619;
	Wed, 18 Nov 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1QwJcLZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C41E1F000C5;
	Wed, 18 Nov 2026 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015664;
	bh=sQ5hBq4QUkxaQAXKPCKnSknNv4YnY0QU7SBfkqFzZ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1QwJcLZDhtIQGj6Aze+JxGnvmBQRVyj5f3zk2E0ZLLVLOL0pZpEKuBAlNcYHpOcy
	 RwwDk45oqBWUZGTz5/NeW8gO7eZSu5Mr1G33UB90F1O5k4u6byb4k8JwbXBANbLbru
	 d5QzXWHvuTdjvpLyL9HS/90Z01sHrwfqDdNgj+h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	Stefan Wahren <wahrenst@gmx.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0203/2651] arm64: dts: broadcom: bcm2712-d-rpi-5-b: add compatible
Date: Wed, 18 Nov 2026 15:24:03 +0100
Message-ID: <20261118150255.169778404@linuxfoundation.org>
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



