Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025287;
	b=U0GkWOvK7jUV9h2lckp4BKJE6JIG7ZCK0kxC05cUHpfP5Sl2EzLtW6miewNDceUwV9je
	 5DiDyF1N16hN+Sjr8nZysUA5PTTWEsNNx8ZOKSHEV+QWxFxyznJ30Wi5afx9EwjcllriZ
	 HzB3x3kD46Px2YRkLz0jvauItiKl1OMxfNO+WsL+x/NneMwuGF0qp6b7rw9Muod8Z5sK8
	 5cCFDtWm0ItlN/XdA8kVK1yhmwhM7Q+kv+6n4B7jyLwEN3lxvx+uA5eiAp/th1GI8BbaD
	 5gmkTYB+cN9GuRdbaCt0SWMJtyxxNDCzztVbWgjIFGlOAZlVdDsIc9b8AwJKC+jfsvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UE9Z8e0LqJEqjcWr3yUQNHJ5aOm1h87YviBqtg6do8M=;
	b=O8luLzX6u/x9gcUiIRWYk6Jcx+doE4JVc8UjG88k1y1ckfBanywbrB7T+4QUvVre9NWk
	 nS6UVlxBE1oyGmfMUnWSY+tKZmtmmr60dMZtVVDTCgmF8J0CioyZyxaY11koTC4kbYpt9
	 qnPy4X6qMFA5OXBYJHgfe5wkQ874Ov+XIyje7JDNxkRsYIs0ibhI4ISuWRLwQGhwENu7f
	 orTEkAoSvuiZ8UWcyf4jyGKozWY9ejaBG4EdS88YP6CrWVqGnyGxxXjxen94EHis3nvr2
	 nDVQ3auNztvjh3Tmq7CUZFNShJ+08j96JVQ7h7ASc870SGOt7Bkve/iBJQPYRizW8WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZOsR9Z4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A80C606A325;
	Wed, 18 Nov 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZOsR9Z4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A064B1F000C4;
	Wed, 18 Nov 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025287;
	bh=UE9Z8e0LqJEqjcWr3yUQNHJ5aOm1h87YviBqtg6do8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZOsR9Z49muyWWmK1T3Dy3/Af96gIOZ7MKnfmZVzQ4EGeux65E96zCGWpuy12c/hC
	 hzc8iTsrJpVF5vvS+Rm94C8JOTnKKDW72EywmzNpS1gpJiRyYpRQ8twmOt0iG+NAvl
	 yKWRD0nA252OBopJvDMrTQkm3QXLh/VtO6DE14f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1027/2151] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Wed, 18 Nov 2026 15:46:02 +0100
Message-ID: <20261118150159.799398505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 900bf42e0ff8009f66ffd4a679c56264957019dd ]

consistency_policy_store() sets MD_HAS_PPL for an external-metadata array
that is not running yet, without holding reconfig_mutex.  But ->pers is
only assigned after pers->run() returns, so "not running" also covers an
md_run() that is in progress under the lock.

If the write lands inside raid5_run() after log_init() has decided not to
set up PPL, or after a failed ppl_init_log() has cleared the flag, the
flag ends up set with conf->log_private still NULL.  The next idle pass
of raid5d() then does:

  raid5d() -> handle_active_stripes() -> log_flush_stripe_to_raid()
    -> ppl_write_stripe_run()

and dereferences the NULL ppl_conf:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000002
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538

Take reconfig_mutex around the update and refuse it with -EBUSY once the
array is running, in which case ->change_consistency_policy() is the
right interface.

Fixes: 664aed04446c ("md: add sysfs entries for PPL")
Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75d7e96ad03ac2dbbd9f
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260924171345.75894-1-ngocthang2710.1999@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8b750af486b69..3c8f11b612883 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5870,7 +5870,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
-		set_bit(MD_HAS_PPL, &mddev->flags);
+		/* md_run() holds the lock until ->pers is set */
+		err = mddev_lock(mddev);
+		if (err)
+			return err;
+		if (mddev->pers)
+			err = -EBUSY;
+		else
+			set_bit(MD_HAS_PPL, &mddev->flags);
+		mddev_unlock(mddev);
 	} else {
 		err = -EINVAL;
 	}
-- 
2.53.0



