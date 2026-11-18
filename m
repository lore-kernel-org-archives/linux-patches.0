Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036120;
	b=XaQCF5lGbNxwGcjoH1FPGPJ6PbsPIqAgRywFCTR1EC4pe8MmDJjIsS2hv4zZ0QcqqWpm
	 I+liIY4mapB7Dn+ZYlxrIkl8kUFBTbow3zvpx4ROpLNE1gz/HVD1FdZoe6/dWP6uCvSWc
	 TWeUYrWHw/hTX4KKLKqIuo89wn4D206Vi3d7tB1aW38/6jYwV9E9R9JY0gFGELIyuqGP9
	 wKwW99HRSgh30/06vfFjnksBQdcojru7LaoQHtrL8XYhSwAgQ17siFOKrUgxRPGE+thkv
	 k3/Uos4opbNkNzPNe2qlfanvSkY9IzixcjQX0HIZ2Phr8M1d4ss/E5nWfYim1uPcEvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wpZLEB9C+Ts/HLoz0IWgRP1noo6l3v9QDPjw2GoRVWY=;
	b=UttEfRr5bUcdUATvNKo2TW5a9x3EI4O1F5J3UnBOklzqN0994ygWyPwKXHL3SI2zoS2k
	 B1M2d0gYSbFwD0ufAkEuuDRbU0E2G6nNKGTNqmmzGZWe/7NKDItutmCmMNgXYD2kS0a8i
	 exAPE93MxFbHQqFt6Tbcc/Igyt2y+3xMRAUf2v0M6mlHQpg935pV4gP2XfDj38x0EDpOk
	 qnVFNFrwfugvA+KKZ7A08TBUVvuIppX3EwsvENCeNq4KPeK+7o8n7j4GBMkE344e7bXZ7
	 Ies/SmYI4qHg4bBUot1P7DE+WGt59doTNO3nqbFf16Cd+sTFtUOB42zkutelNSU66AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaJ94+Ab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F6606A31C;
	Wed, 18 Nov 2026 21:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaJ94+Ab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E233D1F000C4;
	Wed, 18 Nov 2026 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036120;
	bh=wpZLEB9C+Ts/HLoz0IWgRP1noo6l3v9QDPjw2GoRVWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaJ94+AbYxZZTbwP+5DeGeIFyKDSzQ4tMBgDPvDMiqAAceqFp7lzYkz7x4b1VQLXJ
	 Ncsb4DLfKWMEC8msa1Gg47U7lzLa4Hc+AUpYwcn9w7JEAc0nwQLBEIXSv614Sq68r2
	 n+ugPcOId4BQ+trvwheSwAC9a326mrthsILxjR6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Cemin <dcemin@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0946/3318] ASoC: sdw_utils: clear stale RT711 device reference on exit
Date: Wed, 18 Nov 2026 15:26:08 +0100
Message-ID: <20261118150347.975088131@linuxfoundation.org>
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
 sound/soc/intel/boards/sof_sdw_rt711.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw_rt711.c b/sound/soc/intel/boards/sof_sdw_rt711.c
index 2b05e2a707dec..9b474f812e9d5 100644
--- a/sound/soc/intel/boards/sof_sdw_rt711.c
+++ b/sound/soc/intel/boards/sof_sdw_rt711.c
@@ -144,6 +144,7 @@ int sof_sdw_rt711_exit(struct snd_soc_card *card, struct snd_soc_dai_link *dai_l
 
 	device_remove_software_node(ctx->headset_codec_dev);
 	put_device(ctx->headset_codec_dev);
+	ctx->headset_codec_dev = NULL;
 
 	return 0;
 }
-- 
2.53.0



