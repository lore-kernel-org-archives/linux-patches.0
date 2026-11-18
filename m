Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032110;
	b=oB/L3dG1PZ9US8C3uUgRXsTZfIg0uuLVHpxD7teMt8tW2cWVl8IcE0NKgaRVkvlEimRz
	 Mx0N9wrXc4XnJ8mJ5onbx6wELMFitLav12yYMd8U0blDnLAKWtM+ps5wnZpTrAqBcP6LG
	 wNG7MhKKqCk2nlp/d7UJFikOczJyUuXXC+M+a4B351y/3vtwHBzo2X9KqR1fTzWP/gPvi
	 EBiETywYbqcIwWb53QayMamAYhmNEO4lm/iyPNcn+fNGu4NCJ7lzzLFOvdCsoSK5hH1QT
	 BKa2gViP0ziq7sPJMVmmuDp5YWuhUjQCNBDAsegVl1pXNwsZQQM2vVH/9xpq6PHxjlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XIsckEIDmVJB77x62XuxKYoFviNpssrfvMkN23yJGE4=;
	b=z4UnpcV2e/asp5NICCVmmuFEb66cFSboLazREevuHYFvI/oLCEZEAKlRAnIp2R63I+8f
	 bqkjzDzrlYLVinR+ZFDXJL4rFvF+DtvuSJmNCWkRyrMPh+X0e8lkp8XYMALPSjR/GUAgT
	 ksZmmtNiKEQ+ORREVU0K0nYwcDJ799hVV1ABCz1neTHsszxr0cM3EMdiS+c+krGaRahks
	 Xr3H3PxtGRkh7eGEtOjoQ8xTt6StwtEeXD00K4gpFGMmpVR5GlnmY0RexbN0bGNrBCeJX
	 tgaGJ3ivfje/6onVxOLkzxQb6tloY0DPdyjvSG+J4/w9XnvYNePv8+D0iwIYQb0iPdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lPlqB7R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5DF606A32C;
	Wed, 18 Nov 2026 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lPlqB7R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB651F000C4;
	Wed, 18 Nov 2026 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032110;
	bh=XIsckEIDmVJB77x62XuxKYoFviNpssrfvMkN23yJGE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lPlqB7R2Us5Qdzz6swc9LERENhJaDwp8JGCYtDsEqILfAjJsNTzElGQpjT7TDy6h
	 d1J1nWteTTRgOd/TvXUhE1vOSWmN5KHJy8H1nDKqFtGDaW+emOS6jtOQJqEuT6UCBR
	 C6fUgftJKHKW0zqadhtM++tP+XQBofPt+/MMB0Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1297/1756] ASoC: ops: Fix return value in snd_soc_limit_volume()
Date: Wed, 18 Nov 2026 15:57:04 +0100
Message-ID: <20261118150101.161155986@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 669b95cb4850f..768e70f7a5321 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -642,7 +642,7 @@ EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value *uctl;
+	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int ret;
 
 	if (!mc->platform_max)
@@ -654,7 +654,7 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 
 	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (uctl->value.integer.value[0] > mc->platform_max)
 		uctl->value.integer.value[0] = mc->platform_max;
@@ -664,10 +664,10 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
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



