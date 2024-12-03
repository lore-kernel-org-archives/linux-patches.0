Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CB41EE029;
	Tue,  3 Dec 2024 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236824; cv=none; b=hgvjcxJpQvEF0TdZb/wMWRPj8jQ28XCTq3MFnu3/MT+6EWbA978cbORLi8jIadnP0sUvZCczlUzgdsdcMYUTQuckq3S62WcgPrSIAXhWCDY9Jwj3Y7wPSueoYZTIfgr7+tmp7afuuViQbnL//6GJWcLCctC4gtaleT8ONErnTLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236824; c=relaxed/simple;
	bh=ysw/BybpdfYX9g4OBwDOTUKmFQEmmZNCLZB3r9UmRn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBxbj6oSY6EmVIX32BpahZYRUnR92m/89Sl2iG4W1YSyVEo+G1guLddvqW9uShV1E7X2NwMkpd8f2S6pIuu/J1crgSp287y07oJhDy0S051jvIV6J75NJQ93nGYLKv2v4lnGlS6UtXTPiEHi0V+0Su+92nH6lDSjIPYyu1vO0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnfY+d4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnfY+d4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E2CC4CECF;
	Tue,  3 Dec 2024 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236824;
	bh=ysw/BybpdfYX9g4OBwDOTUKmFQEmmZNCLZB3r9UmRn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnfY+d4AlX1P/qrNMSOvDz2GRwgyp3qB0TR3uhdAIM2/62rQVybhtxl36ShvtcyZU
	 NAA5cGe9uk3deKCIhjkmd9NOdNTAll/JOpm8UpfsdSTEm4OJm4T6ksFuG8T8DXvmWc
	 6SXAGyEvYbZ8HLPP9RqudbGPkevaiB7ON1se3OQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/138] um: Fix the return value of elf_core_copy_task_fpregs
Date: Tue,  3 Dec 2024 15:32:36 +0100
Message-ID: <20241203141928.425369167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c9d09d04d19df..83ae59f748e1f 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -396,6 +396,6 @@ int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



