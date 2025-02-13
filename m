Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDAB159596;
	Thu, 13 Feb 2025 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459009; cv=none; b=eyWTr0oUuquaZxGz3C/prieDr2o1KxRX1SQPipXBwoCcWJGjBJIdY1uqNwZMgRSOonx/v8uYv8rpqucVyWXZ3Tybo99HnEDeYv+3CgQBK8xZan6amnmWurMIPVsIHvIeVFOdfL3Tw5uzcX8zQkOdbhQzG45OSZUF0pBlxq4Qyhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459009; c=relaxed/simple;
	bh=id3ts1IgoliR0XUlSFes/4q5CNJoVoOY3s3s1afIfX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVGCklhlOq48rCXhiLgG46RYcj/qQtIYs7OAJNi8PoLB/uQxpXSiJqFgSOTz6xgDy7g7UcLt6PDWiQLTRzsDockLpzCbVovzDmjssy/kRmGsx8uQmVhjpXUEk4M9rlNJ5wLd8KtLjHLxgKSHBrjhNTiZrsdo9rRyvLrJB0I8LDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqOe2f1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqOe2f1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FF9C4CED1;
	Thu, 13 Feb 2025 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459009;
	bh=id3ts1IgoliR0XUlSFes/4q5CNJoVoOY3s3s1afIfX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqOe2f1EmJArNtYJ+TfXkR03ZKHv3S3C0OkaTXebR+2oPdnwxWsiIaohIu2kMssqs
	 Y258cl+ta+qL4jbrj0Y3R/2sq2Hv50B1Pwrth3NXZEzC3b82UJ6h57LUcFyNjDFqn6
	 OUCCOLoThBBE/vpoWohgmCs431fGPbBARda7yKpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 134/443] x86/xen: add FRAME_END to xen_hypercall_hvm()
Date: Thu, 13 Feb 2025 15:24:59 +0100
Message-ID: <20250213142445.776444353@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 0bd797b801bd8ee06c822844e20d73aaea0878dd ]

xen_hypercall_hvm() is missing a FRAME_END at the end, add it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502030848.HTNTTuo9-lkp@intel.com/
Fixes: b4845bb63838 ("x86/xen: add central hypercall functions")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/xen-head.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 72f28d66e0e52..4e481b0eefc96 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -132,6 +132,7 @@ SYM_FUNC_START(xen_hypercall_hvm)
 	pop %rcx
 	pop %rax
 #endif
+	FRAME_END
 	/* Use correct hypercall function. */
 	jz xen_hypercall_amd
 	jmp xen_hypercall_intel
-- 
2.39.5



