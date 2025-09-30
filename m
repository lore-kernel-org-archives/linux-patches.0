Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC62032D;
	Tue, 30 Sep 2025 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246046; cv=none; b=JZcT2rCvH6kkxlGY0WLKt5i8A51w8J1McLlObnt8pwVSgwwxOlDqiCGTIRIlUC4bjES/5mIEWkqMwNE+I0YCnyQFSt1iRHcaKOePbGA79XUEW4z6bfK1RJrP+2dlxs0P0VKM845j4iK+7qhMDGQS3q+sjtfmUBpsNZJtetSlPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246046; c=relaxed/simple;
	bh=zMOk3HSg7uo/B5ZsUJgYtzLQDUIptdZVQJanx9qw5I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghAVugE97uIMlbW5ypFcx5pQ5QDl9RsPOnc3xwT7s5rbRHZEG46AOx1flY8rSGfzc7AVOJ6fH4XiHVi+0Y/bpps3T2+oVIJjhubEjMPsZM5dAurL3IkzwMMPDmnnkU3GjXkz64TCgMg2x3XlsaSnr8yrPHsAaExOfkf35zf/yMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL7UIkih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL7UIkih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EC3C4CEF0;
	Tue, 30 Sep 2025 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246046;
	bh=zMOk3HSg7uo/B5ZsUJgYtzLQDUIptdZVQJanx9qw5I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL7UIkihwL2Hui54x9s3kYrdNnORO1i6KBoWJGNfhjHCcX7wOGzY7RiMBfiTjgYbp
	 3DbS0GqyYeZDEJFA1IEv+ZuWBbNGV3Ltdyunah+yZ75yITeuOuSPeYzJeViFOxYAI1
	 /BluGZa9UjdvlSYC6vDAtl7aCid7/o3GKOhowJ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 07/89] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:21 +0200
Message-ID: <20250930143822.168097894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
index 1eae6e83d0259..3bd2daba8ecac 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -128,7 +128,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 					      t->cmask, t->val_type, t->name,
 					      t->tlv_callback);
-- 
2.51.0



