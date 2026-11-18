Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045323;
	b=bFfOY/5OY/+zkLsUAgtDTW6amwUiFf6EUh+hd5R9dfATLCiQBuGdEaiH8s+tHBI1NpSl
	 y9BeW6HBhY82sK1AicZwbGSwmEn1axMr1tKBNN7lUKAtWumloRWJ10wqNHru8hJBxH3SC
	 yn2HOZ5IVq4kxPq9MNzFSi1Uqh+dH+hpxsyeYpeEUVH93iYU+K3HBMF+J+Jxr6HooJMyH
	 nm2pPP7/dSCJ5yvta4blihWoyuUh1VQClBoWFZyTMWyY0RBn5OvINH9ehzee0g8j2Uz3k
	 meAZVCfK+3yaDEeBmd2Alkq38NxncZuXh1mhFAw4BW0o/KHgkTNPG1EAnfeU+gZBhqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yM5tKBjukBs4BzUzX2A/IyyErcS1JglT6yvkoafa8H8=;
	b=EKace7s4xxp81iIsGH1ZDhxoJFBP22EWsgVYz/p3RNyekgI/KCNhUTTdoE1SLVE0K+a8
	 8HTOxVvGV6TerHknVHy50aeOHaXQzM/ylq8XT5LNX7SbyG4lN6++pPCbSKTdXQusqDMer
	 Z5AaeqUsTZjQ1lu+iDU8vgYNNr2xIR8VOBx+uJqQWqydyiMeH02FI+Ktyt3iH7oBbXzvl
	 B+StAe4x/895YEWOxXZGX0nGmUiiIKeubXGd2tTgQlog/ST2J0c2WjnpyKBfLneSO1ScG
	 I0RS7fSGP8pFHeSy1Xz5b8m5168SF1fhrjKPmrzgv53ZjxjzdYQRhJNxsLYF9Jc/reQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9I8eP73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2888E606A320;
	Wed, 18 Nov 2026 23:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9I8eP73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBB61F000C4;
	Wed, 18 Nov 2026 23:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045322;
	bh=yM5tKBjukBs4BzUzX2A/IyyErcS1JglT6yvkoafa8H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9I8eP73UFWsAm+rnQzObDWHuFCEc6PVe9z+q/OfWJ/KRHIZELRqPgBlaQLmsPCpO
	 z5/xv/FQIeW7+MPcy9RL6AADo1UjdKHsUhOy+IbPhjCSEmIIxAWDSKQ7jQfFN9Um8+
	 tZYZaruX4lT1yVumY+fVzptsS0kdDarFuwddE8zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+874c2707f97fac24b090@syzkaller.appspotmail.com,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0880/2857] floppy: dont store a stack buffer in timeout_message
Date: Wed, 18 Nov 2026 15:31:54 +0100
Message-ID: <20261118150233.246032722@linuxfoundation.org>
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
index 5d29791ec0126..61e936d4f601c 100644
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



