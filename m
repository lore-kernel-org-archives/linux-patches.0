Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE754C10C7;
	Thu, 17 Sep 2026 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659187; cv=none; b=SJpV5+JC0MN7WNumUAnPTJryypunHT0NVYBdq6mK2DykFM4wmP2FNLfVCL/cTDlDDoIPb/ZsI/9x6xj/fI6FVjr38d/+GWN9zklTyIwoqh9nlWtSPO16wAYbtxoWsw9CkSFYvoJAhoR/5d1l2bhuEG2Ah4h2d0dBulLhfIM+cxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659187; c=relaxed/simple;
	bh=AiBEtLXxAGT13KNpJ0y2G6wJ51PRd9gjtzwbplJGU/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXqYmB1REIiGWsMHGN36Mi9q3M3xn/D7qfMwG69F6WuRhcYnH2v94DmO4EhnXszcMz/R7rOhZ1wN2nDyIvv0dwxD/bXhCTyu1X7P8wubcP8TAy0yLzQUyP7TwcEsqtU3fDkk6pFthOXB21pHA3w8LTQNa2qQw6oV175o2qIxFhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq2Txybj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq2Txybj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71FB1F00898;
	Thu, 17 Sep 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659179;
	bh=EFRbJOjAbOuM/ceRQxl+Ad5wX8lGwDMPLboJxRla12k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aq2Txybjozb7uruJVVl+kkMR+D0GGEQ607kxlTTzL0rr8nQp9jNAoVpEfUBwo+S4v
	 bUigkTevdofsBmq9CGBDG9Wxh9FkH7tZJltVhui1/MsyMCKo8zF+yXdcLDJlSK9hR3
	 nif5P+owR5ym5L19V5S9U7cfJsMGAdLinAlKgUPc=
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
Subject: [PATCH 7.2 171/733] x86/itmt: Dont make ITMT enablement depend on debugfs
Date: Thu, 17 Sep 2026 16:07:59 +0100
Message-ID: <20260917151355.363496171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



