Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062206;
	b=Qz1Z62Qfdwo/e+Xt2xfCwINazbxYIFV5BH2G0/L+/D/VFaGBGTm9Vt5QlCUx8f9+2wk3
	 UZR7tejSR+HlQWMpe26L8KeJKEBRu4Gl3Av9yORg4jsSuOrMyIxAZdPXY1KyY1a1Ywccb
	 bbuE/CybFcQ5wl8lzwb6C8zIRVm4VaTqFXUcXJZN1T+R7FjbqoNbzIYw3SXHCahOgCUWP
	 6EjXS5jqzXvmyjRTwcGALjeelIOSMQcTrZP01fLEThLwZbfy7Tk7cM6XFTQ0ry8yFY9wg
	 oRKREzwOnNtdAe5uDjWEAwJ2C/UpNE4O2Zg7TBES48oZgHuYTvuC3wRq2AIhTM/0HAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wNqTjI90OUBgIndbxiNdu21SdWtb1xisIy6c/dtHVSA=;
	b=zrJq7/4UVvotJkUlSoMSq0YZJbqPaazQZ7Id13KswPwDuMA3V1Z5MQjXyZZPCi4/FrDB
	 DnrPfFHknUAoHNadMAWqY2Iut89USkrCxFqXqDsFlLJv1Y/fspiIdiKIEj0P/Qse11DMa
	 Tf5erCc1DNCUkrcQrV/X+XyaxohiQx6ELuxvvcKpcMCVzX+xvtbS9HR1hWHUsHF2HbQxk
	 CKXUE5KzbTtIusA//lxWVeWO3XCpfXDgQudP/JAJXYCJ7xKZw6bHLSTqABPj9zTjWlwxx
	 3BJJ170tNIBG8/k5I91EZqnd64dFZTxs2KwPMlxK6unOjHBp8B2M3g/WCyVetOz/6zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8qq2nSf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6896E6083608;
	Sat,  7 Nov 2026 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8qq2nSf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B651F0089F;
	Sat,  7 Nov 2026 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062206;
	bh=wNqTjI90OUBgIndbxiNdu21SdWtb1xisIy6c/dtHVSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8qq2nSfo1sk+PkdqMn+YO5KIfn7GAUMg8K+U4G021/pM+0iSK47u3FD7Y7ueQgiD
	 Jq2ZaVSKH5fOLxXQ1lUD7aBXpUq6f47f/300SDnxC4+j41lvsVYTjHHzhVoDA+esn2
	 dCbz1Bi5aRDUyqA42Ygap3bA3t9Qxh6evQkHyaFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+874c2707f97fac24b090@syzkaller.appspotmail.com,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1162/1536] floppy: dont store a stack buffer in timeout_message
Date: Sat,  7 Nov 2026 08:52:58 -0500
Message-ID: <20261107135030.368940123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 7f1880284a7bc..b224b2ddc110c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2280,11 +2280,10 @@ static void request_done(int uptodate)
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



