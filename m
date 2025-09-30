Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6605306B3B;
	Tue, 30 Sep 2025 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244403; cv=none; b=Az/ugeUZtAjI6zNcnnPPRw18noCuPgiN29AbggF0FNmfper8XaNiZjQ6QQOK+v9vzPcYsJOzaMrUzCsZvZBgeeRDNTTzuhhRGpC2dZmBTkmToXfOAN43Hk7XdGLegIU+vfRpgxZ1wFot4DKFOejagNjSBI8XedLJHRPNrarRsRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244403; c=relaxed/simple;
	bh=UwC2tjoWZ6u8Ime2UwaOuA2kEP//oibDcLBrJXWMnmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erW2BC/wy2ydw0m/6At/TC/k10rdKvShrQ6QlPODydWUqxA3zscWznrMJKpwsrKWN95NJPfdoF/7Clj7kNaZyxgTOHXKYRHtwTPmkCRgLeb0tC+XKYLZ9W4749GEfJ7OE0L2wzQ24lSlNYkwJvvcsQrSxFaaqCdkmF+F9JJXJWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7lfbye9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7lfbye9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3824C4CEF0;
	Tue, 30 Sep 2025 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244402;
	bh=UwC2tjoWZ6u8Ime2UwaOuA2kEP//oibDcLBrJXWMnmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7lfbye9LAYBa4VFcyIh+hK5zwKxwLl7Bw5Qy3xRS0QqEHWwRpk/Uxk8zQyE6U/Uz
	 6AXsQvphv/1yL2DZOQIpUB2cRyYmcLUgnJWRebrO0G8uNbKBMHMX03XOfWObhBeu3j
	 ReR/Z6lD/htB23xf5qwInxepUP+q2wL1hV3LEGl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/122] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:46:58 +0200
Message-ID: <20250930143826.556799157@linuxfoundation.org>
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

[ Upstream commit f2d6d660e8fd5f4467e80743f82119201e67fa9c ]

Handle report from checkpatch.pl:

  CHECK: Comparison to NULL could be written "t->name"

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-7-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 715b0922243c1..9243094cc0637 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -126,7 +126,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 				t->cmask, t->val_type, t->name, t->tlv_callback);
 		if (err < 0)
-- 
2.51.0



