Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064386;
	b=YXgBlN4g8f4hv35ZGjWw0zgY+4iiiBF2zOgUIFFwDlUUq820GH7FyfWUFfk+MT/9w4Bu
	 52ZTK+rb9vqh/dealScjThmP5d9PFRWjGVdB+Mv+TI7bqEXz8D6Ah3dq/vCbv9EmEYxT8
	 fm1A7Dd7yzZKzJ3bfGqNwwTat2KHXUvT35HzgiNPmyc+LT5LLEd3aRJ6kSty4YRx+Q86c
	 QUWAHN2PztnmNEkWRcmKGH7amPciq0uTlf5/Vi9g6aXmWCJNRnN+0zHYm9o7DzhokaJCB
	 Tz1uq5zgP5kx83U0IGUK8LhlVkAUFYICWF/wOFify5YxE1s9eAZ9ZjGJ//gedP8scrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMt1yHW3K+5HR+6yFqGs0ZkiRmi67luH0/kIrYfvJBY=;
	b=Ax6Fjf9jWQk6FFhe2vjQOUn1EN0gD9pflUCe3VIiSLDLlm3r6PNu1A3GEmZcoCncMgv0
	 SG/CjTsNk1i2xoTww7V3nUZ6a1lvnSn8qtYFVTfhxxxqIy0xZ5ekzIZEF219e5PFQRGhc
	 +xBV6/qg0Ck98GUcZWdWVTmBErHtDhVLB+OLRLb0etaUYcSykth5/MfwZZSEFKTiAX9L4
	 0wQ0zHyBhxxW8SDqGMDjx3mpaDPmsjRUjXqltHqHx1iYMvw4uCzqS9XiJZ1FTkqfizCMN
	 uDzUwVEvH7SqfNKkv3ZoLXSPHvCZ1aa/NsJ5UH1rORaPKDW9PILgRVna4PNPlgHanuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goLiFpE4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DBC606D820;
	Sat,  7 Nov 2026 15:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goLiFpE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6F21F008A3;
	Sat,  7 Nov 2026 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064385;
	bh=FMt1yHW3K+5HR+6yFqGs0ZkiRmi67luH0/kIrYfvJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goLiFpE40QBuPMQ2Zc3x17qJJguoHqCkXjfP+J7GQ3un08JjvUK54fS5xecLx2eMM
	 L6RIhEAvXRIhkeLuVJzbPfS0WLRki/m/X6OXzUSd3T5cmus/A4iOn5wSPfT0jZ0iCv
	 Cj9u73pP2UcqfEM9kyYqfn4ORtKh4ldrQ3952eUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0424/1257] block: drop the cached plug time when blk_add_rq_to_plug() flushes
Date: Sat,  7 Nov 2026 08:45:20 -0500
Message-ID: <20261107134951.208018554@linuxfoundation.org>
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

From: Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>

[ Upstream commit e0f2224433b15a57125d6ac5d46182f99c6c9d08 ]

blk_time_get_ns() caches the current time in the task's plug. The idea
is that the cache lives for one plug and is dropped when the plug is
flushed. __blk_flush_plug() and finish_task_switch() do that.

blk_add_rq_to_plug() also flushes, when the plug has too many requests
or the last request is at least BLK_PLUG_FLUSH_SIZE. But it calls
blk_mq_flush_plug_list() directly and never drops the cached time. So
a task that keeps submitting without sleeping stamps every request
after that with the time first cached in the plug. start_time_ns and
io_start_time_ns are stale and the disk stats charge each request for
the whole time since the plug began.

Drop the cached time after the flush, same as __blk_flush_plug() does.

Fixes: da4c8c3d0975 ("block: cache current nsec time in struct blk_plug")
Cc: stable@vger.kernel.org
Signed-off-by: Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>
Link: https://patch.msgid.link/20260930-blk-plug-ts-flush-v1-1-bf8ca7bc5cd6@virtuozzo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 025a799f35b92..e929f94b25c7f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1397,6 +1397,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 		   (!blk_queue_nomerges(rq->q) &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 		blk_mq_flush_plug_list(plug, false);
+		blk_plug_invalidate_ts();
 		last = NULL;
 		trace_block_plug(rq->q);
 	}
-- 
2.53.0



