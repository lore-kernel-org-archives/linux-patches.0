Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F772216E2D;
	Thu, 12 Dec 2024 17:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025559; cv=none; b=gZCW+tu/oxjxUCGO23/5UTY+VAd2utCfWQXPTedJ5T+1TI8v5asDGbRbJAyoeRPx7qNsm0uFHrS6CdfV3dcQnQ1JH1APOhboe3U5wg+pHffJ1SA6nUReUxbODfUZ2Ljk8fbkorE7iAIIA9bVBw5HyWPHiKV5yfdJxiK+bTOX8BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025559; c=relaxed/simple;
	bh=nnekUKiPqi/HD2B71FNy1qIFCv/t8rbSY4dURSzKP4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV0Qf0Dy7Q+r6JeXF7bQYwGLHickBN6q7CkO3SEWLDpWS/l1d5SHVHdEuKZGOHamzjTPil7gE4hN1JqDAth+fGxU/IzTbt62oesDilRAFU4yJTGxlvwQhISfCmb816kFyetMmiYZ5VTLkKavqYTzsdQapgT4OmAc0I59+2Ihj64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAHfB/ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAHfB/ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0AAC4CED0;
	Thu, 12 Dec 2024 17:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025558;
	bh=nnekUKiPqi/HD2B71FNy1qIFCv/t8rbSY4dURSzKP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAHfB/yahrcLTmiCdejeRfMKelBPD/1nMGcOyr6wJ+7MFv3Zvf6CfwBgyFJF2SKN4
	 jvftEL5rbxMOmimBUXHffNzhrCpMrtHUk4Fblf6ZgnvV3SLwTheVz5mO26NljzihWA
	 81SzLNu4eBAGPX/vOhhF7MC6byyOYTchrv8kZvzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/321] um: Fix the return value of elf_core_copy_task_fpregs
Date: Thu, 12 Dec 2024 16:01:37 +0100
Message-ID: <20241212144237.059225314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f185d19fd9b60..16460c58f3e2f 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -444,6 +444,6 @@ int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu)
 {
 	int cpu = current_thread_info()->cpu;
 
-	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu);
+	return save_i387_registers(userspace_pid[cpu], (unsigned long *) fpu) == 0;
 }
 
-- 
2.43.0



