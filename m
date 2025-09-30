Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEB22FD1DD;
	Tue, 30 Sep 2025 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245232; cv=none; b=FXhjkK9KHMUGYOBai2lsz6h0NJt5OhV8JNdoPialz6kx4MRM5oLm+z6lH0LmuxCkrfEmDvqIjDVtUt3xaV7xETiX18Y0EsquEdRY0UMYF6P7DujHWecMcn6G4eMyzHy3Ol9YSkpk7mqA1pdLiOmwbQD/vNl6WuceQ2T8P13xrSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245232; c=relaxed/simple;
	bh=uG8CNH6Jw2cL13/XqRGbIfTX70EtUR0Tpt5Bvln4E4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz4HiVdWTLtpfaqb5l54gEdQnWYkWy7spM3+YHXcFhDTa/QjIQ0ctPsKrGaFoSfqnpuTtBsODF0jSWs1aDcWzJsN+/LLNor51JB2shrJgSrbHklH20YKbKRUnkLLs5+91nFjz9V40nPDFuk07Q5KWTyaSOSJ8A5ZOimHZbVHUWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zA+cOwAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA+cOwAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DC5C4CEF0;
	Tue, 30 Sep 2025 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245232;
	bh=uG8CNH6Jw2cL13/XqRGbIfTX70EtUR0Tpt5Bvln4E4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zA+cOwADSFWCwZQcbQiaZ570OJ5p6NWB8YhNdrzWEDaeEF/4A5lsF/KXFKbWE2Oqz
	 XxJEKm1MVyWMYkRVAFsin8ma8ovzkjEFIkfn2jKSvWs/G9/+gRI5ZiBrrtuNIMrxjN
	 sFRgIOskzP8F01JZ9NTFaVxjuRFbKSCpfjxjQFhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/151] ALSA: usb-audio: Simplify NULL comparison in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:16 +0200
Message-ID: <20250930143831.828915519@linuxfoundation.org>
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
index 4ab57ef56330d..3156bb50f9ff6 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -126,7 +126,7 @@ static int snd_create_std_mono_table(struct usb_mixer_interface *mixer,
 {
 	int err;
 
-	while (t->name != NULL) {
+	while (t->name) {
 		err = snd_create_std_mono_ctl(mixer, t->unitid, t->control,
 				t->cmask, t->val_type, t->name, t->tlv_callback);
 		if (err < 0)
-- 
2.51.0



