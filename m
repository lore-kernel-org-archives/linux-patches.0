Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035874;
	b=CN884F1X5nYTej9HRQZWpaQcfoxs/f60kJgc28UHJXxXdAKC5PE1wLp7Yxp+jbEzAA2S
	 h/1nuvRT6voI86CpVv+VI5zPlcNJuoiWZtoKS0QcDqW5LEzRSc203wWuio7p9hzJ806yj
	 qH7UqEiMvzLDPlG9KzBKij8M1c2q3A11UKcpvz5Ua0hBQidvgfjl/iUouGRdNFaRKVVQX
	 t948/cJ03FWhrmkOJI9tocmy+ILHmAZri4KZqtMlln2LUtj5lVCm3ZUawstMvXYmFfTY9
	 Vej7cmz0yL4eo2pxtesVC4uE94YJkzrBEgkX2UVVJc8+dKJpu7DYZ6nia84RDF+I8DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EGADmxYTq8WmJMGydCZs759Vd7Z10U8JKKmSUebeEZ8=;
	b=EVbLspEBuclGvY3uL8FEVbbapXPGYfaMJxcCuX4NBRB9zsJYK0Hwumj9952oQKIo5G/9
	 jkbbYv4XiRG5FGBm+XpNspjgLfpaIwJ17t9/hCTEIYjLYBpnZfj/QAhSkYrtJx29Q/UBh
	 zYJXi3vBUqlFYJHfbCoRFbGOc/HfrKTFnOqdUUA211lO1SSjjX64VHULRYvEPrBRhP0Os
	 MApFHiaGcXnRCsdUPBEczw2sFdM2DrpPQcQoEjB8Tncm0jtnwpKfTrd78AxCubtERVFFJ
	 2y/e77x1jTesZbQrRBMnbrsXAsetAQm1AAqO+VfftOdn4XZSYKmo+T+rnKeYcul2yhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZHI6UUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBE0606A325;
	Wed, 18 Nov 2026 21:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZHI6UUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB591F000C7;
	Wed, 18 Nov 2026 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035874;
	bh=EGADmxYTq8WmJMGydCZs759Vd7Z10U8JKKmSUebeEZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZHI6UUpoo8dJTthJHxytLmwc+Yxl5wMhk191UXuZO9FrqKKlyoxyuRJAoSyRAfoU
	 565ZdsF8dM2/P3qRYm8qeTpwl7rpLut6bspZaTv+KNVd5IdLUcw63myNVsbTP4LFpF
	 L3YR3su8fMwP3IfQHQ7VsYaS1c1T3evuTNMekr+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0858/3318] power: supply: qcom_smbx: test battery health status bits
Date: Wed, 18 Nov 2026 15:24:40 +0100
Message-ID: <20261118150345.007004799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Snyders <robin@snyders.xyz>

[ Upstream commit 68f645192f64e1037685dbdb0dffb41a5a012056 ]

BATTERY_CHARGER_STATUS_2 contains independent status and fault bits.
Switching on the complete register only recognizes a fault when it is the
sole asserted bit, and can report a healthy battery when another status
bit is set at the same time.

Test the relevant fault bits in priority order, matching the Qualcomm
downstream driver handling.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-2-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 22 ++++++++-------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 90f99e1a16b3e..8f953d1550b6c 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -636,26 +636,20 @@ static int smb2_get_prop_health(struct smb2_chip *chip, int *val)
 		return rc;
 	}
 
-	switch (stat) {
-	case CHARGER_ERROR_STATUS_BAT_OV_BIT:
+	if (stat & CHARGER_ERROR_STATUS_BAT_OV_BIT)
 		*val = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-		return 0;
-	case BAT_TEMP_STATUS_TOO_COLD_BIT:
+	else if (stat & BAT_TEMP_STATUS_TOO_COLD_BIT)
 		*val = POWER_SUPPLY_HEALTH_COLD;
-		return 0;
-	case BAT_TEMP_STATUS_TOO_HOT_BIT:
+	else if (stat & BAT_TEMP_STATUS_TOO_HOT_BIT)
 		*val = POWER_SUPPLY_HEALTH_OVERHEAT;
-		return 0;
-	case BAT_TEMP_STATUS_COLD_SOFT_LIMIT_BIT:
+	else if (stat & BAT_TEMP_STATUS_COLD_SOFT_LIMIT_BIT)
 		*val = POWER_SUPPLY_HEALTH_COOL;
-		return 0;
-	case BAT_TEMP_STATUS_HOT_SOFT_LIMIT_BIT:
+	else if (stat & BAT_TEMP_STATUS_HOT_SOFT_LIMIT_BIT)
 		*val = POWER_SUPPLY_HEALTH_WARM;
-		return 0;
-	default:
+	else
 		*val = POWER_SUPPLY_HEALTH_GOOD;
-		return 0;
-	}
+
+	return 0;
 }
 
 static int smb2_get_property(struct power_supply *psy,
-- 
2.53.0



