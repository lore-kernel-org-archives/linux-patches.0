Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6443247D449;
	Sat, 12 Sep 2026 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219604; cv=none; b=Dj4xTQcZRlU1jaFEhlNjFqIUjO07H+HCqXcTx0GLXmnU95xl8aZsCZYdw9Z8IfO16v64QtvN7SYejBj+bd8NAZZSyDOePcrasfTP3kEx4qNFF7jqDlGOdm4yTT/W9gNLU3fBnTJEPgsIIRtE0aF7yWgrp6s37Swm+cvxkqY0yak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219604; c=relaxed/simple;
	bh=sEfoPPH32RejTjm9GRe0fGtUC2J3CGm/Wjdt7u2wM4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erWsr9Q0t2e2Vdb8VFnDSxGKz2W1YAduCh6uEigtTyT3SHb4KHGkcwLyHPppLmCjzBAXhpWke/9wtCNgz8LBo6QSRgz0QMlh05T+DkmO0NHCGCxcbP/j5EtT4eddFAT8NjqTVmHpJ4yzteb/vL9OowKdMBPBi7cpN1y0o3uevRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXGVuHFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXGVuHFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682C11F000FF;
	Sat, 12 Sep 2026 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219603;
	bh=/Oc0ju0OBkXG7vWfWDrdqveiCjZ/PR1y6jLVsbmfF44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXGVuHFD6V6SlMp5nMzap6ytVFknO3JGzzVf+qdyPsbtIQm3OWbZg7H+la62fPfkz
	 7ibB16PpIu7c1I6HB1PZK9eatlYBeVauloYqm4i0I/N0zjHlZ7hN3jERCAlEiaFZCU
	 EF0lxQBoOxbhevaT5u+gD2BL6ult/7HPNwuCcz8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Sebastian <sobrus@gmail.com>
Subject: [PATCH 6.12 1339/1376] cpufreq/amd-pstate: Fix prefcore rankings
Date: Sat, 12 Sep 2026 09:02:45 +0200
Message-ID: <20260912065637.373384111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit fd604ae6c261c5a56bb977ae99f875bbd7264a3f ]

commit 50a062a76200 ("cpufreq/amd-pstate: Store the boost numerator as
highest perf again") updated the value stored for highest perf to no longer
store the highest perf value but instead the boost numerator.

This is a fixed value for systems with preferred cores and not appropriate
for use ITMT rankings. Update the value used for ITMT rankings to be the
preferred core ranking.

Reported-and-tested-by: Sebastian <sobrus@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219640
Fixes: 50a062a76200 ("cpufreq/amd-pstate: Store the boost numerator as highest perf again")
Reviewed-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Link: https://lore.kernel.org/r/20250102141204.3413202-1-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index cee6cc7b071ba..c0ddf9f5a8b04 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -780,7 +780,7 @@ static void amd_pstate_init_prefcore(struct amd_cpudata *cpudata)
 	 * sched_set_itmt_support(true) has been called and it is valid to
 	 * update them at any time after it has been called.
 	 */
-	sched_set_itmt_core_prio((int)READ_ONCE(cpudata->highest_perf), cpudata->cpu);
+	sched_set_itmt_core_prio((int)READ_ONCE(cpudata->prefcore_ranking), cpudata->cpu);
 
 	schedule_work(&sched_prefcore_work);
 }
-- 
2.53.0



