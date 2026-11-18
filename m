Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030742;
	b=mRdKP8aP1phZ2KMtzNyGaPodPYs8tR+HoUHsEhJFxdc3w0CN3jS56rV0bFaGU+yz8Y5h
	 9e2o8d8tHq2QWpxwaf6wou5ef6hSpJpit8aq4d96galQE2KKTDpLbuBOEUAyYIDwNLsjM
	 S0TVrAlTMP2/riTLClowEjH44Ou0g2KEct2+IJttoh0ae12MXnpe9n6Nzh/c1VHNzn1CJ
	 zBL6EGvkRRxUkwzVAnXfGkv0BJn1ezkn8s0/4lTMbrNqueEdwwMfVuCq9bIazgypj8pel
	 zH795mHvVfaPEgf+FQllPvzhn3cRrPGqvYySz9tfnVpTy+3tnmsxJCp8goGrPZ2r0Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RgCRf4jhYjyQTgnTiSbV3hRxmbxB8nk9l6dy9hyVwTw=;
	b=1pg7mNYENVzEFJvIFAZzsN6PgcK1/iVpI7OxQazj1OGmzkOTh30M3XpeDJuwoyVVo6VH
	 dgMN5jnfjgRBXx30/Rd4kLpuP7G0iCQ6C8nUFUTEpEaU5z75BEO+zo3u3hdtJQB/uiPau
	 eeHAJ88FwIuT/tCbkhPcIaigrFvZr7JkTE3BuSYtdz85kBBCEjp6vRsG7+PgMEqPyQQH1
	 C22HA14YfNZYi4iymG4bAc/tZkPoBGbeKSI4/VcA/DG5mE2W0xkhz2ExL7Dc23o6PqJWn
	 WXQLi6jXf0/aWVvZrbdDVBNszwFLsrP0UJjtuaBtwouj+ya10o7N7G//aTCiYr/1fEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S79Q7e1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4702D606A90E;
	Wed, 18 Nov 2026 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S79Q7e1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A44B1F000C4;
	Wed, 18 Nov 2026 19:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030741;
	bh=RgCRf4jhYjyQTgnTiSbV3hRxmbxB8nk9l6dy9hyVwTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S79Q7e1u2ruXRy/V7lR8d10TTHmIuClhjCBCcwrwDPfP/6Xyyf94/fxgbkSyY6Ocm
	 avopUdDJGupsPmbjtBhmdgVp0MzJgs9d0pbJT9WYu7gPlinFvYYcl2WDxyKovQsGDA
	 SZJKuhUBAzmtT2eBThcKpwsOA+waELfH+PfI4yo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0812/1756] md: Fix the null-ptr-deref of mddev->private while submitting IO
Date: Wed, 18 Nov 2026 15:48:59 +0100
Message-ID: <20261118150041.938141661@linuxfoundation.org>
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
index d5b46a6e61384..ed125819c61c0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -398,6 +398,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
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
@@ -4468,7 +4482,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	case readonly:
 	case inactive:
 	case read_auto:
-		if (!mddev->pers || !md_is_rdwr(mddev))
+		if (!mddev->pers ||
+		    (st != clear && st != inactive && !md_is_rdwr(mddev)))
 			break;
 		/* write sysfs will not open mddev and opener should be 0 */
 		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
@@ -7736,6 +7751,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	case HOT_REMOVE_DISK:
 	case SET_BITMAP_FILE:
 	case SET_ARRAY_INFO:
+	case STOP_ARRAY:
 		return true;
 	default:
 		return false;
-- 
2.53.0



