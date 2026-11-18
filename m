Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030720;
	b=jFuB41I55YFkJu5hJgJ06pD6cgZPqXEdw2z/JkfUfpFYuE8HVJSAeU1k+Uc7KZqGdbD2
	 FF7lBJW0zFzp4+jZhmgCie3alEmjO1ucc+T/rlA+ebgRdx5Ap7inkEqOERHjuAyGE0/m9
	 HfsJ4DTf3P+uUFHjYeuq4SV1VTKut9jDd5jrZQ7vRCY7hYltUdLCjihJhc8JqAkBBPxNk
	 RD8tMvEYVljsbCDI8dHWuTynaC5TZcQB4gc+80pU9MiBxQ0uBFAnJEBq9mzh5u97zZL49
	 ktqw340/uUeyFzrU4f8xY11vpzZoIrYS1YJQR3xg+jSLSEsOqJelPk02W1AQ5E7wKDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J4BE4EP7AHQNAWULORbyI0A0qICJNv2kRGJc/1n3/N4=;
	b=AS4nFVySN9UyxESh+HYqojDhjrHfQuTYe9RTm1QsvMYIwzwEgJm0z07qoc/H5c+S2Xy7
	 NEEyEQOr6VM/s4rPyqSKrpOOFlheG+n3QCz6Ud93EMBGVaSrK25tyJvN3Jhta+c2MX7r7
	 sDj38KDPhdUa2OZaYEeuQF5m/vzc84sT5xOs07q37x+ir00lcMI8Saa15WTetxZ3eNsuq
	 5vjZkCutI+NUCfDKwFUC6x0r+7xEuX6S7DpMz0aQXhfW236TYwJ74lUMbMNVah8URP+or
	 MZE7rrbw3i6CFGjB1lEc/zKRkRdNcT8p9pFnCRWRwLZCPhnpBgLWGv6kLmRm/ves6mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hF/utMdR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BA2606A333;
	Wed, 18 Nov 2026 19:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hF/utMdR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABDA1F000C4;
	Wed, 18 Nov 2026 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030719;
	bh=J4BE4EP7AHQNAWULORbyI0A0qICJNv2kRGJc/1n3/N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hF/utMdRlyMCex0zdlqxZmRonBQJA5At2BKRr7frKamluFqqFs0NVOj3KF0ozFaOk
	 WXYQ22CtWkG2KzbmdZiFls90AeW7LJsdI0QE3pc1ENbGEDW0GlZpvEqX4toE+/sN9B
	 ZWFsVwgpY1xqwSI7HHGSbhH1KYDm9SAVXShKqFBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0805/1756] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118150041.701708711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index c7214157d12ce..d5b46a6e61384 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5641,7 +5641,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
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



