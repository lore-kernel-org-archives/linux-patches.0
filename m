Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC2B3C1081;
	Tue, 21 Jul 2026 22:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671745; cv=none; b=sqkJwbZxqMMyuEaOZvMmnSCj17BFl1pEdnIX8ZgYVdyDHuzgHw5q18nlPW+Nn1WraJLLe4V1B13x5VgSu13xcHcEEXA2OFTmoz9nt1Ya5WEPRGDthfhB5QMUWEEUvD+g6Rlu0y6w65RqtjD/P2Fq5ZaStxxC4PboA7Xhp961Ljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671745; c=relaxed/simple;
	bh=4uBCGNWYBdlNVMNdnHVgbTFa9yQao9txD3/d4VqQotc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoAYPfFKEfMFCchLtWuF8FT9MFvLQhP522ZReiQnwMNCCm0d3s9B8a9I+2Y45lAKg2zfPxgsHjvqM7TtELMwDz84kIqqffKONtQM8imlFvd+jh2nKybCPtg5PIAdqolFNEDVcrhZxo2upO9piJEEvLlJUezElmRPsra30kErkbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKsPESyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKsPESyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B8A1F000E9;
	Tue, 21 Jul 2026 22:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671743;
	bh=lO4/EPIEF+5ilGDOM3APL242UwX7p779PbRglEHa9Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKsPESypjQWyXSP1fM8wO1r0mWCs9EkwUKmLAXajLQ5uIpucf3M7FWsy/YdIA1sRh
	 Dh2W+9UAIVbdKizVTbAW7CfLhfsxjspLRejqFW0MlbNns6sxFqBUNEt0Vwt0DYeSSC
	 mZzAZed+iZYyGb0JY1ED1LWPEVK4nIfh/uFPUEnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/843] ALSA: seq: Introduce SNDRV_SEQ_IOCTL_USER_PVERSION ioctl
Date: Tue, 21 Jul 2026 17:19:04 +0200
Message-ID: <20260721152412.976459258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index dbd60f48b4b011..742efdcdf7301e 100644
--- a/include/uapi/sound/asequencer.h
+++ b/include/uapi/sound/asequencer.h
@@ -577,6 +577,7 @@ struct snd_seq_query_subs {
 #define SNDRV_SEQ_IOCTL_CLIENT_ID	_IOR ('S', 0x01, int)
 #define SNDRV_SEQ_IOCTL_SYSTEM_INFO	_IOWR('S', 0x02, struct snd_seq_system_info)
 #define SNDRV_SEQ_IOCTL_RUNNING_MODE	_IOWR('S', 0x03, struct snd_seq_running_info)
+#define SNDRV_SEQ_IOCTL_USER_PVERSION	_IOW('S', 0x04, int)
 
 #define SNDRV_SEQ_IOCTL_GET_CLIENT_INFO	_IOWR('S', 0x10, struct snd_seq_client_info)
 #define SNDRV_SEQ_IOCTL_SET_CLIENT_INFO	_IOW ('S', 0x11, struct snd_seq_client_info)
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 2d707afa1ef1cd..21be1a2660a3a2 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1159,6 +1159,12 @@ static int snd_seq_ioctl_pversion(struct snd_seq_client *client, void *arg)
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
@@ -2086,6 +2092,7 @@ static const struct ioctl_handler {
 	int (*func)(struct snd_seq_client *client, void *arg);
 } ioctl_handlers[] = {
 	{ SNDRV_SEQ_IOCTL_PVERSION, snd_seq_ioctl_pversion },
+	{ SNDRV_SEQ_IOCTL_USER_PVERSION, snd_seq_ioctl_user_pversion },
 	{ SNDRV_SEQ_IOCTL_CLIENT_ID, snd_seq_ioctl_client_id },
 	{ SNDRV_SEQ_IOCTL_SYSTEM_INFO, snd_seq_ioctl_system_info },
 	{ SNDRV_SEQ_IOCTL_RUNNING_MODE, snd_seq_ioctl_running_mode },
@@ -2226,6 +2233,7 @@ int snd_seq_create_kernel_client(struct snd_card *card, int client_index,
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



