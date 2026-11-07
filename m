Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064167;
	b=wtLmv6UjNfPq0XkZplw9BUMfsLceJJMwCgw3L7cOl2oGnyg2JF6XUbGNX4VOHC0N2rMt
	 GxRu6/xLAtFeGtNmJQ6pN7P6M4gGpcmWuiERVHgYJxUyn0BY3VAvjC5Sw9YnR9xnACNGw
	 z+7Oev6wHcd7mRbM3v6r2Lccqr3Uf1LbOwUSnlUe7IZ/uT34/1avabi2ljuQpC+F7HMOz
	 zJtmQpe/07JCCufJXRJW8ARLHdIZVZsPWHt+WlNXSUJS0DgP2ytc/+SF3VyCcF7rAgciN
	 4g4FT33B9YTp7pzVjjwYZTmeWS46GEh0clRdLIz0h8UrdAZSScHUMNXKG/bHlbd8y2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hcaevc7KkPRIuivrgsuLnvg+yQcihlBl6Jtp79A884A=;
	b=m7IlhvjM9MPXFlbmR8v0w0LnRyIswt3oaBdm+dWC1vrDhRuR0ZjfUGYgvuxKKbfCWBjr
	 ng6xfgXuWwFsridH8nQziJjTK5XqnhVTfpLto535ZNMW5bW98tbFPJ/GdMM/sBAwKbtsT
	 YvI8YbNZff1r26huzh4LD3C34NbT7Usxs7LGchM3TsaD8ZrHgx5L/rQ8ydH8IUx8dWHGj
	 89l1wyQhiR5QETIu5cFXJ0MDbkvBzGEBKSDirE5qpaPRVvUDdpukd3rm/voXJKgf6jkJH
	 zfuMI9sNumBGXd3iCZLbH0bUeKoMU7vJVy3DTUdGpkrXyR/JbX4T/0ANYhrLJOC4NAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0RaHhkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19193606A32E;
	Sat,  7 Nov 2026 15:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0RaHhkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EDE1F0089F;
	Sat,  7 Nov 2026 15:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064167;
	bh=Hcaevc7KkPRIuivrgsuLnvg+yQcihlBl6Jtp79A884A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0RaHhkcXmwhsSPpxhgA7XUr+EE4+0CzBCsN1oYkjj3y+PZkZSUeeKDDdY6NvxJfW
	 +4ResYL1fBiMUIFx7wp+A8htGiGv/GcuSyIG6xh4Jgr8Oj3TjXeFG3QVTWbj3m3sLs
	 Hbc8kPbrVccPPMWUcDgbwRY0wDxptVQwBrdgcDlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Cemin <dcemin@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0313/1257] ASoC: sdw_utils: clear stale RT711 device reference on exit
Date: Sat,  7 Nov 2026 08:43:29 -0500
Message-ID: <20261107134948.081141272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3a3a66b4b7372..4707190e160c1 100644
--- a/sound/soc/sdw_utils/soc_sdw_rt711.c
+++ b/sound/soc/sdw_utils/soc_sdw_rt711.c
@@ -124,6 +124,7 @@ int asoc_sdw_rt711_exit(struct snd_soc_card *card, struct snd_soc_dai_link *dai_
 
 	device_remove_software_node(ctx->headset_codec_dev);
 	put_device(ctx->headset_codec_dev);
+	ctx->headset_codec_dev = NULL;
 
 	return 0;
 }
-- 
2.53.0



