Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055695;
	b=J8b8Erlr1ZM3L69AQJ7o2KLJZdqSl6VhoeImHd1u81oC62D2rbpCl/YTjSAEOcyx8X8a
	 wY2weAKtDH9opYxQvhv8t/bjg1KkhziEffWnrzFDke+X6LzsALLVLPt3rNy+w4554fcaN
	 q29eLbQt7TM7B4WuWcChNnYQbSsxssIPZGzpWOrbI51qFxM+IqtqeI/3ejI/Zh737akf9
	 A++5wZzu8/k1B4oKajLEOVpv6tXzkXdBIiDXWA4wZlpDyD+78qzz1XFoga2ObqpExNq8V
	 nhiOIs+wzLaVlDvUP8bAb2qHjtlFpB8ZoQbIOkL4ILtk9/XTUgwf9YMKmXZ6op/uqfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcZzhCXbpAjXMU8jg0GNdC7VjCuxdf44ekNdogkIRWA=;
	b=U3VLcD3v4PvcMT/mFbQ1inOnU7aBYAdbDYrmJ9R4SHFCKJSAB7LE6wrZowcnAZq+FJOY
	 AOSEIZngw7PnAnMbaBq1L4upyLG7BOg1cqkmg+rW+5egqYr8OcyCLK5ZbbYA8Xtn17WIJ
	 DYGivQcFxDkNsFEJ4vrjFl0kQA6QduOPILm7yFIG4hm7uV1G7puT+6JOzqWIVKC1iJmcT
	 KiPvn7bOvowY6EDRoUTm9YBYjmeqRhoH0Pke8mGYEV/3T8vXJ3LlArrpPRPmvtFJebkwA
	 vGviPl0z7/7IsVFvJfOarznFh1orOnUemjRXiClzDj/H3d1lnXJpYwqar2zzGS0oAvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQ3nyHm5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F602606A331;
	Thu, 19 Nov 2026 02:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQ3nyHm5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE2E1F000C4;
	Thu, 19 Nov 2026 02:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055695;
	bh=EcZzhCXbpAjXMU8jg0GNdC7VjCuxdf44ekNdogkIRWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQ3nyHm5qaKSz0vXXXwUy34Ovm7pvHWMfP3hQyWdU7RFaqfOgHNaH2nR5ZjInsn0F
	 is9MZzpZ5V+fbNlq4qDSE50Wj91xJDHvVU/hmp8tHPsgLcV2FvntkenJKMiMfnEFoJ
	 KFdntmHtg8ztzBFekeQuTEkIDF6ZIvdHHsuBJ7nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1721/2214] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Wed, 18 Nov 2026 15:56:37 +0100
Message-ID: <20261118150120.573570902@linuxfoundation.org>
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
index bb3d9c52202b0..09a0ced3d386e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5467,7 +5467,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
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



