Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058172;
	b=ndjO2Xwr3YO6ArWdQQUz1CjNhNlzEP92L0Dr5WOBN2VGiVRGcEl1dS9EPaxQbdsngqFU
	 VY2+J/FIcYoRgVls09cLRR87hfhuTMIbw6DmhlYTOooY9SYetcrW7odzbgErR2uYfhaFK
	 x6z3nYbds1D1HMngsYfqEar54msNEkt4Wyx7HsqZpKSvy0FNJc4dHTsoJhvDx4E+FO/dd
	 ZASX/eqYKBuIH1mC2Bdjj1EUmF8agu6GT3Ived5J0Uv8sv0uvoFQGcJi7IUQNQ2dTdcUq
	 N7ESU1C6x1bAwLoXNJdwuMw+meEZc+D8Csnxor8dOnyYKuArYQlrQ4ni5YpLQlBfBGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1k+YlLXj4JyTACJmdgk5vapkxj09+yFG6hSibk3Yo2U=;
	b=EPib2x8762slCUvnOEFs0NjuI0AmjTyxDryZp+mbBJPFoxZt5qWrSzc2ZbFXu540BdXe
	 41H1zp1VkOd145gZ9tnaWpFwQrzSBmXHznH2GE7ZoJkk1EVXKMEVzCX2nsNxxtWe7Q1Fn
	 6MLbJsugAl8n9m3HikNk/Rx/+znJSjXlq/GCEBiwrO6CuR4/gwIaA3FGak2eB152YwNPY
	 x1ChmplS/98EcJSsHT0coprU3Bom02pwr7BKKoBD3nYFXVBBzMo6Pl7y/gXORF/ZXWsdE
	 sHcmalPC9zVB0jR4z7zhBF2j+k7ywneGRpSG1nbE32LGrWuZ2zSRd5o3I527huh8M5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDUgQr5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF6606A31C;
	Thu, 19 Nov 2026 03:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDUgQr5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF55B1F000C4;
	Thu, 19 Nov 2026 03:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058172;
	bh=1k+YlLXj4JyTACJmdgk5vapkxj09+yFG6hSibk3Yo2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDUgQr5U7s6WPjBlwIiKE/Mx2twKkNLUgOPnkuj7qQe4sKx+3KUswxaMdQmI6jZYA
	 x6QR4zRdLWP/AhbZl6lZTpaPf80pIyICGgF3O+/vKn+JUzvCTcPnm13FHx3NZWC4GM
	 rI9yhooct9G3plcDqQuDmUf9o14L8D3KiGDLjUa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0354/1848] microblaze: reserve the ABI argument-home area in the signal frame
Date: Wed, 18 Nov 2026 15:39:52 +0100
Message-ID: <20261118145927.576823955@linuxfoundation.org>
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
index 5a8d173d7b75c..1a41f7266a000 100644
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



