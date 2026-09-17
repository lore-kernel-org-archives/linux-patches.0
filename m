Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0402A4ABBDB;
	Thu, 17 Sep 2026 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665444; cv=none; b=UlQE7pubRxLex9dHYZQjI4edtKyZMghe7xILos9d2jUFRvglSBX2NGL1pMoz4lw1utCcNe+EQj4U7Cz/3LCzRTB6hOX2yRE9h83+NAvOvpI+BfP1b5lIAL6ist/KB4zKpDCCqnL5HMmnFhqeVsiUZYqFwnPpIYjIqS8StPWKsXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665444; c=relaxed/simple;
	bh=Rm0kxe8zDjyyBwC1VDNSTo9nifz0JpUFM5SsO+H7KQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2clEKR5eFv+p5Xh0ust4ArPkNqq3EWF9/tdeMgtKL0ssM8wYWnjOzDWNeivE9FKaF40YRxuYFiZsAkbxBHvUjVzJ0IDACohd64A5lFs1wM/fSvvX9gYXR4kNe5ysMtpDo+FBzW7Yq2Nr6J3j+tDyEYOTHfvKzAFeA6AXfRI498=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8QqQG6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8QqQG6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB0A1F000FF;
	Thu, 17 Sep 2026 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665442;
	bh=S0ri4ux1u5Dzpa2g/3KRPrIJynaM7KfJ8h8ioodKw30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8QqQG6Lb1WIew8rC6fOXyYf6zqG8ySZrMuSXi6x+iwbQhYb7GT+vFTEMItJfsrP4
	 bDPc6w5XQyH3d1MApb5/KN6k9f1dIB6uKDaClYaXTIm/H67ZD/i3KToK9MC7q0FqI+
	 9gkVt3m4E5fFG7pXxrenrXNcYnqlBjy0Q15AOS9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kusche <klaus.kusche@computerix.info>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0707/1250] x86/itmt: Dont make ITMT enablement depend on debugfs
Date: Thu, 17 Sep 2026 16:08:22 +0100
Message-ID: <20260917151611.062950227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit eaece4849991d62fcd6f46637c55dcce00e25d70 ]

sched_set_itmt_support() treats debugfs file creation failures as fatal.
When CONFIG_DEBUG_FS is disabled, debugfs stubs return ERR_PTR(-ENODEV),
causing ITMT to be silently disabled.

debugfs is a debug-only facility; its return values should be ignored.
Drop the fatal error handling and enable ITMT unconditionally.

Fixes: d04013a4b21b ("x86/itmt: Move the "sched_itmt_enabled" sysctl to debugfs")
Reported-by: Klaus Kusche <klaus.kusche@computerix.info>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://patch.msgid.link/20260831053836.1881864-1-mario.limonciello@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/itmt.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/itmt.c b/arch/x86/kernel/itmt.c
index 243a769fdd97b..85ebde361d6ae 100644
--- a/arch/x86/kernel/itmt.c
+++ b/arch/x86/kernel/itmt.c
@@ -110,18 +110,14 @@ int sched_set_itmt_support(void)
 						    arch_debugfs_dir,
 						    &sysctl_sched_itmt_enabled,
 						    &dfs_sched_itmt_fops);
-	if (IS_ERR_OR_NULL(dfs_sched_itmt)) {
+	if (IS_ERR(dfs_sched_itmt))
 		dfs_sched_itmt = NULL;
-		return -ENOMEM;
-	}
 
 	dfs_sched_core_prio = debugfs_create_file("sched_core_priority", 0644,
 						  arch_debugfs_dir, NULL,
 						  &sched_core_priority_fops);
-	if (IS_ERR_OR_NULL(dfs_sched_core_prio)) {
+	if (IS_ERR(dfs_sched_core_prio))
 		dfs_sched_core_prio = NULL;
-		return -ENOMEM;
-	}
 
 	sched_itmt_capable = true;
 
-- 
2.53.0



