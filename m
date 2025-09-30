Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7391F152D;
	Tue, 30 Sep 2025 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244483; cv=none; b=I+3yP6yUliYZwjNxhPgPZY/uLWqgf0+j1nL6FijLgwQ8VwiGrmbzE/ZiFWkU/3QjnuR9GxgRq6TTvoQe1w/E0B+2rST80gxd3LJE9fTYSqAC6Q+4MRqbYYzSQWsnL64VF+thbL1nWCaMe7v30eKZhWVRyCt8aC3+w1e+MJACCFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244483; c=relaxed/simple;
	bh=u7W45zG/0AUl2ACh6A2mdTDdlyfNMjAWhylq7utk+Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDcMgHqjo27ZnJsxlxsh3sVr3jx1VsD9RskCBNqCej4qS4x7SIkauRC+IFHssrPH4o/0GIM+rXhO3H89BGsxJPXhRLXFu2Rk9oV8wL+yQXZF9kgGYvsUEhYFijdh8oBzw6adMYqU4RpjcgFQilreiyh+jXs8okZ8Bb+TvLM0WsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K16ktxP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K16ktxP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A92EC4CEF0;
	Tue, 30 Sep 2025 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244482;
	bh=u7W45zG/0AUl2ACh6A2mdTDdlyfNMjAWhylq7utk+Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K16ktxP4Pq3XLonPT3Wz0Jj7b0xqf4a1pyPHLgYP7U83019yWs7qyVYXegeZ6PwIP
	 dm7DFR9HvmZ31HHpEb4LpVdqyUXUzPH+aSrkr7yO26iaJ3fyILfZZAzgqv6wn9Ojv1
	 lhaOwDMOsl0DiJ2qloiWBdbJPVQyrIVtrgx8Ktu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 005/143] ALSA: usb-audio: Fix block comments in mixer_quirks
Date: Tue, 30 Sep 2025 16:45:29 +0200
Message-ID: <20250930143831.457135785@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 0aad92cb33276..c4d79a9ce2baa 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -78,7 +78,8 @@ static int snd_create_std_mono_ctl_offset(struct usb_mixer_interface *mixer,
 	cval->idx_off = idx_off;
 
 	/* get_min_max() is called only for integer volumes later,
-	 * so provide a short-cut for booleans */
+	 * so provide a short-cut for booleans
+	 */
 	cval->min = 0;
 	cval->max = 1;
 	cval->res = 0;
@@ -4255,7 +4256,8 @@ static void snd_dragonfly_quirk_db_scale(struct usb_mixer_interface *mixer,
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



