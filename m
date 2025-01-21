Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4CD1F0E36;
	Tue, 21 Jan 2025 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482781; cv=none; b=jIg5cMwRbxO4U3YadAhjJAMQ//GuhJdiP/qLMW73B/1xKi8ob2aKxKhU8yDyUr7mOC6d5L71NGXsQHVPewpXEW2ssumvDLPljjbosw25hiwBlk/6YFtZv7xzxRy8uiqRHQUr0MdFjETV1iPNxZG1eW9JlubYU6AKh+KUvLGYdeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482781; c=relaxed/simple;
	bh=462tz4Bscz/JzTv47YuuINvxJN2+jboc15okaQSLmvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2upuLlPMFpqVWN5QmPA+azmW/ksBLRBniT7vw4bDkeD2xlbJKb5Zbn+ZOiiL2+bjDoCx3AQkuJRHOwjfw34N5csWiO6qpmVdWr+U5ts2y8+d+IOikkHXTtoNBSB90W/j9H1ziCYBT2T8Sq+M7pOhlVHG3MfA/SX9TSRjcSiUYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmqBaYIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmqBaYIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D26AC4CEDF;
	Tue, 21 Jan 2025 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482779;
	bh=462tz4Bscz/JzTv47YuuINvxJN2+jboc15okaQSLmvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmqBaYIuhSaxADMUCfPKf43qBdwwzH1KIobiDsxGKuBJyNpgtJwuKbyMMV7vwDmDX
	 N0rghdWzRzRS4OQrY5VGzm5YkVx9r9kK8irixIPCcRHAIfxQGBsdxw3CSSSFHia4XE
	 swhfFJH5UZbH/FDQCcYSOy/6a7JzIhQGCbPQHp6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Juergen Gross" <jgross@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 63/64] x86/xen: fix SLS mitigation in xen_hypercall_iret()
Date: Tue, 21 Jan 2025 18:53:02 +0100
Message-ID: <20250121174523.960506245@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -221,7 +221,7 @@ SYM_CODE_END(xen_early_idt_handler_array
 	push %rax
 	mov  $__HYPERVISOR_iret, %eax
 	syscall		/* Do the IRET. */
-#ifdef CONFIG_MITIGATION_SLS
+#ifdef CONFIG_SLS
 	int3
 #endif
 .endm


