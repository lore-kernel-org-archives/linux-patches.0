Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CBA382F25;
	Sat, 17 Oct 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259025; cv=none; b=p+FenwoE65HZH0JvJey2Z84lUGOhzMPxauSr8vfN2CCs+9gSbl6B778VcrM9SBxZpaUTdG5YwRUakZPArZ6KBjJUAP6eTYsfr6+KUy8bD93+HWHP4UVCfPG8OhD/ApsHhyrI8Q90dY+yoGWcgLW3g08vvB8/mAjPJtHjMAQw7wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259025; c=relaxed/simple;
	bh=3O4ff4nn4JxBZckYodKHqemdkNFNBDesllRrizIFrHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O408wagqiBKmqlYKIz4YXEatQY6gdJo2wJY+Vw3qYnO108WzS4lZOd7loDLa1n9lfay+AXdaZm0dZ3pYwOxRFPcBctaKrTDMF/FyqE/7vmqA57dr7b740B47znf2fOwIb1ePMlMtYopmSChZm9eAuk+S5n79M1e8VPU3r+9y5jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzvLi04O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzvLi04O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E980D1F000C4;
	Sat, 17 Oct 2026 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259024;
	bh=OMvQxu57hmotmPiEPRfQQ6H1+/vWZEa7PgUEZWxOS7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzvLi04O2Mm13liSwMcdDLdiIogO2/5ZO2wwh/GvEpt0UFhnyjbNJF8/mRMILkakZ
	 Kj3FezVxsJp0v6HNiQZ9L3J26H8Jpqv36CYPmXd2hePU8z3Q4eq/PVCxcbBnioWZUz
	 zrmC1g6ACfEKg5TPF1jLVpX8gbnpz7Ff6Ppv450A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1060/1674] cpufreq: pcc: Remove empty exit() callback
Date: Sat, 17 Oct 2026 17:55:32 +0200
Message-ID: <20261017160458.334822520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit dfd3e8b90b3660b706c3031b0f746377c571b324 ]

The exit() callback is optional, remove the empty one.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Stable-dep-of: bcb8889c4981 ("cpufreq: qcom-cpufreq-hw: Fix possible double free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/pcc-cpufreq.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index 335429d0683bf..6eef6a87c5611 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -564,18 +564,12 @@ static int pcc_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	return result;
 }
 
-static int pcc_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-
 static struct cpufreq_driver pcc_cpufreq_driver = {
 	.flags = CPUFREQ_CONST_LOOPS,
 	.get = pcc_get_freq,
 	.verify = pcc_cpufreq_verify,
 	.target = pcc_cpufreq_target,
 	.init = pcc_cpufreq_cpu_init,
-	.exit = pcc_cpufreq_cpu_exit,
 	.name = "pcc-cpufreq",
 };
 
-- 
2.53.0



