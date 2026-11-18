Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021715;
	b=2c6GKBK1/72B6kWOH2yejRxusRTaSl8tS7npfYX0VG+5prNDMFjjYn/Syrem6mVpY/wG
	 B8Tw6zIE8mHIrVDnXHhyFyxZoiTRPoBpHHBZiNc5qZ2+qPsrv3y7c/jv/Y5bzr4cpPDGw
	 6odwG43mCEC/hr3JlOACA+MwM0jq9Kf2uCBrSiI0tLG3kkds/T3UfGYPzrUCyG7XmwSIV
	 F0sUQ/kvlnyq94F4CPelY1QLF4EH/bi5OghXudn1BqWt3NimdvO2QIIeWErI0pb/VeuM+
	 SqH9WEvYhVWBtsXC7XSA88gYWVsOTscHyaThDMAQi1EKu11B9knnNML+kIZWcSHnv1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukGz5AdW56GXfMYYkq/Pk15Ya9Z4QvyCg6Imqe6bChs=;
	b=zmgGrv8VUcQ2n1WGOsVfE5BKGGatwCHhebJmq5tjwfxFm6zLOusSi9EqfUpzn2iG/X1o
	 GaxaKxUA7a+CR65XrO9Ao1uUjpIFcXfcvXf0TrjrFVHy3H8Wy1uDEETZtLtTUCg3DfJQY
	 KNpR7xd/VtrEQxiFw5NDQl5pPPYvHsiHXAKb8nlzLsj8CZCspddfFxLJ7Stj4OokHN0on
	 D08eoZSlxWM2BzgS7sseqH8nljkmUP9/W3JYrktsHRKZ//eimgN51SEXc2M7dVydAJ/9N
	 91shCPnhQPz7dekGUSKJeDCoEOuDlHpDelnuq0fW3LxKibHaapY7FxKkFvvx9vEL5QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+j+Rfbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4CA606A320;
	Wed, 18 Nov 2026 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+j+Rfbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCAC1F000C4;
	Wed, 18 Nov 2026 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021715;
	bh=ukGz5AdW56GXfMYYkq/Pk15Ya9Z4QvyCg6Imqe6bChs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+j+RfbvSlikrUiy7/2G0b2etriJ+GUQNqA99KW2vGiEJ4HcHkl3IUADpVQ/X0j7A
	 kM91isVJ7LGYBmuHhly2Ocw1tyRuvejoAKpvSyBWk/UVIb+tzderq4SF/0b/XTNNZJ
	 f2GxXhP+KiC9FTm6NF4NFrCH7m5RvB+tD2L56hqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2365/2651] cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used
Date: Wed, 18 Nov 2026 16:00:05 +0100
Message-ID: <20261118150410.675342386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 370f8df2fdb4b..4d17eb307b6ab 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -497,6 +497,7 @@ DEFINE_EVENT(dev_pm_qos_request, dev_pm_qos_remove_request,
 	TP_ARGS(name, type, new_value)
 );
 
+#ifdef CONFIG_CPU_IDLE_GOV_HALTPOLL
 TRACE_EVENT(guest_halt_poll_ns,
 
 	TP_PROTO(bool grow, unsigned int new, unsigned int old),
@@ -525,6 +526,8 @@ TRACE_EVENT(guest_halt_poll_ns,
 	trace_guest_halt_poll_ns(true, new, old)
 #define trace_guest_halt_poll_ns_shrink(new, old) \
 	trace_guest_halt_poll_ns(false, new, old)
+#endif /* CONFIG_CPU_IDLE_GOV_HALTPOLL */
+
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */
-- 
2.53.0



