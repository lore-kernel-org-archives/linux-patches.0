Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025522;
	b=j+at2UEEVNn+z9bWLeovLAcH3JDXg4bmo6MxGoHGF0snlhbZRQT/emD0oQWeKpZZ+VnP
	 F0Z65GEdyR1GBuJePvQNJ9irGbRpwb6RLM0RjchVANfL9rFiV49kBEL/UGp0CETazcYW0
	 DDV3tNLI03sXbBYxVjl3Gski0fttMWgmrqejummi+ZbnV8sHczmpG7rRWMqYGAuzYdXt9
	 pkP0RbauU7pShK/enCp7DcSyXduKnNBlgZWhPmXjnyyIRYhtqlrtJM9e9xuqwVJOEYYLT
	 SKLx4cAT91UITBuj+/NlYebQefJrrt0eqvrtJbMh2aBNzIsjmPyZ5i1rG07y7wp4mlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qP7SzereCYnXrG6aGFb3A8AoREYRnqnmsJUYOpKcFRQ=;
	b=XHD/HkTDHrceZJGsrjTn2DVjVnUgnJUwzUhZs+p0YSaibkm3LO720YUXBHiyJVmO8xLR
	 KAl/0RghwI/2lXcz4GpG6tQ5ASLnpAwY/FjHBcpCZAa9EVV53eca72upAdq3y4lha5k4/
	 6PIIEWnerMCKo7dNO9GW1vg95XWqXLqipLsRTkAy5Nwew9mBWmI7fcjQmldEg8OQXM5Yz
	 6any5xfIaGfqcdTMabGYAptQSx9GTN98rkF2ep5sUWsMFP1JvVAw2rHrFfWYCPCW6DfzJ
	 cpSg6fflHhMuVx/H3UWOGd5QFGGHyvigcG5d9xerEbSrX2I2hVXfGuItHBm6QhRFNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OERMN4Wn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8DA606A320;
	Wed, 18 Nov 2026 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OERMN4Wn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218041F000C4;
	Wed, 18 Nov 2026 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025522;
	bh=qP7SzereCYnXrG6aGFb3A8AoREYRnqnmsJUYOpKcFRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OERMN4Wn+QyXrGgNLzVIAYdJQWUjbPh4Za1MBvNjLPFOg+vpyxscoS7YwF2wBFAHT
	 btH/3J1RvGRfJujNF5vbTXqwyfh3rO+dR6ov6mC75y+edMSlQZR1SXdHWyrqYrGqns
	 m25GyJ6KdIrrC3RBrNgD9rq+qi4WeLThXIVVG3uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Giunta <marco_giunta@outlook.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1067/2151] ASoC: aw88399: skip BSTS check when boost converter is bypassed
Date: Wed, 18 Nov 2026 15:46:42 +0100
Message-ID: <20261118150201.160592281@linuxfoundation.org>
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
index dee91b540b81f..0a6e0d85fbd0c 100644
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
index cdb4f8241c6fc..7d4d701083376 100644
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



