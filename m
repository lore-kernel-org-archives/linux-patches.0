Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063522;
	b=sact1lf8337g97utQx/Q1IiPAtSfXmVhJQecTlsyKdBj4OhDswwKlUyANmi9Exmvl6D5
	 5c9B/MNgZQN3OcWcAj0FWzQaqC002X+u2s0BJ0WX6XZFz/JylMUvAQKR44nznr6aHLyrv
	 XpsBjhAjKvWUYsltShbfN/i+7gryHLJI0JJ9TscHtAKEFDiNJK+HbKb2RO6S9lKEpXES6
	 ULTTzaBlj7tyDFA6xaGI4DYATom2rviPPjDd9oFkAzDJJTsD4Vmr9BzV4qnEBbsYjmahi
	 dlmMAXjO6KMF2EySfR1dnSmtcbWuceelFIZ58QaEVK5hCo5ezH1hgltDWDXiHYOmrFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98MCnAT0OxoGWPyrPpwR3BP6O7P21/eDMFc1CLygows=;
	b=QCxiA+F1ze9WpPP79WO/4Beslw3Wtns1Er00CctMpJ8XSrYozLX4XANKNN61Gh6G9jU7
	 fOlbYIJ2A0SElMFhYOACUGUxzcWZa7C5EIXziQh94kW75sWIahsluUvmPD5vDWxcKA1xA
	 h2h6Kd6a64EZo/vY0PLs8EM+kEBnWaX1AbimnMSxdxA5Pf0/2KP3E8JoS6vALvaRbsPZh
	 x1+ufx3EWe7vyr3p/0I7Dal4Na3fEJImmQxDg9nB1SxTwvSlv2ZgrCcf9Jl9w5f94C10S
	 pwMfeaokzbHGKy2/yT7/cXD+fxxSVAg3BA3uAxZQE1Bf6rR2RjkWAq2WJzBNtBQ7hpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giEajoMN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8731606B8BD;
	Sat,  7 Nov 2026 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giEajoMN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F61F008BD;
	Sat,  7 Nov 2026 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063521;
	bh=98MCnAT0OxoGWPyrPpwR3BP6O7P21/eDMFc1CLygows=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giEajoMNyUaSix4Zghch2pnVotWA+DMis87KnHXZ/Lz4zPsTaB+L5lH3+bGrC+77p
	 k1D+HVwjoQvQcHpg53gC82jTRgOnDl7BMyt5QTY/a65ApljoEQKkIhBP34XREtyb+E
	 w1PtvSW69HXn+pbMLra5CrklPFArzgCocdoRDsIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 662/869] ALSA: compress: reject restarting an ACTIVE task via origin_seqno
Date: Sat,  7 Nov 2026 08:55:44 -0500
Message-ID: <20261107134915.614291106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 0ade01edd33181b65393cf3864cb2ac7c5eb1487 ]

snd_compr_task_start_prepare() only rejects tasks with
state >= SND_COMPRESS_TASK_STATE_FINISHED. Since the enum is
IDLE(0) < ACTIVE(1) < FINISHED(2), this accepts ACTIVE tasks and
rejects FINISHED ones, the opposite of what the origin_seqno
mechanism needs: origin_seqno is meant to let a caller reuse a
FINISHED task's buffers for a new job, not to restart a task that is
still queued with the driver.

The seqno lookup path in snd_compr_task_start() has its own explicit
"task->state != IDLE" guard, but the origin_seqno lookup path relies
solely on this function, so it can restart an ACTIVE task, causing
ops->task_start() to be called twice for the same task and
runtime->active_tasks to be incremented twice without a matching
finish/stop.

Accept IDLE and FINISHED, reject ACTIVE, on both entry paths.

Fixes: 04177158cf98 ("ALSA: compress_offload: introduce accel operation mode")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patch.msgid.link/20261019144533.30665-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 1bf943b189cd0..e1b2da84f7782 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1142,7 +1142,9 @@ static int snd_compr_task_start_prepare(struct snd_compr_task_runtime *task,
 {
 	if (task == NULL)
 		return -EINVAL;
-	if (task->state >= SND_COMPRESS_TASK_STATE_FINISHED)
+	/* only an unqueued or already finished task may be (re)started */
+	if (task->state != SND_COMPRESS_TASK_STATE_IDLE &&
+	    task->state != SND_COMPRESS_TASK_STATE_FINISHED)
 		return -EBUSY;
 	if (utask->input_size > task->input->size)
 		return -EINVAL;
-- 
2.53.0



