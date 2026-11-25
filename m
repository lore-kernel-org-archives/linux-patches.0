Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620022;
	b=EWrvsbLPs8+CyEoEhzLnuPn3ETJcBqOLcgtI3k6fmYT4DpfYy5xiUet+sxnJeEbWiIEN
	 KNj+Z+Vf9k4t8OlSmcKNdulODY5mLDfNUcSMwHX3JQlwvgSH2LVsHudxkCEyXPbAUyNaR
	 UIvkkjww3L70a+ssRlER6WPpOXZE71JlZEefo7M/nmcTBI0suAs26sEba+8ARyXVy6oI3
	 NraJbZt5P7+k3CvWKeTHCbPqS96l9qrNrTqs9WAjSycwAZXT3A4Bb9AOKRUODTemuf0A+
	 nblGvsaTnzu3QJKxxLxyaGEdoHlyqwpQS+0HcyZef/MmAHM4NN4CCD1bd+30HzBu4dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=obs5R9BO9yehVkIeEZU4uXhhiHwjvc7+dIa9TXRXIiA=;
	b=ZUp4VyvvJTI2isIVh6/RRogS8NcZxkMKtlyM9pmcdFpN8v1SUrkj5rz7pNNnETlbuLMN
	 sLR5LfAmTB//RKzx6i4IVHuKbTQnc4Quo4ZMxP/H2aDYwBdqT4eW3qsfocVTXkyGsZolj
	 ZFWsvOJG53/L4NGNfQKWwgHVXDMYPIMxIWm7JuII3U3mDLrmYgMFzar3MpU0HGB+b0ImW
	 LaUydj6nhdw9wwqtf4isEE5reP8Jpng3Ksu3hzyJJPyoz9IBjtrOf83yd52blCi5h1jeE
	 Pg07xeuz59vlJJZqLrfuLEo42FhSaiN8aNOx5gODB0I7N1X2pgo3sYigcyeAp/0PGRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FV3An/6H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F50606A31E;
	Wed, 25 Nov 2026 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FV3An/6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C551F000C6;
	Wed, 25 Nov 2026 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620021;
	bh=obs5R9BO9yehVkIeEZU4uXhhiHwjvc7+dIa9TXRXIiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FV3An/6H94y+QXt6B3Yse2MxoolWs6q4YiO6K8GaHAdZRSL9zAxtOvLH7bwnW6F6I
	 pp6zfTWTtsi5hRf5s6ek81gudzZpR8/0RLZMz/3ehxipM9o6bnb0Hpp5jzPelbhcjf
	 gnDK80i1cvvhfznOiVzqa7aApKKjHVc/xCnRY8jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Nigro <nigro.fra@gmail.com>,
	Paolo Bertinetti <paolobertinetti200f4@proton.me>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.3 0781/1005] tracing/perf: Clear stop state in perf_trace_add()
Date: Wed, 25 Nov 2026 15:35:19 +0100
Message-ID: <20261125143840.036812839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bertinetti <paolobertinetti200f4@proton.me>

commit fb3f6b21b04f1e8b8982e90e9bf62db9f0dcb5e4 upstream.

Since commit 18dbcbfabfff ("perf: Fix the POLL_HUP delivery breakage"),
__perf_event_overflow() stops the event with pmu->stop() and disables
it when the PERF_EVENT_IOC_REFRESH limit is reached. When userspace
re-arms the event with PERF_EVENT_IOC_REFRESH, the event is enabled
again and pmu->add() is called with PERF_EF_START.

perf_trace_add() sets PERF_HES_STOPPED when PERF_EF_START is missing,
but never clears it. The flag set by pmu->stop() stays, and
perf_tp_event_match() drops every later hit. A tracepoint, kprobe or
uprobe event re-armed this way delivers only its first overflow. This
breaks self-profilers such as async-profiler, and the "Event re-armed
with PERF_EVENT_IOC_REFRESH" perf test fails:

  1000 events, count 1, 1 overflows (1 POLL_HUP), re-arm errno 0
  Tracepoint event : FAILED!

Set the state from PERF_EF_START on every add, as perf_swevent_add()
does.

Fixes: 18dbcbfabfff ("perf: Fix the POLL_HUP delivery breakage")
Closes: https://lore.kernel.org/r/20261021131006.2101248-1-nigro.fra@gmail.com/
Reported-by: Francesco Nigro <nigro.fra@gmail.com>
Assisted-by: LLM
Signed-off-by: Paolo Bertinetti <paolobertinetti200f4@proton.me>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://github.com/async-profiler/async-profiler/issues/1813
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261103130732.764081-2-paolobertinetti200f4@proton.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_event_perf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -354,8 +354,7 @@ int perf_trace_add(struct perf_event *p_
 	struct trace_event_call *tp_event = p_event->tp_event;
 	struct hw_perf_event *hwc = &p_event->hw;
 
-	if (!(flags & PERF_EF_START))
-		p_event->hw.state = PERF_HES_STOPPED;
+	hwc->state = (flags & PERF_EF_START) ? 0 : PERF_HES_STOPPED;
 
 	if (is_sampling_event(p_event)) {
 		hwc->last_period = hwc->sample_period;


