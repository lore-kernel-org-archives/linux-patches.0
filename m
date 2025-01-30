Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C671E522;
	Thu, 30 Jan 2025 14:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247186; cv=none; b=E3XeBhLNzzzsSVHbCnGzGY7npKqYtjlbEb23bxQ9Up7F02Zc2xLwRFs5FjBmRHNbfmAgFssltpfGbItMLGWu4v8pQG6rKBfZEv8dy1vvGq5VT3ixC9Y2i5ulrOSk+vRA0axOtML3CLnzbRYPj0t/pcsP3pO4SNaYxVrEvD07q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247186; c=relaxed/simple;
	bh=84OvLfBIgKfMo1Tu+oBIs8aU3zLXjkEjINgdBzTxGAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhPy3xHvnLR9V3/Ubnj4barDAbLfLLtsKt1SzSHZ63DhS5FwgeKO2dw3FiylIzuiukXtypmCSMffwcH0o19zQ+eJz0Zk1tVDpjpA5UGV5LuX5kOAM4chJAsr//sRfjl/f6Gh+g/+b2g6sN47OD5rBZNmQia4YquMTeQPn3wxV1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grUqRVHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grUqRVHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8028C4CED2;
	Thu, 30 Jan 2025 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247186;
	bh=84OvLfBIgKfMo1Tu+oBIs8aU3zLXjkEjINgdBzTxGAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grUqRVHhl0loRgD/JRn/n+LvoYyJhSgK+wXsi6wlDYY0VpAaEpQUHwsbL49ezgbaj
	 qoeg2ZXmxmrauI70pTG71YAqn+VGXbLvS2Iymx4R1fNiyzeiiC0VLxcI7R81Mt1DbJ
	 g1XveyrfTpmgTugWZV2nzoMCpTwSuXtepmzCKkHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Juergen Gross" <jgross@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 112/133] x86/xen: fix SLS mitigation in xen_hypercall_iret()
Date: Thu, 30 Jan 2025 15:01:41 +0100
Message-ID: <20250130140147.041410947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -242,7 +242,7 @@ SYM_CODE_END(xen_early_idt_handler_array
 	push %rax
 	mov  $__HYPERVISOR_iret, %eax
 	syscall		/* Do the IRET. */
-#ifdef CONFIG_MITIGATION_SLS
+#ifdef CONFIG_SLS
 	int3
 #endif
 .endm


