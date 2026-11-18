Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043682;
	b=n0jXaRbkWsEuXwCAtgce12+KxrrjUkUxvMLqRV8b9EIsTX0eKC2gOII4DlVxydffbOAp
	 ASLprx7Qrrz6VX92jPeIMUNvZqldKsNbtjDxG4/LhhIaiIkQb9SpmPmVCwHb9IJktihAx
	 rPOyUWQsZeM8zouhKQefn9rcdnB+f5AmR/kxzF2jMAaNJT1n+JEUioMSGAtvWJS24VhR0
	 WYlQ1Jk9g/uJ6/jz7CRuU0xVjBVBzf1ngpQy9B6eGEgsBmaw5fHwcVd6aBOIa9uWkEy0m
	 +UtmlVclPvXx0mbIypdwnNfKOKaYWrYAV7hNioHMJRgA9nNh3MV3M5Iie4+wHKlYcaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1RCr5bl3JBCfX3WgIfcRALJrOfV+gLJv5G+m4QjQgbs=;
	b=bJGFCU+SwyyHxZ4IiWxpxDuSp+95RIZpZb8zAfygH+9sff3j2/YF2+m+Zjq0dCOg0vlB
	 //Yd5OuL7+zRbr5y6Lnb8PPlMEjgRO7hRTges4UQCGBIZdD3atlKZQWv48SM0RhyWu/Eu
	 h+uOej4ajFigyq0FasFoDdOvvOuou/w9kteyVC+hP+DYUBoI8DN1VursRMNKv6wumge2a
	 xJZAvlKPxFK9BXEoZU6mrAQiXbz81geWQAzaVtLwbUXBDcerQoNumxDKAlwxGKklqXsEh
	 GHXf/75/lfcUROClJmT7jIHxPQderKsOmz11YJbiAqvc3Dr8vrJSfb8rMy5atiXhlrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VwH1BniC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C046C606A31C;
	Wed, 18 Nov 2026 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VwH1BniC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A671F000C4;
	Wed, 18 Nov 2026 23:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043682;
	bh=1RCr5bl3JBCfX3WgIfcRALJrOfV+gLJv5G+m4QjQgbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwH1BniCm088DaO/S/Ctg6RvrnWSXWCumIGp+ugWEDTrFwCYDWsuzCSdjyJboVk4b
	 B6BKlPhc7N0DojcrwYlxNlcS1pUwe0zWR7m6JJEC8E5KshDNCRKLFOeTzHegP4MVWJ
	 JzAK3TXerhayPVg0bRHpDs41ij+d2d8H60ofuU9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0297/2857] usb: mtu3: Fix double dereference in TP_printk
Date: Wed, 18 Nov 2026 15:22:11 +0100
Message-ID: <20261118150212.111627833@linuxfoundation.org>
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

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit cfb3293c4573289f11f913611f530ea6b1926d67 ]

Paul reported kernel splat:

