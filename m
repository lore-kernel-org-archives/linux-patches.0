Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585449;
	b=TQtgIbM7JlI0cU0lsVt/dIC+PYzCivVVZ3+f0MHQZn0ymdjFFDgEpi9Wvfe5Mcwjsgqm
	 4pnFk9e2y4O1VOjyfu3N8sPmQsiPqYE1imev5abWy1OHRDWEMVtsGN8n5gcY7wgdpDZgB
	 vsETs9KDB8ylGjy5eUF9vTYkhEkN8Zk+yxGFQBYl6Enf+UhShqS0GYf5F9tArghudY4lJ
	 7UektUpd/HMrk3xrZQsNqK4p/8mMLpCWgHlkDn1E/b+BRSKPN+J1kLn5oIHe2RpiEtxh8
	 oE+zf5ner+B2wLxDuzBV6ABg3FUM4v8xXQhsP11+JvACZmlw4WFc1YCU8aKU7+GiKVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSokjVsuY+oSsYXksgHXroNmlNoU9snP6fihdO4HBHI=;
	b=rMXCDYpezUyseqoOlmBIaOhbDhAXX3e+FkJ5cV+TJ12R8sCxmHuAxf2YIygJa/7EnvEN
	 hneVKk9cwTwmEQLO8g+BrNYyMjCZW5YxQ70Lh4eEua8CvysZRsQwRrC2A6LEWDoCxq4RU
	 nzQGbVYLLq4NHT+kzMal8fsdOLXYdgA2ysNbBdIrUTOHEmJT6VTtvmrPOas/f3a8BCXF5
	 ftimaKpwEIZtLB5IRXnYAau5Az2HI+WasDlIjdmvRHRrkUZYj+bB3Wbk20PgJevLKwT1X
	 zBkiNYzG3Kspj88Bf5yjKXCgYLNogqF8SKSmylBKmJWbofy15ke4e0vn1S4hEiSh8nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dznY9efs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9D4606A8AF;
	Fri, 13 Nov 2026 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dznY9efs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F471F000C4;
	Fri, 13 Nov 2026 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585449;
	bh=pSokjVsuY+oSsYXksgHXroNmlNoU9snP6fihdO4HBHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dznY9efsGuM+RacyIOp6AXjDGy+WDS1TvL4aJcuGXGhf6mp8Nj76p+LJ918PzUc5k
	 Lvji5h0ll22xh28Uy5NQ3EQWTbrcosIBNpXcl5qAafqhnRte8MFPWcjlmeye2+6gI+
	 26b+EvHTIJXU70A/X4e9HmzqFJTWvtqUi+sHGZ7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 109/507] ALSA: hwdep: Serialize DSP load requests
Date: Fri, 13 Nov 2026 10:46:53 -0500
Message-ID: <20261113153758.017413507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit aee83c204f80d56b4d55f53acdb8594308ddcd4a ]

The check of the loaded DSP indices and the call of the driver's
dsp_load callback in snd_hwdep_dsp_load() are not serialized.  A hwdep
file descriptor can be shared among threads, or inherited across fork,
so two SNDRV_HWDEP_IOCTL_DSP_LOAD requests for the same index can both
observe the index as unloaded and enter the driver's callback
concurrently, even though the device itself is opened exclusively.

This breaks the assumption behind hw->dsp_loaded that a firmware index
is loaded only once.  For example, snd-usb-usx2y hits
WARN_ON(usx2y->as04.buffer) in usx2y_async_seq04_init() and may
allocate the US-428 sequence URBs twice.

Serialize the check, the callback invocation and the bookkeeping with a
per-hwdep mutex, so that the second request returns -EBUSY.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261029084810.21910-2-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hwdep.h | 1 +
 sound/core/hwdep.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/sound/hwdep.h b/include/sound/hwdep.h
index b0da633184cde..7357727f06603 100644
--- a/include/sound/hwdep.h
+++ b/include/sound/hwdep.h
@@ -57,6 +57,7 @@ struct snd_hwdep {
 
 	struct mutex open_mutex;
 	int used;			/* reference counter */
+	struct mutex dsp_mutex;		/* serializes DSP load requests */
 	unsigned int dsp_loaded;	/* bit fields of loaded dsp indices */
 	unsigned int exclusive:1;	/* exclusive access mode */
 };
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index c6de5345e946f..fb9034897c561 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -212,6 +212,7 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 		return -ENXIO;
 	if (info->index >= 32)
 		return -EINVAL;
+	guard(mutex)(&hw->dsp_mutex);
 	/* check whether the dsp was already loaded */
 	if (hw->dsp_loaded & (1u << info->index))
 		return -EBUSY;
@@ -380,6 +381,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 
 	init_waitqueue_head(&hwdep->open_wait);
 	mutex_init(&hwdep->open_mutex);
+	mutex_init(&hwdep->dsp_mutex);
 	hwdep->card = card;
 	hwdep->device = device;
 	if (id)
-- 
2.53.0



