Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018538;
	b=xP0qDpttvHiTg4Ze3DY0+FvEQo1Tv+5JzuslCSOvEu02q0u/q0vjIqubgEONWMG8+7my
	 BXCHMzCfrx0Z/qgZXyPaiPwdyYohteWrAJD1mkEs8C92MDnFmoZXE7MGdIObh8dyBVrLB
	 Ug6RhdYuKgsblYheQF4T/eJuU4mNhxkKPx9JUvGQO7XqdSnOnyA9gSokO2P/NKCDIS9Gf
	 F8R2U/6RIkS5TOJ6C15adUZUd6I4uxmWMYoxExNBoeXdGUFKFXhNeVHDvgl81hDx+JBjL
	 ZFTntR9Cs3dwT9qXmw1HDVwXDbv7wWSH8DtiLUGD5Kgmc9Cp3BBN9Mlq7qSjd/o0grw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+j73dKNJQSXM+5YC9v6f1nIdOy74vpRTi8MAhnc28Nw=;
	b=gKJ6JOVAeTCwf4eG4Y8sLM9/AbHlHjfUKfgS1vjPGFqieMH5JBG6wA10ndwk5x3NCuvK
	 4lo/57t2zy2B+XuOnlsU9eZqPn7XNh3Mve/SNL2FdT8Ztr5mVz94Nvem8ogEkHSRABaNI
	 AJ1fLTqKqHBlWzzSEL0Pb/dBRQtgxaYTTiPovlYqYupgCDJ5H4los9TcMKAtKmTgmFpA8
	 x9unp2ST7Mx2xBxdxp6NQbk8y19I5acE+1yAMlGuhL0NkrdNWxo5OVl7v+HuAbqCCfHm2
	 ek9ojZcn05RpWqwUX9NuS+1P5rhVNVzx6Vli5bjxkoxyIU+tW1nztE2MaC1rr5phNNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQyZglh7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DED606A31C;
	Wed, 18 Nov 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQyZglh7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3EC1F000C4;
	Wed, 18 Nov 2026 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018538;
	bh=+j73dKNJQSXM+5YC9v6f1nIdOy74vpRTi8MAhnc28Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQyZglh7Xm31E9H6+2lHfSoE8KeRO9Rj19yAjgMSfxk3J9XMY4YrLMGFrbV+HHzlY
	 kYjv6NOUr5BUWDlI8R/YrK6a6lKhEitc9pjPBWPoZ+BU45oTuMJtp/LRhwZhM9A+7l
	 yT50f8ULkFx/iJ8ODFJjgWJEH/bKc1iNoqgj14y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Giunta <marco_giunta@outlook.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1277/2651] ASoC: aw88399: skip BSTS check when boost converter is bypassed
Date: Wed, 18 Nov 2026 15:41:57 +0100
Message-ID: <20261118150333.921911361@linuxfoundation.org>
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

From: Marco Giunta <marco_giunta@outlook.it>

[ Upstream commit 664824782df63013ba8686b649c625cac4793248 ]

The sysst check in aw_dev_check_sysst() requires BSTS (boost finished)
to assert, but on hardware where the boost converter is bypassed via
external power supply (BSTCTRL10 register 0x69, EN_HVBAT bit 2 set),
BSTS (SYSST register 0x01, bit 9) will never assert.

The vendor's generic driver (aw883xx) handles this by reading EN_HVBAT and
conditionally masking out BSTS from the sysst check. The in-tree driver
missed this logic when the original code was ported upstream.

Add the same conditional check, matching the vendor driver's
aw_dev_sysst_check() implementation.

Fixes: 8ade6cc7e261 ("ASoC: codecs: Add aw88399 amplifier driver")
Signed-off-by: Marco Giunta <marco_giunta@outlook.it>
Link: https://patch.msgid.link/SN6PR19MB2303FF1922BF5F876378066FFC8F2@SN6PR19MB2303.namprd19.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/aw88399.h        |  5 +++++
 sound/soc/codecs/aw88399-lib.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/sound/aw88399.h b/include/sound/aw88399.h
index a1e0de6be8eac..974b5774ac2b6 100644
--- a/include/sound/aw88399.h
+++ b/include/sound/aw88399.h
@@ -449,6 +449,11 @@
 #define AW88399_NOISE_GATE_EN_MASK	\
 	(~(((1<<AW88399_NOISE_GATE_EN_BITS_LEN)-1) << AW88399_NOISE_GATE_EN_START_BIT))
 
+#define AW88399_EPS_EN_START_BIT	(2)
+#define AW88399_EPS_EN_BITS_LEN		(1)
+#define AW88399_EPS_EN_MASK		\
+	(~(((1 << AW88399_EPS_EN_BITS_LEN) - 1) << AW88399_EPS_EN_START_BIT))
+
 #define AW88399_WDT_CNT_START_BIT	(0)
 #define AW88399_WDT_CNT_BITS_LEN	(8)
 #define AW88399_WDT_CNT_MASK		\
diff --git a/sound/soc/codecs/aw88399-lib.c b/sound/soc/codecs/aw88399-lib.c
index 809c2faa0c0c7..1ba0147cf4dfd 100644
--- a/sound/soc/codecs/aw88399-lib.c
+++ b/sound/soc/codecs/aw88399-lib.c
@@ -183,6 +183,19 @@ static int aw_dev_check_sysst(struct aw88399 *aw88399)
 	else
 		check_val = AW88399_BIT_SYSST_SWS_CHECK;
 
+	/*
+	 * When an external power supply (EPS) is used to feed the amplifier
+	 * (EN_HVBAT bit in BSTCTRL10 set), the boost converter is bypassed,
+	 * and BSTS (boost finished) will never assert. Skip the BSTS check in
+	 * this case, matching the vendor driver's behavior.
+	 */
+	ret = regmap_read(aw_dev->regmap, AW88399_BSTCTRL10_REG, &reg_val);
+	if (ret)
+		return ret;
+
+	if (reg_val & (~AW88399_EPS_EN_MASK))
+		check_val &= ~AW88399_BSTS_FINISHED_VALUE;
+
 	/*
 	 * On some hardware the BSTS (boost-finished) status bit does not
 	 * reliably assert even when audio output is working normally.
-- 
2.53.0



