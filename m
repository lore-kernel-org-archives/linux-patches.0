Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7979644AB60;
	Tue, 21 Jul 2026 21:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669006; cv=none; b=Fv7MxCK1yOVn7/05uRcxnpWeQY24WP44n09reTwOulPRH7Jl9FOhSxx63poBQRfqwQSiarXwH2qCNnVmbZph3U9bvMLmbcE1+P6OHFWiJPG3bZNuKQZ73yOLP+p8aZZklr30qy99Hz5UyWLmwH1nnp3pONLepyE7LgivzOV0dzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669006; c=relaxed/simple;
	bh=ed5e+o4KG0LpyfnekHbhP60sJF23SqgmIMJgWerBitk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVlAU/iXo5BEV8LPyw9RYqum1lSl5Gc3r4P+OkUup18EmWDWCXuQGA5MhUaeZJnVSSRszUg+TQou35kferipAVAvP4Z79RlYDQUGvO+Mt4lk3dUR/a6xBuLXsstrfMQU6pMtpgbRAKlP1A4d+ELaUQAPCyFPsyraZ0BKMLAaxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acXipjoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acXipjoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E048D1F000E9;
	Tue, 21 Jul 2026 21:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669005;
	bh=ik8hsMuqLhkY7qTsi2K249FauP9Cn/5+gHRDTHn9dAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acXipjoPNTiHcVXkbrIQWhub5SMLlIzbbuFlR4qupg3csUQGcLBD2OX8nZVhrLo0F
	 aUbmQGgS7YfMe0p4yAhZjozH8htfpFSiGtNha3ywfV+3mZdage5O2SZ8jpvUJ/C6JP
	 I/3GAfJl3wwsZtSw4spG3kWeoiVzB2w+V6Df4Or8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0392/1067] ALSA: seq: Introduce SNDRV_SEQ_IOCTL_USER_PVERSION ioctl
Date: Tue, 21 Jul 2026 17:16:33 +0200
Message-ID: <20260721152433.400532928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit afb72505e4614a2ccefe3440d37dec3a2273c330 ]

For the future extension of ALSA sequencer ABI, introduce a new ioctl
SNDRV_SEQ_IOCTL_USER_PVERSION.  This is similar like the ioctls used
in PCM and other interfaces, for an application to specify its
supporting ABI version.

The use of this ioctl will be mandatory for the upcoming UMP support.

Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230523075358.9672-25-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 705dd6dcbc0e ("ALSA: seq: Clear variable event pointer on read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/sound/asequencer.h | 1 +
 sound/core/seq/seq_clientmgr.c  | 8 ++++++++
 sound/core/seq/seq_clientmgr.h  | 1 +
 sound/core/seq/seq_compat.c     | 1 +
 4 files changed, 11 insertions(+)

diff --git a/include/uapi/sound/asequencer.h b/include/uapi/sound/asequencer.h
index 00d2703e8fca5e..4a3c5a718baeb4 100644
--- a/include/uapi/sound/asequencer.h
+++ b/include/uapi/sound/asequencer.h
@@ -561,6 +561,7 @@ struct snd_seq_query_subs {
 #define SNDRV_SEQ_IOCTL_CLIENT_ID	_IOR ('S', 0x01, int)
 #define SNDRV_SEQ_IOCTL_SYSTEM_INFO	_IOWR('S', 0x02, struct snd_seq_system_info)
 #define SNDRV_SEQ_IOCTL_RUNNING_MODE	_IOWR('S', 0x03, struct snd_seq_running_info)
+#define SNDRV_SEQ_IOCTL_USER_PVERSION	_IOW('S', 0x04, int)
 
 #define SNDRV_SEQ_IOCTL_GET_CLIENT_INFO	_IOWR('S', 0x10, struct snd_seq_client_info)
 #define SNDRV_SEQ_IOCTL_SET_CLIENT_INFO	_IOW ('S', 0x11, struct snd_seq_client_info)
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 1252ea7ad55eab..00c798b83d4fa8 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1158,6 +1158,12 @@ static int snd_seq_ioctl_pversion(struct snd_seq_client *client, void *arg)
 	return 0;
 }
 
+static int snd_seq_ioctl_user_pversion(struct snd_seq_client *client, void *arg)
+{
+	client->user_pversion = *(unsigned int *)arg;
+	return 0;
+}
+
 static int snd_seq_ioctl_client_id(struct snd_seq_client *client, void *arg)
 {
 	int *client_id = arg;
@@ -2085,6 +2091,7 @@ static const struct ioctl_handler {
 	int (*func)(struct snd_seq_client *client, void *arg);
 } ioctl_handlers[] = {
 	{ SNDRV_SEQ_IOCTL_PVERSION, snd_seq_ioctl_pversion },
+	{ SNDRV_SEQ_IOCTL_USER_PVERSION, snd_seq_ioctl_user_pversion },
 	{ SNDRV_SEQ_IOCTL_CLIENT_ID, snd_seq_ioctl_client_id },
 	{ SNDRV_SEQ_IOCTL_SYSTEM_INFO, snd_seq_ioctl_system_info },
 	{ SNDRV_SEQ_IOCTL_RUNNING_MODE, snd_seq_ioctl_running_mode },
@@ -2225,6 +2232,7 @@ int snd_seq_create_kernel_client(struct snd_card *card, int client_index,
 	client->accept_input = 1;
 	client->accept_output = 1;
 	client->data.kernel.card = card;
+	client->user_pversion = SNDRV_SEQ_VERSION;
 		
 	va_start(args, name_fmt);
 	vsnprintf(client->name, sizeof(client->name), name_fmt, args);
diff --git a/sound/core/seq/seq_clientmgr.h b/sound/core/seq/seq_clientmgr.h
index 8cdd0ee53fb1f6..31b988785ca23c 100644
--- a/sound/core/seq/seq_clientmgr.h
+++ b/sound/core/seq/seq_clientmgr.h
@@ -35,6 +35,7 @@ struct snd_seq_client {
 	snd_seq_client_type_t type;
 	unsigned int accept_input: 1,
 		accept_output: 1;
+	unsigned int user_pversion;
 	char name[64];		/* client name */
 	int number;		/* client number */
 	unsigned int filter;	/* filter flags */
diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index 54723566ce2428..c0ce6236dc7f1d 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -81,6 +81,7 @@ static long snd_seq_ioctl_compat(struct file *file, unsigned int cmd, unsigned l
 
 	switch (cmd) {
 	case SNDRV_SEQ_IOCTL_PVERSION:
+	case SNDRV_SEQ_IOCTL_USER_PVERSION:
 	case SNDRV_SEQ_IOCTL_CLIENT_ID:
 	case SNDRV_SEQ_IOCTL_SYSTEM_INFO:
 	case SNDRV_SEQ_IOCTL_GET_CLIENT_INFO:
-- 
2.53.0



