Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050085;
	b=idx3Cpe3oJSP34NzD04tLCkOrU/1gtSCB5nbN/ZLwOqPTsjjkk06ap7MydWwyfZini0T
	 7N4mrt1oBUZ7Khu2ohB7KOnO+q+KKHk1RLYghvBM8v0a6WOxVqUI2wxcd4ACKsTlxUNJt
	 y7KObv/D9gU5QvVDQreHcSae0XRzkKtjCjgMj0c8OHSJpw3kfY2gkb4Ed4TN39tsLFQYr
	 vQtz1n6BXZVPnNmHWWKEGGFiqEbOe8DCH5EFPMIFwvKDYPpGgHqlyXMLKFAN5VmMp0eA5
	 ubNRJvUPPnqNZfEOVsfbg3zZJqMEGjMPAoh6FpI53lRLh1pTvIIa1lz4GtU1I1Rr+8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TUYHoe2m2Lgve9BLTDupqgdZEN8dfQgRjfresuRro10=;
	b=UuZEA7V7gtUDDMslo28n2x1qv8FBSIo0NJvuX6OVKLFxfYSkZCnCbbtnsRP/YDU6DdRi
	 BfOFmWr9B6PciSHfRsnXT0iApgyGlKzV2e6Sq3s2Ednd2/kD95JgAvvGizMJjIRybvyyD
	 kn0i4LfygnClvGElwLOjB1COC1o3INykQquG1mYOeyk2NON/KMJCzib3r/Itv/RKndRLZ
	 z2MDPgA8S+ft4hsJOF4ANPCsiqHIhZUw0jCLYa90bU+tERZoiNArSqklIWTxKc05qjMpm
	 0YcRdABPXgl8Ezl/HKdK1qN3HKeZbtCUs2za5EmORKfX5fNn9KBFJyPqf6dQWDQFykA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZoHoCvM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1837606A32F;
	Thu, 19 Nov 2026 01:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZoHoCvM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1AC1F000C4;
	Thu, 19 Nov 2026 01:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050085;
	bh=TUYHoe2m2Lgve9BLTDupqgdZEN8dfQgRjfresuRro10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZoHoCvMX2LqwlSZgU7Q+7GzhKpxa3NB1mlQGLcdNLMO6Bk7DgTKil4pcgUVOq9ak
	 T9RaiIcAfpT3Ra2nP361QbnJLSdFQArDAUBv0T17YncNLLVdGWGkB3YOQCvx9S3GNL
	 Zi3DIVrQ+fY7M9kBEg2wlGrvSMPgcxkraGI4eTzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2542/2857] ASoC: ops: Fix return value in snd_soc_limit_volume()
Date: Wed, 18 Nov 2026 15:59:36 +0100
Message-ID: <20261118150333.046624079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5be32c37bb8a0..3716e4353f071 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -641,7 +641,7 @@ EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value *uctl;
+	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int ret;
 
 	if (!mc->platform_max)
@@ -653,7 +653,7 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 
 	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (uctl->value.integer.value[0] > mc->platform_max)
 		uctl->value.integer.value[0] = mc->platform_max;
@@ -663,10 +663,10 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
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



