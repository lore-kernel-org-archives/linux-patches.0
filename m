Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AD93FFAB5;
	Thu, 12 Mar 2026 20:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346339; cv=none; b=gC98rkoryAndtPRWHc3LDOkoN49waZX9v5h5vffepSU5A3EB64a1oLfDK5x9jISkW2MpfeXSEQgVolK4KLe/yRbTZmjPRETeBIhstO+490zFe7QtFXW0PcA6dpJ+bQCqBZa0NkzuOejZEHTLoq8Adfpz90OQRe9MCnCrAfO4Sw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346339; c=relaxed/simple;
	bh=NMrVFo42qYmNyGDKuav3KD0LbN5YDndae2OssNj/qPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXgKfLXCui0IJ2YQYAcCvKRYrPYqk0UZQoYCpJ59w83k6moYLntxGl7+qtJK5lw0aZH6oU7vaqdBlqeOYrxO/Y8Zf+s/Cu1gLLcyEPe9tkDaCGxjx63AgR9MfZyvJwlJcA2tATzkoy+m5f2qqF+HwkixGP5Sh63fsjLP1D1+6qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y9ejzRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y9ejzRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FD2C4CEF7;
	Thu, 12 Mar 2026 20:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346338;
	bh=NMrVFo42qYmNyGDKuav3KD0LbN5YDndae2OssNj/qPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y9ejzRm/Dpa9+kU2igBTpZfPVWj5zFW8SRVYVX1t2De8yiVO7rv7c7tQ/lr/hd4F
	 YIh40s5HZA4JBYe9eslW8WpIwnKLrA1ea2zh8HsBl4URu7f5uIFDP9JA5oLNOh+YMk
	 yIBbkNK3/emuueT3Uik7M+W1OJZAG1ttTK3+F54o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/265] ALSA: scarlett2: Fix redeclaration of loop variable
Date: Thu, 12 Mar 2026 21:06:36 +0100
Message-ID: <20260312201018.491424140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 5e7b782259fd396c7802948f5901bb2d769ddff8 ]

Was using both "for (i = 0, ..." and "for (int i = 0, ..." in
scarlett2_update_autogain(). Remove "int" to fix.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/ecb0a8931c1883abd6c0e335c63961653bef85f0.1727971672.git.g@b4.vu
Stable-dep-of: 1d241483368f ("ALSA: scarlett2: Fix DSP filter control array handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index f6292c4b8d214..8c7755fc1519f 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -3416,7 +3416,7 @@ static int scarlett2_update_autogain(struct usb_mixer_interface *mixer)
 				private->num_autogain_status_texts - 1;
 
 
-	for (int i = 0; i < SCARLETT2_AG_TARGET_COUNT; i++)
+	for (i = 0; i < SCARLETT2_AG_TARGET_COUNT; i++)
 		if (scarlett2_has_config_item(private,
 					      scarlett2_ag_target_configs[i])) {
 			err = scarlett2_usb_get_config(
@@ -3427,7 +3427,7 @@ static int scarlett2_update_autogain(struct usb_mixer_interface *mixer)
 		}
 
 	/* convert from negative dBFS as used by the device */
-	for (int i = 0; i < SCARLETT2_AG_TARGET_COUNT; i++)
+	for (i = 0; i < SCARLETT2_AG_TARGET_COUNT; i++)
 		private->ag_targets[i] = -ag_target_values[i];
 
 	return 0;
-- 
2.51.0



