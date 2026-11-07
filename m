Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064257;
	b=vjXUwNnOp4Yy/9iKJqd3x863ZhL6e6GPFZTnNh1/qlVbHFfF1sKtdIzF9MmEs7ygbZf9
	 8E6CAGqniordKjSinK3ozsmTaZtbKzDzpfYiroW16NABwQ2IvUcDP3CMVb6HyxtJwKNbI
	 uzg2TAvtpi+klpdQ/VPHx8yCa3lRLB1py1XuNIsIHhOFhJxf7L4TpcjPEaJELm4LlhHPU
	 ii3rIu33MRgTd7CiaZzoy0qAj//ulKgotVdki4Twntn3+AQ6eQAgw2AzlzJNjBonkAdWx
	 +9TL0MyQSdWVuOeKuk/+2lzKAK+gnM8T5mQw5h1pL6fQqL7vdCYiTHI5Mvq56KBod4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmuYrfW/VFYpLhOGY+XGpumNGw6dALiVX+7hX3THNSI=;
	b=wnL2vG7EYosoqBpdghQn1L6nZgArWRv3VAbwJkeU0gkloxuWSRHj8KtDNwYAzBtpSA+1
	 RBmUz2NwcoxpL9APuQBR145SkJsggbWTYuut2ocXw6rFfWStGwp7S14mMvHK62ykKbbYD
	 TUC5SwM8HZWkLv7mmm6CCRMsj9fUMmvxZaQappohhyD8pK41SJiHwGZ7bQ4thD1NvEE2H
	 4TYzruO/qE4uSeHA0Cm0tsQ4SCsDpSm5nAtVYnizTZIbJxeT6F2QHEQMU8s+lch209imn
	 KnWMhjm2NTZtYx1FJ/DZdpoVe4BuU14uSknLl2ndAIiOjRBoPNURS70du0EYeTNMUfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHhr5rdx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A98606A334;
	Sat,  7 Nov 2026 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHhr5rdx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766401F0089F;
	Sat,  7 Nov 2026 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064256;
	bh=gmuYrfW/VFYpLhOGY+XGpumNGw6dALiVX+7hX3THNSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHhr5rdx/bVB2Ew1zQZa0+iky8je+IimKyTa7QNIfi1qmnY8TRC1/kA9KNbRZ8s+G
	 u5rhetvJbNqh2EWyld9rSEbeaRiuv9Qlmr33sAb0+7Ii0TEyXFDpMnvmmV6YkTI/8m
	 MZuLaJy3R9ddHsNgRl79FhWQh3Krm9oVAc62e8W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0357/1257] ALSA: timer: Handle userspace-driven timer ioctls from 32-bit tasks
Date: Sat,  7 Nov 2026 08:44:13 -0500
Message-ID: <20261107134949.242902652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 679b264356709..69a59b25fe0a8 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -2176,6 +2176,7 @@ static const struct file_operations snd_utimer_fops = {
 	.llseek		=	noop_llseek,
 	.release	=	snd_utimer_release,
 	.unlocked_ioctl	=	snd_utimer_ioctl,
+	.compat_ioctl	=	snd_utimer_ioctl,
 };
 
 static int snd_utimer_start(struct snd_timer *t)
diff --git a/sound/core/timer_compat.c b/sound/core/timer_compat.c
index 25ee81c1668b7..5bab00466de7f 100644
--- a/sound/core/timer_compat.c
+++ b/sound/core/timer_compat.c
@@ -99,6 +99,7 @@ static long __snd_timer_user_ioctl_compat(struct file *file, unsigned int cmd,
 	case SNDRV_TIMER_IOCTL_PAUSE:
 	case SNDRV_TIMER_IOCTL_PAUSE_OLD:
 	case SNDRV_TIMER_IOCTL_NEXT_DEVICE:
+	case SNDRV_TIMER_IOCTL_CREATE:
 		return __snd_timer_user_ioctl(file, cmd, (unsigned long)argp, true);
 	case SNDRV_TIMER_IOCTL_GPARAMS32:
 		return snd_timer_user_gparams_compat(file, argp);
-- 
2.53.0



