Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061918;
	b=4OhJE7ffalo2JykxEKiwjBtVnVIXH64Osg8Xo237GFDs9xAh4T8G99CvIwgDSjSpixeS
	 oWpg7mWc5d/+TNeq3D5PLHHWQqqVmHUTqvwpCtLNv0fVnOrNF1vzhXcgc5GhWUKKRWUTZ
	 k89jt+/q+HdkKbW3OLJwne38hi1rWOl0KryXjETMuR7jag7a/sTfzYWBc7Mp+ZHL5mqjl
	 wj45hHAQOG4i/myQEp5dlC9VsOSoLRwdcQCZ+8cRCtWU+JiVdb1b8gubvvbup3Tgr/lib
	 cFvQwLwMRfyWBYTlxZPo4EWhaElom/E2cRY7peBf0M9aQUEh0cRYJP531RfeCXC9pFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o+ZqTGIK9AZwOwQv3xOb9zvNJHU0a8O9/2oMzEodfrw=;
	b=4QlNRO3BaQwM36LZiRoSFThC+dWu2j6XFO1xYK5dRPyXdAtgr7MWHXWbmVBLRw4PpQjT
	 MrupVdyG+rVDjaGwzIVEyP2fkD6C1fnU+1kmw/pHNJ34qHTT5uTouHR6jiUocTvfvSyvI
	 F2g6ftU+t3Q0m/FC/NSoQO/AqCgOxF6DqpT1tb1m7BOZ6lRWb8SmopvuCsRrIhl4OJBns
	 6NIkp0lyLGo5OZ2VE+MLr9LvGwjOYyHbevS2VE9gbz29DE2Huirh4lftjwaC3p+AGiFoW
	 bNykDibVwICPiswdZlp9l49XZursqj7zxMbuH6yQNEwktkY8CMLW/p+qWg50usEW7CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGNb4oCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68BB606A334;
	Sat,  7 Nov 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGNb4oCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D07A1F0089F;
	Sat,  7 Nov 2026 14:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061917;
	bh=o+ZqTGIK9AZwOwQv3xOb9zvNJHU0a8O9/2oMzEodfrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGNb4oCjVNwlaTppBmgBZW6yt9XgPpq3ySWLGZIkup1EuLHS/m7vVvMYmZsqpHq53
	 WGOccKw7uLnHthPpIgwd3gOH2Jdqt0sJuxYd8Bm1xOTJzGbSSGb3FxgSs7t5NTC7D2
	 3j0fpvllF+QHG4+voTMF4s0BaGv1rzr+eajoFLw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramin Moussavi <ramin.moussavi@yacoub.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0907/1536] microblaze: reserve the ABI argument-home area in the signal frame
Date: Sat,  7 Nov 2026 08:48:43 -0500
Message-ID: <20261107135023.110043091@linuxfoundation.org>
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



