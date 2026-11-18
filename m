Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046530;
	b=pjUx7LflfBD7LgFhGwTBSOjc+ZL35zHzo1h4IM8pfGchRc+JhhRZCfuGnfwfofymGfJo
	 l6+i/sd8LgrF0cE/8RDYfCgu3iM1hn9CYVmSD7VLG12jmMg4HOtKIeQ5vbhXV+42DqhiI
	 v24RTUCPs5G/GJ+1pWDwikqJogoYMC8KMeSu9clrxc3bK25kYvBWACr0r9P/4Ku2eUBEB
	 6RwVwisU6t0Xtvk7Y2GtsGvcwm2otam13as7klp0ziP9zMzCwVPnOXdfbrz7NgLImiBGl
	 n6ZTTKw2j5nxhcbOdZkxIu7T0r5uFI2sIgCil9vAWYNOwSVn4LQi3aGJwXybBFavkgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LtyDzq7beStkrefqiP0d4zA7ql+fjvMOoN89GfOrg4Q=;
	b=emOZQgt8HFkPn+D4GG2U5dqZlNtAeScIFFjJM0JLYqeIcfii+SWFSOfh174igLEIY83R
	 N/t6Kde6BsGVrTBRIcXMVf9C3KD9oyHwoE6HX7DOCPHLjbHP13ZbgmDfchDyilp5Pgt/S
	 KuapGSVCB1Ob4+dA8AolhyCNXHoYRFZd0u0qNbDQK1fZrz+4SeT9pkalUI3q3M3AblFun
	 5RZ1O2FIYYSpBiL9O4ObUBvGwBap5j+Pxhx+hlqdP+TKoqfqyQaeSapeQ7nvLkRuwc0q0
	 2XAE4Aq4BYufkV9hxluwtG8bhsBJIZWOojqLdLgrDxPIT+/rDJIIq3IYfzPhzcPEQgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF+1ti0n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F9460A263C;
	Thu, 19 Nov 2026 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF+1ti0n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF5D1F000C7;
	Thu, 19 Nov 2026 00:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046530;
	bh=LtyDzq7beStkrefqiP0d4zA7ql+fjvMOoN89GfOrg4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF+1ti0nNP0Vo+6Wbkk0ZHo5mJty92FQx7PXDZHNP/iKf0LRyG1CHeufMHrQbWAyi
	 WsAYH8iXqKW20RYcHa1xnQO+XbxFansrCjJxylusa0b3kPe5HMBi8V9pOOhHBUe78K
	 gED4VHsdy+hPuFJi9mzqeW16aVibKPXdhBwQWJnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1314/2857] perf/core: Dont send SIGTRAP after exec removed the event
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118150248.768502836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 6f083fbccd5f06889bc08e1182bd02c0383b9121 ]

A sigtrap event must also set remove_on_exec, so that its SIGTRAP never
reaches a program after exec. But the signal is sent from task work,
which only runs on the way back to user space. If the event overflows
shortly before execve(), the task work can still be pending when the
task enters execve(), and then runs when execve() returns. By then
perf_event_exec() has removed the event and the new program has default
signal handlers, so the SIGTRAP kills it.

The exec_stress test in the remove_on_exec selftest catches this and
fails about half the time in a VM. A process that opens a sigtrap event
on itself and then calls execve() is killed by SIGTRAP in 15% to 50% of
runs, both on an AMD machine running v7.2 and in a VM, with or without
close-on-exec on the event fd.

Commit ffb684f2aa14 ("perf: Fix race between perf_event_exit_task() and
perf_pending_task()") made perf_sigtrap() return once
perf_event_exit_task() has set ctx->task to TASK_TOMBSTONE. Exec only
calls perf_event_exit_task() when the new program is not dumpable, such
as a setuid one. An ordinary exec keeps the context and only removes the
remove_on_exec events, so the SIGTRAP is still sent.

perf_event_exit_event() sets PERF_EVENT_STATE_EXIT when exec removes the
event. If the event fd is close-on-exec and was the last reference to
the file, exec also queues the file release as task work. Task work runs
newest first, so perf_release() runs before the SIGTRAP work and moves
the event on to PERF_EVENT_STATE_DEAD. So don't send the signal when the
event state is PERF_EVENT_STATE_EXIT or lower, which means the event has
been removed. That also covers PERF_EVENT_STATE_REVOKED, where the PMU
is gone.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261015152013.106040-1-danishkhateeb03@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1e9d9b77c10e2..ca5009e11b022 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6586,6 +6586,15 @@ static void perf_sigtrap(struct perf_event *event)
 	if (event->ctx->task == TASK_TOMBSTONE)
 		return;
 
+	/*
+	 * The event was removed after this signal was queued, e.g. by exec()
+	 * (remove_on_exec), which may also have closed its fd (close-on-exec).
+	 * The new program has default signal handlers, so a SIGTRAP would
+	 * kill it.
+	 */
+	if (READ_ONCE(event->state) <= PERF_EVENT_STATE_EXIT)
+		return;
+
 	/*
 	 * We'd expect this to only occur if the irq_work is delayed and either
 	 * ctx->task or current has changed in the meantime. This can be the
-- 
2.53.0



