Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91832303A16;
	Tue, 30 Sep 2025 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243921; cv=none; b=bsoNZ3tDl2JgE/jOG/2RXTOEPOtftua2D7iX6kZmc8Lms0cnarDOVYftcVYTogHC+eEC62EKTJUlVzmsmgB8PkZ44LyNGS3Ahyz80nFfQSt2d3Xq+3Fg8SOWfxFmJHZy9ZALdnoB5Ii4RnLbJrzVWEdGcxql+ySKXI9azxfQ3vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243921; c=relaxed/simple;
	bh=R62ovpQ4Tp3yNzeFvypmestYq9WAsMcFSBmgqNvbEpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKdqixvdB9dZnaVPFxaDzI5T743LLD6GJPOT/M18QYAHoI5WAnX5yA2b9XFZV37AmsKf1TmHRKw7np7tlw32MpyDSQ4flQYy0YuS+wi3Fa38OHyxGDT0FZOQfFQicCZpby9CDG1dwk7cLcOrrQxL99QuAK+y6HXfmBsGLAPf1C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ5NhiUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ5NhiUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96B8C4CEF0;
	Tue, 30 Sep 2025 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243921;
	bh=R62ovpQ4Tp3yNzeFvypmestYq9WAsMcFSBmgqNvbEpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ5NhiUfNzuEi4FUzKuY9sjVQmdpbTCeFjY7Xxs6qSBnii705lbD8MgoQ0ZBCKNZN
	 vAUtqu56I+KHYevM5AxtSYk1CEXQ8vgxGN3pI97xrCj/Cx9VWbt7nP48IZV7uJgwZk
	 W0scNj4UfNuIx29jSwJARKFWE/bo4jmranjefIo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/81] ALSA: usb-audio: Fix block comments in mixer_quirks
Date: Tue, 30 Sep 2025 16:46:57 +0200
Message-ID: <20250930143821.984112575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bc065ec997f39..96397a4fdf873 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -75,7 +75,8 @@ static int snd_create_std_mono_ctl_offset(struct usb_mixer_interface *mixer,
 	cval->idx_off = idx_off;
 
 	/* get_min_max() is called only for integer volumes later,
-	 * so provide a short-cut for booleans */
+	 * so provide a short-cut for booleans
+	 */
 	cval->min = 0;
 	cval->max = 1;
 	cval->res = 0;
@@ -2502,7 +2503,8 @@ static void snd_dragonfly_quirk_db_scale(struct usb_mixer_interface *mixer,
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



