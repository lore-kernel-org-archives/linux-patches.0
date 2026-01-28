Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22FC30DD1E;
	Wed, 28 Jan 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615072; cv=none; b=uWPDVr88TD9D0Fv3YZZhkijyqszIvcZdNfJEsODxSo+cntMghsWir1DPIbjorV5Pg/dkYbEb+X0yPvvjKRuD4n+/4R/+6qIv/7h3wrDx78aNt/5fUH2GFft7wm5Rg/2yCgb2/613qnzpn0V1cjVnlCVsD/0Y8QJ3cCEiD46IPy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615072; c=relaxed/simple;
	bh=O7+LTkgBRLG5/nCsHlB624BvfUEr3zDYsZTDSAO4eRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxBlLPT8XURui3G2yqUvuV0jnYr3/9RXQBS/88qSFdA6ubGG9fxAS9T4sslOFu4tgtLwL5dWJXPmiu4MDUQeOggk0cwcxSMxjxxHMCAww9imic9sNPb51CdexofWxulz6/Z/9Ddpyh2VEzme58+C4DBsbbFLv3ULP42dtEvdQU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed0P4bMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed0P4bMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AEFC4CEF1;
	Wed, 28 Jan 2026 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615072;
	bh=O7+LTkgBRLG5/nCsHlB624BvfUEr3zDYsZTDSAO4eRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed0P4bMy8bgcgMQNRfAYnvVusrcj6TRPYP+G8nXYDw3uoDDL4V5mc/WFr1ld0/HnP
	 zBITpqcmkrs7E3eUDCm4eniUQ+flBFpdvqzTKKjLK/jHfMOIgbb+y9ZVKgGJGJtaSL
	 z/EjyQ+DQPIDUOmfk4Lkl4CJcwruZtRQtP7k7vLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org,
	Arun Raghavan <arunr@valvesoftware.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/169] ALSA: usb: Increase volume range that triggers a warning
Date: Wed, 28 Jan 2026 16:22:33 +0100
Message-ID: <20260128145336.526246805@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Raghavan <arunr@valvesoftware.com>

[ Upstream commit 6b971191fcfc9e3c2c0143eea22534f1f48dbb62 ]

On at least the HyperX Cloud III, the range is 18944 (-18944 -> 0 in
steps of 1), so the original check for 255 steps is definitely obsolete.
Let's give ourselves a little more headroom before we emit a warning.

Fixes: 80acefff3bc7 ("ALSA: usb-audio - Add volume range check and warn if it too big")
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux-sound@vger.kernel.org
Signed-off-by: Arun Raghavan <arunr@valvesoftware.com>
Link: https://patch.msgid.link/20260116225804.3845935-1-arunr@valvesoftware.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 7307e29c60b75..577f9121971e8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1807,11 +1807,10 @@ static void __build_feature_ctl(struct usb_mixer_interface *mixer,
 
 	range = (cval->max - cval->min) / cval->res;
 	/*
-	 * Are there devices with volume range more than 255? I use a bit more
-	 * to be sure. 384 is a resolution magic number found on Logitech
-	 * devices. It will definitively catch all buggy Logitech devices.
+	 * There are definitely devices with a range of ~20,000, so let's be
+	 * conservative and allow for a bit more.
 	 */
-	if (range > 384) {
+	if (range > 65535) {
 		usb_audio_warn(mixer->chip,
 			       "Warning! Unlikely big volume range (=%u), cval->res is probably wrong.",
 			       range);
-- 
2.51.0



