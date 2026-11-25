Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623253;
	b=eK7igFXNJS7n2CooD2l0DtwAXi5GAGWo1IeDsmrSGyFM6F4NojLurOot8CgdifzOSYeN
	 5FijjHZRZpfBa0thrHWEK1EQ3tSU6VKERmhOD5lFM7edUfe5A5sMVYOrz+TIadwxHgQ5Q
	 1QsOn+NJu83+samFjhC7SEsbN8K7gmuBzfsCZf2/N1gC3M9ogeHwj1O3v/ZKicdKr+q8K
	 5rZHMhQ+CPdVzZVJfnoclasN1cydAL0l4befM8N4rwsBBK8Y8VqbrUhunU847Qj0T4VSW
	 zOtCuMOkRGGTgB90DDIF+pOKcUr9DWvZ9Y20WB2Z8trU5ph/NMHpEcC3zbR/oDdx2DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dvycjd9vPF9Mesvj4PRpFTALWE0ctSfDIYQaHwdVD4c=;
	b=1Esvzq6DXRjYzr7jGUL2doTOHwhD5wmWkBN1DP4T818Utyj1vX76rTYnl9jY7XbmA+Km
	 MWnuivZgxZcYst3EmHkz9951Z/dAI7gAbWK6uOS93qrMBOPVszn2aHFwM1NWJ9mSyZtjP
	 6VcC14DjsFKF51VjRvAgMl9kT/4tFlMKaFlra25yMs4kLwVpJdFYh4uCuW7xIDp2pMWS1
	 6z35puDH+PT36PQdVpDHHa21dM4gf9XWPm3EEctQXvbpFLq9lnyWjX6X5o5aEuI1zsgKn
	 AuvqSR53ADX4lEHdMdIJfERRTrXVeYmz5LBNOXxCbvX1Jq20agBz0kVeaFP+CrcyF0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yrrhArZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E07606A31E;
	Wed, 25 Nov 2026 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yrrhArZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3401F000C0;
	Wed, 25 Nov 2026 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623252;
	bh=Dvycjd9vPF9Mesvj4PRpFTALWE0ctSfDIYQaHwdVD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrrhArZ/1JN28SBd1N3+l2858zOObI4EdK0WjAOleUEzHBDIM87edUL/O5soNBRIy
	 71JpETVDbyeVG2W4+9o85mPKNMaQSwA2AieWLnH36J5oe6INNqYenn+QuZl+tQhpgq
	 iGRQjXn2UTktf7Y1RdfR93AX/SwBqL4weOZ9Mrl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Nigro <nigro.fra@gmail.com>,
	Paolo Bertinetti <paolobertinetti200f4@proton.me>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 800/990] tracing/perf: Clear stop state in perf_trace_add()
Date: Wed, 25 Nov 2026 15:36:07 +0100
Message-ID: <20261125143840.785561713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


