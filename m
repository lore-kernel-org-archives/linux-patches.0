Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064701;
	b=qwtk5kV/wv2Jvq2OjA7EBtlnk/QY1LWsqBxoPhteepEcw8VQSU0ZldYrUahY5m78UTT9
	 GhTcZR/vrpIXk5e0fAJhgSnodNVZ8LydAI/lqAF94hLBPgY+kh3CXbM7GBKHzuLXglkfu
	 dJB8+oVtKqeuO5aVpsva9AlWA2RmfpGl9VUYjzCFfFY8yT+SOzIaIX8dtRZBX9ryMIu5J
	 IOCgWing6madK8QS5FhC5FX7ArNLXeuMPz37dZ8OGfzCi+ApKywhEgS4t4p5LmMALfaX4
	 69VmDoniXjWrxA5ZX5+NsCSfP4BkYIfAySDWe5g/eLcYrmH+7vcPaUSdrWxQSk35XUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AXTusUL+9paLQQ4WcL7trCYEmAqRjPGY1zugsYkILk8=;
	b=qHsB85okf82BmeOJ4LxpoqJCm/EdlUbt/7g+trVw2CaLuZ9DMDaTlHY9n77tNXdNdMQM
	 fs+G1Ugjc/MpNErw9PIlrthpsTBm/1gpCrFFiWI95tCZPM8o4vYPCv+fanzYZ9pzK1G0m
	 /RXn/YhHuJALkbC4r/KadHr6tQ2iWAHUeKvyaUzVvCTTI7hP6XGyvmoj5tlZGDpSpmkhS
	 +cY9kaDu5LgthdLZRJWPImzqMHrZftmvVJ0G7KuYOdfGKYJsoXqPZG6MA59C+ZXAtbGfm
	 /nwH6tpnC2blHUJWMYgJxva0Z5KRQfyGPmdaCAdMIBcpRt62HcYWgAxvTtlobWpXqkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LzLGbdh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E71A606CE6D;
	Sat,  7 Nov 2026 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzLGbdh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067121F0089F;
	Sat,  7 Nov 2026 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064701;
	bh=AXTusUL+9paLQQ4WcL7trCYEmAqRjPGY1zugsYkILk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzLGbdh/ukn4jE98UGq9WDPBvdlVYJ3MJdAntGHOFGhEvifll0k52GAjNHYWEx0Z8
	 Hu0hG5Dkhr/gnCy3rFkmSftR+6f/m3Atspfy56u0tYQWcKQ2LT7ijsI9ag5JEjdIi4
	 AYGlYHWOmZopCesFALWnpsqWRzXknPd6tjAIuzFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0690/1257] arm64/mm: Treat faults taken by EFI runtime firmware as kernel faults
Date: Sat,  7 Nov 2026 08:49:46 -0500
Message-ID: <20261107134958.322693176@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 171be684bfa3020f81bf0b85bc7ac42024575fbf ]

When EFI runtime services are invoked from a preemptible kthread, the
kthread runs with efi_mm installed via kthread_use_mm() and preemption
enabled, so neither faulthandler_disabled() nor !mm applies in
do_page_fault(). A permission fault taken by the firmware on one of its
own (TTBR0) mappings then hits the 'access to user memory outside
uaccess routines' check and oopses, without efi_runtime_fixup_exception()
ever being consulted.

efi_mm has no VMAs, so there is nothing for the mm to resolve. Send such
faults to no_context directly, so that __do_kernel_fault() can recover
from them as it does when the call is made with preemption disabled.

Fixes: a5baf582f4c0 ("arm64/efi: Call EFI runtime services without disabling preemption")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 75c3e463df2ef..357be4c9106df 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -620,9 +620,10 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 
 	/*
 	 * If we're in an interrupt or have no user context, we must not take
-	 * the fault.
+	 * the fault. EFI runtime services may execute with preemption enabled
+	 * and mm == &efi_mm, but faults need to be treated as kernel faults.
 	 */
-	if (faulthandler_disabled() || !mm)
+	if (faulthandler_disabled() || !mm || mm_is_efi(mm))
 		goto no_context;
 
 	if (user_mode(regs))
-- 
2.53.0



