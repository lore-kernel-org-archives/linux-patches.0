Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052582;
	b=p0pfuwYqcQJ9VFK3eEHBBcxqXkZuC3DbwEoEvN3srttsXIyGwDSG7gsHR76h3sJvvupd
	 6o2AIadFe5zwQs9eCJWD+EoOpaacW3P+fMqRP9/FbJXPJadzndakEFmNtejN/5GWv4R1h
	 KQxpPvl7p7cCj3gUjzHiBPr33MAwaL257H31BYup4G0LgdKRSFtExtb9q+ojgl9blINF9
	 sGIVZY8S78+C+rtTCLy2FbgGR8hng+H48xYFIM9oI92fLNIWJR7cyjLEvj2CrZZcgPIEJ
	 WCbxllaCl7pRlUX358AnlWeIg8JOuz3PHfAiTLFl9xxbHcQ+X3aCdl+6pPhoKO+gJGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6v1/kRyZxxIBBRxOoOiGaXl23jKl/YoMdMTUA3jWgSw=;
	b=Ze+sBUQ+akKFddKdUgZyUze2L3t5480GOurukfjnVQCMh/lhpvC5sR6t5QedKdYUy9cG
	 vOmijJdod8YhmC2hN6yutATKD3+0QBBDPyaEu20FmU5Vh0loNmG1cm+EQflUlbJganpyL
	 s1h83bVwRER2XcALGQwGpwI+K5lF8bIx5WEQm4SC6WQLU17ViREbUpeLbh8ZErkSYbpvu
	 /97lpaUZUfAgAmSzf+o734GpLutgQHWzkY1xnXZ/YEtLwUXbqCkKd6mEE9N9S12QGrL7L
	 qWA49+R1DRHePwzgSq0pWTv6JLYZO//7+pmbRubSkmvWyC72+qwROTpISvM7NVOmWGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Po12D1TB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2E5606A33A;
	Thu, 19 Nov 2026 01:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Po12D1TB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4E61F000C9;
	Thu, 19 Nov 2026 01:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052582;
	bh=6v1/kRyZxxIBBRxOoOiGaXl23jKl/YoMdMTUA3jWgSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Po12D1TBtN+VrUQnX8VLoSg8ZkQCNnEAqb5sbfGqP7dzE1seEg8tPYowwfXUeuJ+R
	 l3WAo2KwVWFzwaQh10406et5iojl7HiFA84suswb/VDwIk4hSISHJH6W9gyNdsxhOU
	 q8bebd7oaO3mxXQq9y5y+MB3QfiaSeYOnGJopq6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+874c2707f97fac24b090@syzkaller.appspotmail.com,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0578/2214] floppy: dont store a stack buffer in timeout_message
Date: Wed, 18 Nov 2026 15:37:34 +0100
Message-ID: <20261118150034.062618118@linuxfoundation.org>
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
index 94e591d598f16..f08607f69645a 100644
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



