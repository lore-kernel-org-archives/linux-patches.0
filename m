Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062999;
	b=rLHxAYDJZxsyJeRkjZBaqWdJdo5lLHGW33GQJiUe6uPhdj/HSfZw3myQjqfWNEV/ykS0
	 /+DZgkvlQLhlpmD/y9YD2edg3pzusfYEf0g+/xTOews36ehdAQ22H629ManCWkp4mhiL6
	 BlLN/dn/32oAr/6KaGsUxOL1Cy/uwKpWli623yxLPTnmbg0K4aZEaBXwKf4qmdqXJMyM6
	 K0YRjPyTsm6LSXx/j/GMxs3HYERIOBdGd0vdvyF3Ao+jlfefphUNZUFDiKdn0wjqprp2N
	 DbsDoNTljOge3EZ+XR10Xe0nNimrbCTlVKVVb34Ri4oNod0N9xCUbR8XosshtjVDrxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bR6LEXzLUy0+n87jVvb9hzDm50o3wHPtVshVftA7pLY=;
	b=09ymj/2yrkhZ5j9DeWM1U5xIgeN85bRZQgHW4TonYHr32bnJlTTBH6poZ3GOD74XW5s0
	 +BV5Yx2/jqDtcGYav9gEezm7JoTj9N18aGUYVbKWno5Qx3cepKPwBMSp62Yc3KER8RYKN
	 pnDBAqyo+dXKn5HBBfslURhkbg8eeYVdh+JH6nnUkPb159Fj1IYM6u8vaak05L33UIKGK
	 HnBuKuoLkF2L2Aj+7UIfqEHP/IHdWTb/nIS8Dxq8YsvPcWRnvSWvsI0f8SCpxiX6GN/gb
	 EQWAVJ9afwsvk190b+F5y7votYCclwcgt8GeBaB+1Ab6DPEXIODF88rD9g7Mda5bS6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m93jnfqX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC04606D80D;
	Sat,  7 Nov 2026 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m93jnfqX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0171F008A3;
	Sat,  7 Nov 2026 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062999;
	bh=bR6LEXzLUy0+n87jVvb9hzDm50o3wHPtVshVftA7pLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m93jnfqXN8b49hKpq2TGhJOsi65KvghXThurFoYYsM0JCPws+MFz2vl6PNejTz4E7
	 qcRv0OAeJLQbUEce9ftyd77+2yIkAlU5PoSWcSbkGx3MWeiKmdO0xP/FsA/XXHg3xz
	 +0U/NAJgUCjcQmdrmEbEM/S8vqKeWhn05gRUF1FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Cemin <dcemin@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/869] ASoC: sdw_utils: clear stale RT711 device reference on exit
Date: Sat,  7 Nov 2026 08:48:56 -0500
Message-ID: <20261107134900.401194016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 4aa93fdefef63..1d020d44d474b 100644
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



