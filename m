Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1FA1E0DEA;
	Wed, 19 Feb 2025 09:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956873; cv=none; b=qcIKeaN4T9dX6nhR2WX9FKxpYucD3AKxHmk0ACW2KIpTQpEShp+a5x+4/GWCFeznuSst1LVoIzXss3nUnDtzl8BLtKfBvBqZAO4qhnrZGVYn9UuTz/07ZI80jaIU/l7EgeZONZEMViSWPUfldKAyETDQANvDSBL9NPh7hgsPjUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956873; c=relaxed/simple;
	bh=xxcKu3GnZhXjosgUvm5dVpKZmyE4yWrGFJ+NCwITrMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWpZxqjELpGFezGpRPZuyNlxy0z65G1tM/R6at98uSPApQDgeJb30/2ld9QBcmpzJ6GK0C1wwv0O1qp146i8Hl6TaTGicOdt2lT2u/44gxJAGnqA3MWOohRCkkMu6SbPHcBCVxI2GHvp0VYBDGkwNEKh70Kc8205JTvVEAxDS6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygKuxujF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygKuxujF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72827C4CEE7;
	Wed, 19 Feb 2025 09:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956872;
	bh=xxcKu3GnZhXjosgUvm5dVpKZmyE4yWrGFJ+NCwITrMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygKuxujFRbmxllu7esNYEml2RBdi5OQrRXWPW+S+w0DqejIOOmfWX9ruXGD6jGt9Q
	 ej494d8uLRbZZ957hFDGwXYRhnNAVoTrJOwM4EkJm+jlHuYXlOwnUeyO4e9yvKKGKz
	 Sz9Uu4sqPsbMyT9FSMLP+RikC5pWuBd58FtiksSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 330/578] x86/xen: add FRAME_END to xen_hypercall_hvm()
Date: Wed, 19 Feb 2025 09:25:34 +0100
Message-ID: <20250219082705.998439118@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 565708675b2f2..31d9e56ad6c6a 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -125,6 +125,7 @@ SYM_FUNC_START(xen_hypercall_hvm)
 	pop %rcx
 	pop %rax
 #endif
+	FRAME_END
 	/* Use correct hypercall function. */
 	jz xen_hypercall_amd
 	jmp xen_hypercall_intel
-- 
2.39.5



