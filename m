Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625440;
	b=tu5EW3G9EaUMzEtgbBOPNF55cZo/iT2PUZ2/NUXSvoD4aE32czpmC04j2s6md8Ic7Egq
	 HHzreg4SluRdmcaTQniy0iU/+1y6qU60PuPuQRvP6eHhbW8/QwiqEkN+z6F0aIwo1ua7A
	 eLU+xi0op8RlXZR5AJSuUK6Q3sDbsopG7wJjJyxkr/6yrGiH8ca45tnsR4qistC0qkuSQ
	 NFf0u/hpmt36MhLd2WJUOIePS4DKXRgUdvH5AwDyaKSU0cmDirN3whfPo2lpPFhKBegvk
	 aVkSxIxdvflfO1Pn4wNM2vpDijnamGDwxLUAyIfmj7xkyUu5pKUqzKexPgZ9dF6bEMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4j/tFm68/NvqXxmeE1Wn0L9Yr6Oc7ClU8aFSUMf6/4c=;
	b=2nPIinj3FZ7Dn1KmWPB3U+PsJAyc9KgEyZdmH2IcpKEoXkWHlKFjnAeA1X8QL0UuG0f/
	 nLftDuCWpILHnpcrQQnuUb2SyLXA5cuWdhrjkp7Vu9wLqOwJNrYcJZu9z7naSgpzuzHwN
	 VzUsYqvE2hMAi/f6ILcUU3PEseuwSv6CMzf7iyM9ttMsZpqCG0AYUSI9BKLzDJRKMoQ6f
	 EbpjfIw49WhgCOpO7eYuRleWWt0uUiANWR/BDKXudqEcH2zuLXthD4qBbmHksI11wIoRM
	 LT/KqHjDFo4h4pDrPtHJ0VTIKlUXQ4JgJM9hwQIRu61s1VYGmmw43ETMe26pyyBilCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CqeQR/Ls";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2130A606A31E;
	Wed, 25 Nov 2026 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqeQR/Ls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A34B1F000C4;
	Wed, 25 Nov 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625439;
	bh=4j/tFm68/NvqXxmeE1Wn0L9Yr6Oc7ClU8aFSUMf6/4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqeQR/LsYHM54wfraPwP+drc1/QLC1cYxEYrvd3z9t3lOXqM72D2U4COktZjdWAtd
	 cKJCPdAz0Z2NwOZAUSKQekIQ7GYVaqsboHWIe57Inm7Sc5MsVWf57nvthGrbHsmHCQ
	 NLqGjIcaRcFdmDGqRH6kjM/3KcDZBTTfWfm+DvwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 472/816] ALSA: aloop: Avoid a bad mixure of guard() and goto
Date: Wed, 25 Nov 2026 15:33:40 +0100
Message-ID: <20261125143900.125691725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f7faf5d9b5668919cae84a6247f8f7b4e2c0227c ]

The rewrite of aloop driver code using guard() leaded to a mixture of
guard() and some goto; although it currently works, it isn't really a
good match.

For avoiding the bad match, just move the code using goto into a
function and wrap it with guard().

Fixes: ebd9b6c91d4e ("ALSA: aloop: Use guard() for mutex locks")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-6-tiwai@suse.de
[ sashal: Kept the local kzalloc(sizeof(*dpcm), GFP_KERNEL) call in place of upstream's kzalloc_obj(*dpcm) so the hunk applies; the rest matches upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index d7857659a7313..fa8d2877516d9 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1273,7 +1273,7 @@ static const struct loopback_ops loopback_snd_timer_ops = {
 	.dpcm_info = loopback_snd_timer_dpcm_info,
 };
 
-static int loopback_open(struct snd_pcm_substream *substream)
+static int __loopback_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct loopback *loopback = substream->private_data;
@@ -1282,7 +1282,6 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	int err = 0;
 	int dev = get_cable_index(substream);
 
-	guard(mutex)(&loopback->cable_lock);
 	dpcm = kzalloc(sizeof(*dpcm), GFP_KERNEL);
 	if (!dpcm)
 		return -ENOMEM;
@@ -1373,6 +1372,14 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	return err;
 }
 
+static int loopback_open(struct snd_pcm_substream *substream)
+{
+	struct loopback *loopback = substream->private_data;
+
+	guard(mutex)(&loopback->cable_lock);
+	return __loopback_open(substream);
+}
+
 static int loopback_close(struct snd_pcm_substream *substream)
 {
 	struct loopback *loopback = substream->private_data;
-- 
2.53.0



