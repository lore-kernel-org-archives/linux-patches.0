Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773846;
	b=yCqKXhhDSXbi568bczi2b4nru4JonwsHnvHR+NVXrxmKPBFUUmDyOIhdLDoM6okpCntj
	 PcE6uDWlm3Gi8YnWtW++iypdyRk4pW+aAmtV64vhiJntVAri7tliQ7j/mHRXguzt1MJAj
	 HB69MziPQ6mX1zwy9ba/Vy8wvhr07slgmopvW8k2e+TDlOCaen8Rkbake2be1wolyI3Rk
	 cwqak8xPA42d/sMW5SvZtKaVgseUrVC/RE/T7N7iNYsEN+xfKIlKB7cFgYbGY+d4AWSsa
	 eu2sYELfMvuonj2ApjsC7SZq49VJN9bagNmd5MVRWZZ7roc2oo9M7D/YXVpGPEDbuVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmOvtEtdeD6qBcduTc3/4i92CiEJkiSFdswFbqBhIyw=;
	b=5OVtxdGWkvTEbGN+hffHPdzaPxaUdvGJ2hcMVLqhkhkbuyriZW+aYicKe0CFEgasL2Z1
	 T6E8EkmSR3H/cuQtTtWhrWSZ/LcGsHwnr2qonbgojwoyaouI0jk9q0brCX24xRvqqMaqq
	 01dla1zfhxvOgbj6SVoSbkJHRueSa1Oe6kPNlxcGnsdyHaVFQZNKKyQX9+yWIPYsiEsCX
	 zmeb5YC/nYViXi6K6RybmMJIJB0RFvY7CL55Cvw43K/ntt6In6moJ09SKA9SKu0xBznCW
	 24Mj4jMWI69SIFvwqQp2fKqCt8rZLrAJBX+nnKG3QFmemFAMcl6+cACF6HBBEEzwM3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+M+FFDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE79606A332;
	Fri, 23 Oct 2026 16:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+M+FFDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D5B1F031E4;
	Fri, 23 Oct 2026 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773846;
	bh=cmOvtEtdeD6qBcduTc3/4i92CiEJkiSFdswFbqBhIyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+M+FFDwbo8+hBvLE+1Tg+Z4FxhuDbemIL4q/XPMRRTvUwXZ+hkR3xP97RHYez6HL
	 0WI4rOTwI1UMNjXH7PBx+jfpxPcJ6TSDKDXAb+kwVsYxQvgiym1EmRkN2KwWbqntRL
	 iPfo3ZSGbipqS4Mp/OkTQqifkl+X+2ikRaajov/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/193] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Fri, 23 Oct 2026 18:35:12 +0200
Message-ID: <20261023163715.033334774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit f7934340c56a84fc1b246ebf6b2e806d775f3b54 ]

Register 0x31 holds two 4-bit fields. The datasheet puts SPK_GAIN_MIN
at bits 7:4 and DHT_VROT_PNT at bits 3:0. The Speaker DHT Min Volume
and Speaker DHT Rotation Volume controls both use bits 3:0.

So setting the minimum speaker gain changes the DHT rotation point, and
SPK_GAIN_MIN cannot be set.

Move Speaker DHT Min Volume to bits 7:4.

Fixes: ca2cd6bc6663 ("ASoC: Add max98371 codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-5-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98371.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98371.c b/sound/soc/codecs/max98371.c
index 852db211ba1e7..c53f76f0ade76 100644
--- a/sound/soc/codecs/max98371.c
+++ b/sound/soc/codecs/max98371.c
@@ -166,7 +166,7 @@ static const struct snd_kcontrol_new max98371_snd_controls[] = {
 			0, (1<<MAX98371_DHT_MAX_WIDTH)-1, 0,
 			max98371_dht_max_gain),
 	SOC_SINGLE_TLV("Speaker DHT Min Volume", MAX98371_DHT_GAIN,
-			0, (1<<MAX98371_DHT_GAIN_WIDTH)-1, 0,
+			4, (1<<MAX98371_DHT_GAIN_WIDTH)-1, 0,
 			max98371_dht_min_gain),
 	SOC_SINGLE_TLV("Speaker DHT Rotation Volume", MAX98371_DHT_GAIN,
 			0, (1<<MAX98371_DHT_ROT_WIDTH)-1, 0,
-- 
2.53.0



