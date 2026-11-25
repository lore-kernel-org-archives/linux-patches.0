Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620700;
	b=F3Wfd9TWi5rK0S0Rmio0FxZA18s0eBnkfcYN5cv9ybOfln96Sc9Kx+6imLVIxhB4IaqM
	 mQbTtD2+m50LGU2udt/q04/+EqDapvtqRwNwvxEzaAcqcZUP2waZjICrRHIyOsKFYaRl2
	 sOMF2hRdoGtLvAly6+RpBuLO5gLC/Soq/HWrNM/SKbBzcUVPZ9FfAB87sI5IkhuREDRdJ
	 wMAZrHTVxXp3wZNUc5MPmr2G+y4oGb4c/Bnm0N7VjV1/AWDtzAgtIqSFympON+qG1/w1W
	 +XUmNGPg8fv7zT61hRefpaOWnLLOyx5PeShIhge1NL6mPi/WhT84FpQHX8yfFcKk1LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otX5lhHgbHnpd9S+2vmRktPivRoiHETnl5BkFPvXK5s=;
	b=YcgLaVw1ibB5RofYL0grN7pP+OehLHRLPJ2sILb0w76jtAeTVDHmo9e+g1Dzc7jjAwxJ
	 qIsjujzVTj4aKklKVeWeyqpybSXJDSSf/EdW+fWQVWMewbpeOXLr7D4d6syd07IMKDgOO
	 lWSogbUL1xGjhbPLpxb7eg9x8e+ei+Hn9tzYwbR6dgNNS8mhUxfR96B2XDej6DD2l8ow9
	 zPMVBeCCdmKs0QbXCgmWil1UPb/UXtMnO67DaGewE5HuvF2MesDZ58SjpkzUhrOm4jWKZ
	 ytLKQ3M5XbxtZQrlqv/Fbtl7GuQ8HKWwEpm5RScQIQ++4/mEZ5A358XBdH10QGtL/kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4UL2tBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF595606A31E;
	Wed, 25 Nov 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4UL2tBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5FD1F000C0;
	Wed, 25 Nov 2026 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620700;
	bh=otX5lhHgbHnpd9S+2vmRktPivRoiHETnl5BkFPvXK5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4UL2tBDO9HgiNqwbKfDy0VHrQZvTcgBDxrMD7wdhXa0hUU/lP3EXdq4i+qTRFSTg
	 HcK+99JSX8ztbf2xaSw4bT1V9cXcBGOmQpQwRWNFinD6epeQJT8MXDUzQyYdrtbvBU
	 yV2+F+VnJaBIY25QI7gayvDzX5q3Bvr+QcUkWXZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luiz Capitulino (Red Hat)" <luiz.capitulino@linux.dev>,
	Michael Ellerman <mpe@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.3 1004/1005] powerpc/watchdog: disable watchdog when watchdog_thresh=0
Date: Wed, 25 Nov 2026 15:39:02 +0100
Message-ID: <20261125143845.170920139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>

commit d513ec3c907b067d4a32b14ec6f73c3e041cb136 upstream.

On powerpc, trying to disable the hardlockup detector with:

 # echo 0 > /proc/sys/kernel/watchdog_thresh

causes an immediate and endless hardlockup detection, eventually leading
to an unusable system (splat example below). This happens because
watchdog_calc_timeouts() sets wd_timer_period_ms, wd_panic_timeout_tb
and wd_smp_panic_timeout_tb to zero, but start_watchdog() still starts
the timer (with expiry=0) in this code path:

proc_watchdog_thresh()
  proc_watchdog_update()
    __lockup_detector_reconfigure()
      watchdog_hardlockup_start()
        start_watchdog_on_cpu()
          start_watchdog()
            hrtimer_start() /* wd_timer_period_ms=0 */

However, according to Documentation/admin-guide/sysctl/kernel.rst,
setting watchdog_thresh=0 should disable both the soft and hard lockup
detectors.

This condition is already checked in __lockup_detector_reconfigure() for
the soft lockup detector and the arch-independent hardlockup detector,
what's missing is powerpc performing the same check in start_watchdog().

[  278.110085] watchdog: CPU 0 detected hard LOCKUP on other CPUs 1
[  278.110086] watchdog: CPU 1 became unstuck TB:33050716089564575
[  278.110097] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G            E       7.4.0-rc1 #1 PREEMPT(full)
[  278.110103] watchdog: CPU 0 TB:33050716089564185, last SMP heartbeat TB:33050716089563885 (0ms ago)
[  278.110109] Tainted: [E]=UNSIGNED_MODULE
[  278.110126] Hardware name: IBM,8375-42A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW940.00 (VL940_027) hv:phyp pSeries
[  278.110136] NIP:  c0000000001bd518 LR: c0000000014dedf8 CTR: 0000000000000000
[  278.110145] REGS: c000000004b17a80 TRAP: 0900   Tainted: G            E        (7.4.0-rc1)
[  278.110155] MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 22000224  XER: 20040004
[  278.110189] CFAR: 0000000000000000 IRQMASK: 0
GPR00: 0000000000000000 c000000004b17d20 c000000001c38100 0000000000000000
GPR04: 000000000000ffff 0000000000000000 0000000000000000 0000000000000000
GPR08: 0000000000000000 0000000000000080 0000000000000080 ffffffffffffffff
GPR12: 0000000000000000 c000000017fff300 0000000000000000 000000002ef3d820
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000001
GPR24: 0000000000000001 00000040c0a6075e 0000000000000000 0000000000000001
GPR28: c0000001fdb5b140 0000000000000001 c000000002291968 c000000002291970
[  278.110306] NIP [c0000000001bd518] plpar_hcall_norets_notrace+0x18/0x2c
[  278.110319] LR [c0000000014dedf8] check_and_cede_processor+0x48/0x60
[  278.110333] Call Trace:
[  278.110338] [c000000004b17d20] [c000000004b17dd0] 0xc000000004b17dd0 (unreliable)
[  278.110354] [c000000004b17d80] [c0000000014df020] shared_cede_loop+0x70/0x170
[  278.110367] [c000000004b17dc0] [c0000000014de460] cpuidle_enter_state+0x2f0/0x748
[  278.110381] [c000000004b17e70] [c000000000fe43b8] cpuidle_enter+0x48/0x70
[  278.110397] [c000000004b17eb0] [c0000000002cdcf8] call_cpuidle+0x48/0x90
[  278.110409] [c000000004b17ed0] [c0000000002d6300] cpuidle_idle_call+0x160/0x2d0
[  278.110422] [c000000004b17f20] [c0000000002d6578] do_idle+0x108/0x1f0
[  278.110434] [c000000004b17f60] [c0000000002d6938] cpu_startup_entry+0x48/0x50
[  278.110446] [c000000004b17f90] [c0000000000615c0] start_secondary+0x290/0x2a0
[  278.110459] [c000000004b17fe0] [c00000000000e258] start_secondary_prolog+0x10/0x14

Fixes: 2104180a5369 ("powerpc/64s: implement arch-specific hardlockup watchdog")
Cc: stable@vger.kernel.org
Signed-off-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
Reviewed-by: Michael Ellerman <mpe@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20261104034018.2676750-1-luiz.capitulino@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/watchdog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -487,6 +487,9 @@ static void start_watchdog(void *arg)
 	if (!(watchdog_enabled & WATCHDOG_HARDLOCKUP_ENABLED))
 		return;
 
+	if (!watchdog_thresh)
+		return;
+
 	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
 		return;
 


