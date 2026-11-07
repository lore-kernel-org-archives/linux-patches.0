Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062780;
	b=jxVIR8EvogM7MXQSkhWC8gxcqva3NhqH+Qe5MyLWwete7LCKSJ7Nsn9OkHoaVa0UtoIb
	 9FgU1MbbmzuHi53fKeq/S6kjtbT7zvHRFdDgj03JlU3pIUJFGTtyvjWqB3feFVj3OGZqr
	 PlL2rht8H2nof0c73jIGx94L1DkZIYoyCDwCSpooFjAdzKyXfZEiG9FjRBGrI9RSRQ7CR
	 o/Ge9XO0uYBoIHFu35gQkwewDGWOHf8rQjA1mnvbE9IBQhdwCOveEG58yfZqZFIKZnGgs
	 SwUrF1tiiVxZolXnrHoG84CZGtQzz3LCpvjLazbebapW5SYAFppdIBNMkmIf5HWvkTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HR/oOHvyPVdysJUuiIZdcdyV/u+fKOzhIqhQ6E9Dyck=;
	b=j3sRLwcQxf5TUG5n+QmGxh8JEnN6uyqwsFtbA2GgyYcSKjXWfGLZ3vSSDAHjN5npH4kh
	 IpZ/iqTRGjJmjYMKkovj9kK0Kg50K1Cb6wc6BC5FZj/SAteiY1iGWAVLFkP/SMFJNWxEm
	 Gnv4e1cRcMeofimUczZKxq28Eso11jShYJhRDPpS2buPh10RR4kS5JOLcIBirKluixo+3
	 hn6ajBboD8fU/nuDZmqdOXe1SrCxVYuQSI7vKxnjb/w+07OYnGj9KXrwGNzpJ8oiFoLgH
	 Xmfoqwsb4AgOSp43/LAOQNzGTLOA/a/xEp/TJctDs7pHCZ4gYv2ZtbH4wGizKS03WuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mTXSIa7o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037C2606A326;
	Sat,  7 Nov 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mTXSIa7o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69E81F0089F;
	Sat,  7 Nov 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062779;
	bh=HR/oOHvyPVdysJUuiIZdcdyV/u+fKOzhIqhQ6E9Dyck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTXSIa7ohgbuVhVcaO+pIgvIPfpIn389nCayES5kv044dDTrhH/gqnSyugTfmyijW
	 sQHOMsTaQbkI0ohho4b6vCqEv6np35FqWQpkAd3iHLtFVu4gFz5nNJjvtriJ3bVAjM
	 TF3O12vLCl76Gws2N5Bgu7akZM2CW8RQ0qlmYDh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/869] microblaze: reserve the ABI argument-home area in the signal frame
Date: Sat,  7 Nov 2026 08:45:31 -0500
Message-ID: <20261107134853.761585314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index c78a0ff480660..4956014a99379 100644
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



