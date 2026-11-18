Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048515;
	b=B1U1ZMrJXzUCZQlfFRnz6fuxfqblTZ83c+GtL8Tosbzcjkm9qIeRia4fZbyKkU+gHLXJ
	 HjYGfhiZV9LzkwR38daJZ+mAZWTJEikQoB0IStbOq5gFX+fHVOyboM4udPudBZJNkP1QA
	 pVgVONUbBUaIZbthIHei8/E1fHvTT9xiG2txfc4+HBAgyoPNW01ANMHxfIStyJNZzbJC/
	 H0dV6qF6N9T09ReG3rGhBRCj4kvVM7DGRadm1O98FFzcXV1ec4hpqToW9VTADTSjNjUq5
	 MQD6HGcibsYk4xbso15bDVdeAbukCqQM/5eNDxTEp4qFWFFF+qACAqQERl+V1IXOR5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvpW/uZ5T6Lc3FxJfoJims7ITMDiHZjBT1mjfzPRqCo=;
	b=hz2AwB+BKwbRCX2n8yhlNm5VyHLB1KhL/j+yA6GqYI9BEGhJLb0oPIn4virw/WIzTJrr
	 iiltQnLcf6la8Oh/MX2lTOiuGI3dRAmP5Va2h1BO6+4pcTrR0gSg/SaYE4x4AOuzTWOLv
	 BKnaSO7QdTOukKP8VEMaEZWEXgy1pJhDeqyrYYzfvtRlmU1ZjI6DSn7RSwvG1HOYj8shK
	 a93b6uXVBrrrWOhTwoQqShuADG4kYe7Y4OSilzYLRxjuX08ybmBdcdEaX6B7Nw+35Xhup
	 +j2gSBtCihzj2TkrciGsHIZCVVhlZtZE2KynARAZrwoERL0EhhLXSC4cKTE1BvtOqYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrUZYMIt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00971606A320;
	Thu, 19 Nov 2026 00:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrUZYMIt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592241F000C4;
	Thu, 19 Nov 2026 00:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048514;
	bh=PvpW/uZ5T6Lc3FxJfoJims7ITMDiHZjBT1mjfzPRqCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrUZYMIt5azetnCVPtWBJQ5Zw0cVlgEAzz4fp9ZC8zA9cWOMbY4ytDqYl5zlXHhF6
	 9PO3ApWkXihDM5FIhdGH86nt2jdDTD/UrxLx3sZ2fPi7iT4mIp+0YkH41QW6aukE8m
	 RGfDTc+2lpJKmiU139NH0PDqNIW4ykE4muSTQFJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2021/2857] swim: Simplify return value initialization
Date: Wed, 18 Nov 2026 15:50:55 +0100
Message-ID: <20261118150314.172555348@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 385a44e78702762e2fce796cf37b6f465d86a87f ]

Initialize the error result once only. Update the result only after a
successful read.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/28322f0cbefd865bdfb679bab4352c111996795b.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d66bdef0a308 ("swim: Check error register during sector read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 250e408060e8b..81c824923336c 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -49,6 +49,7 @@ swim_read_sector_header:
 	link	%a6, #0
 	moveml	%d1-%d5/%a0-%a4,%sp@-
 	movel	%a6@(0x0c), %a4
+	moveq	#-1, %d0
 	bsr	mfm_read_addrmark
 	moveml	%sp@+, %d1-%d5/%a0-%a4
 	unlk	%a6
@@ -63,7 +64,6 @@ mfm_read_addrmark:
 	movel	%a6@(0x08), %a3
 	lea	%a3@(read_handshake), %a2
 	lea	%a3@(read_mark), %a3
-	moveq	#-1, %d0
 	movew	#seek_time, %d2
 
 wait_header_init:
@@ -143,10 +143,7 @@ crc1:	tstb	%a2@
 	tstb	%a3@(read_error - read_mark)
 
 	moveq	#0, %d0
-	moveb	#0x18, %a3@(write_mode0 - read_mark)
-	rts
 signal_nonyb:
-	moveq	#-1, %d0
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	rts
 
@@ -155,6 +152,7 @@ swim_read_sector_data:
 	link	%a6, #0
 	moveml	%d1-%d5/%a0-%a5,%sp@-
 	movel	%a6@(0x0c), %a4
+	moveq	#-1, %d0
 	bsr	mfm_read_data
 	moveml	%sp@+, %d1-%d5/%a0-%a5
 	unlk	%a6
@@ -238,15 +236,12 @@ data_crc1:
 
 	tstb	%a3@(read_error - read_mark)
 
-	moveb	#0x18, %a3@(write_mode0 - read_mark)
-
 	/* return number of bytes read */
 
 	movel	#sector_size, %d0
 	addw	#1, %d4
 	subl	%d4, %d0
-	rts
+
 data_exit:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
-	moveq	#-1, %d0
 	rts
-- 
2.53.0



