Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062149;
	b=fjmnArf7KWk91Ab8EySbuncOnRwzCYhDDXQ/S9z55ieCKlRQG5+Za9CLMxwtSUu3snW3
	 M0ilx2rpBqNMqEX6t9p8+leiCr7RBoDYx6QA/v3tp4TEiV/1y/NX36eD8se3RMpi4XZvv
	 u4qb9e1zHsUFhZYkb3jcf2ojn3BG3/r5dbl7726ykqV+JjMxA1ZZ01jlnSnH46pbi2jGt
	 xAzNqyTRBD3BHcIkgtqzZNLL3US3M3DuBipvJyee759rjQr6LOCw8Z+Ec+cmZbpTUCD5Z
	 tEMcc8y45JAPb3X9dlHzRLAm5E3b/6euxmpJHw0mLc0Y+ts2gr/FwvYGUk8LBBqgrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEBYh91y1kwQU/twuf4x4UfUiUPfmSm1MDNcmJgtXbY=;
	b=NwVzP7juAeW4BwN5hyVhRLDiWbbf+q924Kb6zv93763l6m2pFyrb1eNPtlGp07BAK7X4
	 LG/bLLbkMiVbROj7ctHf00XB1ku36wJsi9hDJiVGECX0lH4iLzMhXTNM3i6XCTr+9w3+v
	 FKpt6/3J5mLNjdXZaUuPb5BHDW+uUYbrFjZGhOOg/6TxiLcKiSzxUbKUMnc9puDXKeKWJ
	 Sq/BEj+1rwohA1hhmCKCKGMLdBVC99hJ+/AZbox4WivZ32sLIUuHqdNzN7/+z/liu3JzE
	 iJXESz+nGmYcmRoOJ5YMLbXU14eXyh1nuXIt45Fv+ITQVJ4PrBzfZYMMjUO9sPktbtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTvRM5b1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BDB606A66A;
	Sat,  7 Nov 2026 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTvRM5b1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425031F008A6;
	Sat,  7 Nov 2026 14:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062149;
	bh=VEBYh91y1kwQU/twuf4x4UfUiUPfmSm1MDNcmJgtXbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTvRM5b1BefyY5SyXMZiKRHYpaagixMp5f2izpjntYs9JBJwOl4jerS3qPa9ayuIr
	 Dv0xmT/meec6Zd2aP3e2BYP+ivu/y59hrtFKqHLJqNNHULtRXouPaT0ZcUM9U/neji
	 2M6Xi4ZaB3ESX2YvEWDElQSHS520URvybpKto4rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Cemin <dcemin@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1076/1536] ASoC: sdw_utils: clear stale RT711 device reference on exit
Date: Sat,  7 Nov 2026 08:51:32 -0500
Message-ID: <20261107135027.915113768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: David Cemin <dcemin@nvidia.com>

[ Upstream commit 7c7df141dcabaa5370b5e52a9d64e2c1ea13a338 ]

asoc_sdw_rt711_exit() drops the reference held in ctx->headset_codec_dev
but leaves the pointer populated. If the card cleanup path reaches the
exit hook more than once after a failed or deferred probe, a later
invocation reuses the stale pointer and calls put_device() again,
underflowing the refcount and leading to oopses when later probe,
driver bind, or suspend paths walk the SoundWire bus after the device
reference was released. Observed as boot- and suspend-time oopses on an
arm64 platform with an RT712 headset codec, reproducible
deterministically by repeated machine-driver probe cycling with the
codec drivers unloaded.

Clear the pointer after put_device() so repeated cleanup becomes a
no-op, which also makes the existing NULL check at the top of the exit
hook effective. This matches what commit 046173b98de3 ("ASoC: sdw_utils:
fix double put_device() on aggregated amps") did for the aggregated amp
references.

Fixes: 811648340707 ("ASoC: Intel: sof_sdw: avoid oops in error handling")
Cc: stable@vger.kernel.org
Signed-off-by: David Cemin <dcemin@nvidia.com>
Link: https://patch.msgid.link/20260912182131.1156475-1-dcemin@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_rt711.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_rt711.c b/sound/soc/sdw_utils/soc_sdw_rt711.c
index 38b4126dd45f1..4f0c78466edc8 100644
--- a/sound/soc/sdw_utils/soc_sdw_rt711.c
+++ b/sound/soc/sdw_utils/soc_sdw_rt711.c
@@ -123,6 +123,7 @@ int asoc_sdw_rt711_exit(struct snd_soc_card *card, struct snd_soc_dai_link *dai_
 
 	device_remove_software_node(ctx->headset_codec_dev);
 	put_device(ctx->headset_codec_dev);
+	ctx->headset_codec_dev = NULL;
 
 	return 0;
 }
-- 
2.53.0



