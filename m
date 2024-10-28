Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D828837;
	Mon, 28 Oct 2024 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098005; cv=none; b=Hstlz0HdluyZN4vD9+ffkWhJ/jjb3YxH6osZMtMCfd0dlwYcDodMHbG3hFq4MqgG+B+BSzwNLMpqit/K6ljPv5GUxgPAI3rXWOMqsUNyC2Xlwa5wsmPYyLGEkivvLB7JWQphrvQIP9yvqEJQb5qVL2yxsv6sjHLYS0464dgap6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098005; c=relaxed/simple;
	bh=l9FEdk5BFrkdjQWa84k+Cwq6HdLsLhT3wjsgCfisSWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGsfsCUqaQWrO3b/7cgkoN3AkG2rLso5UMswiackoh1RGp2VQJ57lMMLDdmVCwWjblrXO+dsyR+J1EAYcjVpA1R6ga1o2Zxee7ZA5dmcrnQ4+Y9FlWbOHIGKtSAa/dOiVkD4NZoV6AjAgJGTPp4sUG/wdxFRPiv52BIgF1eTDPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGME9yMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGME9yMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73DDC4CEC3;
	Mon, 28 Oct 2024 06:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098005;
	bh=l9FEdk5BFrkdjQWa84k+Cwq6HdLsLhT3wjsgCfisSWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGME9yMiscGRCkvTYYo0Wf1lkVS64Pgwp8Ra8To8QJfIViiaNT41BfWxYDdTjrKoR
	 fAeO6IvvVGS/MS23u/j55DDvZwDIJZXtbPYyDgmqzPg7cVdqCrl8HfPEi2htuEZPEQ
	 0KFIZUhxvTjcfTrQfQgfr0Oitp6nWe6koaE+mENU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 036/261] elevator: Remove argument from elevator_find_get
Date: Mon, 28 Oct 2024 07:22:58 +0100
Message-ID: <20241028062312.915550506@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ee7ff15bf507d4cf9a2b11b00690dfe6046ad325 ]

Commit e4eb37cc0f3ed ("block: Remove elevator required features")
removed the usage of `struct request_queue` from elevator_find_get(),
but didn't removed the argument.

Remove the "struct request_queue *q" argument from elevator_find_get()
given it is useless.

Fixes: e4eb37cc0f3e ("block: Remove elevator required features")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20241011155615.3361143-1-leitao@debian.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/elevator.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 8f155512bcd84..640fcc891b0d2 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -106,8 +106,7 @@ static struct elevator_type *__elevator_find(const char *name)
 	return NULL;
 }
 
-static struct elevator_type *elevator_find_get(struct request_queue *q,
-		const char *name)
+static struct elevator_type *elevator_find_get(const char *name)
 {
 	struct elevator_type *e;
 
@@ -569,7 +568,7 @@ static struct elevator_type *elevator_get_default(struct request_queue *q)
 	    !blk_mq_is_shared_tags(q->tag_set->flags))
 		return NULL;
 
-	return elevator_find_get(q, "mq-deadline");
+	return elevator_find_get("mq-deadline");
 }
 
 /*
@@ -697,7 +696,7 @@ static int elevator_change(struct request_queue *q, const char *elevator_name)
 	if (q->elevator && elevator_match(q->elevator->type, elevator_name))
 		return 0;
 
-	e = elevator_find_get(q, elevator_name);
+	e = elevator_find_get(elevator_name);
 	if (!e)
 		return -EINVAL;
 	ret = elevator_switch(q, e);
-- 
2.43.0



