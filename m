Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060761;
	b=a/UhFHaei1PSLQmDzPb+7eeu3aCWL5YOP+SvDAgxKSIonJDKyiLjO8VHOFaKfLujw5Ds
	 eHWg9YC8DbCwHLWf8vXfgao6BogSVSuYW00Q34yq5VDoadTgCQG+K2ZueVDEuPhNvcZum
	 q+pbrpTkICk1/0OKaKEnNw034Z7zuBhXeAsXVMUQBEbuhZ2T302oNoa/sccz7e1Y3hiQd
	 81dByNsm7Ydgm+/clAFg6jqKoS1NjC3QVStPsf5Fm1u37hPOA9NZskvBjRLk7iQ6Hl6hm
	 dH5ZW0UD5dUpBqmamrCdLMAqoGjGkDQLgGVDe/89uYoL9mx+jE4ca2etEBkYqdZPhxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JkI6clri1gpLwSX7a7FA0OtVu57SR2+C5rlwOuzKpEA=;
	b=eZjODYr7SCY9SOOYdZ08VU2RvgmnFmJmmnexwQATs+dt9SswpqLVe/gZjQVWBo/L47dB
	 +3x0c+4Bi/GdJQwdpKO0jjknmqNjnochQaVCtlBofhFwhOALsP6qI3kUZXeyng+jxRUgW
	 h2jBxcTEP+Xwd7uP0xI9KDW5yjCdLhGWyghBHfWrZI5BIm+/A2w86G5XTMPU02Ho834OD
	 cUgyigddnJvJdO8elLsgONo28AJtbUatfm5ZWce8ZO4gt+Ek+gMvSc8VbKpCAJK6hpOPu
	 LM6gHCHvXyB36TRWjkAUz2YtOBnLnTp4mKoUNcvmHuNNsrcIm8qZRjntdcTMwPEGFBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Phr5n8Fp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1843606A320;
	Thu, 19 Nov 2026 03:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Phr5n8Fp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCB91F000C4;
	Thu, 19 Nov 2026 03:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060761;
	bh=JkI6clri1gpLwSX7a7FA0OtVu57SR2+C5rlwOuzKpEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Phr5n8Fp3Fs2h/RjWplWHI3gBcY/Pa1+8lqt3hjNbv7BwTl11MOLRIEDg0rHJ4NmM
	 171hlYEBnQiluZFS5uPwZaOz+t+JHZOmommNRc69NxMBBIZ6Y7BJ3bOedORPZbVXuC
	 o7adQYnStzQzaZ0apGSFTfpBoUVFQyrJPpMGNhOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1314/1848] swim: Simplify return value initialization
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150014.486803971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



