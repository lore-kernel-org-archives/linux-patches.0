Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F5C25C6ED;
	Tue, 11 Mar 2025 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706765; cv=none; b=XIOvj4Bj3pKsTkn2fNbFZD7R7UMuNmzQ6tiKjWoC5E4j47YxqTldAnJHAS55XBFrC4H2QUqeGo2l55dEK6+SPsSXbqsG1Yy6nZPPDvWdBxkizWodK9NyoRoYfPw01mFtWJW/nzMEcE7oar+xAH3kTDaoNX3kHwgNzscubaCmJWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706765; c=relaxed/simple;
	bh=wnWPPbTKN2uK+14WKtL7mgRff71qUBP2omj5J5oX9OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqNf6Qf9V/C93rss3OgWp7pm/21DyPsw9ZHdLVfWoyorib27xxkZZERyZ7syqQD7zigX1oLJYF6xVtFxMO/dytXy7j1dmYSRltkKIS2qMem+HtJ7+AGmu4fXDLxWd2naTn+2OarelNr78BJcmrtgGKZ+A741TviEUAI7JG60/no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPZ6MeVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPZ6MeVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9164AC4CEE9;
	Tue, 11 Mar 2025 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706765;
	bh=wnWPPbTKN2uK+14WKtL7mgRff71qUBP2omj5J5oX9OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPZ6MeVFK1HimrUrUHjgJUHnW/+65+kW8Do3LKcFb5dheu92iwbAa0vAfxgGWoJlx
	 Rr2CndnUG5HF2Msf0tVzQuecnNNDoVE9GgUaWXPxoYR3UdbTLXFfgwr30rpvNz5YS0
	 ZF6XvYcXTMqfLM9DWmOwabBZ0pOhgv0brB+ZhB4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/462] x86/xen: add FRAME_END to xen_hypercall_hvm()
Date: Tue, 11 Mar 2025 15:57:06 +0100
Message-ID: <20250311145804.663718813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
index 0dce73077c8cb..6105404ba5703 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -130,6 +130,7 @@ SYM_FUNC_START(xen_hypercall_hvm)
 	pop %rcx
 	pop %rax
 #endif
+	FRAME_END
 	/* Use correct hypercall function. */
 	jz xen_hypercall_amd
 	jmp xen_hypercall_intel
-- 
2.39.5



