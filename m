Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056355;
	b=kxc0sZQGVJeSTLUQtZ9E1oOwiWbGzJ+oj5ibIyVGkAeyG1AOZFVMraGxC2GNNqvr6bQf
	 9rGmAD8A8JCrNnNwaby8fMVaiJvExntnkLSemdL8nkXx1Fbg6pTEShkS259IKLFTzMFP9
	 R1+kDr79UJtu4tdiKYvT5DZsXdT258iOLhk0WEFEcVUxRWQp6zKrMlJEp+bA3y++IkjIL
	 yQLTi8kzEgAnRD39eH/o6KxJqKiihijLSZ2kDFG0A5Z0m6QxLvY4m0YbGLZcyYlnMjK0y
	 86NwgGNykdFoxhIrgz2YLD+8xxmLc1ZJ3zrVcAmYzYmNJQkf4dL//sxeaM7nQy2ODXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8mKdMAywH/Yp3sVUOj/FTthbzBClJVQBqSg+ir0RQFU=;
	b=2Aij+1Q1GEEVofr3b2dTw5tbytWBbsNG8fD4RiO8fYXoDi6MZtTwTrQuEONQRFAjWAEs
	 pJI3T0iLTrgdQIhxW6MGfFWhZbOIXgWvkhK+1sGGiUpS9V2OZIngdFkUmY37vBB/hhDTy
	 vH1aWrwFe0fvoX2QumkEFqlkA7p+GZpztzYJIWhyXLjZbiqu/i1YopEr2Sf9hjXsfkTb7
	 IP3uDN/iW6Kitd8UAJ44vi9mV91qGGAPHG78H956rNb4WJHLG/ENOHiGUu6Z2Lc7jDpSb
	 fZaL9uUnmta00k/U9AExHRTJZA3BLdn6nW1+rB4Tn0x+hmkwfZZ5jCfSyahLWcCF6ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q0JFJDiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2745A606A320;
	Thu, 19 Nov 2026 02:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q0JFJDiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C551F000C4;
	Thu, 19 Nov 2026 02:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056354;
	bh=8mKdMAywH/Yp3sVUOj/FTthbzBClJVQBqSg+ir0RQFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0JFJDiByY3DCQVquFm0FzCH4+35w/xZO6X0KF3iMMqgtas686dihgtOgvLKXEi12
	 nqh/mR1EInO1t/N+1AB41HbxfCWsrv+z9DE5YfEssdxxXt9Na5PR+/FC0/nHkfCp22
	 cegeFNY0c+VdzyHZwcHK4vl3TycGGR0zllwwbznA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com,
	syzbot+669c9abf11a6a011dd09@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1959/2214] ALSA: pcm: Use deferred fasync helper
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150129.327778863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 96b097091c66df4f6fbf5cbff21df6cc02a2f055 ]

For avoiding the potential deadlock via kill_fasync() call, use the
new fasync helpers to defer the invocation from timer API.  Note that
it's merely a workaround.

Reported-by: syzbot+8285e973a41b5aa68902@syzkaller.appspotmail.com
Reported-by: syzbot+669c9abf11a6a011dd09@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20220728125945.29533-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 91d0048a97e0 ("ALSA: pcm: Add refcount for races between drain and unlink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/pcm.h     | 2 +-
 sound/core/pcm.c        | 1 +
 sound/core/pcm_lib.c    | 2 +-
 sound/core/pcm_native.c | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index c827527b0e1fc..9a4cd00b3e221 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -398,7 +398,7 @@ struct snd_pcm_runtime {
 	snd_pcm_uframes_t twake; 	/* do transfer (!poll) wakeup if non-zero */
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	bool stop_operating;		/* sync_stop will be called */
 	struct mutex buffer_mutex;	/* protect for buffer changes */
 	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 8bad50bf00e13..927974a7bcf70 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1008,6 +1008,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 		substream->runtime = NULL;
 	}
 	mutex_destroy(&runtime->buffer_mutex);
+	snd_fasync_free(runtime->fasync);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 38671c4737f51..e9d9624209acc 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1821,7 +1821,7 @@ void snd_pcm_period_elapsed_under_stream_lock(struct snd_pcm_substream *substrea
 		snd_timer_interrupt(substream->timer, 1);
 #endif
  _end:
-	kill_fasync(&runtime->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(runtime->fasync, SIGIO, POLL_IN);
 }
 EXPORT_SYMBOL(snd_pcm_period_elapsed_under_stream_lock);
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 757f5c4c25a25..3a792defc3998 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -4007,7 +4007,7 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
 	runtime = substream->runtime;
 	if (runtime->state == SNDRV_PCM_STATE_DISCONNECTED)
 		return -EBADFD;
-	return fasync_helper(fd, file, on, &runtime->fasync);
+	return snd_fasync_helper(fd, file, on, &runtime->fasync);
 }
 
 /*
-- 
2.53.0



