Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894E23542F8;
	Sat, 12 Sep 2026 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212839; cv=none; b=aKNKAuMzFe2YyMzFUbl1eO40wrJWX07bjJCDi/ZoBIe7jf3q+Pq5/9vSJTQQGFZnYzZhA2zHedtA63jtecxtlOwsnx2o5uRlR5rtgPgoSbCPG3bfmOVJGCSFX0e6ITPL9maOKVt5TNgIsIWgD5eCNUgHoKd7iR+FE9s21MDDozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212839; c=relaxed/simple;
	bh=yoXmbu84NJb0dtyAOdyYq6GZlm51ryH7DRJBlzDq3+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSTEw1HOnSp3eEZYJrVMilyDCDKmcAFX/glVv/3DFVk4IcBwkFncfdcfu8KTqSwG2es1OvSaqx1DeCHO4ij8EHPCON26aXMWxC5BXd3Yb/uCVxKpaJ+4yno0z/Vv/G500tApk5M2bsbLdQR2LLHmEfax5v6oFxuerXBT6YwPbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdekBkQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdekBkQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EA81F000FF;
	Sat, 12 Sep 2026 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212838;
	bh=Va+gPNgKlR9Wr4FV58wvGtAEBK3EbAQFhg7UBIEdAIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdekBkQhwwITxnHizLAGHvTyIOqzkz1Me+79j2wKzNLqN//z8oVgL8I8UX1N3EHA0
	 mPeTa8MfRrtjitjj1iXYxBa9WeS1VhDoEXdieG7vvyBvDaL9G6hydhUMQrT26AxVzp
	 ga2cCYzwd6jRt0Ap5jmUb83p8svaHz2BLRozd8hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Stuart Meckle <stuartmeckle@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1474/1518] cpufreq/amd-pstate: Fix setting EPP in performance mode
Date: Sat, 12 Sep 2026 09:00:43 +0200
Message-ID: <20260912065656.901347679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 5629eec1a2829871d496f3042884cdc267612f6a ]

EPP 0 is the only supported value in the performance policy.
commit 798c47593cca ("cpufreq/amd-pstate: Add support for platform profile
class") changed this while adding platform profile support to the
dynamic EPP feature, but this actually wasn't necessary since platform
profile writes disable manual EPP writes.

Restore allowing writing EPP of 0 when in performance mode.

Reviewed-by: Marco Scardovi <scardracs@disroot.org>
Tested-by: Marco Scardovi <scardracs@disroot.org>
Reported-by: Stuart Meckle <stuartmeckle@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221473
Closes: https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/work_items/190
Fixes: 798c47593cca ("cpufreq/amd-pstate: Add support for platform profile class")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index eed7ed42c391c..108d5e01459f6 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1364,7 +1364,7 @@ static ssize_t store_energy_performance_preference(struct cpufreq_policy *policy
 	else
 		epp = amd_pstate_get_balanced_epp(policy);
 
-	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE) {
+	if (epp > 0 && cpudata->policy == CPUFREQ_POLICY_PERFORMANCE) {
 		pr_debug("EPP cannot be set under performance policy\n");
 		return -EBUSY;
 	}
-- 
2.53.0



