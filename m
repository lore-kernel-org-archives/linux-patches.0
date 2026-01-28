Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E462D2D5940;
	Wed, 28 Jan 2026 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614522; cv=none; b=S4ecKBrm3cD3GBNhhMHDrB/XkHpEYLn0QfiycmubrHO9P0D8RlTPjsk5LIjmaipJTiKnB00GIn7RIuXNGZilY+UtBhWIwvGfaRx8tpetai9TAiq+9DbymBq9HHxa3eQCYGefDTcVkNx1Hwwsg06gdt5PgF4QnG256DARjiGDdiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614522; c=relaxed/simple;
	bh=onOsSlSzCYqKxpdjenGCjHwyhwk3xeMjVCTkp15QW2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qczp77H3IhT2eK7zTiEgocKZLhdAbyxW7V0dS5u8wQBHTIocdIPTjzUEDD8tBX0YaWVLJ5GFa/EwkwoSVrCLjTwQpkcD5byZ0WByxqGn2Qyxcd1AiVm1BNuJtiZh1l8f2lnvITtsBBj6JTzT8RmkK5sEnJRvIwJaMukQkh/kwjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhXpK5dh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhXpK5dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E28C4CEF1;
	Wed, 28 Jan 2026 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614521;
	bh=onOsSlSzCYqKxpdjenGCjHwyhwk3xeMjVCTkp15QW2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhXpK5dhVmNACo95pbHNpkUUFebBNIFFde1gsFoed2+IGXyRqTgrv8k7P0WvX7EpP
	 qBDWmrcKhdHK5L/C/PR8V9yWGtlHSv74aRONGkIYkI/CLhN00gdmz2LI2CEmjNM/2L
	 2QL1os+vIjjgUKomX1Pf3bl0OUVT8mX0/5apy05Q=
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
Subject: [PATCH 6.6 162/254] ALSA: usb: Increase volume range that triggers a warning
Date: Wed, 28 Jan 2026 16:22:18 +0100
Message-ID: <20260128145350.639653226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e19d962fab870..76aac42c3c805 100644
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



