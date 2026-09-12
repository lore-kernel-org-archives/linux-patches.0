Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9894BEE38;
	Sat, 12 Sep 2026 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229744; cv=none; b=Q0EV6KvCO4ARfRxLBRNharJbPGwn3fXcDyvOV1sWKW5xHNh4FrsrpwS+bPPUNanrT/lVo27zxWNQCAnOzMJCN33el8s9kDFJAinIW6ABVZ3Ndx1UvqUsNDYJGydm6xb68/bkZqr8CDPUqgvkRtBUScL+DFhwvjGl9Jul/zWWsZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229744; c=relaxed/simple;
	bh=3gZB3yGRuI96IDYVpd2r34Ylc7VUNLK8zyLbp+wFS78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBKXe8sIAR9ocbsZ86k26dOIaybcSEOBUxEY2KEX6LtoyG1Am0Z9u1Wd0Kb8AJbrcKCNPaLoo0ZS10SWvyIi5/0wkAt1T2bU8VwToO6oN6uYy0whTNFzpt3TCLHwkTGFZHAt5s3Nvob/j5wk7jukAb44upVWRV2A+gjrohVQTJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy6LuPcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy6LuPcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858DD1F000FF;
	Sat, 12 Sep 2026 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229743;
	bh=SzmzDH+wn9M+8pWTg2bM9za1BJ+InC9j2rprQOy9b0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vy6LuPcP5NDgicFnbQOcQJ4ZqiKxa2eYdRWIp8Y0fOfW0sOUu5Kj3vMJEdNlzL4HR
	 wi+9qqg8lJULG/ewq6KqekJuYhu6awRKmZ55B7vgkIX60zj3FBzw4YOM3zMDdSUeHO
	 MY7psg+BMCCKCpqopeRu8UFbpqpuYCMqrWsqtzeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0645/1191] s390/con3215: Fix white space errors
Date: Sat, 12 Sep 2026 08:56:13 +0200
Message-ID: <20260912065602.742074704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 55af33fdec50a9a88f0dc0f8b898db7399e32645 ]

Adjust white space according to coding guidelines.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: b6b5d64cb161 ("ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/con3215.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 4ae07c7e2175f..b66fe5aac5671 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -159,7 +159,7 @@ static void raw3215_mk_read_req(struct raw3215_info *raw)
 	ccw->cmd_code = 0x0A; /* read inquiry */
 	ccw->flags = 0x20;    /* ignore incorrect length */
 	ccw->count = 160;
-	ccw->cda = (__u32) __pa(raw->inbuf);
+	ccw->cda = (__u32)__pa(raw->inbuf);
 }
 
 /*
@@ -218,8 +218,7 @@ static void raw3215_mk_write_req(struct raw3215_info *raw)
 			ccw[-1].flags |= 0x40; /* use command chaining */
 		ccw->cmd_code = 0x01; /* write, auto carrier return */
 		ccw->flags = 0x20;    /* ignore incorrect length ind.  */
-		ccw->cda =
-			(__u32) __pa(raw->buffer + ix);
+		ccw->cda = (__u32)__pa(raw->buffer + ix);
 		count = len;
 		if (ix + count > RAW3215_BUFFER_SIZE)
 			count = RAW3215_BUFFER_SIZE - ix;
@@ -642,7 +641,7 @@ static void raw3215_free_info(struct raw3215_info *raw)
 	kfree(raw);
 }
 
-static int raw3215_probe (struct ccw_device *cdev)
+static int raw3215_probe(struct ccw_device *cdev)
 {
 	struct raw3215_info *raw;
 	int line;
@@ -675,7 +674,7 @@ static int raw3215_probe (struct ccw_device *cdev)
 	return 0;
 }
 
-static void raw3215_remove (struct ccw_device *cdev)
+static void raw3215_remove(struct ccw_device *cdev)
 {
 	struct raw3215_info *raw;
 	unsigned int line;
@@ -694,7 +693,7 @@ static void raw3215_remove (struct ccw_device *cdev)
 	}
 }
 
-static int raw3215_set_online (struct ccw_device *cdev)
+static int raw3215_set_online(struct ccw_device *cdev)
 {
 	struct raw3215_info *raw;
 
@@ -705,7 +704,7 @@ static int raw3215_set_online (struct ccw_device *cdev)
 	return raw3215_startup(raw);
 }
 
-static int raw3215_set_offline (struct ccw_device *cdev)
+static int raw3215_set_offline(struct ccw_device *cdev)
 {
 	struct raw3215_info *raw;
 
@@ -940,7 +939,7 @@ static unsigned int tty3215_write_room(struct tty_struct *tty)
 /*
  * String write routine for 3215 ttys
  */
-static int tty3215_write(struct tty_struct * tty,
+static int tty3215_write(struct tty_struct *tty,
 			 const unsigned char *buf, int count)
 {
 	struct raw3215_info *raw = tty->driver_data;
@@ -1000,7 +999,7 @@ static void tty3215_flush_buffer(struct tty_struct *tty)
 /*
  * Disable reading from a 3215 tty
  */
-static void tty3215_throttle(struct tty_struct * tty)
+static void tty3215_throttle(struct tty_struct *tty)
 {
 	struct raw3215_info *raw = tty->driver_data;
 
@@ -1010,7 +1009,7 @@ static void tty3215_throttle(struct tty_struct * tty)
 /*
  * Enable reading from a 3215 tty
  */
-static void tty3215_unthrottle(struct tty_struct * tty)
+static void tty3215_unthrottle(struct tty_struct *tty)
 {
 	struct raw3215_info *raw = tty->driver_data;
 	unsigned long flags;
-- 
2.53.0



