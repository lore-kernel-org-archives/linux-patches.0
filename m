Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D726B0BD;
	Thu, 13 Feb 2025 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460307; cv=none; b=KnO8Cja9co7ZnCS/iT3ETz+FcdGN6plJZjlxsPd5tpGtTF79mmz5DvEfSBVUQ/erFI0eqlALVZavtNIHMZs6gRjRLW4sXXCvkjQ6KzwkZJ8GbMBEOwv2NNqek4u/D00N2q8ShqO+3ns1tzZ8rbVfhi+ucl0OHgMkfossAtCAl6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460307; c=relaxed/simple;
	bh=Ix6Cofll2ep3/5hDCw9PGv61q5hMVbUQFOHh1bz2uYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMnrc8nqkp1yFEyitrnyqwYkchEBtHC2ja2AVLCJ7Rz/v1AexXASz1t0lP/UN41Q2DKySLgC4v0thJBRe00vzYOHCeZSZKnm5eCG/NdqV192neF0kUcHj7dquiGr4zT3COFcSFeoxySog3JPEnGz35ZmiN47Mn+7/ntPr0sQWTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luw/v8cG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luw/v8cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9012CC4CED1;
	Thu, 13 Feb 2025 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460307;
	bh=Ix6Cofll2ep3/5hDCw9PGv61q5hMVbUQFOHh1bz2uYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luw/v8cGxoMkTbDe3ZdzdB8WzumE0tCYqyORJ1xga7Gje24LFtc0CB+eB/BECnIHy
	 D244I7QFhzIkBi0p/huqtQOKxnKj2/5xRRE+gDAf+y2Gs3u/yCdArx34M6S2fY0Uk8
	 piVt4FmjU9hlcrW4yW50tR+FDHBtX451ko7K5cL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/273] x86/xen: add FRAME_END to xen_hypercall_hvm()
Date: Thu, 13 Feb 2025 15:27:27 +0100
Message-ID: <20250213142410.313361188@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
index 9ecdde17c4e1e..059f343da76d6 100644
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



