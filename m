Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217386;
	b=Wnh/teH17k3BH53Zvc+X/doItYu/u1XbydjWzjNPuikYD8sXyy8I5FwAq1R9oabOq1T6
	 d6KghGAkR4MfjxnBOJ8cg+wqOg+wEvfLKrkBUZUi3YPJmJ033Sgkxs7sO+arEfssLpj/T
	 ivSBcGpljewEnXFrWLgHuCRuUFzSzXc76Py6Y3g/4JTdGn+tkbPP+A5x1u9cstry5ttbs
	 Y/g/UiApxhU9Ixr1/rfW6Fj6NrCUQ7WisBtqeriV8cFuVPPZUNMaIB1uoukOwNjagmszq
	 ilpPO1LM4cmhx1JUZOdEmJXRSc2HyEG5vCc9RLEDMgtM0KHD2tsaEmogEd3u+PKdMXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4AAW/+rge53fWI/acMqyA6CGGldwdcZB+mFmOCRREEY=;
	b=BWt/CCV1zzzQpxasMPxFuqQUbdkSo73QCgcSaMRmRLgzV2rN72+YZIn8b1NTF94SLSLI
	 c/klHd0eqq8pDRk4GR9TccFuuRwdTMmgLvS6CKoj4CaVn3OAxdHkO4dZYaC3cIsVeNIJe
	 +x6XBNYY6nt4d8FUzSqc2dmOzkPcryeJTYdxDJ3ER0b1lCD1GFrTmQ5mGaLfM6/4wZeG1
	 5/IOeshN3VGdfG/wrL4N4H0QLIP0nnZerSk9nfDA8IOyxz6YpmS9gRXRs10JLu28tVaCU
	 n6dD3/tpS/MWe0VR1vzmNg3AGo2e/cGJGGfNl0QE+8HQKzULL9L/0fJWbgHzGFDS4+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aic4NuFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6B3606A31A;
	Wed, 28 Oct 2026 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aic4NuFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9521D1F01825;
	Wed, 28 Oct 2026 19:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217386;
	bh=4AAW/+rge53fWI/acMqyA6CGGldwdcZB+mFmOCRREEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aic4NuFzhRHnO4/GMrT0TJXzHNJdGbvyrDyZuQ13x9+aWYQisOA8XgydeOPbWHHdy
	 wJy/2ixRn7XnR3kM+A/tuSWcpNBksHQ8bLu3B5esSlcxYlOTgqyS3qjDeX+lfqqnw2
	 41OFMyjNKHNUiENSLiDOmVXkYxm7ehga7Q1t79KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"ke.wang" <ke.wang@unisoc.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1879/1887] mm: use stack_depot_early_init for kmemleak
Date: Wed, 28 Oct 2026 18:06:15 +0100
Message-ID: <20261028170542.216752438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 993f57e0277b78182eb9e4955d118cc8b086c83d ]

Mirsad report the below error which is caused by stack_depot_init()
failure in kvcalloc.  Solve this by having stackdepot use
stack_depot_early_init().

On 1/4/23 17:08, Mirsad Goran Todorovac wrote:
I hate to bring bad news again, but there seems to be a problem with the output of /sys/kernel/debug/kmemleak:

[root@pc-mtodorov ~]# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff951c118568b0 (size 16):
comm "kworker/u12:2", pid 56, jiffies 4294893952 (age 4356.548s)
hex dump (first 16 bytes):
    6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00 memstick0.......
    backtrace:
[root@pc-mtodorov ~]#

Apparently, backtrace of called functions on the stack is no longer
printed with the list of memory leaks.  This appeared on Lenovo desktop
10TX000VCR, with AlmaLinux 8.7 and BIOS version M22KT49A (11/10/2022) and
6.2-rc1 and 6.2-rc2 builds.  This worked on 6.1 with the same
CONFIG_KMEMLEAK=y and MGLRU enabled on a vanilla mainstream kernel from
Mr.  Torvalds' tree.  I don't know if this is deliberate feature for some
reason or a bug.  Please find attached the config, lshw and kmemleak
output.

[vbabka@suse.cz: remove stack_depot_init() call]
Link: https://lore.kernel.org/all/5272a819-ef74-65ff-be61-4d2d567337de@alu.unizg.hr/
Link: https://lkml.kernel.org/r/1674091345-14799-2-git-send-email-zhaoyang.huang@unisoc.com
Fixes: 56a61617dd22 ("mm: use stack_depot for recording kmemleak's backtrace")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 1 +
 mm/kmemleak.c     | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cfff3f1e4713d..ee70b79a4308c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -738,6 +738,7 @@ config DEBUG_KMEMLEAK
 	select KALLSYMS
 	select CRC32
 	select STACKDEPOT
+	select STACKDEPOT_ALWAYS_INIT if !DEBUG_KMEMLEAK_DEFAULT_OFF
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4e5bc3cec3ca6..2200f34a4f004 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2105,8 +2105,10 @@ static int __init kmemleak_boot_config(char *str)
 		return -EINVAL;
 	if (strcmp(str, "off") == 0)
 		kmemleak_disable();
-	else if (strcmp(str, "on") == 0)
+	else if (strcmp(str, "on") == 0) {
 		kmemleak_skip_disable = 1;
+		stack_depot_want_early_init();
+	}
 	else
 		return -EINVAL;
 	return 0;
@@ -2128,7 +2130,6 @@ void __init kmemleak_init(void)
 	if (kmemleak_error)
 		return;
 
-	stack_depot_init();
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
-- 
2.53.0



