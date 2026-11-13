Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591331;
	b=BCXa6hofeNRciX6OM/DBA2zuqa/kMxqiFIRtki3cB1ppYgIJ4gowg6Pbp1pvKncYU5YJ
	 W/tn8fTipJ7XoMVMHmIIwC1RFrZ6slMLsk4A3InPqMx7SYxhkFfG6JHuKwYAjE+gaovGo
	 hua538K5XKPPOpcGHTiuWdqJOSXaAee5k/NNhfvMWoaDzC1UBKYdM2rRKIbBUJXfUTEg2
	 rbqItx7HbPrpTtenqdbwuqnfY3TH3QvgdgzDK99/+1hhWcnldwqUql3gt59vCbsrK+Dy9
	 q4qC4dyyM0tSFGr0Pu7qNeJMacgGmWjW2C4mMdlICNxBkRFLWAi5MKAjk0B58V1u5gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/jRQCPfavg32Gmldmhjj2KMYhZNGkADmIBj/27JxhbQ=;
	b=jhn2r56qHurCuecz6chOqEHaW03HzFc+yynFThcsgg/IcUEc22SHgJnW2QeyolAFBAru
	 mI7jpIad3NQxlH/jS4Cib0vNHVOB5UdEFUPLcmHdWQNSHKyF/nJF9+EUxuuDzhK6e0Ja0
	 DW1ehAeSVCNJeKLdH1P9NJHTNYGLLqzpjw6Gb5P/Wm/6/tLHX01sBmKZL/oIGk+UfNJfv
	 KnUND++Z/uKKAw+h/8FRskYHNi4X4c+C9hx1TUZrn6WNu+OWK4X9qLPH0ccUjlgCsc7zr
	 qDGUZzQdgR8DtW84WdUocGcXxfBCxurZv3b/AwE6bfbpSqnVDg6/xEFPNrtkabxg01Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnQ9OyFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ED860A6F77;
	Fri, 13 Nov 2026 17:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnQ9OyFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ADC1F000C6;
	Fri, 13 Nov 2026 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591331;
	bh=/jRQCPfavg32Gmldmhjj2KMYhZNGkADmIBj/27JxhbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnQ9OyFzqjaYlQxxR/fWbj9ybEyYZXdo1QcSZaDOq4GuldLnHmFr7Bojjdzj+C1tP
	 5+LN2vFZg3Pu+iwNyfvnOE9YrXwTuMA0mbZ68WO7bLN/kAtJkf1N2+P/P3Qp3jdvbg
	 W76Mx24eaLHiS6H3MmyTFTisO5fBmUXZyiHbS4GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 443/670] ALSA: timer: Handle userspace-driven timer ioctls from 32-bit tasks
Date: Fri, 13 Nov 2026 10:50:07 -0500
Message-ID: <20261113153826.934709011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 1bbc033983b76f41d51d4a48838bf94c5e6b6f50 ]

32-bit tasks on a 64-bit kernel can't use userspace-driven timers. The
compat handler for /dev/snd/timer doesn't list SNDRV_TIMER_IOCTL_CREATE,
so creating a timer fails with -ENOTTY. The file returned for a timer
has no .compat_ioctl either, so SNDRV_TIMER_IOCTL_TRIGGER fails with
-ENOTTY too.

struct snd_timer_uinfo has the same layout for 32-bit and 64-bit tasks,
and SNDRV_TIMER_IOCTL_TRIGGER takes no argument, so both commands can
be passed through unchanged.

The utimer selftest doesn't catch this when built with -m32: it takes
-ENOTTY from SNDRV_TIMER_IOCTL_CREATE to mean CONFIG_SND_UTIMER=n and
skips.

Fixes: 37745918e0e7 ("ALSA: timer: Introduce virtual userspace-driven timers")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260928182352.309457-1-danishkhateeb03@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c        | 1 +
 sound/core/timer_compat.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 688a2d1257485..8f84055d3e53f 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -2104,6 +2104,7 @@ static const struct file_operations snd_utimer_fops = {
 	.llseek		=	noop_llseek,
 	.release	=	snd_utimer_release,
 	.unlocked_ioctl	=	snd_utimer_ioctl,
+	.compat_ioctl	=	snd_utimer_ioctl,
 };
 
 static int snd_utimer_start(struct snd_timer *t)
diff --git a/sound/core/timer_compat.c b/sound/core/timer_compat.c
index 4ae9eaeb5afb1..7b648edcb9cba 100644
--- a/sound/core/timer_compat.c
+++ b/sound/core/timer_compat.c
@@ -98,6 +98,7 @@ static long __snd_timer_user_ioctl_compat(struct file *file, unsigned int cmd,
 	case SNDRV_TIMER_IOCTL_PAUSE:
 	case SNDRV_TIMER_IOCTL_PAUSE_OLD:
 	case SNDRV_TIMER_IOCTL_NEXT_DEVICE:
+	case SNDRV_TIMER_IOCTL_CREATE:
 		return __snd_timer_user_ioctl(file, cmd, (unsigned long)argp, true);
 	case SNDRV_TIMER_IOCTL_GPARAMS32:
 		return snd_timer_user_gparams_compat(file, argp);
-- 
2.53.0



