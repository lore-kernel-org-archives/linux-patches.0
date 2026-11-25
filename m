Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625262;
	b=N4HBFH3WhlP1LKLgDpd5CHKnrys9rsYU3r5wrOHTLrlXml8Bcb1eH5e6BbyRiG7go5TG
	 WlLaZ2+alrmNpiMi7ULbJ/dMmIbAc2VklhEXXoj6jTcWmu2/a39BRF6aWW4Ebv4hVYk7O
	 dkWfED8quWrapYfG5BQcyrDDBZRubU4klMnoDXEg2yfF6+YDaF/6ZpisCZT72DvTwaI0Q
	 ppvuFLWR6t81s0uJavUCaR43F2jBKkrx1/7a0v5e9KtOCYYPA2gle/oCH9yA+C/kdcSIS
	 nsZXeeZ7qwGnALqmpfSfG6LjGUIqLUSs0jltRHinqgjTI2QMiITV0K7mGwCEb18utVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9EgYzxtYiLN0vDmCYVSFMQKtkYCU8DSAa7SdGU1vdoM=;
	b=ULgNRjUVYad3r8b8+w2DKp4ocgE/qNquEZdAHfyl+ETiNIxjju/NjZ5cGxPnUjKR9h/S
	 Ntm1ijJ+oWfz2NrJMDS0Qu0uF8VOM6TEG8374FqLjtY22YntMxgrLJsfp4ynH0RFqQ86/
	 yuXEUKUEAkBESF5X56tyaG2PkTTTPf4XsEp+ajk7sHDuyLq9glPnpdNZ5aFtzzRItQoOB
	 M8aqzCBmnWVuOQmP7J7Bx4TV1l7QOmw/gG4Bno5Lq7RlDw9rTqrGkthpg9aH/xwAZ/iXb
	 Fo1+fukgMKZnx1sbz+oECXynjoL5DiBV1O+A/koin6CBjSjQpxdiOs4tV3msOQ+8DPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueAeJMAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2D606A32C;
	Wed, 25 Nov 2026 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueAeJMAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72DF1F000EC;
	Wed, 25 Nov 2026 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625262;
	bh=9EgYzxtYiLN0vDmCYVSFMQKtkYCU8DSAa7SdGU1vdoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueAeJMAQGwaN7M0PFCO0NPsDEtS3zeF5z+D7omPs0BpbkFpJZRD+3218+SgoSMbZ+
	 4VC2nddMPgpcWsIzSq4RSfOlNtREiWJAMIOKqc4+/7cHF5Q3kXOUxQLFUXI1KKbYpk
	 UBzOQL1EFNQZZVcjTxyIfPtUK0qIeqQwi4dO1lng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Giunta <marco_giunta@outlook.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/816] ASoC: aw88399: skip BSTS check when boost converter is bypassed
Date: Wed, 25 Nov 2026 15:33:25 +0100
Message-ID: <20261125143859.769238073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Ported to the single-file driver layout: the EPS_EN defines went into the local header and the BSTS-skip check into aw_dev_check_sysst(), since the upstream bsts_unreliable context is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/aw88399.c | 13 +++++++++++++
 sound/soc/codecs/aw88399.h |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/sound/soc/codecs/aw88399.c b/sound/soc/codecs/aw88399.c
index bba59885242d0..63c849a19da72 100644
--- a/sound/soc/codecs/aw88399.c
+++ b/sound/soc/codecs/aw88399.c
@@ -285,6 +285,19 @@ static int aw_dev_check_sysst(struct aw_device *aw_dev)
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
 	for (i = 0; i < AW88399_DEV_SYSST_CHECK_MAX; i++) {
 		ret = regmap_read(aw_dev->regmap, AW88399_SYSST_REG, &reg_val);
 		if (ret)
diff --git a/sound/soc/codecs/aw88399.h b/sound/soc/codecs/aw88399.h
index 5e9cdf725d3dd..1e9fab17f28c3 100644
--- a/sound/soc/codecs/aw88399.h
+++ b/sound/soc/codecs/aw88399.h
@@ -446,6 +446,11 @@
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
-- 
2.53.0



