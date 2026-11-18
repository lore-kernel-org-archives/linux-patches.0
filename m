Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032386;
	b=gEPRbmyIer8fU6mnoyKqrU9kp2rKwUp7tvxFJg4o+AytK+KXxktudEZi8l+R4Za0Ubzt
	 qSz0XsVdqUCyb6O7y6PPDFFZ6wBcqkBfR7V7ioUSphKPIR/Ud4B0snqVkibfNewawgT0E
	 3xKzJNk0DLjv3cZOYfms4skYrH2kQZP82VHJmDhgHLuhrE1BGJwnwV2CHZ84l8ObCHKy7
	 JXDNiC64QWcorB8unLlmlwJJ5fwksn7AOognVFCD4HPB89LWAkzvffRtVWjjgl3Emcyaf
	 AucspMO5DVt2PlxtCOxbJgJ5x0a9fefDi1k4VMt0gXSo9ydKA32ztp+ZG0etKk+eAdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9fO05uA0E31uxcRTyUQhsWCykjXxTdprkDlCugylznI=;
	b=Y83TXWzAJjk1pOo4GLk/jDnI4YmlPI8h41v+p8n/OnY4MCgoNwAvFF39tCECQg8cpy0c
	 iCR823a29AEEKhqVPAMo22npYowIgt4M4VCvT7vfwdOHEK9DCQchO3+xPShNaE2CFfMnT
	 r+XPGxJ2mqleGjChwjuw25aTUm8Xc36LmcImfFvBjX7+0MzQ6nu8Gp5XNaIGy4OYJFngF
	 TIUrQwUK3pSee9pcKPUdTR+E67R3Iya6fR6/17ayZ3oUrtSKHXZ/nhAv9u8CwnUnSCwfj
	 0/DwUzpOrkQ8PbTVzfP5DBc/EhWF/QVrFnYLo75LGDR1KsYDTTBk8fwfrGInGImjaww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=albvtINt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91551606A31C;
	Wed, 18 Nov 2026 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=albvtINt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7FB1F000C4;
	Wed, 18 Nov 2026 20:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032386;
	bh=9fO05uA0E31uxcRTyUQhsWCykjXxTdprkDlCugylznI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=albvtINtD/GcIXLURFDJp+TMa1kjhTyVqV1e2+V2qkZKH9MeNfkm0jsiWNZ9qOwmd
	 rqCV+cn8CQSV975ffbXq1IQTxiZBmPBeIko5lyj61YH/yOJjcSQLqMcbzmfe77rYRP
	 Wgbwk/nKvBIqclO2xdyyW4RyzgPRMQRNBKc3XhsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1394/1756] ASoC: codecs: sta32x: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 15:58:41 +0100
Message-ID: <20261118150104.630451912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit e06bf60ee5bffa9eeacff0bf8b03d4572b04f67d ]

The limiter attack and release thresholds are the two 4-bit halves of
one register, so their maximum is 15, not 16. With 16 the controls on
bits 3:0 also write bit 4, which belongs to the other threshold.

Fixes: c034abf6e503 ("ASoC: add STA32X codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/179118fc7680b2b872d1f917b7fd21f54a73a6d8.1792135145.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta32x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index b179f2495834d..122f832d90e05 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -480,21 +480,21 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
  * two different enum definitions; provide both
  */
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (AC Mode)", STA32X_L1ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_ac_attack_tlv),
+	       15, 0, sta32x_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (AC Mode)", STA32X_L2ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_ac_attack_tlv),
+	       15, 0, sta32x_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (AC Mode)", STA32X_L1ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_ac_release_tlv),
+	       15, 0, sta32x_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (AC Mode)", STA32X_L2ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_ac_release_tlv),
+	       15, 0, sta32x_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (DRC Mode)", STA32X_L1ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_drc_attack_tlv),
+	       15, 0, sta32x_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (DRC Mode)", STA32X_L2ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_drc_attack_tlv),
+	       15, 0, sta32x_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (DRC Mode)", STA32X_L1ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_drc_release_tlv),
+	       15, 0, sta32x_limiter_drc_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (DRC Mode)", STA32X_L2ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_drc_release_tlv),
+	       15, 0, sta32x_limiter_drc_release_tlv),
 
 BIQUAD_COEFS("Ch1 - Biquad 1", 0),
 BIQUAD_COEFS("Ch1 - Biquad 2", 5),
-- 
2.53.0



