Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3732210E1;
	Thu, 12 Dec 2024 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020399; cv=none; b=Nxoq6mghmnfTztKuvgRJavoFJmrl5YbAll+SPgmqWIaPuyP5g+OF+ARez3aVH0xEimkSswUbtD4aUI75SvNiuaDFftZ9AFCjKjKeoVr/TUPGk9qKyV8OByok1zosR9aRpgCwWlRbqym0wqvJ4xSP+TNj9vsrzqZwEey7ZdOGrO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020399; c=relaxed/simple;
	bh=dPqBVv37FtB8KWueQIddzLQ04nzTzuJiu5Pr5OIhaYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDCGayLQlyAXlJ4VX66iWatDbsDn9fkQZEvetQhE05fY+bH7njmw4P78saHx8RDZyRcff2ey44iaq/q0pFmJMiissttiwy606d4mvadkY2XFRBPvwng9rxlkeAoBn6wDe6j7TuIEQjN0jfwANxB+qK1BBNYLYC7bYnerYXj0ysQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agsoqHvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agsoqHvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B69C4CECE;
	Thu, 12 Dec 2024 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020399;
	bh=dPqBVv37FtB8KWueQIddzLQ04nzTzuJiu5Pr5OIhaYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agsoqHvMR0S0hwzaQ+i/IRtwbJFBbrybRzXx3Em/6qS/CXoucBGHwQZ+TTATr1LP7
	 xu9KZufXWuaoX34bj8e8WaFtSlPeDQL6uvTtNm+tIQ63O0YgGT9QjSzTMIBSP2c33/
	 dPXgShwJb4g+/cJIqRzpUcqIasrL1QOQP2HijqcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 427/772] um: Fix the return value of elf_core_copy_task_fpregs
Date: Thu, 12 Dec 2024 15:56:12 +0100
Message-ID: <20241212144407.565416708@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a351c87db2488..c5281ce31685d 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -397,6 +397,6 @@ int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



