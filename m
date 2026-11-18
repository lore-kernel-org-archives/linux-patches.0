Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026977;
	b=xUmefYeiqB6vq3H277+Xl7oTkgEaYcnqmYL3N62YrQ1c2cjQI8Ee3ZWocakGB/vZvaQH
	 E9S2/Q2wz91DcdkqreB76QECfbVgBwKBMizMDP+ltRtuVxLJGFjbGkraRGGiZ74y58ZOI
	 FRSi75rfPfsxi7HKjDQAlNEJPVzCp64HVBV9Kj53zNvzf+MpTchOCRg3vDnnGOhGPltb/
	 N+vMyF8S4X5UNVTypMTihykTyrtWUoheUzU9hP0oCrjIlfCOxG/ZvrqJYxFP5y9E3FMWw
	 CHBer3ZDUAyroHlUO1Pqz+goFZ85sZqIFOYQn6mW/3uJbXvMoDEtY96f9aUTKzqTO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MBLv+6c8wlf32PUP4a5KaD83HMjRRjDdWtQ/igJluHQ=;
	b=IXXSgnhxdySNBtq1MdlItAuRp8DeuUvZqocXcwcYE1eZ6exMCmypWFrjeh0ZGuQGrpx+
	 YtEZqANx+w03ehqsc+MbOOSWw3oIxD/3e9/uRiXMv3DcrYk++4ASoPmXsgbqmIz5Wp77A
	 WaKfMDbfiIMZMFBaibcXn4B8pQaEa/kbjiTClfhAyeD5kYkgtWUACH444BDzzgcmhtgxf
	 Bvkjguy4NvuOSmZiXydqADCeciTPlDutYpbWrHF+o+s4Ob/dtUj74rGEQiGoAivWQi79z
	 mbkzvIoL/gsmlvFwoZ4YrTiuvm10bU8R8bKr9EKg0Z2Unwz1u+G4FJsEI7iOQHLmijw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5wymAVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D254606A325;
	Wed, 18 Nov 2026 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5wymAVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE1A1F000C5;
	Wed, 18 Nov 2026 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026976;
	bh=MBLv+6c8wlf32PUP4a5KaD83HMjRRjDdWtQ/igJluHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5wymAVmNTRVy1b5Qp4Z3I/m/mzcEFDokiuHVcMy4wc960km+6qJJd9UmI5++5znN
	 fbvpm0oy6KZz3gA7yCDsQlL0+txCDEesXgmXY4NMy1Y7fbHcf9XJxJP2DfZW9nhe8j
	 bl0Sgz79idKwBR8JLp61ppTyUNd0tF1pn0cmz3Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1626/2151] ASoC: ops: Fix return value in snd_soc_limit_volume()
Date: Wed, 18 Nov 2026 15:56:01 +0100
Message-ID: <20261118150221.107648166@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 223ec2a93bec6c5ee859094c826fec78516a0bb3 ]

As documented snd_soc_limit_volume() should return 0 on success, however
at some point in time this promise was broken when
snd_soc_clip_to_platform_max() was refactored, refactor it once again
using __free() to automatically free struct snd_ctl_elem_value and
return proper value.

Fixes: 7e10d7242ea8 ("ASoC: ops: dynamically allocate struct snd_ctl_elem_value")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-3-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 624e9269fc25b..6630cf87d266d 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -448,7 +448,7 @@ EXPORT_SYMBOL_GPL(snd_soc_put_volsw_sx);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value *uctl;
+	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int ret;
 
 	if (!mc->platform_max)
@@ -460,7 +460,7 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 
 	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (uctl->value.integer.value[0] > mc->platform_max)
 		uctl->value.integer.value[0] = mc->platform_max;
@@ -470,10 +470,10 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 		uctl->value.integer.value[1] = mc->platform_max;
 
 	ret = kctl->put(kctl, uctl);
+	if (ret < 0)
+		return ret;
 
-out:
-	kfree(uctl);
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.53.0



