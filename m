Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7DF2153DD;
	Thu, 12 Dec 2024 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022977; cv=none; b=NiP0qrqJFyqW1HYxD1USFHF7JxLSFB1XgtDPwN3L7beTqprdNXfT/FNKWdHs9XCANK2Q3buXZkgTynaoE0ucs3DShV9arg9ZnxVT9IClzakrZeSlP0Sjc43MY4Ex4hDmduf5TJN2icQGcBuUQx6lITUeVy9hPBgie8tVtCD9eho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022977; c=relaxed/simple;
	bh=3kRjESqyhqvYIg1Ox9O7u0b2W4TC3pCatdaYBGyP3ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNL0owAQhC7Qw52Myx4XyV725rPj/m7InAnzRGA9VLv3mlwtXy2NAsE9lrmcSf4wpb/xxz/OLioqIZgdzqksF04M19GqObJebn8hPW5AvQVBDJ9+DkkV4AijfR3qrkSPG6ODG4ZEmx1WEC1RLD005esvRBPj+zv1BkHfKfsm1/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpnbrHWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpnbrHWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303ACC4CED0;
	Thu, 12 Dec 2024 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022977;
	bh=3kRjESqyhqvYIg1Ox9O7u0b2W4TC3pCatdaYBGyP3ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpnbrHWUHUSmFc89QjRdUrK1xmKWMGZIyrrxeQ8GVccgqP+ykUSCVRG2hHj/5yydT
	 z4Tk5CuGhscIRrOx6bSpBbZsie/cAIFEPGVv54qH/TMPXIuPw9ZAB+ubo0AzMmxyx7
	 bzInAPrOm9kan/ik4YFZEtWCOv4nuLzKM7Tm191w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/565] um: Fix the return value of elf_core_copy_task_fpregs
Date: Thu, 12 Dec 2024 15:59:10 +0100
Message-ID: <20241212144325.635833727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4b6179a8a3e8f..8d84684000b0b 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -403,6 +403,6 @@ int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



