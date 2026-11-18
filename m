Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018297;
	b=15c63B4LL9Ly6My6umpouTpuzcHE4P+l0j1C7vlhhNHqmAao3enA2G8iQKYLJaQ0gh88
	 2fSq2i0tZkRmsqiGrcRx35FCxrSlG5lO4xnDwAW5EEEX4sYZF+acDYvJSP9Yer0fib0QB
	 1tlf1ji+RIGQTTpCcczos6E82K1xge3g7oaBJ8XRsk24wrQuG8ILImVPl0m21EMDqRBoW
	 hcfylOsvtTfCfpE3PZjKlRR6hjmicMsMcQhxnXfx7zDtLBOYK5U1nukCH+NVB8Ebw+3yE
	 A4W6DYDmMlRefjD7M4BeUjGnb1xixAq2ED5SrtNPalqCUY/NZk88pfM7SyMkA64O/8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2zRj+NrlhBzDmGuiJpNNEO/yLaHbgckYJB/3IPQCML4=;
	b=JRQWwTOGGuSB5pELKPk+iTcai60X6wHQD+ZFJvVwGPV5SDfA5HYu/GILuv86DoWHbwbN
	 m7vSNWscqpVsiR85mYRBlikM57gp6y819Gjnmm+c72iMXZun8tCIVjE6Lvbokl4lfsDZB
	 +t9SRlnyVL2T4JxyOWlMHzyfuSAhe6yALzZ6NNBqf5BPkdhZebQzUv9DsHOCyU7x4yeTe
	 PCj+D/1rArF3LiOhl4nmyb/Ima7RFUl6LEyulZa1PxaeDCnFyy36vjGWJXnSX7rwWZCPs
	 FfqJdJ//8ZKmcqfwfr/fNdacaTLo+JGH22NSF1nXAkEgNdqDz7p6AL9VdU12CRvmaRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zg2um1bb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC74606A320;
	Wed, 18 Nov 2026 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zg2um1bb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9FB1F000C4;
	Wed, 18 Nov 2026 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018296;
	bh=2zRj+NrlhBzDmGuiJpNNEO/yLaHbgckYJB/3IPQCML4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zg2um1bbD+62NFbjQlc/u8g9qy61vqZXFBuTKwB88EgWElEredcP5YvPE//AvG0T7
	 YjcgrhFlNJWX59HtEEPOhfxL4ljGqlIjcs3rw5QqKYC+4x+GdYrnNKxFlZOqioLDOe
	 p1DRCcArDhUdtkr1PQ6GHCuQ6cJIl81Wm4FiSYvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1191/2651] arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
Date: Wed, 18 Nov 2026 15:40:31 +0100
Message-ID: <20261118150330.875261015@linuxfoundation.org>
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

From: Igor Velkov <iav@iav.lv>

[ Upstream commit b44e2be772f866985cafdf90355285069ea68495 ]

At 104 MHz, reads return corrupted data: bit 0 of the first byte of a
transfer flips from 0 to 1 part of the time. The same byte read as the
second byte of a transfer was correct in all 100 reads. One 4 KiB block
read 200 times came back wrong 157 times. Writes are unaffected.

flashcp verifies while it writes, so a bootloader update erases blocks
it should skip and can abort halfway, with the flash half written.

The Hardkernel vendor device tree for this board uses 40 MHz. At 40 MHz
the same tests pass: 200 block reads with no mismatch, and 14 flashcp
runs with no block erased.

Tested on ODROID-HC4 with an XT25F128B.

Fixes: 7178f340e929 ("arm64: dts: meson-sm1-odroid-hc4: add spifc node to ODROID-HC4")
Assisted-by: LLM
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Igor Velkov <iav@iav.lv>
Link: https://patch.msgid.link/20261002-hc4-spi-nor-v2-2-8366a4f91049@iav.lv
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
index c4b93d6619f25..5f15c2299509b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -134,7 +134,7 @@ flash@0 {
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <104000000>;
+		spi-max-frequency = <40000000>;
 	};
 };
 
-- 
2.53.0



