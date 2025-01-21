Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623941F63EF;
	Tue, 21 Jan 2025 18:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483128; cv=none; b=EXQG3ocWgphkFprSAgT69F9hDjnHUhqYYGydF34Fdn4gV3d+EOOfqve0GCEQQd2QiLPbuPuJQYdaVQIE+ou92PD+YPt22aotlLaga1F4y14n0tdYTHZM0vC4tM5zWIG+ze3dQepG2GsQi4I5Cc/uz7JK+drAw9u72h9zhU+XtVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483128; c=relaxed/simple;
	bh=rv/KecJhIA9+H6yjpZgmKz5fh4thTadPcrTkEtqGOEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoAw6E8q+LqRtwa0E9/F0G5NmKJomXiwtaZ7PCMqpmmlGCiykzrC+lUV+PM0wdDbIxZrMFlSq3eDcwadyblcfU4PjEr8HDLBmX1gd9ad/qfVDjtFCdLghQg9JHAuXAiBG37CVnL7qvSP9FgjZPMEBppvlDjjF4UmF8bNEHGFFaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9kbZJoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9kbZJoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DE7C4CEE1;
	Tue, 21 Jan 2025 18:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483127;
	bh=rv/KecJhIA9+H6yjpZgmKz5fh4thTadPcrTkEtqGOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9kbZJoShHGrx2mkAdJmoqlMVG8BVgVWmIHsE8WSvfIM8iafhOvyadxbkLHAfHTGU
	 n9V3I4sZJtcK5HgAXii6zQBBfo7b4ypE8IbKMf+3LBEFAC1tRehzNoUc2wnux5ENDw
	 nZwNAaMwbfshEERjoAEUvuxalVQjwf89+3sLmdBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Juergen Gross" <jgross@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 125/127] x86/xen: fix SLS mitigation in xen_hypercall_iret()
Date: Tue, 21 Jan 2025 18:53:17 +0100
Message-ID: <20250121174534.454806322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

The backport of upstream patch a2796dff62d6 ("x86/xen: don't do PV iret
hypercall through hypercall page") missed to adapt the SLS mitigation
config check from CONFIG_MITIGATION_SLS to CONFIG_SLS.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/xen-asm.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -214,7 +214,7 @@ SYM_CODE_END(xen_early_idt_handler_array
 	push %rax
 	mov  $__HYPERVISOR_iret, %eax
 	syscall		/* Do the IRET. */
-#ifdef CONFIG_MITIGATION_SLS
+#ifdef CONFIG_SLS
 	int3
 #endif
 .endm


