Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7404D8CE;
	Tue, 30 Sep 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243958; cv=none; b=duIos/UNUcBp5SjhlsauTMVeHqujZj1yojNzJCKzIMrPwTOKVunJhfEKg3Si91cpPFNbc4O2hG+pZH37kV9jnH9+3yaspBWDPhYgoB77YHiU+4ohJC5GY2/tsp28d9PmgUbdhihjCmKrBX5eg7HhevJlnBPFB5GPr16arOYjUhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243958; c=relaxed/simple;
	bh=OIoKhL1Wzr9Sp1G6J6H01naF9G0gTZwt1/hws7VrXRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCQGDqe9DbLS1pC24afyKlyp++88zOgukDAx0CN6SIn1VZ6wiYb7k5EcngCKNnBQbCBcLRLSCRB77rO/K78I6UMHz0hGA+UdXjU3cWUusKWBCsQ46lWsRS5pZARZ8gMznMmNbmptALUCIq/gv/UmqorC5wEQEIvZJNB8vu57dKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de7StS3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de7StS3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5291BC4CEF0;
	Tue, 30 Sep 2025 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243957;
	bh=OIoKhL1Wzr9Sp1G6J6H01naF9G0gTZwt1/hws7VrXRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de7StS3yRbStwLJCWLE4OPClL280IonnGd/PBK80oGVrhC8jQ9IJBk7c8hOes8lsR
	 xPRosjnSuJm0ycDNwOSn6XpoNMH+9kxtD5DdiNaTW46/6oHczNJlhVUw0SgAwsf3Ch
	 +WvLdxmOnYk5iuFAsCz1FMIaUs2HVehaHjVCuing=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/81] ALSA: usb-audio: Convert comma to semicolon
Date: Tue, 30 Sep 2025 16:47:02 +0200
Message-ID: <20250930143822.191841587@linuxfoundation.org>
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
index cea1c970359c1..833f894a692c7 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -757,9 +757,9 @@ static int snd_dualsense_jack_create(struct usb_mixer_interface *mixer,
 
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



