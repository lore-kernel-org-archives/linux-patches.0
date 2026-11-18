Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024210;
	b=oSmTEBWa8jygYiv4vn2995l3S8Pq4iC7RavBjwkNZhJ3ArJ/KLB2LKiX3/RiggGtOVTU
	 psIhNSnZQPkeXCho5QComJVMR24vaSXpRNkgRNVZA1ZaalFfeFtFOeM0+wN+OlFgoLJ0S
	 o+tLAcFgGERL31BzgZiOLqQFK6/fw1iCEw6Lj8e6ZeFZst7gbm6gVMAQSx1wG71Znydqg
	 Oa7n3WRkmFf5O+G9pJJ5GGk34VmANSNPbO44iwW+H265pLBjTLE/yYRkN1Mvq+///WzNy
	 UYMv/Lxl3QNZQsCpaZ9JqPCfpwW9AHYFFtMXZ6INOsChX5N2osaM0FAvFD1oq2KF6VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PlO2ftxL+LTWUkacD2QdJ97drJ026WBmH+nsKL0nZ1k=;
	b=TdXcMZNt3Jeb8e3Cx5EeQMoIZGMZqjFdQDKEuVb/KeJWrE5ATOh4EIoHIBzXMrCKu/W/
	 ew18DrRwggK4bIHnY9QTMHIOS4zTZzAT4cdSfLNDJROHPF4h12uwpqiKjrNWPlawMKaNi
	 4/OK3DiI5ZV8qqejrCddh/SklL2+AxAwF1+R5QTdIGSnn7C6d2kxv+3+AREqadiOduM6t
	 y1UJfTd68IDjrvCCPUOrzr2Z3LMUM6M4ZPRRGhHpbM4JbKa72zH9ruG5AAhIBZb0fa16l
	 Q78g752BIqikth8ZSkAwYCxCQj7/G+hAFpm8NbxNA/bOV5zdOtcrvk6Ja7k+o0ObkOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1koZNFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921F5606A325;
	Wed, 18 Nov 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1koZNFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A681F000C4;
	Wed, 18 Nov 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024210;
	bh=PlO2ftxL+LTWUkacD2QdJ97drJ026WBmH+nsKL0nZ1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1koZNFn7HmdpP6J/XAw4Bv0HUekNS6mWZD2LwRhCpyrC3rm2AWqjxAm72WChZP1u
	 XNN78+XnhRQT7E5TsLuD0v5/PtdOWxWYn82vFmnelJd2qOFdA0OJzfMI/I5k7Q+uCc
	 oPKi/NESrwC3B+RnPhSR3B0nky0zGPcDpSGEVqCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0642/2151] swim: Simplify return value initialization
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118150145.244040748@linuxfoundation.org>
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



