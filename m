Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061384;
	b=x/JZYAnhU8a+dUKNVdwb99QU5U3xPh7uoE8t2jB5noc6l+xODvtaveIGEf4h6AM9M8z6
	 JIHed235yjK7SHHAI2x1yS4pYLBFdA8/kRrT2lhuhiZoFnDIQMMIHIAzyFZM/PmGvYPVt
	 HuhdzQF2QmHbc/obKaY67LmmJcscFWznIvBwy9DNfoPNXqSZhDECGVIvUfMhQI9t+5UpJ
	 ZrWEL7MQSPpIY4GrUwOiOLXsOzjMOsRMNlBhg0w8jMDsjuN8gCi94Qfv2cIVAaNP8SUWX
	 Q/9anpqqq2t7x48oVt5sGg8Vg8nY94TZTcZ8drG69GW2pdPbGKLx3F5cPWtlhf7Fldg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lwxXOm+GdLTXmj1NLdArczzRwodhYkBb6n/3SoENxQI=;
	b=T2KcEK7EGE9S68NfmMzUufHkPvYcw7t7RSmq5wN27qYQ8NY/cpV5e55L6xxi5i+OxpnI
	 yBM12cTrOdL1x+zNVkHxXRaqYyJyGIGARUFg5Ttb5sAPJwLuR7hRPWfn6wQoeI2CpdDSn
	 A6JW93BZCBVrEvrDKopC7Dxqf51k5HPrVM30UCBKMz6YA1g7Sl0TRzVAxE46pgBJ1VNKk
	 0l9f/eWlmugt75Ww5Wc4zhlMM2saTk1fwZVFiDWSTsnz8KayIPNfUI1XEvw21Nd2ivrvy
	 at5VLQit39v94IL+3M24/KgscYfIEmP4Dl99x1aRDkooFbB34lCSh93tmsJMCQyAIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdLkk8xU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168D5606A33A;
	Sat,  7 Nov 2026 14:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdLkk8xU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F1B1F0089F;
	Sat,  7 Nov 2026 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061383;
	bh=lwxXOm+GdLTXmj1NLdArczzRwodhYkBb6n/3SoENxQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdLkk8xU9Asg2LRwm9ewKJif1TzVrO3NN2gZMDTykwtEuzKKA9Vs4KJLabnY2DFRW
	 BULHU+BAB7zoW92TPu5fTUp9Z5SfcMtwQlYz+FL6zr8rmI9YUaAt/m1i15/aUB3iQb
	 Y9c0d+jRGX3lkDR9U86R/shwNxMMguyJn3lh1vlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0506/1536] mips: select CONFIG_WEAK_REORDERING_BEYOND_LLSC from CONFIG_EYEQ
Date: Sat,  7 Nov 2026 08:42:02 -0500
Message-ID: <20261107135011.658227250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit bbc448c541ed90d52f9ec22f17394304e3bf170e ]

On I6500 CPU cores, lld and scd give no ordering guarantees (same as all
other instructions). To respect the assumption that arch_cmpxchg() is
fully ordered, we must inject sync instructions above and below our
lld/scd loops using the already in place WEAK_REORDERING_BEYOND_LLSC
infrastructure.

Otherwise, bad things can happen:

