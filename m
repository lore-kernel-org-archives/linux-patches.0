Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624956;
	b=Kyl+nQc7qt8kurggKewNv0HaTsoEMZNDHfMfYg44o1G39fkTB42usDW9An9Rec0F67gA
	 4pZw173w7lgtNXAT0N+/vgHB0x/xnD8dWOlx8Uiev5uDM3m7xsIcHsK7vXLVZ8dzLYBlU
	 nZ7ktofjXipnj+ciafw0+Q8KM8YoEz3QC8C7dBb7QL3JSAz8CCI4hWUNIcylxN/q5SvPu
	 WZt/eCapEE6pu86P1Bv4q/CPHFXkHRqYE2jrPmVbXtlqyGvUX7cwMnYYKhQ/bGg+1t9WD
	 eKS63W/Uo5I4SsFVv5SZOaSe5KeN0vIZDHvdAsk7z2RBPnTH5skGxIvfZvHQLg2HTPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cVr4QajK6WAhfaXAXBDLbo0h9pDj3/8WCgszEX0QTuU=;
	b=5K0eVh7cDj0q1cpw+xO/MOS1SElDRlZUpm8nS7EaM6p0I1iIYa3CNm9vkiHgtnB6XmM7
	 0SPy2tDmIC+VQZy4Id2sGGckEBRH+Gdh+nuRsMxoKk+g+n/wKcMYxUUk2NUi/mM8PSc0L
	 k3yYN8H/nSsXl84OoBKtGmz9cK2Ko79MJxx8nu62N3QHKWYQU2PvswAt5ZUSlA4VsHrle
	 Raf3ElSCHPmAGyICYyfNNyNJqXSZYKbJ9eBH560klLWv7hbb//bzlW0N8dHR6qsitQITI
	 qpYUx4xs1iQ7Hgq+SWdsUWGFv+MLYUSUR9D7Dhca9sRy1rMe9h49oMAoj8dxMJvT0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yFUY/6h5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6664C606A321;
	Wed, 25 Nov 2026 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFUY/6h5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62981F000C6;
	Wed, 25 Nov 2026 16:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624955;
	bh=cVr4QajK6WAhfaXAXBDLbo0h9pDj3/8WCgszEX0QTuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFUY/6h56XkxfI9x0qyykg3RyTEYrjCUdxs7SfdZih1EW7Ny/M5oGaisZH1wSpDAx
	 EoKQsu9ok9OasXzy5Hsa7VNc5hWyuDYbu756QMH+6+mXPPqtsnAzGwjis7W588vvAS
	 K9mC33dwYvbg0KTHygwm/MPDie4mW46Aj0WNzKH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenwen Fu <wenwfu@qti.qualcomm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/816] tracing: skip boot kprobe setup when no events were requested
Date: Wed, 25 Nov 2026 15:31:46 +0100
Message-ID: <20261125143857.485752834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index b273611c5026c..ffc9dffe1e86c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1985,6 +1985,9 @@ static __init void setup_boot_kprobe_events(void)
 	char *p, *cmd = kprobe_boot_events_buf;
 	int ret;
 
+	if (!kprobe_boot_events_buf[0])
+		return;
+
 	strreplace(kprobe_boot_events_buf, ',', ' ');
 
 	while (cmd && *cmd != '\0') {
-- 
2.53.0



