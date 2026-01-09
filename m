Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64A33290A;
	Fri,  9 Jan 2026 11:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959794; cv=none; b=CHbJe9OIXEiGAgZ/dofnch8Z+XIs2ANxhlQPEHId76ejs/PchBhARMHjEEJ2we4PzBBeNzUZnoH8v4EaH1qvftGAXPqGPkhKokJ9cQsA5W4x6RCbwqL1IDAS8ISpno02t9IWrZsVQjhdKBOJVcfwIcMH8o5BZGmF3RdLHx4Gzzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959794; c=relaxed/simple;
	bh=/JEz22GyCjMPLMWECVksD3ve3sz+FKI3DyhMGccqpwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GL48XKV+E6YL4LR+Qgk1Bl/C70+Cgk0CXNIdq82+TwLRyflJ3nTdaof5JG1fiectMNsh+YdATqC9YEntnlTVk/C9pOw3Tu9jvc5sKQNHrEh1LmG73g6ulXdzudgwcJacOugZKpKezuudbzWdjFHDR0ZgO8VeOZNuDKUaXM/e7Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caJDD8fO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caJDD8fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207B3C4CEF1;
	Fri,  9 Jan 2026 11:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959794;
	bh=/JEz22GyCjMPLMWECVksD3ve3sz+FKI3DyhMGccqpwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caJDD8fOs9JqwOWa1BqDkTZCPT7tryg5sxq5OjngM2C3IuHN92tUTwD75kDMmgYhR
	 EseYfAF5YWsfBUJINMQuguDYji/rcJpPpe3WJxA+v5ZsHHQ99S+tdwD7+q4iEj9Dbe
	 GJmLmrXy7NwxQljnkXA785v3vFtVqTkYaNpLftBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/737] coresight: etm4x: Correct polling IDLE bit
Date: Fri,  9 Jan 2026 12:34:43 +0100
Message-ID: <20260109112139.415563977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 4dc4e22f9536341255f5de6047977a80ff47eaef ]

Since commit 4ff6039ffb79 ("coresight-etm4x: add isb() before reading
the TRCSTATR"), the code has incorrectly been polling the PMSTABLE bit
instead of the IDLE bit.

This commit corrects the typo.

Fixes: 4ff6039ffb79 ("coresight-etm4x: add isb() before reading the TRCSTATR")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-4-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index e4d8d446ea4d3..cc35175abd504 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1805,7 +1805,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trcpdcr = etm4x_read32(csa, TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
-	if (etm4x_wait_status(csa, TRCSTATR_PMSTABLE_BIT, 1)) {
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 1)) {
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 		etm4_os_unlock(drvdata);
-- 
2.51.0