[    0.000000] TRACE EVENT ERROR: Event mtu3_gadget_ep_set_halt has double dereference in TP_printk: &REC->gpd_ring->dma
[    0.000000] ------------[ cut here ]------------
[    0.000000] Event mtu3_gadget_ep_set_halt has double dereference in TP_printk: &REC->gpd_ring->dma
[    0.000000] WARNING: kernel/trace/trace_events.c:420 at test_double_dereference+0x144/0x14c, CPU#0: swapper/0/0
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.3.0-rc1 #15247 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : test_double_dereference+0x144/0x14c
[    0.000000] lr : test_double_dereference+0x144/0x14c
[    0.000000] sp : ffffc80aa7633bf0
[    0.000000] x29: ffffc80aa7633bf0 x28: ffffc80aa7c0f047 x27: 000508b58019388f
[    0.000000] x26: 0000000000000003 x25: 0000000000000007 x24: ffffc80aa5fceff8
[    0.000000] x23: ffffc80aa7c0f05a x22: ffffc80aa64edfe8 x21: ffffc80aa7c0fce8
[    0.000000] x20: ffffc80aa7c0f047 x19: 0000000000000013 x18: 0000000000000001
[    0.000000] x17: 6572656420656c62 x16: 756f642073616820 x15: 746c61685f746573
[    0.000000] x14: 0000000000000000 x13: ffff000139d90000 x12: 0000000000000045
[    0.000000] x11: 00000000000000cf x10: ffff00013f546428 x9 : ffff000139d90000
[    0.000000] x8 : 3fffffffffffc000 x7 : 0000000000000001 x6 : 0000000000000001
[    0.000000] x5 : ffff00013f4e6440 x4 : 0000000000000000 x3 : 0000000000000000
[    0.000000] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffc80aa764a700
[    0.000000] Call trace:
[    0.000000]  test_double_dereference+0x144/0x14c (P)
[    0.000000]  trace_event_raw_init+0x37c/0x5d8
[    0.000000]  event_init+0x34/0xc0
[    0.000000]  trace_event_init+0xec/0x588
[    0.000000]  trace_init+0x24/0x6e0
[    0.000000]  start_kernel+0x4a0/0x8ec
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] irq event stamp: 0
[    0.000000] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[    0.000000] hardirqs last disabled at (0): [<0000000000000000>] 0x0
[    0.000000] softirqs last  enabled at (0): [<0000000000000000>] 0x0
[    0.000000] softirqs last disabled at (0): [<0000000000000000>] 0x0
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] TRACE EVENT ERROR: Event mtu3_gadget_ep_disable has double dereference in TP_printk: &REC->gpd_ring->dma
[    0.000000] TRACE EVENT ERROR: Event mtu3_gadget_ep_enable has double dereference in TP_printk: &REC->gpd_ring->dma

Which also observed by Mark and myself.

The splat it result of new check introduced by b5cc230af5e5 ("tracing:
Warn when an event dereferences a pointer in TP_printk()") which
correctly catches issue with %pad dereferencing the address saved in
the ring buffer. TP_fast_assign() logic gets executed when the
tracepoint is triggered, however the TP_printk() is executed when the
user reads the trace buffer which could be seconds, minutes, hours,
days, even months later and nothing guarantee that __entry->gpd_ring
pointer will still be pointing to what it was when it was recorded.

Fix the issue by capturing immediate value of gpd_ring.dma when trace
point is triggered.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_trace.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_trace.h b/drivers/usb/mtu3/mtu3_trace.h
index 03d2a9bac27ee..0b70b47833e96 100644
--- a/drivers/usb/mtu3/mtu3_trace.h
+++ b/drivers/usb/mtu3/mtu3_trace.h
@@ -224,6 +224,7 @@ DECLARE_EVENT_CLASS(mtu3_log_ep,
 		__field(unsigned int, flags)
 		__field(unsigned int, direction)
 		__field(struct mtu3_gpd_ring *, gpd_ring)
+		__field(dma_addr_t, gpd_ring_dma)
 	),
 	TP_fast_assign(
 		__assign_str(name, mep->name);
@@ -235,12 +236,13 @@ DECLARE_EVENT_CLASS(mtu3_log_ep,
 		__entry->flags = mep->flags;
 		__entry->direction = mep->is_in;
 		__entry->gpd_ring = &mep->gpd_ring;
+		__entry->gpd_ring_dma = mep->gpd_ring.dma
 	),
 	TP_printk("%s: type %s maxp %d slot %d mult %d burst %d ring %p/%pad flags %c:%c%c%c:%c",
 		__get_str(name), usb_ep_type_string(__entry->type),
 		__entry->maxp, __entry->slot,
 		__entry->mult, __entry->maxburst,
-		__entry->gpd_ring, &__entry->gpd_ring->dma,
+		__entry->gpd_ring, &__entry->gpd_ring_dma,
 		__entry->flags & MTU3_EP_ENABLED ? 'E' : 'e',
 		__entry->flags & MTU3_EP_STALL ? 'S' : 's',
 		__entry->flags & MTU3_EP_WEDGE ? 'W' : 'w',
-- 
2.53.0



