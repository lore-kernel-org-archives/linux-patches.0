Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732A220B80A;
	Fri,  6 Dec 2024 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498443; cv=none; b=So48D54co4r/7n6NzxjOLFYkIf65MrXsRhpV3WEXijsMgk6+JRhS2r1ijMsPj1AU3wjTzAe+Edp3YGf2ob6i2ZnMmeu9LhJPWHQ44/rjbpPGVI7Mo3vu9Gcyab5fLP7Dpleokhxm2K5epBypEQROkFacSz4/1YnP67NGsXpoW1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498443; c=relaxed/simple;
	bh=UWQYCdYt29aOdAduovYa3JrpHgscYeLSZlBpvTxtvfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPFme5PqdsweFFO6N9CH/nDhFdzTiuuE/cACc8gh+ZOQGejcFDGXN1GSlt3u1sfSri9IRjDY/DC9QSztGTstefpssdThlR1/hoX35BLCBZlSHpNAPv5sPE4YxclS8Rb7d1SYM2ln/tk+tuLMe1rmVXEhAAiJPec201z2JMy8+9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhnqSHtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhnqSHtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFE6C4CEDC;
	Fri,  6 Dec 2024 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498443;
	bh=UWQYCdYt29aOdAduovYa3JrpHgscYeLSZlBpvTxtvfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhnqSHtr0xxVdBloc+okVIk7NOA90s58n8L9UddHBgsNeFyLaGUq87dYe70wYMi4B
	 WDcAZ4Myva31EcGCuv96YA5pIEC+uZigSAiGIKoPBfoutK2LVwFXUuTB/X1y1rSJcj
	 eYIfxknkSwoeJceMfuG9QWMu4WydAoYbPQGPL59Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 555/676] um: Fix the return value of elf_core_copy_task_fpregs
Date: Fri,  6 Dec 2024 15:36:14 +0100
Message-ID: <20241206143715.046080090@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6daffb9d8a8d7..afe67d8161467 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -397,6 +397,6 @@ int elf_core_copy_task_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



