Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052106;
	b=bEWIxkeTsNULKh+Y2d0iUtYAxljgNTMSJSfOSMbb5g1/1i8Uz0ykU5YSaQcAwXygb3Bp
	 SGcc1g4zgBJPk5QqEC9c+Jn0vtjhRetDRAWNxlPM9stweih1ZK3IquHcwT/PWaI3a9CXO
	 WPe9oyqheNZdvijX/yIOpHcfVwaNXviMM1WTUGyYz42780o/lQ0QRuQUy8qRTMQLU2JIV
	 sMkG0Q22kxCqDQ/DjR5F6yBXqCAHBL5JyHWQNXFfBhEMNK8ZR1aJvD267RObvYKHI6Nms
	 5U223rkN7YXnx8kXt9/my1cEoZan5+183nlpqg4j5fcvQSMXaduh4VMRKVzpry58eJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZdbDf1IYYjBaOkPlcvBK+8hHUODPvX7VnIFPIGF3pNo=;
	b=zzgsbHrPAYKhGUG9VknFD9vDEHgn52iTB6CKY6h5J+lRhEM+xURTOeBoHcvDPYAv/hFA
	 SCwJx1j58ytRMJWSJr1aeUAw+WtB9HWEkDBdzhyC0ZbdgvA9Sl6ovlWYyz5pgmUkUYRNX
	 IFHej1bt2GzuzBqoNsmBmcZio8j/ajylHKtlp+GwoGNtPx/43Nz/vVRzLRX1h8kKxetyI
	 20gFHdX2IOqeQhQcCxHVDVu33e1EQqQAl4SBZgSQSaLhYYOWLt1/jFWOs6nheyobZ1/3T
	 KmK1GZme2qhVc/mdSq1mBszhVOrOv6+Chm+PQThUcugMiU6m+bP+sQTWxLtDMQF9ZAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEFlFJcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D793606A31C;
	Thu, 19 Nov 2026 01:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEFlFJcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FFA1F000C4;
	Thu, 19 Nov 2026 01:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052106;
	bh=ZdbDf1IYYjBaOkPlcvBK+8hHUODPvX7VnIFPIGF3pNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEFlFJcWSRW5n5XPOIdBGGMSpELDWqPlseCNH8QnmxHs6CHhHM0kS5Q2Tr5pXWVUg
	 gONhDsLIZwh55un2VsC6rFLK+HqrZ534IR2X9inSgBZ87/cdRj40QZC4JOhjth1SPM
	 oAEdfxRTE4tvhbt3VBKScfU0d/h5D8A5z0zgOm/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0445/2214] microblaze: reserve the ABI argument-home area in the signal frame
Date: Wed, 18 Nov 2026 15:35:21 +0100
Message-ID: <20261118150028.881082990@linuxfoundation.org>
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

From: Ramin Moussavi <ramin.moussavi@yacoub.de>

[ Upstream commit c5947d28c20955de897eeb98430f96db0494f7d7 ]

The MicroBlaze procedure call standard reserves [r1+0] for the return
address and lets a callee store its incoming register arguments r5..r10
into the caller-provided home slots at [r1+4]..[r1+24].  When the kernel
enters a signal handler it sets r1 to point at struct rt_sigframe, whose
leading member is the siginfo prepared for the handler.  A handler that
homes its arguments - which an unoptimised (-O0) build always does -
therefore overwrites the first 24 bytes of that siginfo, so an
SA_SIGINFO handler reads corrupted values.  The stores stay within
siginfo (128 bytes) and do not reach the ucontext behind it.

Reserve the home area by making a seven-word gap -- the return-address
slot plus the six argument slots, 28 bytes -- the first member of struct
rt_sigframe, so the handler's argument stores land in scratch space
instead of clobbering siginfo.

Tested on qemu-system-microblazeel (petalogix-s3adsp1800) with the
uClibc-ng NPTL test suite: tst-timer4, tst-timer5, tst-mqueue5 and
tst-signal6 pass; before this change they failed because the handler
clobbered the signal frame.

Fixes: 2148daa9c45f ("microblaze_v8: Signal support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ramin Moussavi <ramin.moussavi@yacoub.de>
Tested-by: Waldemar Brodkorb <wbx@openadk.org>
Link: https://patch.msgid.link/20260821151809.1233057-3-ramin.moussavi@yacoub.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/signal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index fc61eb0eb8dd4..6989792d10e84 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -49,6 +49,14 @@ struct sigframe {
 };
 
 struct rt_sigframe {
+	/*
+	 * Home area for the handler's register arguments: the MicroBlaze
+	 * ABI reserves [r1+0] for the return address and lets the callee
+	 * store r5..r10 at [r1+4]..[r1+24], and r1 points at this frame
+	 * when the handler is entered.  Without the gap those stores
+	 * corrupt frame->info.
+	 */
+	unsigned long abi_gap[7];
 	struct siginfo info;
 	struct ucontext uc;
 	unsigned long tramp[2];	/* signal trampoline */
-- 
2.53.0



