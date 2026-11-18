Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049008;
	b=xXSQcbalA8iS8aAHOT79QdMTHtv0m6L/K4mFq0vqEgvq6GdBEw8sIFuuWoF7HVq23CDK
	 a/odSSw0Gzo7ST5MCzvkfhcOQ0Eads2jUkjfsGCFssMLQbW/J7G3J+o9yUpzNLjQUf9Ah
	 HOJKV3vlsXHkNCh5KpExArLY0FW1Ou10xWO/q7UT1XpvtYxhQXfyCKj5TfcxfBx2oG+9C
	 lpfc5tz7VK9Qswhn/VQA8J97HQXBbJyocKLMglpnh1HP3dWD/yo6axp4Na6WJoxS6HkK9
	 l0ATiaXWssw539CiCwC+sNuKLpLiltEvtAHW7+yvhC5x83eqrVMfg2513TQkXfybj/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3HqhoQmKk6pkRvdHUmi8X3SgKSEVh17gbUSliR24IiI=;
	b=1zuxhidliWXbUQA28HGf/QioNgqvvAAp+oMHbdaIDfHJvj6O9T4QA6g6keTSJ7mx4p8d
	 G9goENOIpt6nm0LahUevonovPSoW8EjohQ534Pj9L11OdEyX3Zj4gCHHN+wzuKhR/2Uh9
	 CvmYKhlwgLkRJPXz1k9FN/pFckLh5Lb4TkdEs0DydWFAqFKWA55M6fgNcbmxbP/+t0s/M
	 klWq14IVKT1c9JboAGIhiQ5gtZCW3cDReQeVfQp70va+7S5dPmn4UiUgBUroZ7s0K4k5D
	 GUVG+kZ33gUvgwkjE2osTjXIWMosnH+F6xl7wKoJ2lb+2wuGpi46MZxauzyCtuHxvzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2QFHxT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD96606A31C;
	Thu, 19 Nov 2026 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2QFHxT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19691F000C4;
	Thu, 19 Nov 2026 00:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049008;
	bh=3HqhoQmKk6pkRvdHUmi8X3SgKSEVh17gbUSliR24IiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2QFHxT7egrFhE06hLu1t+zP0hAyPpB9FrD0QQSxPRN7w7mneYv57zuFb2HzG7Ytu
	 Y8cNIw0c1+OUIWWOYmQy9hauoxu03mLGj55x4YyLgwCVt5ZwAS1ExCH4TfTnBlj4zO
	 vuZGSiq3wpviPG51lB8GW7BAUks3BMBSxkzOq45g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2199/2857] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Wed, 18 Nov 2026 15:53:53 +0100
Message-ID: <20261118150320.604883962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c2c52ac8e01f..6182702195132 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5450,7 +5450,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
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



