Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050174;
	b=bsAusyV/sh+LRPY8RYK+iq1cuk9duCBxznXLDq+zWiXYcT9ccJnRNC/vGp6ZnX6ZUSiQ
	 GtAjIdWFj4AY5BphQrLHoNOd54KjEoAHAKycz8L+GY29Xum3GcMHIDgYU8zMLQSV8iNwp
	 2edboHVQyb7SwJqvyaFOYbu4yryCLJEM1vl3UFLvM6p997c9xo4S7AKB2+BGqfhKbC0OS
	 KbvYJ6qKylWzg8LZ06dQ10nbduZrdg3TCb5o9vm0gzdk2CCCERw0/V07KM3cvcsusssZn
	 /nQkOquprWWF+CISe/RGRwNxOY4sZay3XyhGqfcLmf2jKE/Ewfh0lOuxp3dslW9YIvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3D3bbDho+niq/sSbbM79jgPL/agrynwy+AHxr5orco=;
	b=WQeLbRmV0BM+iYB5NXz770YzWZX37wuo7iEkyAM8j4KWxoMmspz3pB7ZfTB2iBOA2mnn
	 lhs9xCxugUsrPC1y6QhHok/TrVHz7ob+EQbROV52vxjAmW9V79vqDm+wyq+ae5m6Yf7Xk
	 LTRP8coF0KrBd0PX3YtkKx+T0ReNQfqPzSmmylJeWuisfqfO51Te0/2Q8jZEIMVz/z/iR
	 SuqgFMGnwXs2dK7biSqhS7f3GncEslhVjR18VkMzaXzQR6svpN8FtozT1rL0vF5d0r+ev
	 xOKVD9n43qMgpIpQONJdDhziCEwu3x75ItloiC34Xrb9xGVhN+fDk2fImSde9dRneJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsFWF5Ae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CCA606A32F;
	Thu, 19 Nov 2026 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsFWF5Ae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFACA1F000C6;
	Thu, 19 Nov 2026 01:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050174;
	bh=X3D3bbDho+niq/sSbbM79jgPL/agrynwy+AHxr5orco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsFWF5AeSI/9xA+otl3y1EMEJ8ThAnVFP2ucPySTE5iNboGoDqiDfCfnMJywLVlkf
	 7M/eQnrp9zjrPeXYOzBurfDMNIrRT6+6O5onSalYWE7dcm6GXaMh+5UybxkEZq2/l5
	 8/Ol4PJk0MtCopLQFLCNBUMIeRh8MYKNBJhnrseE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2613/2857] ASoC: tlv320aic32x4-spi: Simplify probe()
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150335.664960232@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit c6d86149db94c0289b0e5950fa23c5b19031ab8d ]

Simplify probe() by replacing of_match_node() and spi_get_device_id() with
spi_get_device_match_data().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230831194622.87653-4-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f28c09b7e62f ("ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-spi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-spi.c b/sound/soc/codecs/tlv320aic32x4-spi.c
index 81c05030dd3bf..d5976c91766e0 100644
--- a/sound/soc/codecs/tlv320aic32x4-spi.c
+++ b/sound/soc/codecs/tlv320aic32x4-spi.c
@@ -16,8 +16,6 @@
 
 #include "tlv320aic32x4.h"
 
-static const struct of_device_id aic32x4_of_id[];
-
 static int aic32x4_spi_probe(struct spi_device *spi)
 {
 	struct regmap *regmap;
@@ -31,18 +29,7 @@ static int aic32x4_spi_probe(struct spi_device *spi)
 	config.read_flag_mask = 0x01;
 
 	regmap = devm_regmap_init_spi(spi, &config);
-
-	if (spi->dev.of_node) {
-		const struct of_device_id *oid;
-
-		oid = of_match_node(aic32x4_of_id, spi->dev.of_node);
-		type = (uintptr_t)oid->data;
-	} else {
-		const struct spi_device_id *id_entry;
-
-		id_entry = spi_get_device_id(spi);
-		type = id_entry->driver_data;
-	}
+	type = (uintptr_t)spi_get_device_match_data(spi);
 
 	return aic32x4_probe(&spi->dev, regmap, type);
 }
-- 
2.53.0



