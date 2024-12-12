Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03A613CA93;
	Thu, 12 Dec 2024 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024415; cv=none; b=QuatbmwM7zVAmVl430mP2gZhWOtjZuIUr3TlsyecQbCFtrOssuh3/IRqSuAS+M4mudgywKY4uLQAk04IXpJRtP1ilu540viXgV7cBMEB1UnGosL1LGF4pcsL3v5pMRLDMti2oqY/K/J8lhCYiNNaKkYZ/NqohWOrgnnnL2z7QVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024415; c=relaxed/simple;
	bh=MO1v9TkF2PsUYi09O57paOKlVw8afMU2htNDH2pU7Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0SYBcGSvULyqSIgHNQiUtGzFnAbzZLxta9dm0vw8s5WCUn/SIqWdk9timciLak8NHcHtaxMI0lIy5dcpy8vZjewlN8gLWPcLv+IMjOYS/HFQfjFa+bZN4tA+R4MbMu2j2hBw/hNx6GDOFhSpTc02oTZFbTeEY/w3/bvBFIPwRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1IlKh4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1IlKh4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69D6C4CED0;
	Thu, 12 Dec 2024 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024415;
	bh=MO1v9TkF2PsUYi09O57paOKlVw8afMU2htNDH2pU7Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1IlKh4gCc96QN6ysx7WggR+ECtZ9qcJSURCpqRm5fbJZyl1JiqI6XeGMCtTikojJ
	 AC1W41eNLA4EbV4ZK6HcbVE9kSZmJRz1zsNKfZNkSp4zfpeDEL/ati2AXwEV2B0AOL
	 GjqXpMkj5jCbAjBZhEPP22XgVwqAE1yULqDsMo6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/459] um: Fix the return value of elf_core_copy_task_fpregs
Date: Thu, 12 Dec 2024 16:00:27 +0100
Message-ID: <20241212144305.048926860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 865e3845eeaa21e9a62abc1361644e67124f1ec0 ]

This function is expected to return a boolean value, which should be
true on success and false on failure.

Fixes: d1254b12c93e ("uml: fix x86_64 core dump crash")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20240913023302.130300-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 76faaf1082cec..63c6fbd4e45b6 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -406,6 +406,6 @@ int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



