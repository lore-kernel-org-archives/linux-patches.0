Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACC1F1302;
	Tue, 30 Sep 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245407; cv=none; b=mMwxcGZHHa/1mQIYfHguZhFRD+ttAgbSgdJvExsYXtpqGm83aL2a8S8Qfo6Y2ineY7RrcitpbqwMsCW6zEMB/sGhGo/EM95czeJ/jPDWe4YJdN7l0LU8qkJakMWsYGASDmZa1UDVXCxT1sUd4r+Ctfvy5gtS8bj5HfKCNcNCF4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245407; c=relaxed/simple;
	bh=bZM9y2c975G3WjsTpZi5nBejqpDGGv3DoAA7b734G8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfkoU6FjBMgpemzgD5rRHCJsf171W1k4JH9cVgZuuQlVcC6FN+m3RRU6ZP6cfL0EDc+tahr/B2cwxhNKr3Ot6XBhKb0i4ZVaanPaSX7mnT2QSXyAugDatSNk52O9BGY04y4hESs7/UliWBCU5w8WbO0y/vjhGBbmgGp+OBaPXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ll1+F9AW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ll1+F9AW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C32C4CEF0;
	Tue, 30 Sep 2025 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245407;
	bh=bZM9y2c975G3WjsTpZi5nBejqpDGGv3DoAA7b734G8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ll1+F9AWFO/4vgk21XW3SCg7uEm4dh+1T7gWjnp4HMvc48eYt6/QNOTAYNHdXv9yy
	 GToK5Xy2qrvEpvAulLwYSVEy4bhk5aekEi7jcXiRYHvQgp07Ul9Bop85qN5YlvBMil
	 SLD6taOJyqJCnXbYDJICgWMHCGqSMREXLuiDFCpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/73] ALSA: usb-audio: Fix block comments in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:05 +0200
Message-ID: <20250930143820.601749242@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 68c82e344d3ba..4ce470e291b25 100644
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
@@ -3546,7 +3547,8 @@ static void snd_dragonfly_quirk_db_scale(struct usb_mixer_interface *mixer,
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



