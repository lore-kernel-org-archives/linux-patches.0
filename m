Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036331;
	b=rcgpCcm9BLw87F7/x8e4RercxWpKiVn8ErcETyRvkBjrA/mKAPzRuIgKRAxsIxFC9rz6
	 gDYRj9glHbBOByCqMBXvmdrWDQS2bw7W13OLyKQd0CKst0N2sN7JPqQ0lWcfzZEAFwZWX
	 y8DlGX4jkETSW4gEEYEvx/GHxwArp7YFUTryrztPqyLThe2rBEMkZ87CP65PoInYshsCD
	 uH2GuJhbbJ6vxLMX8etA8vdCwRjvWtRnRrp0ScUDlxRvFCVSo43K37Rgyau+Vn9DsOqM+
	 zJLsRrVfstUbunXLfLEdQNhQEn0QwfRDHLCvWqUAZxFBhKBrfOMbUjcIC2UXj02uSFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tL910mdljUfBbaKnO6QpBJGNURZ6oS4J6HMk1I/u65U=;
	b=wr1WPo/MvwhxbO6qdpY6s2t6RNFWd2BYROkK28OVQnz7Toh08B4MwzKSHvtkKjMN5kaZ
	 NiMZrAZdGk1HYIwZKtWMXuTX1Qe4qqOL6Lej56o5LnXVGFOMRK5WDdNsnHhxYv5rped33
	 y04Q6UU/uqft8BWlaApA26YgeIJoR6gFuuz2OlY+KwH4GK4m9yNdDHNgp8haW6h5O9Qqo
	 Q9lfPbnOClFc1jvMscMXS8GY+E7hw25stE5A7fuqe7CjGxrmkF2Hsth1uMqAei27brR7Q
	 o9UGLz8LU3MBh5bsQZsMBu6LcayAmTkXWGiH8iRUHYS97k9FNZ1dGwhIBWNWl2KzQZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TniEg3kQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6283E606A337;
	Wed, 18 Nov 2026 21:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TniEg3kQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AD81F000C6;
	Wed, 18 Nov 2026 21:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036331;
	bh=tL910mdljUfBbaKnO6QpBJGNURZ6oS4J6HMk1I/u65U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TniEg3kQ6/IuHw1ueodhKE2y/R0wfZxOu8cTnHkK7lhOJ4BUaGp9WtdI2vuaqLBdo
	 wk51y7U9/l2zels//PPa3RrPuLpaE6J2PuXswR9m/4i0VCWlIbHE8ITjOC32tPmgLh
	 A4Ojb4aY9nlxeYgKlLwA2MtOohXv5yTZs6i98fSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+874c2707f97fac24b090@syzkaller.appspotmail.com,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1014/3318] floppy: dont store a stack buffer in timeout_message
Date: Wed, 18 Nov 2026 15:27:16 +0100
Message-ID: <20261118150350.304560055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov (Oracle) <efremov@linux.com>

[ Upstream commit 66be62ee5d64b6ad1285978644798d8611add931 ]

request_done() formats "request done %d" into a buffer on its stack and
passes it to reschedule_timeout(), which keeps the pointer in
timeout_message. show_floppy() prints timeout_message long after
request_done() has returned, e.g. from result() in the interrupt
handler, and reads a dead stack frame:

  BUG: KASAN: stack-out-of-bounds in string+0x39c/0x3d0 lib/vsprintf.c:720
  Read of size 1 at addr ffffc900003cfc70 by task swapper/3/0
  Call Trace:
   <IRQ>
   ...
   show_floppy+0xb1/0x45f drivers/block/floppy.c:1838
   result.cold+0x2b/0x30 drivers/block/floppy.c:1183
   floppy_interrupt+0x191/0x340 drivers/block/floppy.c:1755
   floppy_hardint+0x1a7/0x200 arch/x86/include/asm/floppy.h:66

uptodate is either 0 or 1, so pass one of two string literals instead.

Cc: stable@vger.kernel.org
Fixes: 73507e6cd8dc ("drivers/block/floppy.c: remove unnecessary argument from [__]reschedule_timeout")
Reported-by: syzbot+874c2707f97fac24b090@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=874c2707f97fac24b090
Link: https://patch.msgid.link/20260924094839.3239569-1-efremov@linux.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 419143f6cf79c..2bffe6830570b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2277,11 +2277,10 @@ static void request_done(int uptodate)
 {
 	struct request *req = current_req;
 	int block;
-	char msg[sizeof("request done ") + sizeof(int) * 3];
 
 	probing = 0;
-	snprintf(msg, sizeof(msg), "request done %d", uptodate);
-	reschedule_timeout(MAXTIMEOUT, msg);
+	reschedule_timeout(MAXTIMEOUT,
+			   uptodate ? "request done 1" : "request done 0");
 
 	if (!req) {
 		pr_info("floppy.c: no request in request_done\n");
-- 
2.53.0



