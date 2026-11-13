Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590574;
	b=rKfLLydlks3QwJqOGdHBikXDOrtI1skVAJrI9f9OosndEuVkvMi8Meb/IoeWC4zNNleP
	 OzKLNRTXBtGUnof+HAEJWMV7O2k6iZLc/w37xkepy0lW4OXCHHBRJNlnAV6YJVT8XQYj3
	 uRl/F6Le5/6V0ZaDYYDky35x2+VmleNxO8wIhWSyZFHS33k9TPSKWnADr9n/YhCtW4GcU
	 t4IrO1OgKlh5xIB9ExfMsARlLYd+ZjflcV+wZcLmjaoP2yXt2mHYwuawqQYoP8e11Cmi9
	 CwbYMageNU8Wik6BSdvkTqZDIHtZ/xH92DQKFyiEM/eu3w5DuFU/beAY4Ab+gUUu86g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oeQXtbcI5sIjxy+t1FQrFbYTh0+0Y0hbnRX6uZCJGnQ=;
	b=FwpO4r5EE/lwXMlOlYVWSVirWAFmdELpbgbsoMf0vBlfgGoZSun6q6YAHpxYtBtVz/Wj
	 ybdETFDuUg9tw9L9KhByRaH7MKg8oW3eDPE1bH8HErbEt9nkIXnSugpCZMreOn14E3xKo
	 +5hSaSwSIboaP65s5bNz3DF9rOYO9lvu2V72naP2Xq7nBSuhsYD0fIPVYuyOF1oIiPKdb
	 BslKIylfA2wmlvmOLu09SrHJqOxwli98ieLo9Yom2yTJE6VnqwNUTNy2+l/m8+fq9NfkN
	 fegogWw59LxyVo6iuIC3T1me8pXzl3+xBQGnbaZdjLAzNEkgLovS00UzNdHbwic3/UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pru3K/En";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4A606BD38;
	Fri, 13 Nov 2026 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pru3K/En
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AAC1F000C4;
	Fri, 13 Nov 2026 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590574;
	bh=oeQXtbcI5sIjxy+t1FQrFbYTh0+0Y0hbnRX6uZCJGnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pru3K/EnAxzlwTwRYH5Mf/dV9oYSeQqZETgPWmwCHtTya2Vd5d9xd2Auo3ijcOfeN
	 HcIM1vR5jIS55qT9ryeRY9zQF93R/d16dL9wa8BGNXyBwmgewdNUZ7Uud1WU7JEhiM
	 AkytPXUOTLyLbSjIspkxWSjYMO54tRXMj6tZ865U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/686] ALSA: core: Clean up file_operations definitions
Date: Fri, 13 Nov 2026 10:50:38 -0500
Message-ID: <20261113153838.015110756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 307835a6eb50e548e58ee604bf91909d4faa4203 ]

