Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061763;
	b=tcfzmPf51lWEFsQTjBg3lscB1csy8oIXBH5QYedIyX/JRQkz3SallIDxniXhDQdHefIc
	 JaSYbTZnXW1q3PaGAkh2IazFaStvA7U/IYYPfgs2Pf4uRPpOORH/mI9/NpBI+xZ/O5cnM
	 5hUiGSVEv/obeFzd0d75a4gA5O0AfLn1Xe5ssM+9BekvbU2cus0NBxxMfRdqJ5qb7VlBs
	 oD0vFu0scIWJdE0T/GBiNXtJ6RVppLr7oZPYod6uPzD54jJOLEAlVe+zqRItgdA5CAIdK
	 /4Uhk8Oc3IvoB04yDIObTzFD+U5fnRcHFAywef+fl/dz3wPPqlg//cEbOC57b5S12aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qr1f1XOPpbLuXM21Zikw6xH9JhxLAXn/kIMbdGytwSI=;
	b=okvTUJ5dPiosqMr8lxVawLsrE3uF5ElhrxJVEkpmdaFCao7273Vkqbs/wcL/0DJWJNAr
	 0mbkg79R1u8yDTkiID8cD/99MN7bp3F0ukoqzqlLnSFqRwdH2vvuqSuBnQYod5C8Pelwq
	 +MxB98/QaI5s3orY912ysQiB6qlItZWTtF7srjm2dKDlPZ8Fv59tguO31wyiQFtz0Daas
	 6oXHjHpW4ddP/GW83Kkhgi0qeRn7bGLxeb2LLK6QOMjoKy4mmJFDqYJPf3gLJiqjLJ7db
	 2mrmkQwPwVQ48J9IX+OVHkhD1TmgFw/jVSfwzzZOOVj2siJzk1WkZBynRevVuRMzx0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Pj3Sw1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E36606A32F;
	Thu, 19 Nov 2026 04:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Pj3Sw1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD8A1F000C4;
	Thu, 19 Nov 2026 04:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061763;
	bh=qr1f1XOPpbLuXM21Zikw6xH9JhxLAXn/kIMbdGytwSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Pj3Sw1a1rzjDBmDYapJj26lCib0U8UltjtJkIK0cJZTVLtRrvxe2Q3SfFAtdF1f/
	 DJbcEXvZhnSIzKgvGOOk/Q0FjhYgTo10hwiwXAmcLZhB/al/GOfmDfyEVaqFxhN+7V
	 8d0uzxAW/udxZlUOyjudwIItjOMuLQInyrmfIU1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1642/1848] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 16:01:20 +0100
Message-ID: <20261118150028.412553103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 96d30816a9a4fa6b3cc470f82d0f53e8a6425ab9 ]

The EQ3 band 1 gain is in WM5100_EQ3_1, not in WM5100_EQ1_1, which
holds the EQ1 band 1 gain.

Fixes: 6d4baf084f4d ("ASoC: Add WM5100 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d7f690e391feda7a6d8f38d0b238b165bc1f4fe2.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 9cab01ee4ee91..45ffe82abef57 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -655,7 +655,7 @@ SOC_SINGLE_TLV("EQ2 Band 4 Volume", WM5100_EQ2_2, WM5100_EQ2_B4_GAIN_SHIFT,
 SOC_SINGLE_TLV("EQ2 Band 5 Volume", WM5100_EQ2_2, WM5100_EQ2_B5_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 
-SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ1_1, WM5100_EQ3_B1_GAIN_SHIFT,
+SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ3_1, WM5100_EQ3_B1_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 SOC_SINGLE_TLV("EQ3 Band 2 Volume", WM5100_EQ3_1, WM5100_EQ3_B2_GAIN_SHIFT,
 	       24, 0, eq_tlv),
-- 
2.53.0



