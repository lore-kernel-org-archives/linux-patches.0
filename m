Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E5241699;
	Thu, 13 Feb 2025 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457478; cv=none; b=KnHA55V7tfafocoCyKgj5xr9ebQfZASzPrjYiWrMOmCLU33k44iPrG7s9/5X969e3cZ2tuL2wCsodspw9BcOTCwcFmC6vDu2BXh96mLqXvOqtxaS45C5bcz4EEclMnEaeHdQK6TA0u4ueHXS4fdcufi9PFF2tl8BwQ0hySdG0yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457478; c=relaxed/simple;
	bh=nE62W3Vthgo1mSoSKzC+RgQNE3K84dlKAaNnExxaJcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSTzXo/Fytxzk1bISZm+bC1hMfcKa8Q66V88mDRWllyRl8ZJtqUYEN0RoaZdG+AfR6ssVjIyL4ZR4yhZVMbXbIncxT2BWlYv5AMgdRSZb4TVfQOJPPLlF5QRScoTVc1rEkfxoI9Z9ODnrXRiKQNgJpEosc3Vbp6C31Z9E6pv9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+8A/Pj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+8A/Pj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428F9C4CED1;
	Thu, 13 Feb 2025 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457478;
	bh=nE62W3Vthgo1mSoSKzC+RgQNE3K84dlKAaNnExxaJcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+8A/Pj8mCJX6Aat3ODhmUcKd6B+ysxUQrcOF9GVGTWYX42+pNRjRxD79DKz3eH9h
	 ccudq1J5u+/XWdNMQ5a+9hpfD3V5+Ur44YuqVqYj2v26+m+z1p4cJGse5+OuDJTMWE
	 fmgHJXVdociAk38vUPBsnlkpPA2/2PUSOJ14ptbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/422] x86/xen: add FRAME_END to xen_hypercall_hvm()
Date: Thu, 13 Feb 2025 15:24:30 +0100
Message-ID: <20250213142441.220155501@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ce96877c3c4fe..55978e0dc1755 100644
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