Align file_operations initializers with tabs to match the standard
kernel coding style and improve readability.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260708140624.562403-1-phucduc.bui@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 1bbc033983b7 ("ALSA: timer: Handle userspace-driven timer ioctls from 32-bit tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c  | 18 +++++++-------
 sound/core/control.c           | 19 +++++++--------
 sound/core/hwdep.c             | 23 +++++++++---------
 sound/core/init.c              | 23 +++++++++---------
 sound/core/jack.c              | 38 ++++++++++++++---------------
 sound/core/oss/mixer_oss.c     | 13 +++++-----
 sound/core/oss/pcm_oss.c       | 21 ++++++++--------
 sound/core/pcm_native.c        | 44 +++++++++++++++++-----------------
 sound/core/rawmidi.c           | 16 ++++++-------
 sound/core/seq/oss/seq_oss.c   | 21 ++++++++--------
 sound/core/seq/seq_clientmgr.c | 19 +++++++--------
 sound/core/sound.c             |  9 ++++---
 sound/core/timer.c             | 25 ++++++++++---------
 13 files changed, 140 insertions(+), 149 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index e1b2da84f7782..b965eabf96844 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1399,17 +1399,17 @@ static long snd_compr_ioctl_compat(struct file *file, unsigned int cmd,
 #endif
 
 static const struct file_operations snd_compr_file_ops = {
-		.owner =	THIS_MODULE,
-		.open =		snd_compr_open,
-		.release =	snd_compr_free,
-		.write =	snd_compr_write,
-		.read =		snd_compr_read,
-		.unlocked_ioctl = snd_compr_ioctl,
+		.owner		=	THIS_MODULE,
+		.open		=	snd_compr_open,
+		.release	=	snd_compr_free,
+		.write		=	snd_compr_write,
+		.read		=	snd_compr_read,
+		.unlocked_ioctl	=	snd_compr_ioctl,
 #ifdef CONFIG_COMPAT
-		.compat_ioctl = snd_compr_ioctl_compat,
+		.compat_ioctl	=	snd_compr_ioctl_compat,
 #endif
-		.mmap =		snd_compr_mmap,
-		.poll =		snd_compr_poll,
+		.mmap		=	snd_compr_mmap,
+		.poll		=	snd_compr_poll,
 };
 
 static int snd_compress_dev_register(struct snd_device *device)
diff --git a/sound/core/control.c b/sound/core/control.c
index 1d13352afed2b..750bb3f52d26d 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -2269,16 +2269,15 @@ EXPORT_SYMBOL_GPL(snd_ctl_disconnect_layer);
  *  INIT PART
  */
 
-static const struct file_operations snd_ctl_f_ops =
-{
-	.owner =	THIS_MODULE,
-	.read =		snd_ctl_read,
-	.open =		snd_ctl_open,
-	.release =	snd_ctl_release,
-	.poll =		snd_ctl_poll,
-	.unlocked_ioctl =	snd_ctl_ioctl,
-	.compat_ioctl =	snd_ctl_ioctl_compat,
-	.fasync =	snd_ctl_fasync,
+static const struct file_operations snd_ctl_f_ops = {
+	.owner		=	THIS_MODULE,
+	.read		=	snd_ctl_read,
+	.open		=	snd_ctl_open,
+	.release	=	snd_ctl_release,
+	.poll		=	snd_ctl_poll,
+	.unlocked_ioctl	=	snd_ctl_ioctl,
+	.compat_ioctl	=	snd_ctl_ioctl_compat,
+	.fasync		=	snd_ctl_fasync,
 };
 
 /* call lops under rwsems; called from snd_ctl_dev_*() below() */
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 10a32004398ff..4334162bc0b22 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -324,18 +324,17 @@ static int snd_hwdep_control_ioctl(struct snd_card *card,
 
  */
 
-static const struct file_operations snd_hwdep_f_ops =
-{
-	.owner = 	THIS_MODULE,
-	.llseek =	snd_hwdep_llseek,
-	.read = 	snd_hwdep_read,
-	.write =	snd_hwdep_write,
-	.open =		snd_hwdep_open,
-	.release =	snd_hwdep_release,
-	.poll =		snd_hwdep_poll,
-	.unlocked_ioctl =	snd_hwdep_ioctl,
-	.compat_ioctl =	snd_hwdep_ioctl_compat,
-	.mmap =		snd_hwdep_mmap,
+static const struct file_operations snd_hwdep_f_ops = {
+	.owner		=	THIS_MODULE,
+	.llseek		=	snd_hwdep_llseek,
+	.read		=	snd_hwdep_read,
+	.write		=	snd_hwdep_write,
+	.open		=	snd_hwdep_open,
+	.release	=	snd_hwdep_release,
+	.poll		=	snd_hwdep_poll,
+	.unlocked_ioctl	=	snd_hwdep_ioctl,
+	.compat_ioctl	=	snd_hwdep_ioctl_compat,
+	.mmap		=	snd_hwdep_mmap,
 };
 
 static void snd_hwdep_free(struct snd_hwdep *hwdep)
diff --git a/sound/core/init.c b/sound/core/init.c
index 2bf98de846f61..779729738b128 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -461,20 +461,19 @@ static int snd_disconnect_fasync(int fd, struct file *file, int on)
 	return -ENODEV;
 }
 
-static const struct file_operations snd_shutdown_f_ops =
-{
-	.owner = 	THIS_MODULE,
-	.llseek =	snd_disconnect_llseek,
-	.read = 	snd_disconnect_read,
-	.write =	snd_disconnect_write,
-	.release =	snd_disconnect_release,
-	.poll =		snd_disconnect_poll,
-	.unlocked_ioctl = snd_disconnect_ioctl,
+static const struct file_operations snd_shutdown_f_ops = {
+	.owner		=	THIS_MODULE,
+	.llseek		=	snd_disconnect_llseek,
+	.read		=	snd_disconnect_read,
+	.write		=	snd_disconnect_write,
+	.release	=	snd_disconnect_release,
+	.poll		=	snd_disconnect_poll,
+	.unlocked_ioctl	=	snd_disconnect_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = snd_disconnect_ioctl,
+	.compat_ioctl	=	snd_disconnect_ioctl,
 #endif
-	.mmap =		snd_disconnect_mmap,
-	.fasync =	snd_disconnect_fasync
+	.mmap		=	snd_disconnect_mmap,
+	.fasync		=	snd_disconnect_fasync
 };
 
 /**
diff --git a/sound/core/jack.c b/sound/core/jack.c
index 93e357a23f171..71607d904e061 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -306,41 +306,41 @@ static ssize_t jack_type_read(struct file *file,
 }
 
 static const struct file_operations jack_type_fops = {
-	.open = simple_open,
-	.read = jack_type_read,
-	.llseek = default_llseek,
+	.open	=	simple_open,
+	.read	=	jack_type_read,
+	.llseek	=	default_llseek,
 };
 #endif
 
 static const struct file_operations sw_inject_enable_fops = {
-	.open = simple_open,
-	.read = sw_inject_enable_read,
-	.write = sw_inject_enable_write,
-	.llseek = default_llseek,
+	.open	=	simple_open,
+	.read	=	sw_inject_enable_read,
+	.write	=	sw_inject_enable_write,
+	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jackin_inject_fops = {
-	.open = simple_open,
-	.write = jackin_inject_write,
-	.llseek = default_llseek,
+	.open	=	simple_open,
+	.write	=	jackin_inject_write,
+	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jack_kctl_id_fops = {
-	.open = simple_open,
-	.read = jack_kctl_id_read,
-	.llseek = default_llseek,
+	.open	=	simple_open,
+	.read	=	jack_kctl_id_read,
+	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jack_kctl_mask_bits_fops = {
-	.open = simple_open,
-	.read = jack_kctl_mask_bits_read,
-	.llseek = default_llseek,
+	.open	=	simple_open,
+	.read	=	jack_kctl_mask_bits_read,
+	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jack_kctl_status_fops = {
-	.open = simple_open,
-	.read = jack_kctl_status_read,
-	.llseek = default_llseek,
+	.open	=	simple_open,
+	.read	=	jack_kctl_status_read,
+	.llseek	=	default_llseek,
 };
 
 static int snd_jack_debugfs_add_inject_node(struct snd_jack *jack,
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index aa98caaaea3c5..a7d66ea7c795d 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -407,13 +407,12 @@ static long snd_mixer_oss_ioctl_compat(struct file *file, unsigned int cmd,
  *  REGISTRATION PART
  */
 
-static const struct file_operations snd_mixer_oss_f_ops =
-{
-	.owner =	THIS_MODULE,
-	.open =		snd_mixer_oss_open,
-	.release =	snd_mixer_oss_release,
-	.unlocked_ioctl =	snd_mixer_oss_ioctl,
-	.compat_ioctl =	snd_mixer_oss_ioctl_compat,
+static const struct file_operations snd_mixer_oss_f_ops = {
+	.owner		=	THIS_MODULE,
+	.open		=	snd_mixer_oss_open,
+	.release	=	snd_mixer_oss_release,
+	.unlocked_ioctl	=	snd_mixer_oss_ioctl,
+	.compat_ioctl	=	snd_mixer_oss_ioctl_compat,
 };
 
 /*
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 59d5153d11132..6d49451b730cd 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -3120,17 +3120,16 @@ static inline void snd_pcm_oss_proc_done(struct snd_pcm *pcm)
  *  ENTRY functions
  */
 
-static const struct file_operations snd_pcm_oss_f_reg =
-{
-	.owner =	THIS_MODULE,
-	.read =		snd_pcm_oss_read,
-	.write =	snd_pcm_oss_write,
-	.open =		snd_pcm_oss_open,
-	.release =	snd_pcm_oss_release,
-	.poll =		snd_pcm_oss_poll,
-	.unlocked_ioctl =	snd_pcm_oss_ioctl,
-	.compat_ioctl =	snd_pcm_oss_ioctl_compat,
-	.mmap =		snd_pcm_oss_mmap,
+static const struct file_operations snd_pcm_oss_f_reg = {
+	.owner		=	THIS_MODULE,
+	.read		=	snd_pcm_oss_read,
+	.write		=	snd_pcm_oss_write,
+	.open		=	snd_pcm_oss_open,
+	.release	=	snd_pcm_oss_release,
+	.poll		=	snd_pcm_oss_poll,
+	.unlocked_ioctl	=	snd_pcm_oss_ioctl,
+	.compat_ioctl	=	snd_pcm_oss_ioctl_compat,
+	.mmap		=	snd_pcm_oss_mmap,
 };
 
 static void register_oss_dsp(struct snd_pcm *pcm, int index)
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 304b7e4965e3f..553fad5300e10 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -4228,29 +4228,29 @@ static unsigned long snd_pcm_get_unmapped_area(struct file *file,
 
 const struct file_operations snd_pcm_f_ops[2] = {
 	{
-		.owner =		THIS_MODULE,
-		.write =		snd_pcm_write,
-		.write_iter =		snd_pcm_writev,
-		.open =			snd_pcm_playback_open,
-		.release =		snd_pcm_release,
-		.poll =			snd_pcm_poll,
-		.unlocked_ioctl =	snd_pcm_ioctl,
-		.compat_ioctl = 	snd_pcm_ioctl_compat,
-		.mmap =			snd_pcm_mmap,
-		.fasync =		snd_pcm_fasync,
-		.get_unmapped_area =	snd_pcm_get_unmapped_area,
+		.owner			=	THIS_MODULE,
+		.write			=	snd_pcm_write,
+		.write_iter		=	snd_pcm_writev,
+		.open			=	snd_pcm_playback_open,
+		.release		=	snd_pcm_release,
+		.poll			=	snd_pcm_poll,
+		.unlocked_ioctl		=	snd_pcm_ioctl,
+		.compat_ioctl		=	snd_pcm_ioctl_compat,
+		.mmap			=	snd_pcm_mmap,
+		.fasync			=	snd_pcm_fasync,
+		.get_unmapped_area	=	snd_pcm_get_unmapped_area,
 	},
 	{
-		.owner =		THIS_MODULE,
-		.read =			snd_pcm_read,
-		.read_iter =		snd_pcm_readv,
-		.open =			snd_pcm_capture_open,
-		.release =		snd_pcm_release,
-		.poll =			snd_pcm_poll,
-		.unlocked_ioctl =	snd_pcm_ioctl,
-		.compat_ioctl = 	snd_pcm_ioctl_compat,
-		.mmap =			snd_pcm_mmap,
-		.fasync =		snd_pcm_fasync,
-		.get_unmapped_area =	snd_pcm_get_unmapped_area,
+		.owner			=	THIS_MODULE,
+		.read			=	snd_pcm_read,
+		.read_iter		=	snd_pcm_readv,
+		.open			=	snd_pcm_capture_open,
+		.release		=	snd_pcm_release,
+		.poll			=	snd_pcm_poll,
+		.unlocked_ioctl		=	snd_pcm_ioctl,
+		.compat_ioctl		=	snd_pcm_ioctl_compat,
+		.mmap			=	snd_pcm_mmap,
+		.fasync			=	snd_pcm_fasync,
+		.get_unmapped_area	=	snd_pcm_get_unmapped_area,
 	}
 };
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 7508d99c1e441..63c8978c98750 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1784,14 +1784,14 @@ static void snd_rawmidi_proc_info_read(struct snd_info_entry *entry,
  */
 
 static const struct file_operations snd_rawmidi_f_ops = {
-	.owner =	THIS_MODULE,
-	.read =		snd_rawmidi_read,
-	.write =	snd_rawmidi_write,
-	.open =		snd_rawmidi_open,
-	.release =	snd_rawmidi_release,
-	.poll =		snd_rawmidi_poll,
-	.unlocked_ioctl =	snd_rawmidi_ioctl,
-	.compat_ioctl =	snd_rawmidi_ioctl_compat,
+	.owner		=	THIS_MODULE,
+	.read		=	snd_rawmidi_read,
+	.write		=	snd_rawmidi_write,
+	.open		=	snd_rawmidi_open,
+	.release	=	snd_rawmidi_release,
+	.poll		=	snd_rawmidi_poll,
+	.unlocked_ioctl	=	snd_rawmidi_ioctl,
+	.compat_ioctl	=	snd_rawmidi_ioctl_compat,
 };
 
 static int snd_rawmidi_alloc_substreams(struct snd_rawmidi *rmidi,
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index 02d30d8b6c3a8..4ecb43b6ad3ba 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -206,17 +206,16 @@ odev_poll(struct file *file, poll_table * wait)
  * registration of sequencer minor device
  */
 
-static const struct file_operations seq_oss_f_ops =
-{
-	.owner =	THIS_MODULE,
-	.read =		odev_read,
-	.write =	odev_write,
-	.open =		odev_open,
-	.release =	odev_release,
-	.poll =		odev_poll,
-	.unlocked_ioctl =	odev_ioctl,
-	.compat_ioctl =	odev_ioctl_compat,
-	.llseek =	noop_llseek,
+static const struct file_operations seq_oss_f_ops = {
+	.owner		=	THIS_MODULE,
+	.read		=	odev_read,
+	.write		=	odev_write,
+	.open		=	odev_open,
+	.release	=	odev_release,
+	.poll		=	odev_poll,
+	.unlocked_ioctl	=	odev_ioctl,
+	.compat_ioctl	=	odev_ioctl_compat,
+	.llseek		=	noop_llseek,
 };
 
 static int __init
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index e73c1becb6e15..9a92a37602586 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2661,16 +2661,15 @@ void snd_seq_info_clients_read(struct snd_info_entry *entry,
  *  REGISTRATION PART
  */
 
-static const struct file_operations snd_seq_f_ops =
-{
-	.owner =	THIS_MODULE,
-	.read =		snd_seq_read,
-	.write =	snd_seq_write,
-	.open =		snd_seq_open,
-	.release =	snd_seq_release,
-	.poll =		snd_seq_poll,
-	.unlocked_ioctl =	snd_seq_ioctl,
-	.compat_ioctl =	snd_seq_ioctl_compat,
+static const struct file_operations snd_seq_f_ops = {
+	.owner		=	THIS_MODULE,
+	.read		=	snd_seq_read,
+	.write		=	snd_seq_write,
+	.open		=	snd_seq_open,
+	.release	=	snd_seq_release,
+	.poll		=	snd_seq_poll,
+	.unlocked_ioctl	=	snd_seq_ioctl,
+	.compat_ioctl	=	snd_seq_ioctl_compat,
 };
 
 static struct device *seq_dev;
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 7980b60f4ba0b..5ce042db47559 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -167,11 +167,10 @@ static int snd_open(struct inode *inode, struct file *file)
 	return err;
 }
 
-static const struct file_operations snd_fops =
-{
-	.owner =	THIS_MODULE,
-	.open =		snd_open,
-	.llseek =	noop_llseek,
+static const struct file_operations snd_fops = {
+	.owner	=	THIS_MODULE,
+	.open	=	snd_open,
+	.llseek	=	noop_llseek,
 };
 
 #ifdef CONFIG_SND_DYNAMIC_MINORS
diff --git a/sound/core/timer.c b/sound/core/timer.c
index c5f0e895ea024..9838cc6636427 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -2101,9 +2101,9 @@ static long snd_utimer_ioctl(struct file *file, unsigned int ioctl, unsigned lon
 }
 
 static const struct file_operations snd_utimer_fops = {
-	.llseek = noop_llseek,
-	.release = snd_utimer_release,
-	.unlocked_ioctl = snd_utimer_ioctl,
+	.llseek		=	noop_llseek,
+	.release	=	snd_utimer_release,
+	.unlocked_ioctl	=	snd_utimer_ioctl,
 };
 
 static int snd_utimer_start(struct snd_timer *t)
@@ -2455,16 +2455,15 @@ static __poll_t snd_timer_user_poll(struct file *file, poll_table * wait)
 #define snd_timer_user_ioctl_compat	NULL
 #endif
 
-static const struct file_operations snd_timer_f_ops =
-{
-	.owner =	THIS_MODULE,
-	.read =		snd_timer_user_read,
-	.open =		snd_timer_user_open,
-	.release =	snd_timer_user_release,
-	.poll =		snd_timer_user_poll,
-	.unlocked_ioctl =	snd_timer_user_ioctl,
-	.compat_ioctl =	snd_timer_user_ioctl_compat,
-	.fasync = 	snd_timer_user_fasync,
+static const struct file_operations snd_timer_f_ops = {
+	.owner		=	THIS_MODULE,
+	.read		=	snd_timer_user_read,
+	.open		=	snd_timer_user_open,
+	.release	=	snd_timer_user_release,
+	.poll		=	snd_timer_user_poll,
+	.unlocked_ioctl	=	snd_timer_user_ioctl,
+	.compat_ioctl	=	snd_timer_user_ioctl_compat,
+	.fasync		=	snd_timer_user_fasync,
 };
 
 /* unregister the system timer */
-- 
2.53.0



