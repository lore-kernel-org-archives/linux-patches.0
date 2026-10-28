Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207639;
	b=2uupeMCB/BN/f1J0u2CEG1TvhKVCeKG/YAPbBTl3dx828d35AAGjT8dyqxBEXclh6fjR
	 4n0BYQoAgfsHBcwX+o+MUVq/BX/Gv7cfeWTF6t6I/C1b2ahyzsH6sno4w+Z20SZ4IRM4b
	 uLWsH12pN76WZpgIVm9gHPyBO22ty0Gh79e0Zt30wmieXpdMUiUOWmJUM04TzgwYQwpVT
	 mfS5N4vOg6Ymz2Lexvlhh9DGgFBx9wLLFElIXKZOGaY2/+g2nHqaaXSYiY2OF4B76jHjR
	 M47Rz4t3l9YHZrYNS0ByrmOidyEIgLFORE3u6YNjM1sdHb1XaOAdnxsUWsjdAMrrajQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PLa9f6QpQGyhbfxpPvmOc0DE7PpjYnEaBmyCigN+5a0=;
	b=xU7hneuuwG/qTzNFjkTTylVnvJ7Mx2NJkfpwSYhFV2pex6nNxD/UA0jnp5zSESmjxqom
	 pRmmX7al8uTW2aamAc0ypj3EKA5mNIUh/i9UZdeYxLu5YopXovjg9DXdmoYIqmPUH7kOV
	 VQw9nlQvs3dOxYJaf49eYJJtLWl4x1yTlEoUUHpqhpUDxIm5mHWCZIfrtqRLKwJtNoiQR
	 zNzt6kVQCLLthmdoTx/H3U/mbXLGqGQw+D/O1oiMBDXcDJioH5o5Jf9Ehb8bGkrgRRUuX
	 cZGER1+4CnnxCNWznXB7laq7zYpdlVq/k5eSzCcbUSogziBD1qkeny9AazcvqthcW+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhevNHhq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7CE606A31A;
	Wed, 28 Oct 2026 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhevNHhq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0E71F01825;
	Wed, 28 Oct 2026 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207639;
	bh=PLa9f6QpQGyhbfxpPvmOc0DE7PpjYnEaBmyCigN+5a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhevNHhqswuzJ8pmIYN6uY5EF5nNKAPG22WDvCF3PBB2ZlxwDGDWNSAIPz6Lw8Jlc
	 pnSrpGddGxlfXHYghrIiHVMynsviXXfnWjK+gzLXq2+Glxje+1bckERyD2qBRF/p2z
	 kVf7MZOKAVD21LgEaMX3Oy9H1K23ElbB95ty0uok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/247] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Wed, 28 Oct 2026 17:57:17 +0100
Message-ID: <20261028165948.174454809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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



