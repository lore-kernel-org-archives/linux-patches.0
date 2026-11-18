Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020541;
	b=gWHpymYBqAMk5xtWNonJIBMQ2hpz6Xtpla5FdO0upsTnW4WKPVUzlCEKlM9wlOAba3Qt
	 SKs5KCIOWFMXPoNPR5spNtDKY3M+iQ8J0H6maqE0dEVfzZ/1kRWpLd5MYE8PAhlpQfx3/
	 krfkltTwdg0SakIeWZSomUwLoyY04vJD6/Xqpx0qykXDYx9K5xsJBHdqDFAK1ZktGsE/P
	 7dUiRzPBPM8/e6PhLE19saX5kJ+5Hoh5B8Rgto/HFgZjXvfAFbJlqGAMbyDfZl6YEZlPg
	 KX76YTybUH/NqA58XLtec1oH1bbO5uZQ64E52cvpjGYYVWknPEcmaRs7EqAUHnDAmVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zd8H0egoz+Oq4ac7rgWj80PMNe3UWEULjqqLsj6jweM=;
	b=puNYT0+NdruSRhOpbdyMxuCFBQEOgWsC2XXR5EIkfjhwEVjWCykkVru01jWYaWSqieJ+
	 DF1EmcZpSNKkhaCkheRbSaD2hiSlzOhyHC3Mjgtv69VWZ2ddg21d9zoerp8+8oKP9SiKt
	 vQVp5eGFtJHtX2VZ+STi9LUiPABS64OPDRNr6IUZUIX6OV8E4m5+Z9Y1FEKqMI7056eRd
	 Mgqe/N5dW9r1Yax4Tk9pb9OyHeucB9KAKa2ZXy+m2RLGLBQ7saeMIWP8BYUPglZ5LQmks
	 kwaZw+nRDJ5ylxHm6LFlB2DfOCJVA+HJq5vFIVQPBL3jn+FQPTIxFtpdiGUaJ9vDZuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJNF8+JJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B110606A320;
	Wed, 18 Nov 2026 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJNF8+JJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B421F000C4;
	Wed, 18 Nov 2026 16:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020541;
	bh=zd8H0egoz+Oq4ac7rgWj80PMNe3UWEULjqqLsj6jweM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJNF8+JJ+WSFrz9BQI/X0Ai2l/wJaRP+rTOIQWMTHU1yTnMYFIk+lTOy3G+rrJ+Lz
	 RyLc4Df5DjqVTLipsnqICS/KFCkOoGLSky0TXBXQFuACDvQgtqzpnnYzGS60jFn0rs
	 hugBGLy3G9QkoNHAVJo/u128thLSBsNl3uhM2a6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1988/2651] ASoC: ops: Fix return value in snd_soc_limit_volume()
Date: Wed, 18 Nov 2026 15:53:48 +0100
Message-ID: <20261118150357.942218387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c935571d43e9d..59ab521f99a84 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -406,7 +406,7 @@ EXPORT_SYMBOL_GPL(snd_soc_put_volsw_sx);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value *uctl;
+	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int ret;
 
 	if (!mc->platform_max)
@@ -418,7 +418,7 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 
 	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (uctl->value.integer.value[0] > mc->platform_max)
 		uctl->value.integer.value[0] = mc->platform_max;
@@ -428,10 +428,10 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
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



