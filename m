Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA0143D501;
	Mon, 31 Aug 2026 13:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183452; cv=none; b=AlLURP3XyFXYBthLH2TTVJDwreJArYKpdnzotBeC9RcvlYiPV9ZfM4PKU9rmoGD5AjaZjxnaIWFAT7UfM4Qfwz8GMyKgP389HZqKPPaDwNwJxaA8MiJ1oW0ylJ/TIAPq8WDorgyV/cW0YVDCT53Of83Sisv6L5+LgBDhiz27/0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183452; c=relaxed/simple;
	bh=h5hKXYXZEJCivYXk2sY1rx80bAdLWZtlsZADaIMmIKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZnXv4MNL1G25hH+xFcvICSZsXddr3pVd2C0XtSy5dDtFTW2tlqf2DoYiJzIHQjFnjWbox4sBoiDhyXCJTopZxo5IOepmEYBl6SWLqc6DMyURwtAV7abOkZ5r3EK+NBmcaGYjLXYRGui8lQVptQelxs3OTf9EuMeAuVmhP+rJgME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZbYe2bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZbYe2bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4FB1F00A3E;
	Mon, 31 Aug 2026 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183450;
	bh=KeUVHocBtuxyivqgIPcKBpB0L3X8j7zqPIirTyiTYqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZbYe2bJvLQjGdwmByc1PI4rtUPiCRkb1iAJQ9rAJNm6a7/2c3jcCLkJGE6qmNsqv
	 F7tuP4wFcGjx3Ae4lceblOjmycPjour7CNoDCP/cjxhWwP4jiWdiecrm50jlDHkTGY
	 Xo48EHTyAmuqY6kiwke1wE8cFTHn+OD4CkqbG1QEAyBP6W2RrC9IAj16WUFWnfZd50
	 c9yssn5uTJ/glszjALdUed5l789Y11rmAxd4jCf4ueA146HOADE4ue26YDigYmlOfa
	 KNZNLBye8VcD6Oh9h8ZfUTXfdvzOm4vWXaf6ZqbWtDHjziE2YNqUjRJCA7jtTAekyt
	 fdonY5xvcKC1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ray.huang@amd.com,
	rafael@kernel.org,
	viresh.kumar@linaro.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] cpufreq/amd-pstate: Loosen requirement on lowest nonlinear frequency != min freq
Date: Mon, 31 Aug 2026 09:22:12 -0400
Message-ID: <20260831133314.4125787-104-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 6842427bf2990271c771081f11fd8fab17f86c82 ]

This requirement was introduced by commit 8f8b42c1fcc93 ("cpufreq:
amd-pstate: optimize the initial frequency values verification")
specifically to aid in debugging BIOS issues with invalid _CPC tables
on some older systems.

This requirement is too tight for new systems though as some systems
actually have lowest nonlinear frequency identical to minimum
frequency.  Allow that combo to work.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260715174318.18235-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Verdict for Linux 6.18.y: YES**

The amd-pstate patch is a one-line fix (`<=` → `<`) in
`amd_pstate_init_freq()`. The strict check from `8f8b42c1fcc93` (June
2024, present since v6.11) rejects valid ACPI `_CPC` tables where
`lowest_nonlinear_freq == min_freq`, so the driver fails to probe on
some newer AMD systems. The fix matches the existing comment that
documents the inclusive range `[min_freq, nominal_freq]`, is
reviewed/tested by AMD, and should apply cleanly to 6.18.44.

 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index ce6d6b3ff58a3..46086a9053044 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -951,7 +951,7 @@ static int amd_pstate_init_freq(struct amd_cpudata *cpudata)
 		return -EINVAL;
 	}
 
-	if (lowest_nonlinear_freq <= min_freq || lowest_nonlinear_freq > nominal_freq) {
+	if (lowest_nonlinear_freq < min_freq || lowest_nonlinear_freq > nominal_freq) {
 		pr_err("lowest_nonlinear_freq(%d) value is out of range [min_freq(%d), nominal_freq(%d)]\n",
 			lowest_nonlinear_freq, min_freq, nominal_freq);
 		return -EINVAL;
-- 
2.53.0

