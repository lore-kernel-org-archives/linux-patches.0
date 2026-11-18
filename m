Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025304;
	b=OxiAWnCWJAkzg0q2/rV0LUtlAyp8M/GI1WgUWy0ro8PWSHAii3ygDnegZK1tqX2eMQoN
	 hW0Im0wQPaVVXV8dgQqEdW73ELDyjcIduhcyW9J1jNunn94QZSEpbTzy0N23SfjKFwIng
	 aQQrPkOe09p/kDljBStLLYxvISAo1QFTfR0jdW3a/qjXkac1kVOxb1nnPlJil7i8D4l/E
	 Zk6MVwdB6Pj5y4JIgsMCEnOhNM49+4FTdvUtdavE5yWDTPVWkJBVgUvZkcoG8nH7adlMS
	 3XaJdj1apBIlLLgDMCPXRRKWwOV7W5TY2psADvF7f9IMuJahGKluxmwZUz0md7l36uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gm0sCF9S6JcI6Trz9dROSNaJXacFqB5uiGbtWMGGWFw=;
	b=PpBlC19PeSmrt0HnNoI5fhcXaApOf9T5hq8wvFKrv8IlbMl97xDkDMNBkuLIAEF+5atQ
	 iYqFgufWNGtgH/0Nwp6fLwIr7sz4KgpOKdWEfudMrE4ChTSwVGM3gDQRA1cE2yyczVjWO
	 W+iAEm1kvvEEa9v5sixnDD21NPJqlPGRXUPyBm03hSmNxlLcWALiIe7qX0ouy4hFgL+fj
	 qlKHE5VS/sLWOWDtHUJaPpuvZ+gYpPGlBT9plQiJsLsEBmH2aLr+GCgz+6chCoGmYZIl8
	 bnYe/xbBtOwMIRENe1+ep7KQrM5Jc+GxFhN3MTnlzYsytSbq6cOfsV4+vuuFk5mwaqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kYzBqQOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B301606A320;
	Wed, 18 Nov 2026 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kYzBqQOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A231F000C4;
	Wed, 18 Nov 2026 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025304;
	bh=Gm0sCF9S6JcI6Trz9dROSNaJXacFqB5uiGbtWMGGWFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kYzBqQOOgzLXsGhY1sXGYIh2OPoDK10O+CDYlIFf2xtjxjzRnFCuTFkexr8VEMf+6
	 D0324/69hMp5VOpqiAr2tpPv+Sms6TpPe/y83rSpnc9Qz9ImVs3NJlV6Acv6ArgPW3
	 7ZYaliMWV49gbPAGaSliKgDKeMoFBvFtSn2HTeCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1033/2151] md: Fix the null-ptr-deref of mddev->private while submitting IO
Date: Wed, 18 Nov 2026 15:46:08 +0100
Message-ID: <20261118150159.992778061@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4c90b76e0198deb89376988daa8d96b48bea7fcf ]

Concurrent processes md_stop and IO submission can trigger a NULL
pointer dereference of mddev->private:

 BUG: kernel NULL pointer dereference, address: 0000000000000070
 RIP: 0010:_wait_barrier+0x2f/0x250
 Call Trace:
  raid1_make_request+0x150/0xf50
  md_handle_request+0x104/0x530
  md_submit_bio+0x76/0x130
  submit_bio+0xdd/0x250
  submit_bio_wait+0x1f/0x40
  __blkdev_direct_IO_simple+0x1f6/0x370
  blkdev_write_iter+0x3b2/0x520
  ksys_write+0x7d/0x190

One process can submit I/O through an open file while a forked process
uses the same file to issue STOP_ARRAY. The opener check permits this
because md_open() was called only once. do_md_stop() can then clear
mddev->private while the I/O is entering the personality make_request
callback.

This affects raid0, raid1, raid10, and raid5. Suspend STOP_ARRAY while
holding the reconfiguration lock so teardown waits for active_io
references to drain. Fail I/O in md_handle_request() if mddev->pers is
NULL after the array resumes.

The sysfs stopping paths are protected by
mddev_set_closing_and_sync_blockdev(). Apply that protection to both
clear and inactive transitions even when the array is read-only.
dm-raid teardown is already invoked with the device suspended.

Fetch a reproducer in
https://bugzilla.kernel.org/show_bug.cgi?id=222020

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20260922030538.1634904-1-chengzhihao1@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3c8f11b612883..c54f5f34b1dcc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 		if (!percpu_ref_tryget_live(&mddev->active_io))
 			goto check_suspended;
 	}
+	if (!mddev->pers) {
+		/*
+		 * The __md_stop() sets 'mddev->private' to NULL during
+		 * the IO submitting, check 'mddev->pers' before the IO
+		 * being processed by specific driver to avoid the
+		 * null-ptr-deref of 'mddev-><member>'. The check is
+		 * safe because the IO has got the 'mddev->active_io'
+		 * reference, and all __md_stop() callers will wait for
+		 * the reference to be zero.
+		 */
+		bio_io_error(bio);
+		percpu_ref_put(&mddev->active_io);
+		return true;
+	}
 	if (!mddev->pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
 		if (!mddev->gendisk && mddev->pers->prepare_suspend)
@@ -4665,7 +4679,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	case readonly:
 	case inactive:
 	case read_auto:
-		if (!mddev->pers || !md_is_rdwr(mddev))
+		if (!mddev->pers ||
+		    (st != clear && st != inactive && !md_is_rdwr(mddev)))
 			break;
 		/* write sysfs will not open mddev and opener should be 0 */
 		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
@@ -8189,6 +8204,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	case HOT_REMOVE_DISK:
 	case SET_BITMAP_FILE:
 	case SET_ARRAY_INFO:
+	case STOP_ARRAY:
 		return true;
 	default:
 		return false;
-- 
2.53.0



