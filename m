Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ED87E0E9;
	Wed,  7 Aug 2024 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043643; cv=none; b=KJCovvaaVHGs1hGJB0XAzHkeCYaJAV8TPPyl+kJSwsyvITxXCVWpVLPD+mXxxAOQcnYOe17nyCP26XyH6jxohmgVUXu4nqzH2wBCQAOqpSJj4ku4eoSleeJnfHQs3wy6kOgUjcP0gTR551nG3+SG+nTFfIP8PvQyFujjKE7KIYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043643; c=relaxed/simple;
	bh=GeKQ7qap2W8ZbXk/k9VXe3K6gPHFZUKTlE4kGdYrkr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxTpdYs6kX+wZ8PR1dJm7pfHgzpD2f08cNz+2nZDrT+jzCJhtIqwbO+8qkNfbxGjywMsJVKzQzTiIYNPSRsgJ68YE9twTf7cMglPGfFki+6EcieVFPY4EZ1o5THazLMjNB7epd6oUUQ6HoQqjVaOHKa+K48ro98UMl9OzeKJSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQ9eoF+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQ9eoF+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8C0C32781;
	Wed,  7 Aug 2024 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043642;
	bh=GeKQ7qap2W8ZbXk/k9VXe3K6gPHFZUKTlE4kGdYrkr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQ9eoF+sJQ0adZsBtFJQ2YRt8IL04rJUwzwxAs4aARRCHxp9XnUJ1D9K6/QyyDI2C
	 SOYGp2mUjlgY9/JxtqFPvwOwz7aeoQzZlcEYZ15HH0SeV0wGiQJ62ggcdg7r0WQrhh
	 myanV5PA5zl1kXKLkbqNi+13j8xmxE4I3hJ/MYso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 45/86] ALSA: hda: conexant: Reduce CONFIG_PM dependencies
Date: Wed,  7 Aug 2024 17:00:24 +0200
Message-ID: <20240807150040.723894959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 29d57f6dc62485ee0752767debdfa2783d162beb ]

CONFIG_PM dependencies got reduced in HD-audio codec core driver, and
now it's time to reduce in HD-audio conexant codec driver, too.

Simply drop CONFIG_PM ifdefs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240506161359.6960-8-tiwai@suse.de
Stable-dep-of: e60dc9812211 ("ALSA: hda: conexant: Fix headset auto detect fail in the polling mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index e8209178d87bb..17389a3801bd1 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -294,13 +294,11 @@ static void cx_jack_unsol_event(struct hda_codec *codec, unsigned int res)
 	snd_hda_jack_unsol_event(codec, res);
 }
 
-#ifdef CONFIG_PM
 static int cx_auto_suspend(struct hda_codec *codec)
 {
 	cx_auto_shutdown(codec);
 	return 0;
 }
-#endif
 
 static const struct hda_codec_ops cx_auto_patch_ops = {
 	.build_controls = snd_hda_gen_build_controls,
@@ -308,10 +306,8 @@ static const struct hda_codec_ops cx_auto_patch_ops = {
 	.init = cx_auto_init,
 	.free = cx_auto_free,
 	.unsol_event = cx_jack_unsol_event,
-#ifdef CONFIG_PM
 	.suspend = cx_auto_suspend,
 	.check_power_status = snd_hda_gen_check_power_status,
-#endif
 };
 
 /*
-- 
2.43.0



