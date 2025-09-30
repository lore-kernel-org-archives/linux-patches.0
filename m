Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088B5201017;
	Tue, 30 Sep 2025 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244312; cv=none; b=G5St207CTMUBDjZ44CrUs50KbzdckfSdHZAxsZcA4M0rjd8SjlL/CqtL/ilAVj7+h1WwGQjonfILAX2YckcU+5djYpoUNRNWQeBMY2V0JxGQQm5wHcNVAlw7VZ65Qr4WuuKPNAgIysZKmdE4rQAJqfFY10YIx75wq56eL+fmuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244312; c=relaxed/simple;
	bh=jWtywtrJqpqpb/qIkNNLU93OTBTiJImUzkHvpJZtLV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrP9Ms1tEuEvgSvoknXFV9FJCgWawIjD9LvOT4GE444zJKqaDQu97LL2sBTh4tPdpx46tWi5ckGUBPUV5mLESpXIuNMROrGaUAemK7PhY5+hRz28JykNrI4wQ1iSVeCQlfkSo827bkfiW+7oBM4iVVHZA7GjWYaTS4b1Gzm9yiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yj5i4FII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yj5i4FII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6DC4CEF0;
	Tue, 30 Sep 2025 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244311;
	bh=jWtywtrJqpqpb/qIkNNLU93OTBTiJImUzkHvpJZtLV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yj5i4FIIK0O8WnT++D0UU/l2Sy3RQl2uOALi28r2ouST34kYriEM/bRn2lGDkPgK+
	 50pCEcNuXQKg/4tlAp8QZiVyBdqAFOCmiiM6eOiTFuuhAW+xroQCoGlgpwXbaXFOfe
	 PUn2E3l+Am4ChLlfK3R6VAj2wHlDa8uxeEmVtsoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/122] ALSA: usb-audio: Fix block comments in mixer_quirks
Date: Tue, 30 Sep 2025 16:46:55 +0200
Message-ID: <20250930143826.440626198@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 231225d8a20f8668b4fd6601d54a2fac0e0ab7a5 ]

Address a couple of comment formatting issues indicated by
checkpatch.pl:

  WARNING: Block comments use a trailing */ on a separate line

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-4-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 866b5470f84bd..14b0a91c19d34 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -76,7 +76,8 @@ static int snd_create_std_mono_ctl_offset(struct usb_mixer_interface *mixer,
 	cval->idx_off = idx_off;
 
 	/* get_min_max() is called only for integer volumes later,
-	 * so provide a short-cut for booleans */
+	 * so provide a short-cut for booleans
+	 */
 	cval->min = 0;
 	cval->max = 1;
 	cval->res = 0;
@@ -3267,7 +3268,8 @@ static void snd_dragonfly_quirk_db_scale(struct usb_mixer_interface *mixer,
 					 struct snd_kcontrol *kctl)
 {
 	/* Approximation using 10 ranges based on output measurement on hw v1.2.
-	 * This seems close to the cubic mapping e.g. alsamixer uses. */
+	 * This seems close to the cubic mapping e.g. alsamixer uses.
+	 */
 	static const DECLARE_TLV_DB_RANGE(scale,
 		 0,  1, TLV_DB_MINMAX_ITEM(-5300, -4970),
 		 2,  5, TLV_DB_MINMAX_ITEM(-4710, -4160),
-- 
2.51.0



