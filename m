Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065055;
	b=KzrMhgctQfAtm4VgYA0vUDYx0gnZOR6aXGp3iPg5ndE0ecW73lFwmnCp50IFQcZ7kJtz
	 JaH+j3gLngh2AtbUe3ifVoctZisdEhvlG7iPO1dASZtgnjo/r19WEwth6fpY8DZ0ONJHF
	 +zXpJXD8LulfJltp37TI7/dfUtT4nY7k9RF/dctO/h9vAhF7A9h8aQYpya+t6SRoqBXJX
	 OjmKEkqUAZIpAnEEHuCV8NZ0kX/nPzaJNNA8VCj4V4jAvdqNGOy/pxMLqTKNsqhX2KSsM
	 XY4ya0RbhpRQFnHQP/38rZmOjDDkxb5eyUbTQs8DOQn1Cux0tRHPeQduNE5Zscy+TLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdBL7QqWc4294AHEx3S9S5R1mJMLZopPC1tAh4WeDM8=;
	b=MMOzlYJkxm+Nif783m6D1a+0afgjmn5z0BbfNwHRq1TVGeHvG9jWQtR9bT9d5I2FYUBa
	 QbSAhyFELVDHh6orQrkFD6OMmwBoB9OXxfBu8SGosNIrrbYnvcco/XpQRauHYOzo0r9nc
	 biOMJOWkSjxazngzxE+CXkOryBs5UYHqyrh25vKjIfv+i7rzn1kLXWuGO50LVtwsyFGuM
	 mUD24Y/RaZpADHQgj03gcJXcuSm8Xx80Y2CgD1EBLDBuVMgM5iIqA7f8fYjy98n8Nfjoi
	 1uJojmI8QMpbb7P22t6ZjiR5cTgUzp6BFNlP4BJ/LIjG8lFI1aGJ0WtuwfTw+d2J2/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhcLLIyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8D7606A32F;
	Sat,  7 Nov 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhcLLIyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B3A1F008A1;
	Sat,  7 Nov 2026 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065054;
	bh=fdBL7QqWc4294AHEx3S9S5R1mJMLZopPC1tAh4WeDM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhcLLIyYDCOskAD3c9zL/DKqg9KihzETB3ksBIS4ekRuWS5GIVmtpumxfoEssEOmI
	 yX5qfItwazn8ejYZScM3FoJGSqh2LmjToX25RknfvNq+H42q6mT3/aydcnDajb/HzI
	 YmDV5vyjKxFJAtTTjDlfyXD46LxOrmrkmutGQVuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0903/1257] ALSA: compress: reject restarting an ACTIVE task via origin_seqno
Date: Sat,  7 Nov 2026 08:53:19 -0500
Message-ID: <20261107135004.274359584@linuxfoundation.org>
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
index ce806ca875d3a..77503bcdc53b4 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1156,7 +1156,9 @@ static int snd_compr_task_start_prepare(struct snd_compr_task_runtime *task,
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



