Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81C03C465;
	Tue, 30 Sep 2025 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243927; cv=none; b=IhHL4aKSCMBxICIg3Lb6JegaF9M1jbhgNm9RALAfRcbdpv5byjc9prq5IXGdk10wfcnDmPA152UxK69jfcvLVvu/oBCUm+QzFqi7nwzsw6/nmHZlxdoBoG/cnCRe4wicT5g3OwXZE6k31MmcIxMZ4OvRBLyRleXifvK+jySwl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243927; c=relaxed/simple;
	bh=8EDmuB6My/qyCCaUHqgKdgpiAWW1VQB839xUbU88MUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMSWqcH8ADW2bB3E1fi5urGQBV6K1MUHC9XTtVJXQ4lbSwClYdy5OvUfGVzrQxJzIPelCz9dyl0fLcoUboymCPTU9k/F8BNM+x93DOnXHjZBhzrEz9lYR2VhqhqaQB4GwAJNpaWxclC4Yy7rn7Ceis8IswEQwOr9RBm5gUbX0ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhvlVYQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhvlVYQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8F1C4CEF0;
	Tue, 30 Sep 2025 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243927;
	bh=8EDmuB6My/qyCCaUHqgKdgpiAWW1VQB839xUbU88MUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhvlVYQ9i7UefO22Q0Ak5Lgo6kSgT8nwXGQSmfMGhcsmIjlRN28+dvHh/fKkjRgVv
	 JHqCi+ixstm4ukx9iHhGOdea6WnNl2apV/yHAhNU1vPl/xjnnRORgLR3exMZuoqBn6
	 vW104wg/Q1ILXprUFLvG6/fpdVKH/pxZXxsVAuiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/81] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:46:59 +0200
Message-ID: <20250930143822.064397467@linuxfoundation.org>
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
index 22f483fee5f8c..f318b80d646d5 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -125,7 +125,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 				t->cmask, t->val_type, t->name, t->tlv_callback);
 		if (err < 0)
-- 
2.51.0



