Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19C32F6167;
	Tue, 30 Sep 2025 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245241; cv=none; b=oFNQBEAIO5fRjpcyhiimSiE4yBjpDfulWBdTe8X4Sv+rzHKrSxIe7i8Ma8kbkof5m5CnaK2/apJ+gY/3XvgVRJVBCAfU298LcK2TXf9vaH69xaEyAZv9SAje1mnJ6ijG4xbMa4pA1H1z/vEUT0fGVWrwDLXRPCzLg47mdh3VJh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245241; c=relaxed/simple;
	bh=ifh2GDAFRzFbMBcYABecW//abb3Zbe/yIh+oDJTZHYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XciHsGWciZIbHsScX1Ws9jqgxdzMUDKlLf8nwq6XYUeCRZ1e/RSLxP4Bf2CeZYSRRlDu/RXtWLDB6ijj/Qd2FbhlZE1PRAha6Wf3LciSMPF+6QD43eR4O0VASfNso4QM0pY0qjTEvZ+s0dPFMZfIV6g+VvXaugNBDxeF6Wpu3mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omRTxCKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omRTxCKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D37C4CEF0;
	Tue, 30 Sep 2025 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245241;
	bh=ifh2GDAFRzFbMBcYABecW//abb3Zbe/yIh+oDJTZHYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omRTxCKu5mvpSWpET4U4FHvFwpqBpwgDL67niGDtFRl0YOLHPYDky+la4WqhvDdum
	 lDRlJqnMRUTyrVpY6cYc/kZxp4HdI3UV7ZIw8ko9f4+bcLB2yK/Zx2UhPzSEdlwp7I
	 NHq3svw911tU6ie0vdZFELHjKOfJe6qyzkybbPYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/151] ALSA: usb-audio: Convert comma to semicolon
Date: Tue, 30 Sep 2025 16:47:19 +0200
Message-ID: <20250930143831.950698943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 9ca30a1b007d5fefb5752428f852a2d8d7219c1c ]

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Fixes: 79d561c4ec04 ("ALSA: usb-audio: Add mixer quirk for Sony DualSense PS5")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20250612060228.1518028-1-nichen@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index fc62ad4c8ef11..9b59d90ab8ca5 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -758,9 +758,9 @@ static int snd_dualsense_jack_create(struct usb_mixer_interface *mixer,
 
 	mei->ih.event = snd_dualsense_ih_event;
 	mei->ih.match = snd_dualsense_ih_match;
-	mei->ih.connect = snd_dualsense_ih_connect,
-	mei->ih.disconnect = snd_dualsense_ih_disconnect,
-	mei->ih.start = snd_dualsense_ih_start,
+	mei->ih.connect = snd_dualsense_ih_connect;
+	mei->ih.disconnect = snd_dualsense_ih_disconnect;
+	mei->ih.start = snd_dualsense_ih_start;
 	mei->ih.name = name;
 	mei->ih.id_table = mei->id_table;
 
-- 
2.51.0



