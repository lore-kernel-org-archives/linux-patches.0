Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC0D18027;
	Wed, 28 Jan 2026 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615725; cv=none; b=LOyydilSMVtLBPcau1mFAw7hLOZYmUE9RPw4sz+3Dv8Dq7a5g1+bLAQPSFHrW1GncBFbAb1kdkEPiH7VIlFPZAVpqRNurBR/Ryuq+lbwj//W1re/m4tYS7OwQK6iFCXlXWRoRJ3+xT5IYnYPXLvUdqAaIqssL/pJjPAgCmgDWWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615725; c=relaxed/simple;
	bh=CW5XAGuyNaTriiS7ewU/iwEJftRKMCW4eis1iSon0CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjtF03UDpbc8f9ChZN5rTk3rxkKvUxs7uupLcWu9SqNAIzxXiL8+KaL9dysdYF23VNoYoPjwZggMm/6reEZBth1LafRaqq0KuD4WoTXO5/C9xKYpfPyh8MZsCBmuliWSmCPnYGxBVj+0ZB2OzE9arzC/UqQX7yiGj2VIqS2UOL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy04dQfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy04dQfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BCAC116C6;
	Wed, 28 Jan 2026 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615725;
	bh=CW5XAGuyNaTriiS7ewU/iwEJftRKMCW4eis1iSon0CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vy04dQfCRVwPFs9kd8bPm8n1TjtI0oiMObDDVl7XzgAACJQ/t6xrsTw+RlT8/yeih
	 80+rcWOkbCqj+4Q98166owlRlNsIp4aCntBDTzsJ56HVfZ6iqRJlGLOhmE1bvQDsoq
	 piA4T6d2hh6fJtzSNBZnAvi0CTG+0LBsT/k7XQ5g=
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
Subject: [PATCH 6.18 094/227] ALSA: usb: Increase volume range that triggers a warning
Date: Wed, 28 Jan 2026 16:22:19 +0100
Message-ID: <20260128145347.716376141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3af71d42b9b9a..90917c6ea871b 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1813,11 +1813,10 @@ static void __build_feature_ctl(struct usb_mixer_interface *mixer,
 
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