[   34.054496] CPU 3 Unable to handle kernel paging request at virtual address 0000000000000000, epc == a80000080838e01c, ra == a80000080838dfc4
[   34.054559] Oops[#1]:
[   34.069561] CPU: 3 UID: 0 PID: 170 Comm: pipe_race Not tainted 7.2.0-rc6-01553-gb73c35220968-dirty #103 VOLUNTARY
[   34.079932] Hardware name: Mobile EyeQ5 MP5 Evaluation board
[   34.085592] $ 0   : 0000000000000000 0000000000000001 0000000000000000 0000000000000000
[   34.093616] $ 4   : a800000808ee2618 000000000b7a879d 0000000000001000 0000000000000000
[   34.101638] $ 8   : 0000000000e3f2c9 0000000000000000 a800000808a2a9f8 0000000000000000
[   34.109660] $12   : a8000008139ffcd8 ffffffff84080018 a80000080837fae0 7878787878787878
[   34.117682] $16   : a800000807e82940 0000000000001000 0000000000000000 0000000000000000
[   34.125704] $20   : a800000802920e00 a8000008139ffdf8 a800000802649400 0000000000e3f2c9
[   34.133726] $24   : 0000000000000006 00000001200406e0
[   34.141783] $28   : a8000008139fc000 a8000008139ffd10 0000000000e3f2c8 a80000080838dfc4
[   34.149837] epc   : a80000080838e01c anon_pipe_read+0xd4/0x428
[   34.155697] ra    : a80000080838dfc4 anon_pipe_read+0x7c/0x428
[   34.161549] Status: 140000e3  KX SX UX KERNEL EXL IE
[   34.166551] Cause : 40800408 (ExcCode 02)
[   34.170574] BadVA : 0000000000000000
[   34.174161] PrId  : 0001b028 (MIPS I6500)
[   34.178183] Process pipe_race (pid: 170, threadinfo=000000005ca35720, task=00000000e1013890, tls=000000014ebbb780)
[   34.188568] Stack : a800000802649400 0000000000000000 0000000000000000 a8000008139ffdd0
[   34.196623]	 0000000000000fba a800000808ee0000 0000000000000001 a8000008130c3e80
[   34.204676]	 a8000008080d1280 a8000008139ffd58 a8000008139ffd58 1dbd2b22ea1dd500
[   34.212729]	 a800000802649400 a800000808ee0000 ffffffffffffffea 0000000000000001
[   34.220783]	 0000000000001000 0000000000000000 00000001200ae518 ffffffffffffffff
[   34.228836]	 000000fffbe0e530 a80000080837edf4 000000fffbe0e530 0000000000000000
[   34.236890]	 0000000000000000 0000000000000000 000000014ebb55a0 0000000000001000
[   34.244943]	 0000000000000001 a800000802649400 0000000000000000 0000000000000000
[   34.252996]	 0000000000000000 0000400400000000 0000000000000000 1dbd2b22ea1dd500
[   34.261049]	 00000000140000e3 a800000802649400 a800000802649400 a800000808ee0000
[   34.269103]	 ...
[   34.271568] Call Trace:
[   34.274026] [<a80000080838e01c>] anon_pipe_read+0xd4/0x428
[   34.279533] [<a80000080837edf4>] vfs_read+0x25c/0x318
[   34.284607] [<a80000080837faac>] ksys_read+0x104/0x138
[   34.289763] [<a80000080802b9cc>] syscall_common+0x44/0x68
[   34.295187]
[   34.296689] Code: f84000cf  02209825  de020010 <dc420000> d8400004  02002825  0040f809  02802025  f84000c3
[   34.306504]
[   34.308099] ---[ end trace 0000000000000000 ]---

My initial reproducer was the xdp-tools test suite. A standalone
reproducer would be an lld/scd loop that, when the read is reordered by
the CPU, triggers a fault. We can achieve this from userspace by
stressing an anonymous pipe, which uses a mutex. Program used:

	// SPDX-License-Identifier: GPL-2.0
	// pipe_race.c - reproducer for MIPS LL/SC reordering vs fs/pipe.c
	//
	// Two userspace processes on an anonymous pipe:
	//   parent  = writer: tight write() loop
	//   child   = reader: tight read() loop

	#define _GNU_SOURCE
	#include <assert.h>
	#include <errno.h>
	#include <sched.h>
	#include <signal.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/types.h>
	#include <sys/wait.h>
	#include <time.h>
	#include <unistd.h>

	int main(void)
	{
		long wrsize = 70;	// bytes per write()
		long rdsize = 4096;	// bytes per read()
		int pfd[2];
		char *buf;
		pid_t pid;
		int ret;

		ret = pipe(pfd);
		assert(!ret);

		pid = fork();
		assert(pid >= 0);

		if (pid == 0) {			/* reader */
			close(pfd[1]);
			buf = malloc(rdsize);
			assert(buf);
			for (;;) {
				ssize_t n = read(pfd[0], buf, rdsize);

				if (n < 0 && errno == EINTR)
					continue;
				if (n <= 0)
					_exit(n < 0 ? 1 : 0);
			}
		}

		close(pfd[0]);			/* writer */
		buf = malloc(wrsize);
		assert(buf);
		memset(buf, 'x', wrsize);

		for (;;) {
			ssize_t n = write(pfd[1], buf, wrsize);

			if (n < 0 && errno == EINTR)
				continue;
			if (n != wrsize)
				break;
		}

		kill(pid, SIGKILL);
		wait(NULL);
		return 0;
	}

Fixes: fbe0fae601b7 ("MIPS: mobileye: Add EyeQ6H support")
Cc: stable@vger.kernel.org
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[ sashal: Adjusted context: the upstream HOTPLUG_PARALLEL select line is absent here, so the single select WEAK_REORDERING_BEYOND_LLSC line was added after select USE_OF instead. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5078ebf071ec0..b107ce720279a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -614,6 +614,7 @@ config EYEQ
 	select USB_UHCI_BIG_ENDIAN_DESC if CPU_BIG_ENDIAN
 	select USB_UHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
 	select USE_OF
+	select WEAK_REORDERING_BEYOND_LLSC
 	help
 	  Select this to build a kernel supporting EyeQ SoC from Mobileye.
 
-- 
2.53.0



