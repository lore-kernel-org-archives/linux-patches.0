Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17173338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301738; cv=none; b=pUwjyn7dkrC5TZmm9UigeeNqne1Ip1FjHABacnHJ6rCYi0Qnqf/2qyDP1+h0IgxusKjysJ8LK9vi+nPmBUgw5olVnLGtWlnt/7U4opohCesY3quCwqQmvhIX73cLi4Cy5DtchoV932nyRJPiKUJWFGMmHLgBuW3toxBkIlD5V0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301738; c=relaxed/simple;
	bh=qLah5gOvNYF7tbcWcSsImjDqnUoqlGqJGj+kHcc5yP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3nYlc8q78YCFblyVaO5q5eyKpdST/+gf04cZ6B4rt0GsyAQxW1ufrJlMDb/Thymjr7BLsCPswGA4elwItqJO75YVD16xqaRHqxYy/csckpXz94Me70n6AjaAQYBvqlsKTo6wnA1NPTSlv2WBbgm2q8Ug7sDcemCAtJHLQ0d3QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bc8yvjTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bc8yvjTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79291C2BC87;
	Sat, 28 Feb 2026 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301738;
	bh=qLah5gOvNYF7tbcWcSsImjDqnUoqlGqJGj+kHcc5yP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bc8yvjTJQmsUVRh1W+aieZxxLnvfZt0zFL+cNXInxT3wt7OKqQrG1NhteGH8ZNV8I
	 dGRgTVMNlScYuK9ckHxzXPuL8iEndJcmNX5u52BmF+1Vt1uz+QmkYMQvvaJF6sofVV
	 yiC3Cq+b+oEHCtr13l+rdFS8F7SoO5LqUcGI+EtcZt/K0fr8/h4/Bkv9vDziGEv1wr
	 K+8DKEJTk/3pWpsokbrk+z2cH+cdGXme3D00OEI1v24VUtsE9bmVn8JzjoJ7BLgUBN
	 +6Qelx3U81TA1rOKV6hLbDUYMu1zo4NX0pmY2gmRBSmKuX03PHkwC5H1JOkWszTYJ9
	 y9EgWOJWvdUXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenyuan Yang <chenyuan0y@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/385] ALSA: pcm: use new array-copying-wrapper
Date: Sat, 28 Feb 2026 12:56:00 -0500
Message-ID: <20260228180011.1568201-138-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 519b2b14bef70922bd64117a978ea7f2a683b75b ]

This is found by our static analysis tool.

pcm_native.c utilizes memdup_user() to copy an array from userspace.

There is a new wrapper, specifically designed for copying arrays. Use
this one instead.

This is similar to the
commit 3e91a38de1dc ("fbdev: viafb: use new array-copying-wrapper").

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://patch.msgid.link/20250127160655.3119470-1-cy1yang@outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: f3d233daf011 ("ALSA: pcm: Relax __free() variable declarations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 6417178ca0978..f5a4541fbda00 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3277,7 +3277,7 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 	if (copy_from_user(&xfern, _xfern, sizeof(xfern)))
 		return -EFAULT;
 
-	bufs = memdup_user(xfern.bufs, sizeof(void *) * runtime->channels);
+	bufs = memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
 	if (IS_ERR(bufs))
 		return PTR_ERR(bufs);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-- 
2.51.0

