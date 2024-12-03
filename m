Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1CF1F76AC;
	Tue,  3 Dec 2024 15:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239882; cv=none; b=QFA2/jKiVAkfix5CvmsFHfbzgMZQuFaK7eGU+g6TLZdc4C8RDIpILK8jY81ltbho92rApWOUPoesOuT8fjIpfLcJPZDIJOV38JG1UBdzNvYYLySHTsXYlG5HJQlpagsW9LGHSGplWAay1Djq181x/8DMlds5JeYunSVkTWhHiTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239882; c=relaxed/simple;
	bh=JSqXZ9QKCMP/cE8kb6gyR1xnW1DYXq726pDxmIIIT/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXa7xz2VbINUPQ3KphuVVtIiULVTK0YOJbEWtkw65V8+12srKVG3ajpwj/VmtNileisJLOmRe0TGxKKjF7f0UOIz2pceKMH8YyZwLDt6OthDv2onKyycWPL+k2Goj2ePpmE05YsKBZFOghDrbD0pyrEbacb8u36zWyNCPVNOH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PK+ZumqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK+ZumqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0AAC4CECF;
	Tue,  3 Dec 2024 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239882;
	bh=JSqXZ9QKCMP/cE8kb6gyR1xnW1DYXq726pDxmIIIT/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PK+ZumqPDzFuOz9NOlSlkMn9L12fTpE55jrwXU5Jp6QIqajXU7EhHI2qlURMAPGRZ
	 LPZBZQsl9sxWqWt3ckk17kfMKCESbx49pqYE4SzNNuimzxBcF6GzYLedi68AIuJt81
	 XbXR6aMykChPKqx1ktMIh51yVSL7CXPAC9906aSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 766/817] um: Fix the return value of elf_core_copy_task_fpregs
Date: Tue,  3 Dec 2024 15:45:38 +0100
Message-ID: <20241203144025.911597041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f36b63f53babd..d3786577c6fbf 100644
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



