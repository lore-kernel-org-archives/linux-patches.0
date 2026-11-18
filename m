Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019414;
	b=ZLcckcXZYBi0UEX/Q8hozDyxPGVEhEK5RNs+hZuxs/PlQSvzOb3De2yHQAKWwNYEkV4b
	 yrKps1FOEy4etVdBqP47J/pu0XiTPFME04vGCxnEQZzgFcS5Bltbc79+a88cYKzWQ+Xx8
	 0v82zFf+nG9BnyjTyD5ZCHE4ibns9xChr397jeiZq/LBQrH0un50Akr6FdLXSFuUfCNpR
	 JxZiVn2FT7OrGistJHYiMm85mcERFh+vTrYDjDmEng+bfBbvypeTHVVVyAZ+d6ZJ9YDMv
	 kVtduY6XOa9I52Yq5UUPSDFkWfRbdbCi9bbpKzeZmtPcq/VF4woecETkr61jKC58oeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i3DCjybJ/wKSXXLI2q5O+oYfHKaUFvI/96LoSzfiHuA=;
	b=FPvIw9m94ILq4WEVyC0voi/lSGe379cI4PtQYj947YDKVHBwwZlbZJ3YqwMRItImTPdv
	 WpZRoyJT4GcORIyi1yRyLDe6xPFyWRl/1HNZ6OzEgSVeE/AACHnlqvSvI8j5hCR4uDYN+
	 zYvCmGfVRSQxU6fR1BVw9lrdP76jYQpE8/D/M/qEhwFqk5V1NdkmV7EpO3HYJggasOHKc
	 rXxPvndn5lgPXu3hc8TVRAA+xCskO0cztKJpqfzysDsZayux9XLOKwgs951pzMRKkH4gK
	 HFtN+tjg6wqqI/jiu1zfmlArcPkyojwPT9rpaYGsPe2cLKKRLQVL+CwjyenZnMYBAhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1du4BPTT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC8A60A5BCB;
	Wed, 18 Nov 2026 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1du4BPTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452B31F00935;
	Wed, 18 Nov 2026 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019413;
	bh=i3DCjybJ/wKSXXLI2q5O+oYfHKaUFvI/96LoSzfiHuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1du4BPTTjd2BkYdXiIiiFg+riGNmO9234BO+NcJM1Smg+9i/XIdLUHN4c+/GR5tqg
	 HRguehk16Bd7h+DSKJkykgpZTeuos6qaAnRMmuCSTLapdpbvQHJoK0qEDXXZjeibnv
	 O0Zx11Ap52xQtPlekXvOwOB20XutyXMBpIyXXAuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1588/2651] ALSA: hda: Disable unsol event handling at error and shutdown paths
Date: Wed, 18 Nov 2026 15:47:08 +0100
Message-ID: <20261118150345.075569432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7a78c18bffc6e09016720681d791b799feb61783 ]

When the HD-audio controller driver probe fails, it still leaves the
unsolicited event handling and jackpoll work active, hence if they are
pending, they might fire up later after the resource gets released,
which may lead to a UAF.  A similar problem may be seen at shutdown,
too.

Add the recently added helper to disable unsol events and the cancel
of jackpoll_work at the appropriate places.  We need the workaround in
the error path before driver->ops->remove, too.  As unsol events and
jack polling may have been already enabled during the probe callback,
the driver->ops->remove call is done (more) conditionally now.

Fixes: c3ec8ac82105 ("ASoC: hdac_hda: fix memleak on module unload")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261009133341.440917-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/bind.c  | 8 ++++++--
 sound/hda/common/codec.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/hda/common/bind.c b/sound/hda/common/bind.c
index 4772ca154a290..d12359970e74d 100644
--- a/sound/hda/common/bind.c
+++ b/sound/hda/common/bind.c
@@ -89,6 +89,7 @@ static int hda_codec_driver_probe(struct device *dev)
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 	struct module *owner = dev->driver->owner;
 	struct hda_codec_driver *driver = hda_codec_to_driver(codec);
+	bool probed = false;
 	int err;
 
 	if (codec->bus->core.ext_ops) {
@@ -122,7 +123,8 @@ static int hda_codec_driver_probe(struct device *dev)
 
 	err = driver->ops->probe(codec, codec->preset);
 	if (err < 0)
-		goto error_module_put;
+		goto error_module;
+	probed = true;
 	err = snd_hda_codec_build_pcms(codec);
 	if (err < 0)
 		goto error_module;
@@ -141,7 +143,9 @@ static int hda_codec_driver_probe(struct device *dev)
 	return 0;
 
  error_module:
-	if (driver->ops->remove)
+	snd_hdac_device_disable_unsol(&codec->core);
+	cancel_delayed_work_sync(&codec->jackpoll_work);
+	if (probed && driver->ops->remove)
 		driver->ops->remove(codec);
  error_module_put:
 	module_put(owner);
diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 652df589759d4..5fc3b0344763d 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -3045,6 +3045,7 @@ void snd_hda_codec_shutdown(struct hda_codec *codec)
 
 	codec->jackpoll_interval = 0; /* don't poll any longer */
 	cancel_delayed_work_sync(&codec->jackpoll_work);
+	snd_hdac_device_disable_unsol(&codec->core);
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
 
-- 
2.53.0



