Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050422;
	b=lt27iv8NfCQ3NJ2cWNsEJ0wtd2of5Jow6YihB+UjNHYk4dtsjE/VDAAm/qoUHnjbbvCz
	 3s1qao3UeMsJ98O3gxBgejoht1F1K3zNj1vx3W27zpkXGjXd22Uq4U7BV2ZsuhPoGGPPA
	 Zo6ZvTCF1nhu6bJikFDi+4ULkxUJei+nnFboTu6FgWsZxYlhrBPJvEhHTvPZlAwaT8G16
	 GeRB1cn/atNB+ONlozmQqlhQsGbv/y001PDyatG2aEF2ytjylq2cg7F0b4O8xYWzS788x
	 BCYN/1CIOl4nXC3Y/+ovFZjXX/gJZbHeGiUTrfLA0dk3cNl916a1akbL5VWGY5PvL/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZoJmSMHXaWjEsb31zhbOHkqD9WFYPEN3ELuxD/b6m8=;
	b=aT/bfwArM+Cp4m5WK3wg0FfDXVgiyPVLLK3fCUdBsHbu3o0LV8oogyRDF/OjbPw34VEX
	 dAOvwsCPDzv0p9EJA5KfOrOGA2pltuBm6A04o+NzUpv8cM8fTVAgSJFfG9iiEMik9x4lb
	 cYamO4bi7Q/OuRqoILZKzSUHfNdyDlFEH+ybzsSH7Uxb8m24MOGekSB6vLf5+JlLvjzNP
	 adCJSDzaxK31VO98IRWz5w8UlVkhwZw7rE0c+C6stslG+mk3rYyMcagM8vbG91s0UYbWt
	 ppS8tkN1Byk/R+FOpHzcWJmx5eHeSC71W60tG8lqRMfdrK0XQ6jRnruu9PRGtS9yr1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU43C9I6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C031D606A31C;
	Thu, 19 Nov 2026 01:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU43C9I6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464F41F000C4;
	Thu, 19 Nov 2026 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050422;
	bh=RZoJmSMHXaWjEsb31zhbOHkqD9WFYPEN3ELuxD/b6m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OU43C9I6kS9B5/C284bUTCOxFRpK2d/CVfYnlRCP/cRYqD9gF0ytJ/JtanJ7bMsqT
	 pfufyzpyg5yd1PuBAlkAwez8RffsG2LiKN7qSOfN00d44sSQYYavBVqvh/vLDJBIKy
	 g0dALUvNwnU+sXcRoFwZKYSt3QjeV1zRg83ntdvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2701/2857] cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used
Date: Wed, 18 Nov 2026 16:02:15 +0100
Message-ID: <20261118150338.816937592@linuxfoundation.org>
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



