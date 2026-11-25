Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619795;
	b=h/rQThW7d5aWnsqeWljsAViFy97MXbu3Uzyc4+afYmLjvZGopFEwGHljhxIFWR5MqUXr
	 HWcdO98BUsKfwVi0y8iJk5bTY86XHl6Vibkf9pLS1gYOPdeW61fn5Ueok8vpwaEzziyjf
	 TbdwJ/Z3KZJx9LLKuPTZFsDFZ/S9hxOvbd+l0egPKSHzYdZNcOLlOQ83oN856+RrLu03P
	 UZJplaETEtZKr/zDzHglXpbq8bU2Zk1D1i3F/AIZ1uIbWECKNJsnAzquuhlk49itEZAhv
	 plumNpAdOgUtoyzwI4z+FQ3GQgsk8dGQ5L9S63+wkj82KEObEWxLjF6ci49/qURpv4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h74UlHuNjoJEcNM+g7ChiU25QF2bxM0zwphdfZZGyLU=;
	b=Y8R/pHbGc0rTdNULDqJuUTv1LCxKyRGcpS732nbb8Efx0J74IUkklA7cLs3a/ZsmFSet
	 VQqPpIk4jzMgWJmwyS4Shs/6qgtUeZhCmEFARnUIAnipLo7uqZlr6aL7qt+2DpPT+EIFy
	 IpcU7aHlw6WLCQJqapeewEaXqy4NbEyG13j2whsNFUClhDJxCidXFzZzHaPqTo+WydrzG
	 V6UThdxTQJ0cH72drXF6+BVkIbW3n8wbg5+40eHHo+uw/VI+iUW/Urfv3JJHMM8RayF9g
	 x4qSQ3uTh61EOayKC+rSCE/4wYFHVkb3B4tD57Np+jOOxs0ylxv30G+llHzpfbzzVEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpY3dvBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6E606A329;
	Wed, 25 Nov 2026 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpY3dvBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F21F000CA;
	Wed, 25 Nov 2026 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619794;
	bh=h74UlHuNjoJEcNM+g7ChiU25QF2bxM0zwphdfZZGyLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpY3dvBGQj9c68exn+InBE6Nne3QwED6DlwFVTNk9CKIjJ82YJlvK9S7rc0ohS5MQ
	 VNDMsiSyvhNloWYAdi4D+qhoHMQ43J668fO0u9qqm3AiidAWs0KR2+fSd1cR1yYSif
	 bK1A3bo7HoC81eFFLlytGbeio68gbNIi6LRLZA4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0711/1005] arm64: suspend: Save POR_EL0 over suspend
Date: Wed, 25 Nov 2026 15:34:09 +0100
Message-ID: <20261125143838.414577488@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 2386c3dcf13e39d7576eae821af66537332c02de upstream.

POR_EL0 is a live EL0 register on systems with S1POE but it is not saved
and restored by cpu_do_suspend()/cpu_do_resume(). This means that the task
that initiated suspend can return to userspace with an UNKNOWN value. Fix
this by saving and restoring the value over suspend.

This increases the size of struct cpu_suspend_ctx.

Fixes: bf83dae90fbc ("arm64: enable the Permission Overlay Extension for EL0")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/suspend.h |    2 +-
 arch/arm64/mm/proc.S             |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 15
+#define NR_CTX_REGS 16
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -118,6 +118,10 @@ alternative_if ARM64_SME
 	mrs_s	x2, SYS_TPIDR2_EL0
 	str	x2, [x0, #112]
 alternative_else_nop_endif
+alternative_if ARM64_HAS_S1POE
+	mrs	x2, REG_POR_EL0
+	str	x2, [x0, #120]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -160,6 +164,10 @@ alternative_if ARM64_SME
 	ldr	x2, [x0, #112]
 	msr_s	SYS_TPIDR2_EL0, x2
 alternative_else_nop_endif
+alternative_if ARM64_HAS_S1POE
+	ldr	x2, [x0, #120]
+	msr	REG_POR_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13


