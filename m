Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041931F890F;
	Tue,  3 Dec 2024 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242670; cv=none; b=O4b/HY0oAUau8dT2tIRiorvnHGnfsBvX8Rvd/RMrbPe3tTpTo2spuDThE4sU128K2fu1pM/XrE7bQxs5L2OtnyeFNxl+YWW/Yk1CSj2lM9JAar0Ncf5U8766+4waLhs0KoL3ZzGnJp9aNvKfoBC9TZC/w5xI7hUKAMzcZHU8ZOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242670; c=relaxed/simple;
	bh=9unZLCG1wqJvZN0TN2oTkzHy54sKAT+q6KJqTM33Zgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rm3nTZAnW0Ve0IjrvUboFUp8baR+i2mbOJibo8EngYYSiJqSFEIwBGOIsGTX61L8NEBfLeo+9uBpklwOCffz4aWnipiiImUCCiO4Gi1RIjjPOjLVbzuylHdioHDN4WOB7CUKvXC2t+jYtasL2K4S9foNqzeAlyvTF4YuzkGsf5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KT7izuks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KT7izuks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6EAC4CECF;
	Tue,  3 Dec 2024 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242669;
	bh=9unZLCG1wqJvZN0TN2oTkzHy54sKAT+q6KJqTM33Zgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT7izuksa7mVLyhXRUgts48aTpEm87oSuNzT15paL+FsnM5R21F4Fu9ATD7ULI3Ch
	 CAvmu0fimu/LZXf9M7dWYzOOe7zRgrvFaS4Bj5ZlbdeH0a1LY5zAGLHaSyncT9gtXB
	 HLDVBoch/Cvq8e+/BBq2qqDr/d5dcxO0zDKV64js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 773/826] um: Fix the return value of elf_core_copy_task_fpregs
Date: Tue,  3 Dec 2024 15:48:20 +0100
Message-ID: <20241203144813.921775075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be2856af6d4c3..9c6cf03ed02b0 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -292,6 +292,6 @@ int elf_core_copy_task_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



