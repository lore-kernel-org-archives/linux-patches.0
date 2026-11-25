Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625743;
	b=KWGYRf4GUoym32nONbFpMP/wdNdUDRoZ6P0jl1BvL9aIY6rO//EtA4Rp9RwpCKNmrxPh
	 BdtbTkGxu37k6g8q7TV24+zzivoEt+SoU7k+rff44qN8Q10vmonSrn+dQUoG29qP92cFG
	 buD+YlB2bR5VQnNlhApR+jyvxifdhZxwcDflfLgsYAxtxpA/+4RvfwEMz05g/OWblwnos
	 /fVe4aI5ErX/+IeX5HzzqlXJfDxj2plVOsi6gNAqI6ElUkspeNm6CMM6dNwcKU1Zt3ins
	 WHMpbc6i051conFzJ1Qaaetof07g7LNJZEogqXaXDaESh4TbQ6BVfwxaCnCswdnPoEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pcsynHYCkG9kxniC4kjMseFPEWaVY+klPS6Y4BSHlXA=;
	b=vedmgh85S3ts+uDL1qNlTJdRl1/ylG1Dgm57snHkE+2FCzEGGwaUDaFLZN4nORXdXfpx
	 jCYL7+jKqws5QwVNAtX/Sxq0j18CXRQxntakFhSIcaP315ela8FeJkOYvUuzClhtJaN3R
	 pdlkVSej5FQPaCYRP+R3P4CLx+MaNWCnWcE32Knq9ilVc5mSUm47VPGBOFK58bP2OWGvn
	 dFNFb/RpLXVNySSflpIO0uXy0gkiGbnJUWJ9HOMl+5m6XBddIDVnSq5tF+ohD3rOxHD4X
	 u3SwzEUYRsJIX28Rz7wlh03hUctUWVN+TQmtWPdYGR98iastx2yJLE2l0TslQRO+xLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTYr52aF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E5D606A687;
	Wed, 25 Nov 2026 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTYr52aF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B81F00AE3;
	Wed, 25 Nov 2026 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625743;
	bh=pcsynHYCkG9kxniC4kjMseFPEWaVY+klPS6Y4BSHlXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTYr52aFmE3UrreWOf7SejxaMix/rTPhXtcKDGlTF7m5eP53vOmLsSDNSOlVJ5qbW
	 gd1xbqtqY+AlgHjGXKVGsbOxbUjH0c2bMKG1uK3Dl9gsiKNEPKsWaM/Ej2umPSZHQl
	 I2FC1I0ljrqIbQPJtpJ0zY0jac5LSZZRS8TwsYI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 619/816] arm64: ptrace: dont warn on missing siginfo in a group-stop
Date: Wed, 25 Nov 2026 15:36:07 +0100
Message-ID: <20261125143903.509348664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Gongyi <zhaogongyi@bytedance.com>

commit 5306f124f3171289b2ef5bac1e08aad175f66d1e upstream.

PTRACE_ATTACH to a group-stopped child can enter do_jobctl_trap(),
which calls ptrace_stop() without siginfo. If the tracer writes
NT_ARM_SYSTEM_CALL, system_call_set() can change syscallno from
NO_SYSCALL before update_syscall_orig_x0_after_ptrace() checks
last_siginfo. WARN_ON_ONCE(!info) then fires for a valid ptrace stop.

Keep the early return when siginfo is absent, but remove the warning.
This leaves orig_x0 untouched at a non-seized group-stop and preserves
the existing syscall-exit-stop handling.

Fixes: 88b839ce497c ("arm64: ptrace: Keep 'orig_x0' in-sync with x0 on syscall entry")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
[catalin.marinas@arm.com: modified comment as per Will's suggestion]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -572,8 +572,12 @@ static void update_syscall_orig_x0_after
 	if (regs->syscallno == NO_SYSCALL)
 		return;
 
-	/* We should only be called when target is in a ptrace stop */
-	if (WARN_ON_ONCE(!info))
+	/*
+	 * For exit-stops, info is always non-NULL, but that's not true for other
+	 * stops such as non-seized group-stops. In those cases, just return early
+	 * as there's no need to update orig_x0 anyway.
+	 */
+	if (!info)
 		return;
 
 	/*


