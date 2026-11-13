Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590575;
	b=BOZqLH0G9yp5CPh4KKVmjVXCndtXqLIpWAvW4l6mvhG4XhzThgcYHOZS8EpmCOXoHCaT
	 GaleF4aegf3jDy1+GIwUNrxJYged5YYyYoV3vGmcCD4evuawEiDG2inXocoOoiKgTUH5Y
	 Sdpu6iwSUUA0FiLmYeBL7ahw21Z7q+SMISq6TCSymT5AsxQeMhHD78eWE/cF0KeRC+geR
	 BZjZg5XpDAupQXJhWhnuY2ehZg1xjH4bUQxKiSC6auneBMFQUoht39d0TlWilZoguVpmz
	 jssrKIVYE7aWTpYSkl1/y82teAfgc7d5mFq3MzklEbs1MRqtcMXkjEpWOJ8Wl3BaIoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYoEeR4Omfzqns25HlnuRIkbHCmQNzvGk6Wl8AH9Hqc=;
	b=wYdb5PzGxrughtjyjBAEPhonA9RkWHNSQ3Dxbqu36A7hb7Aoc/GPoNOQ+eEEc9ElbKdB
	 27O4sV7RHntRlv6oo5Py6mIwcKbbTH4JkGC6aUl+4QC02XVSjUJbHaAemFJfaQq1mlaxJ
	 aL3oCM98tuEYCpjz1GVcQsBi2YxkDFjHmtK2/xNcs7K3AMGIB65Q9SZ7Wk4gu2Pq3qFMR
	 wuCRMiH+v5jywQ14xJe/ksUW64AuVqlN7TMF4wZ2EuG4ALJGb/iz+uYkUYkdQUGZh4ptK
	 D5Fy3fEePY/jT2gSEbAFtx4D8gHWxN6HnADdZAx4YZfdAFNqSkM9opMCqFInnATLMeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXpjLk6j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A178606BD3E;
	Fri, 13 Nov 2026 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXpjLk6j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3625F1F000C4;
	Fri, 13 Nov 2026 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590575;
	bh=PYoEeR4Omfzqns25HlnuRIkbHCmQNzvGk6Wl8AH9Hqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXpjLk6jOSRQq7cjMTmdEzii3AXAzY8LLjhCU9P/8wHmUpl+IcNoHut+UT5eSQNVJ
	 Rh/epns9nnjOlwK2UEGmO89Seoj/w8zVyFuX5VYBys28QPJKscRTxnz0C+hUGTPHx/
	 KUwZV8A1ICkZGs4uSuIp+sH3h78qKeg07fhnAAE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 506/686] ALSA: timer: Handle userspace-driven timer ioctls from 32-bit tasks
Date: Fri, 13 Nov 2026 10:50:39 -0500
Message-ID: <20261113153838.046494491@linuxfoundation.org>
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
index 9838cc6636427..64bffc21295d4 100644
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



