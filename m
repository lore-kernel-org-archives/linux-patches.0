Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063198;
	b=qjalCHw2+zxkuGpQdmL0d0thybV6QS1FJvyCYk1L36b7UiDe5GMIHl4Ur3qK/tr27Ccg
	 mcURTbMeaGen1S23qbvl+CcLJYVWBq0JcXGNtbbJk6y+CyfdkeaZwNaRBbBbbbhCgUpHH
	 wbU2jCGmKvrCLvFHCmbkvYu2N7bI0la4Nlet47+jc2tze+U07KMX/zdJBzUxGIbmPBLF3
	 yA9xWQ0XHaQHRVShV+OrYD3GyKjg+4OGMcowqctNphPZViHRJkevWT95gD31smoXmmZgn
	 sFp7wS9UD5W9LWIHNIT5k9oRq9KA2mvUzjHLJwFzWNANCgVVoXZStGT6azRGLgYtAcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFkiYTuZDdelbvFrCWR7ZAfK/KYLBX1h2/rO4hN3UBg=;
	b=OmHBB9WBRL0gVIFOlVK4diI7btqad4orRGV51ZRYKUzTksB0I3e4jeh7L87Ifkyt0CwA
	 3AJk82Z1GdFfzMyccEJ5U5qv8f1y3h4GBpd78eAMo6QbYRuTAx7QjPsobb91/stFLF92k
	 iZCjHBKi1f+gTzrhDqs+XO/yACBE38YnzNVNyMxTEaNnDyggYwwGzzHadlI5emsRXYETy
	 bUFYO3IO+pJ+MLdXJZbWbdiFYzjNfzJ6PvO14kB7vae6mbxpa7Y0RlMOL0M5vTdxdaoFP
	 FXFa3IhDhGT5Nwt1X/ZKLU/JFMjooLEBhCIpivt6fBxtc3No5q/IUPPCiKPnJFkhkRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+rxvJyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D89606EE88;
	Sat,  7 Nov 2026 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+rxvJyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5178F1F0089F;
	Sat,  7 Nov 2026 14:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063197;
	bh=jFkiYTuZDdelbvFrCWR7ZAfK/KYLBX1h2/rO4hN3UBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+rxvJyUDvfG583PWlz2TgFWKaQAjAUpPlhl603uwu0yEN15lGCG5PkjdvWuI2a/x
	 8w1D9X4mZ/gMKHeIR5yuhEA9Ax+uCVms5opZ2hVBZHyrEGnZBXk94qgdJtok2ojIV9
	 wtez94abwP6VGP7dMTCY6OuJsTCao8ji3YOqO/v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <include@grrlz.net>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 394/869] fork: honor task_structs declared alignment
Date: Sat,  7 Nov 2026 08:51:16 -0500
Message-ID: <20261107134906.777617093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 9decb604dc064099a6249150f0c4909525ed657c ]

Since commit cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant
size"), struct task_struct is declared __attribute__((aligned(64))) on all
architectures.

But fork_init() still sets the task_struct slab cache's alignment to

	align = max(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN)

which is smaller than 64 on architectures whose cache lines are below 64
bytes: e.g.  32 on ARMv5.

In practice plain SLUB happens to hand out 64-byte-aligned objects anyway.
With CONFIG_SLUB_DEBUG_ON the red-zone padding shifts objects to the
requested alignment.

With CONFIG_UBSAN_ALIGNMENT=y a boot on QEMU versatilepb (ARM926EJ-S,
v7.2-rc2, gcc 13.3) floods the console with reports like:

  UBSAN: misaligned-access in include/linux/sched.h:2087:9
  member access within misaligned address c295d7e0 for type 'struct task_struct'
  which requires 64 byte alignment
  CPU: 0 UID: 0 PID: 15 Comm: pr/ttyAMA-1 Not tainted 7.2.0-rc2 #1 VOLUNTARY

Set the slab alignment to at least the type's declared alignment.

Link: https://lore.kernel.org/20260710123957.31774-1-kmehltretter@gmail.com
Fixes: cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant size")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Assisted-by: Claude:claude-fable-5
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b7543a93f269a..bc6078b910a6a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -810,7 +810,8 @@ void __init fork_init(void)
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
-	int align = max_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
+	int align = max3(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN,
+			 __alignof__(struct task_struct));
 	unsigned long useroffset, usersize;
 
 	/* create a slab on which task_structs can be allocated */
-- 
2.53.0



