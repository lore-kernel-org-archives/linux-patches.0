Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585844;
	b=OsX7MJDSQ7qFMDVxYI1ZkS4UcbQsen/PdoP8a6LmvfIBYMxmjCx2a+8ZUct1jTKddPHN
	 hEZ/wWh3IIo7lYnqtOPEPSa5uYJ6FpzGl4M9tS7XElG/MUR9eDUrJQVx7+NkQXlMSqCMH
	 /FkQAq8n6ro6Sf2+LBybMy3yG4NCmxteDRjWZihdqVvbArsx8zF0yKzGf69VvHA0N/LIO
	 wTpvjVNSL9rTliB1WigCw6rOv+vt0ljzQZd5950CCmSxViXADsT4HXRXB/uSwZ8fCUB/2
	 0mWAGrtVKpzs0R50SbYoUrMMrLIdCSlszvdxned0l5MUwOaWy12Rl7cyjhPcu2PljZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iEa1OEnOlqs0P4g8dW2EcwKS1KFugKuNcAgWJruO5Y0=;
	b=VhYHJW65rKKd6SkiEwwA7V4QiLNEg8am5EwvPI3njE9lJ4shPqzXN5+1ObywjYq66gf6
	 U8yRpDR6VUOEvvcn+MRzx8bXLaqADHuuVaYIGFTJH1gMgdPUqJ/eTMvyArelLmHXUBt/d
	 EtJFG02zuwxOJvo258LCGu5zQBBWBahErUSj7/xKDsudxJBNdFgMYopPuCXa4gGaPihtf
	 KmWVVIA1m3Toi49+e4HUZUZVHbJbkVCsjPIz21UOb1nqM9H+6KIdDM/8zCbWYpsbbP6rZ
	 SGklzkY7xE8ys6z8rt5lHLrFe2zCMcXv4IXrYCmM6BUrW/Pbnsf1Hc+9tCodvAb4vhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN3nErfU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEEE606A891;
	Fri, 13 Nov 2026 16:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN3nErfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5D21F000C4;
	Fri, 13 Nov 2026 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585843;
	bh=iEa1OEnOlqs0P4g8dW2EcwKS1KFugKuNcAgWJruO5Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gN3nErfUom7YNSJCeAYKcRG3WWFOBrpGJtQ4rnjtLrji1Qs3ri32/g8Yj53A9JvyY
	 rfw/aSUWFRFNIQ2fAHq5+CAeMhoTVpg7QNre3ZnM6npHsU6kJwurR0btmEy0gElPey
	 2VPaYy+hrtcogiOHG57b/34PWwBUFMVDS99SjwS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 422/507] perf/core: Dont send SIGTRAP after exec removed the event
Date: Fri, 13 Nov 2026 10:52:06 -0500
Message-ID: <20261113153811.051992904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index c4217c996f5a1..9b90b6831de7c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7634,6 +7634,15 @@ static void perf_sigtrap(struct perf_event *event)
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



