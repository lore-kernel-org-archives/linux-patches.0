Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209327;
	b=3+60dRgT/3CCvqNClXiXV9fdQ2ULzcRt+KrDMiZI8qyYkQSTymmoaSmibfwQqUDkKgNr
	 Q0tDZiVp717WJMTVfSqhuievSENYZLkhrVPLRaF7anTcmhNeRsR/0eIF60mGN5qWXDEtx
	 qFILYgwikVihXn5n69uIfdqTfq8WxK4MG8KxETULVhA0Fe3o1bMomDbJ9TukKBSSnaDCj
	 vGpOX/PxxLA9F/Fdy6hvD6qjamrFKppyMy5qRM9b8yhMbiriU0CLmeG8oUeXCcala/Fzm
	 FyYvfDFhYVISL5MbjFqdG5zvkxfzqGuJ9/vmQ5Q0nlHlet5Ydrc+Mj4JBMr8BLYiIKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VnNJrVMuQptp3PZcRoy132b21CGxv42nFuEHkG6z12s=;
	b=N2cuoFWYi+Uha+qfxX1JoN4NKy/go7iXByBfqidXGT2xZBi//zN6Z1MBuOVeKosYqH7r
	 enjy1wMwxmf2RerrkNNWVJj/aV9qaXVyXzfwU7kBTu0phiOKWD9ab9Qay4yEIu+cmCm29
	 Q7H/sfcqy0J6SW4HG4bM6/MIVCBWMOBqLUhfmI5bfZGELmgMUwlMFfvURZQrEyTOoe/8d
	 pI/GoNIabcxuFx2r8+9OQ/eK/b6hRp21bmZxKzGJw/UoUiqs8DTGo7E4a8Pfro9SYBz5l
	 bZI/tIOrTuPmYiJCmqbaW4DHdSWfjSpMB29f0GUZxxSqttiIsRHEShciIZvha91zwzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgUD27ex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D2C606A31C;
	Wed, 28 Oct 2026 17:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgUD27ex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EEC1F01825;
	Wed, 28 Oct 2026 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209326;
	bh=VnNJrVMuQptp3PZcRoy132b21CGxv42nFuEHkG6z12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgUD27exMvqfQg79TwGjM/yMjHQj6fSPrinGBC8KH3vxqubgSI7wGLe3aZy6NM5LO
	 dQpgdgRbfl5S4lhC79P5kn03I8fh8pplnz35pZArz25CHsmdJouuo/pwOYPIDJ630k
	 fyUIRg231JnsetyGRc8DGNq/UayE01wpTLWilC5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/516] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Wed, 28 Oct 2026 17:59:45 +0100
Message-ID: <20261028170013.742449264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index dfee05f985bd2..82e1a3e513bb9 100644
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



