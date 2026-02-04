Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A51C5D77;
	Wed,  4 Feb 2026 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216392; cv=none; b=aVdMG6J8DxVzvGdxzDU1ZyTLjL2LacQu3m6YNAKVIIsIv8bzGLLUtYbsBTpS7EowTrx+D2JuUljiBFl5xuxfQ5A3HTXTwNvppJC+xfyQgbt6JJmEsNBGQdedR+azretWaHAM+R1+4dw0et5JdQ+lDQ2NS94DkDKyg8jbbCxzXo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216392; c=relaxed/simple;
	bh=aLi24bvb0exwi/7BzgDyMdCEkLERUaD3zq9UNswit14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1mL9uAt2SveMiXAcAsF9bJiuZ7wYe70CyT4R7qsMpdmBPlhziGu7ykPuo6/xUilFSnMyB74Xviee/p1oQ1CfSC58ARgrPxNp5yGZ0EnAhD2bo8+v81MOAIf5s/5b38VL1c/oo4Gbln1mEo6GlOKeQqbPKytgOZ67CKWvA+hgfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXsgEmh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXsgEmh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E09C4CEF7;
	Wed,  4 Feb 2026 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216391;
	bh=aLi24bvb0exwi/7BzgDyMdCEkLERUaD3zq9UNswit14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXsgEmh36EbTx91XBrp+hxfo9MfcAnF21cdXGmzTtumXW3Bc5AmMmH4tjbh2r59WO
	 ondRU0gJZ77KsmkbNu4wnkFBvxJYYblaFSQeoKZ23XngXkfcPzatrKtsfmhv9PmOGo
	 ySdbLJf63b1bG2PzDu5eWJbf9qnWcE7xxR/KzAi8=
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
Subject: [PATCH 5.10 075/161] ALSA: usb: Increase volume range that triggers a warning
Date: Wed,  4 Feb 2026 15:38:58 +0100
Message-ID: <20260204143854.452265274@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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
index 949b171377267..b5baf9d609333 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1741,11 +1741,10 @@ static void __build_feature_ctl(struct usb_mixer_interface *mixer,
 
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



