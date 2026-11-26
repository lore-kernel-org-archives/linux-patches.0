Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705341;
	b=UYigJ0Kg/Z4gzcA02n7hl1pj00nuzAlKgnUcZjhWGymbQXm/xm91w6pbRZGwhsbZ9l9a
	 3PMv0mKVGCbFXtAv3nV9AA95HU1kQO9Nux8UuB8ILLgJaKaz97wpkAseT/XqWPU/ysN24
	 cB+FRN5WqlH7+t1rCY1AgsTBVRMZh4+C/dt47Bv1MFxt437fqfP7uKoa+l9ONNJqOlxFV
	 Eq2e+6DuY74ezgb2Y1Lz3UTQhTLNjIwLT1UkthiY4qik1GWD2GFMXkXdGmMTacoqQroqB
	 MJ5K0C5fkX4sk1vqviRQ0uOQEv/xSOubyMsrHd6P/JfzNUFqRXiBQpFcQULxSIMXLdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JlOvyv9Ph4cgJ8pHcTRk097w+NMhwnIhv6tpn2ikAxw=;
	b=QWj5aGq40tp+uVKqEjmuRAEfNHWikGjrLWDPg4TviCLb59FjbnyaT3sWsZrU/k3MUjLM
	 dxyJQWh0i9Xo/3deyxsOXT/AJ28ng29HVGNUYa7rDv0k8s/Dnqrky5k4LVoUR1LRfvsMa
	 JVp6brRvwi0y8l7Wp5VKPXM9rlHg+fMIsLl3Dg3gP4mNvqLID/4loel1ctVgVcMc9Snv/
	 We+3ckg1rdOO/wBPfuEck72QL6hXEhrTK9z0oeAsr4kDAqkImFz/HgECFUEazc1A6IDy7
	 bNBAh57wcHPnZJyoE1MnWWnOa7T+g1joGJl6UpDCNhbigbGS1Dy1MtYyP60BN/72+nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2wCabPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54CF606A33B;
	Thu, 26 Nov 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2wCabPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FA61F000D1;
	Thu, 26 Nov 2026 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705340;
	bh=JlOvyv9Ph4cgJ8pHcTRk097w+NMhwnIhv6tpn2ikAxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2wCabPf9LZtsJhfgG+/jVnp6szzJk6RnqARwq+n5r7QSp7sh1vURt0pK1aAeHq6j
	 MVS9FGHdsn8m/crXZKJIkKDVX1KxZH+6i5pH9B/J0zNsTCj2wUOqksTCw02GzeHq8j
	 tPwpcArHRSEprFiVTmz9Fq581lPzTU7QbCrcFG8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenwen Fu <wenwfu@qti.qualcomm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/319] tracing: skip boot kprobe setup when no events were requested
Date: Thu, 26 Nov 2026 15:38:51 +0100
Message-ID: <20261126144010.426534375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Wenwen Fu <wenwfu@qti.qualcomm.com>

[ Upstream commit 2388a673e9276de30c7e917fce50830e497d46cc ]

setup_boot_kprobe_events() calls enable_boot_kprobe_events() even when
the kprobe_event= boot parameter was not supplied. That call takes
event_mutex without any command-line probes to enable.

Asynchronous eval-map updates also hold event_mutex. A normal boot can
therefore wait in init_kprobe_trace() for this background work despite
having no boot probes to set up.

Return early when the boot-event buffer is empty. Keep the mutex
protection in trace_event_update_all() and retain setup for explicit
kprobe_event= parameters. Bootconfig handles its own probe enablement,
and the existing trace_eval_sync() still waits for background work
before init memory is freed.

Link: https://lore.kernel.org/all/20261106021457.2648231-1-wenwfu@qti.qualcomm.com/

Fixes: 970988e19eb0 ("tracing/kprobe: Add kprobe_event= boot parameter")
Signed-off-by: Wenwen Fu <wenwfu@qti.qualcomm.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 03d4ac41d9031..354ad90ceb68a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1920,6 +1920,9 @@ static __init void setup_boot_kprobe_events(void)
 	char *p, *cmd = kprobe_boot_events_buf;
 	int ret;
 
+	if (!kprobe_boot_events_buf[0])
+		return;
+
 	strreplace(kprobe_boot_events_buf, ',', ' ');
 
 	while (cmd && *cmd != '\0') {
-- 
2.53.0



