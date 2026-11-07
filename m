Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064498;
	b=q05y6x0aQhCDVVyfcY4ZNqoYgIE9rEOzw9+WgfocnJkioK76lUhqHSX+kH8I9QzoUzp3
	 7s4JpZSIKShLvrbIdyhsKUjQ2P3MWrR138f58SjrP3SXLkac+5Hv2vspDremT/kyBkLCW
	 0pxakkBN+4n2J8ZY3BPUjzBdhPmv7dwAYvlrG5v3mc/zqJlBN5vX+fYstMIdHwpAeqfUf
	 2eau8ZvSZWgXm5wkzvPZJMujCBPVfhrkrCmlE7t1eHioRMu8r8grzx+pA7J2khH8CAtsh
	 hjSseSBCLZ1ctfGlQLXc3U1yFE2q9LXucPIIidJVG+UpLBXq3kpsZ2eT2odtCFSCvjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KdBbrZ9hOV7leiB9WDbbiPDQeiC78GESPDnc0Zw3z5E=;
	b=xfwbE2Ma+X9S6hh341RrgdbZFG+GXL8RW4zbouVw8hOyCYLeeIry3rBM0ehi+qn6Oefc
	 liCqVLcC7QDe4K66f7yvB8y7JMJLUEwfrJQCIYvSOMdtHpXG7Gk403nL5OnQIoc5GmE6o
	 1C9UmToU5swZQWEmqXVyTiH9ulAKknLIAm530KyXj0iVtgh+hyCtur6ckSNSAXFWqw97y
	 QErRTId79UNlc/a9CrOOR1672mVqLKUMqXHJPCNUyXXfR0J5Jd6mYmH+VhsZOCbWIDF9S
	 T3boN+i8xSeZwIqIvNYmaWiLd2w6bam/TENt077qJajXTG97OTEU3C/owmOXI7ZEVnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3OKegMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CAE606C03F;
	Sat,  7 Nov 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3OKegMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F2D1F008A1;
	Sat,  7 Nov 2026 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064497;
	bh=KdBbrZ9hOV7leiB9WDbbiPDQeiC78GESPDnc0Zw3z5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3OKegMcUWIlkjkTvThtNzUR/tgO1AyI07HuQqh+LPZTaS882Ca2T6OkV8g/WNBvh
	 F14OoidN2ZrpUioPGDIL4uI9NGJDRFVzpPWFTviiPt6vl06tLCylRJHOebFpKi8ple
	 tSngwD0WwjaKqpSIS0l5+5ARzIwk6wLZ18C/v8/A=
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
Subject: [PATCH 7.3 0531/1257] fork: honor task_structs declared alignment
Date: Sat,  7 Nov 2026 08:47:07 -0500
Message-ID: <20261107134954.076151046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 26b666e98bb8a..8ad34646962d2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -858,7 +858,8 @@ void __init fork_init(void)
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



