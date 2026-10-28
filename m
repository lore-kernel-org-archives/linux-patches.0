Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213070;
	b=Pc0fwJwY8NWVo4hD+ha4KCxBljHJ7vu22iclIp7Sf8r9/zJn6IffgqMOsxx8VOyE8Hdx
	 2+S6EGrSFl0qHvGtliHkUzd3DB0pzPPBvgTrcUhhi6vmOSxGAK47qXWO0b5WgnkoTYIRb
	 YdPmiNJ9uiHg5BJeK6lG7HMDIDVwkvLa7i/RUBzscwdgeelSAiZkCKD4C7iFY+UDak4oh
	 o1VbQX1k4BAWyUDwe3t1RFx4Jegv8nw8/clxxMUYPS/N0+sJYW7vFlw9fBAiFeHkuNj+8
	 I1nWem86+yja2EK9SdGGaLexbFK+oRs7B7IiKTk/ITrS1JGK3bFj5c76+sZkPHeRm6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/R1IvK+8dPpYNUIlsGHyKm7etV/+HUmnkvspfeqMqLE=;
	b=1Jroo17o2jBHPpm7cpE/pGlzR0vnBbxdDJZzZ2e6Zycfki/MDjX7ukTeA/d2+OhbL0pi
	 wZx1Kobltb7xWjFDu4rUwhKKY1ylw/O1m7QKvYOQajf8uiS2ye30m++XVQOhuJwozUl0a
	 f2HPsMj1gqN/dnIqhVDknOFGQo01dBPp70/mW3Xvo9npdt2yO+7W7K1pRGSrS+LF09muh
	 tYyoR8NmO92NgF/x2sghUJPC+az4uZ+0/l9YpV17mr0r5PiR8QzgdHOYwhqv1VDz00qLg
	 KBlQuH8rWJJ6eZy441ccPTC2GSx8chSFuPzwvk+SEdPppkf3sVuBfkFzL+YsVtUW/oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXeBsx9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0872C606A31C;
	Wed, 28 Oct 2026 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXeBsx9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C541F01825;
	Wed, 28 Oct 2026 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213069;
	bh=/R1IvK+8dPpYNUIlsGHyKm7etV/+HUmnkvspfeqMqLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXeBsx9jfp+3R4Zo/KvdX7JrHuJnFAy+OcXGX8LQLPvFLR/JLFBPIzt2Ao4sUvhn0
	 8Fd3ecrlT+8QaB90xgJKZJhsUiuA+ecg5vmy9p6cn9Rq2KkFeTpUi7rSt29nWPDK34
	 wEpLa99YUAjQFu6BpyaeUjklrZphovnfNX/OV69I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0375/1887] perf: Require kernel access for text poke events
Date: Wed, 28 Oct 2026 17:41:11 +0100
Message-ID: <20261028170507.766246371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 357e8a77a501d96c9517f01f4a211eed5e9c9184 ]

Perf events with exclude_kernel=1 can be opened without kernel perf
access. However, exclude_kernel does not suppress text-poke sideband
records. Every PERF_RECORD_TEXT_POKE is marked PERF_RECORD_MISC_KERNEL
and contains a raw kernel instruction address.

An unprivileged task can therefore open and mmap a task-local software
event with text_poke=1. Both opening a count-only tracepoint event and
configuring UDP GRO for ESP-in-UDP cause updates to inline static calls;
the observer receives the relocated addresses of the modified instructions.
For a known kernel image, any such address reveals the runtime kernel
text base despite KASLR.

Call perf_allow_kernel() whenever attr.text_poke is set, regardless of
exclude_kernel. Events that neither monitor kernel execution nor request
text-poke records retain their existing permissions.

Fixes: e17d43b93e54 ("perf: Add perf text poke event")
Assisted-by: LLM
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/99131354c41e23188f778b92f90363775b482395.1790573390.git.zcliangcn@gmail.com
[ sashal: adjusted context around the simpler exclude_kernel check that calls perf_allow_kernel(&attr) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 013c3a4afb8a3..a64e0254e803c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12458,7 +12458,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel || attr.text_poke) {
 		err = perf_allow_kernel(&attr);
 		if (err)
 			return err;
-- 
2.53.0



