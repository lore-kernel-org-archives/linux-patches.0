Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032761;
	b=EN9Cpn2CWjFjJuV/50mkriPSDO8hRN3AswCTcFpoB9UsgHj2Tbapz+rTRBOVEC2RDFOH
	 c+a7Crd+ny9uyhyg01Yljhg++GS3+l9iGLHCr9g6F12yw0YXoxP4WragaTatVFxsqbgEG
	 Ku1mZu2xPz2aPX149hsC9VCyzwY7Xsla8LqJct4+uM0Q3jqFIS4sklOM7+jPhaGCofC4q
	 R5PpsSNCXNlnFg9jpnJCshutGC2EVp7LNJcZ6H6tAaogH3MY5VrV1m1Vxft/MC0N+A0Q2
	 5wszPbFLyq/8pg8kHM4Xh00fF+olDYSzQvvRu4cjmiGKY+2y0G6vSKYyMMkdAiabkYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFhT7LM/NfrmX7D8fihkOXB21DXc8P2M1SRiAOxsGwM=;
	b=bi1t2YrymURCCp878SgZL85htV/wLTEOgLU993mgDzd1mz4YnPsabI9ieFJL5p7CwOZk
	 2SXDLN1bNtVL0ABBJOiTQZPhNkUd4F1MsTe1KsXjfHJBlZThMa3xOeGlN6SOeaVZee94b
	 eFDawJRA01Sc84+Z5cjqzTakMUwi/JzgONkQ+3MGIIAL4wisf3mJZ5dNn5rfLaDuNdzCD
	 uQcfoPOlPq4IPurh9VpWMNmWe834Vy/4jGncXNhjFRN808aOu1Kfs+Wz5CXorF5SHGNRA
	 34lQL7rLV/aWzq8zSzAIGeSNuuqzyaQ+9rcInV7nzEpdxgEMkI2UY+941cw5YfDjpUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcYVUlfm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED43606A31C;
	Wed, 18 Nov 2026 20:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcYVUlfm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FBC1F000C4;
	Wed, 18 Nov 2026 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032761;
	bh=DFhT7LM/NfrmX7D8fihkOXB21DXc8P2M1SRiAOxsGwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcYVUlfmvz9ZTWnVZ8NaobYwoEMP8qDDx/hDDpqXW1d29HGUi6J9LeFWE5NSQNL9J
	 tduzfuMk89jlYFrjR4LqTATWf5xoUnYYFRQZh9txy415fQyxEUNXqRlGVo6udVJBEr
	 T3zt7bN/kRdiSBVGuELueuqmLiRgojuA0UOqqV8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1527/1756] cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150109.735690419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index d2349b6b531ac..f14a123ce2696 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -522,6 +522,7 @@ DEFINE_EVENT(dev_pm_qos_request, dev_pm_qos_remove_request,
 	TP_ARGS(name, type, new_value)
 );
 
+#ifdef CONFIG_CPU_IDLE_GOV_HALTPOLL
 TRACE_EVENT(guest_halt_poll_ns,
 
 	TP_PROTO(bool grow, unsigned int new, unsigned int old),
@@ -550,6 +551,8 @@ TRACE_EVENT(guest_halt_poll_ns,
 	trace_guest_halt_poll_ns(true, new, old)
 #define trace_guest_halt_poll_ns_shrink(new, old) \
 	trace_guest_halt_poll_ns(false, new, old)
+#endif /* CONFIG_CPU_IDLE_GOV_HALTPOLL */
+
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */
-- 
2.53.0



