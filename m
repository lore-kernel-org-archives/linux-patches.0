Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042352;
	b=lk+m3mzby0JO5gmdmZwO2VnuL3YRYDdeC4LymYg/ix2Pf0PulnVnsFqk1X1mKasuZiGi
	 Cn9Rm9FQcYQ0g7qChuN/bKn+pNmHgIhk/+V7nLHHEZJXnhfD5e1KFKQjBpQAGR3jVxZLk
	 /HGtaNmWKSUrTtGXWxzUqmbNcISVJRQxf652RVZKbKavmyBMbUjVfJEHBnqEK7U7AJYz/
	 Jj8nTIbs46EG6wIKef8jHKN/iqkDjgFepuExttZM1OCbaJCfTEAyuhxyuiFKSE1WuZSkf
	 7nYZpQ3jd+l0KdahY7WkC+9a4vr3n27q5SKUt2pLywfWQ0AzdTt0KWCbSNhbdvcl8SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j2mpfmQViWlyyjurMX0+N1JNjhbaHsDdSrSN36kUOBo=;
	b=e+wZvmdycbfk715mCYjITc4kdq7icsjwidAyioSak+mDG5pnvfG9H9tr1Y5wSpmEjsj3
	 lMd8fiHJsQPKWCUZa+WK8HGRxPLK0fOO6TqdpSruvMSrtFLxa/LhGLGk4bKOPaUB1UVCE
	 r3uaf3vQX4XaciLqq6Wfkxc4KRlIT/H3N1WjwBr9nu09d6xCvDesXfpuHsmQe23fX7+NH
	 i+YlqO7YoYx1Yzw96wysdo7944bdKcnuwHB2jsclro+zj91J+1LaMR/gn80hmfNqREaKi
	 EuYKgx5YKyU66uCcgfw0Qsj5TC0XeIs3b2DGQv7YuPp+c4GTpc/g1Ck9crIEcdFF7tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aA4vY5f4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402B606A31C;
	Wed, 18 Nov 2026 22:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aA4vY5f4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67F21F000C4;
	Wed, 18 Nov 2026 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042352;
	bh=j2mpfmQViWlyyjurMX0+N1JNjhbaHsDdSrSN36kUOBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aA4vY5f42jAhhM8rrzqBAC9E7+dVT8MpOl4LZLqj2loOIaGk495cIdmjYPl86j4q9
	 o+oTGMkj9IMywODqf8zYpGaTdR2oqni7UYGU4B2IqnzbuzUn0nf414bqSmAC9tlmk9
	 m0PElEB1uXshpp8S87YLUyND6F+lmtA3mwVnNFKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3140/3318] cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used
Date: Wed, 18 Nov 2026 16:02:42 +0100
Message-ID: <20261118150454.077800500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77f14f7a11d48..093f29f2ec109 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -523,6 +523,7 @@ DEFINE_EVENT(dev_pm_qos_request, dev_pm_qos_remove_request,
 	TP_ARGS(name, type, new_value)
 );
 
+#ifdef CONFIG_CPU_IDLE_GOV_HALTPOLL
 TRACE_EVENT(guest_halt_poll_ns,
 
 	TP_PROTO(bool grow, unsigned int new, unsigned int old),
@@ -551,6 +552,8 @@ TRACE_EVENT(guest_halt_poll_ns,
 	trace_guest_halt_poll_ns(true, new, old)
 #define trace_guest_halt_poll_ns_shrink(new, old) \
 	trace_guest_halt_poll_ns(false, new, old)
+#endif /* CONFIG_CPU_IDLE_GOV_HALTPOLL */
+
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */
-- 
2.53.0



