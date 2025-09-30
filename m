Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82491F152D;
	Tue, 30 Sep 2025 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244492; cv=none; b=owQKWFih0OnziahjkmSH3+BmPo8VonIlk6jMg36VHmbF5K8C/enJGTq3+ciq3fnaAnUHtrA9yu8s7H7DfvYjxniQB+3+DnuVMLQk/ZMAOOw3VQ5zJP89igV79txRPgexEZ3M24oTS4aDWAviCcgjqFBhd1UDNPHBg83jElg98q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244492; c=relaxed/simple;
	bh=C2/p7bATVKeqGQCYu32hYJQlRN2U/SaMZVLeTnsszMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJrMR3Fcc2BNVBJJx8tVKAx/DlQHKUcHEW3eD4I7xTHjIJF0scp8LXemkU/mVpNAHOYNTEdOS4cmUM02eDRNloH6DuCEuZ4hqCGtgGnlReCIXgs1kMPEvJ0U8gVdnRfmcISyY1pKPFMK4QMmGgSR18BZZUQsemVIRLXgs7QuudU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snzBpEu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snzBpEu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F99CC4CEF0;
	Tue, 30 Sep 2025 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244492;
	bh=C2/p7bATVKeqGQCYu32hYJQlRN2U/SaMZVLeTnsszMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snzBpEu337IP6fFck/g2oghw7+eim8Uz0l3KTyQFI+m61+C60j1WvlqMSJ9PIokTf
	 91MZxMgSBl2vlBT7QH5uaaHBFEi6Ifg3t6mp8VC8zxotcLQ/GvhvvYJU6J7APNYy6y
	 owDsHtDjjVrZbD7VsGc45NyzQgtxnGQGfiQg/VDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 008/143] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:45:32 +0200
Message-ID: <20250930143831.577354010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 741a70d0816cc..dab6d461cf8cd 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -129,7 +129,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 					      t->cmask, t->val_type, t->name,
 					      t->tlv_callback);
-- 
2.51.0



