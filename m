Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027861;
	b=RcRPjme2/VD/VMd/y7KJ38B1gnnxUPnn9UNcfnH8gF7IKHoX9+AJN4Q2UAdLYvwVALf5
	 WMpLpCk+vqXoewXG85QcYl+FEhPcJb0SZFWvr0piFFonB6XfSc8DgPAE4LQC+y8l4lYxf
	 WQnW8IT8pi+yfQm3jv/DmD0pa9mkDPne6ox2OgXbHI3IyRw7Mj1Q3VrTivEXiIVOk73DH
	 dkwOmR2gDrHqLvRMtbO1ozMEvhxbiaPUxWnKjbdo4KO3sfbRGOfzbrttchJPWnI7Uwo/M
	 IlEMyEpvekAhlxHPX358wwH5TpJyWCvdcgysodhtoYQvCdMZkFF2CXdeDFI6BCuUmZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nERrcJhu/40eZWTtHKukaF+LHFdio8+JsSK5OKbqE/0=;
	b=cZhtMQzgQYeQdbTNAmyS1/GhVhXePrTXOmW1YdmWhwggjZLX0bM/6i1bVcTsVM/S97D+
	 4xoKRgjPG6N+1dbx2gyQFfvYx8yn3fchRePUwM46bZNID4fslBWObj+aJlVTGjcivH6K6
	 4taqwNure31CDVJ7INZVgDs/B91jXJIdNX+oCMnulgu72exITgmlKMliYgU3I/kC2FbKG
	 R5Gv0hNybhP9PBxnjBMfWPo5a0m7khN+PJ6WMgUHoLAOIT6Bc/e1SU2vvAKcXOoIqg/mt
	 urYY0RBxwwj+Pekfar2eUf5GVOWeWtkHuxzWRC8uG5c4vVIyDAl+7Ic6dWQCXXLTuQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLOkMQz2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22E0606A320;
	Wed, 18 Nov 2026 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLOkMQz2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21D01F000C4;
	Wed, 18 Nov 2026 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027861;
	bh=nERrcJhu/40eZWTtHKukaF+LHFdio8+JsSK5OKbqE/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLOkMQz2yCG/bHt7axckgsWzeELw/19zBDtxbuUeQh37PXMJ5Z67wUrHYwNZBAA8y
	 DYWOQNqrVkECrbUWx7jEXGgJ50Qyv7MJ/n1x4750f+ozkPThoQUfdNkpWdcfEFxTQz
	 rVTia+SiJjMefUrIKKqsNymdW4nU9TtlJtMh5jGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1912/2151] cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150231.435236385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 107b87efc8fcd6a597f1b534f116385620770e56 ]

Tracepoints that are defined take up around 5K each, even if they are not
used. When a tracepoint is used only in code when a specific config is
enabled, their definition must also be only defined when the same config
is enabled otherwise it wastes memory.

The tracepoint guest_halt_poll_ns is only used when CONFIG_CPU_IDLE_GOV_HALTPOLL
is enabled. Guard the definition of that tracepoint with the same config.

Link: https://patch.msgid.link/20261022153359.2433474b@gandalf.local.home
Fixes: 0da11bf0cab90 ("cpuidle: haltpoll: Add trace points for guest_halt_poll_ns grow/shrink")
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/power.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 82904291c2b81..20c97e71bd0e9 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -496,6 +496,7 @@ DEFINE_EVENT(dev_pm_qos_request, dev_pm_qos_remove_request,
 	TP_ARGS(name, type, new_value)
 );
 
+#ifdef CONFIG_CPU_IDLE_GOV_HALTPOLL
 TRACE_EVENT(guest_halt_poll_ns,
 
 	TP_PROTO(bool grow, unsigned int new, unsigned int old),
@@ -524,6 +525,8 @@ TRACE_EVENT(guest_halt_poll_ns,
 	trace_guest_halt_poll_ns(true, new, old)
 #define trace_guest_halt_poll_ns_shrink(new, old) \
 	trace_guest_halt_poll_ns(false, new, old)
+#endif /* CONFIG_CPU_IDLE_GOV_HALTPOLL */
+
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */
-- 
2.53.0



