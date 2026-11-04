Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829311;
	b=noCVgS0uJTPO1SLmK287O7GzKxLKP2CZDGrtW/nB1kWKJYO8gchfAHeoyvCAZQsQWGNu
	 urIcmEYmR29ccgKNgrvbwWt24ODU/W0bjIqzfFdTNWurBEet5BtYDwxojDdT3/7YlHRe4
	 7MxlQHBqut/x3OQk5ZFf8Zcb3IY4VlY95YwWQuW2l/Vs8DtcN/RCJxKkmFCNDAvVhEqHx
	 Ly77DgvlOSjgAMBAg4TCx/2wkgu1Q5F5ahuoHgcJLrX6z5iFEt1ooflTunAK+kALx/TX3
	 jdaJIELEvuEle1kpYgP2oBjGCiBNF2gSW27AbYkX38WE36JTqpZT83lHi+3iBdYxJew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iVBYFbHQzqSZ4Gh9Zws8VXko+LgwYSDMd5Iyew8hJR8=;
	b=I/8b3jxE3jPzSmYX7gpr5nWap+jumPHPFmVv5b3Oc0oEWnIJLIw0xd1BRL/48UclKnme
	 bDie/INARRTAUGqKJeT5+4fRY9OM5HEEIYOGDRSJnxOwjivelEofIBDqdHyfZOU6nyYqu
	 fj8cJR43ktrfbt8RBDYtpfxxFO6OxHPhJYcL8uc6TY7czdSvUH6KzN5OBllRbwMVOmcKX
	 +F2tAMBqRXYwFZ2A7+a10EC8MQwj2LmQg5ZnkSz94j22AuOzKLG20iEClpNjrWH3b+/UA
	 RrSxKj61k4judjTxjtjlBrL6gbmVN5wekLctdtRtbJz9+pRAUsgCsHNML9dAycfujRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjSP69QA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8766B6074918;
	Wed,  4 Nov 2026 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjSP69QA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DA61F000C1;
	Wed,  4 Nov 2026 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829311;
	bh=iVBYFbHQzqSZ4Gh9Zws8VXko+LgwYSDMd5Iyew8hJR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjSP69QAT7gBU7aUGcq2DifJJfLn/9mR7AqZlSErp5fLVRsZen2LD4PGyo/NjY/Fs
	 M7wWOWETiuhUpjfcpxK+u11qLyVVcZTgMRAGe1VbXcpIg9oV50tS1Phttn1rJUp/+b
	 Y3AAoRVWNk2qup6gXPUI3MeN0gYG8I9GBhBUN8ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0045/1005] perf/core: Fix kernel register info leak via hardware skid
Date: Wed,  4 Nov 2026 15:56:18 -0500
Message-ID: <20261104211044.846806371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 166f10836a653dfa280d4335603b52f685b8b1ef ]

An unprivileged hardware perf event using exclude_kernel=1 can leak kernel
register data to user space via PERF_SAMPLE_REGS_INTR or PERF_SAMPLE_IP.
Due to hardware skid, a PMI may trigger after the CPU has already entered
kernel space (Ring 0), bypassing the perf_allow_kernel() privilege
barrier.

This security vulnerability is severely exacerbated by upcoming support
for SIMD register sampling via XSAVES, which could expose sensitive kernel
FPU states (such as active cryptographic keys).

Fix this by ensuring that sampled register data is dropped if the event's
exclude_kernel attribute is set but the PMI catches the CPU in kernel mode.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/20260529085613.CCAFB1F00893@smtp.kernel.org/
Link: https://patch.msgid.link/20260616044654.3468742-8-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9007f2b36c447..469f89cb92f11 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7500,10 +7500,20 @@ unsigned long perf_misc_flags(struct perf_event *event,
 unsigned long perf_instruction_pointer(struct perf_event *event,
 				       struct pt_regs *regs)
 {
-	if (should_sample_guest(event))
-		return perf_guest_get_ip();
+	/*
+	 * Hardware skid can lead to a scenario where a PMI is
+	 * delivered after the CPU has already entered kernel mode.
+	 * In that case, user-space sampling must not expose kernel
+	 * register state.
+	 */
+	if (should_sample_guest(event)) {
+		return event->attr.exclude_kernel &&
+		       !(perf_guest_state() & PERF_GUEST_USER) ?
+			0 : perf_guest_get_ip();
+	}
 
-	return perf_arch_instruction_pointer(regs);
+	return event->attr.exclude_kernel && !user_mode(regs) ?
+		0 : perf_arch_instruction_pointer(regs);
 }
 
 static void
@@ -7537,10 +7547,22 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 }
 
 static void perf_sample_regs_intr(struct perf_regs *regs_intr,
-				  struct pt_regs *regs)
+				  struct pt_regs *regs,
+				  bool exclude_kernel)
 {
-	regs_intr->regs = regs;
-	regs_intr->abi  = perf_reg_abi(current);
+	/*
+	 * Hardware skid can lead to a scenario where a PMI is
+	 * delivered after the CPU has already entered kernel mode.
+	 * In that case, user-space sampling must not expose kernel
+	 * register state.
+	 */
+	if (exclude_kernel && !user_mode(regs)) {
+		regs_intr->abi = PERF_SAMPLE_REGS_ABI_NONE;
+		regs_intr->regs = NULL;
+	} else {
+		regs_intr->regs = regs;
+		regs_intr->abi = perf_reg_abi(current);
+	}
 }
 
 
@@ -8428,7 +8450,8 @@ void perf_prepare_sample(struct perf_sample_data *data,
 		/* regs dump ABI info */
 		int size = sizeof(u64);
 
-		perf_sample_regs_intr(&data->regs_intr, regs);
+		perf_sample_regs_intr(&data->regs_intr, regs,
+				      event->attr.exclude_kernel);
 
 		if (data->regs_intr.regs) {
 			u64 mask = event->attr.sample_regs_intr;
-- 
2.53.0



