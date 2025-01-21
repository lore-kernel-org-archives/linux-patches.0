Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5331F7578;
	Tue, 21 Jan 2025 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482211; cv=none; b=Q9P+9OrSc0iZW6iFL6nh3sGvxgtABkurXVVCRdGwyRv5lBbySZvASq0vSLRcvlmLAJkcecuD7nkB6II7wXvDv18P5S60IvuUa6yI/qXLJBsiR5bnlrhf3s9d8H01QUE7fNhNpBwqmDn9YAAaj/lLastkfD06++At7+rIbJUS5ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482211; c=relaxed/simple;
	bh=EE0ZojvnZGfV46b003ctVwVurCABehLUwX22FKZd/v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da05BFKqpTZX2fXNYp65Pm6Vz7My4zWc88QEuLUxkp9LakV9h5pBEX1TaSdI0MotYHVhPsPIicy3TAxep5A7AcBst8AW+BcuUvDlrB7Am1sZUTcYmOIFiU5QBaewNaISi7EwuCRpq/QRScfDWl0ZwYcPbL5UafvRsML8ZF+L2pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkPamKDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkPamKDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF00C4CEDF;
	Tue, 21 Jan 2025 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482210;
	bh=EE0ZojvnZGfV46b003ctVwVurCABehLUwX22FKZd/v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkPamKDokzxVCYrU+I9PBd5h9+QWYGWgrCZaYnFjRQ9fExOEpxjWl9BcvHGO9ivc9
	 8tXcIrR2mXu7venakpwESgrldOu8X7es6osV1e5pDuYxYQXKj1UU8tys6Q+it1oIvY
	 ib37bw0dNZlI2LHgnVjGMdknylyEiW66nESNGI+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Juergen Gross" <jgross@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 71/72] x86/xen: fix SLS mitigation in xen_hypercall_iret()
Date: Tue, 21 Jan 2025 18:52:37 +0100
Message-ID: <20250121174526.168510888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


