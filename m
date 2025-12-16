Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525E350286;
	Tue, 16 Dec 2025 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885688; cv=none; b=OroyfVMgPLniESrXInni0SZJvObMalCh1B/QWzhqdfzyLrOEk9AQAit8Z8fYFpUYzjdM3CBcqJ010ZOZb7h5Rl3XKU8ncCBxcbXaQD7EmKS0lsRq2tcX1ShmDmGrxAItrlFfc09gT62aLhWkQ1x9qfB+uuxCl0n+ojix2m2ZV1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885688; c=relaxed/simple;
	bh=jnLddWrYZTPKFqQMSPG1YtjCgrz7ZUQ8+zN+ExkVDjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3f6NMOVnGiluaahWJQpfu4UgqvNrO2dppv0Mn9HFkdTkVwnzhYGF4ddlF8WO5c7sz2UxB09ooMnrvoWzc3++6Qm5UpUkQqFpWB0/xNfIy2TM3NLAevey73wxephuwQqkcCSyCmKp86ihaPnaKTaspKKTARRh4Q91jy2ZDZRIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJOOcPv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJOOcPv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD2FC4CEF1;
	Tue, 16 Dec 2025 11:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885687;
	bh=jnLddWrYZTPKFqQMSPG1YtjCgrz7ZUQ8+zN+ExkVDjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJOOcPv/9Aazf9/pVJapBfe6cIHT1NwLcO35mU3VRT3IZQ0Aek5vTyJ+usZswg/td
	 giIVbYWq1TxDgpO78yzlH0HLCFhJvV+6xrrOmmyquSAIPWbfU7pNZQIY/FLBtwoUgA
	 ++IdV/YdJolkDJ/Dfckne8uUgbUUDyI5aPkhRnJo=
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
Subject: [PATCH 6.17 215/507] coresight: etm4x: Correct polling IDLE bit
Date: Tue, 16 Dec 2025 12:10:56 +0100
Message-ID: <20251216111353.297291110@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index baf38142b317f..1fa6d123b8143 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1924,7 +1924,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trcpdcr = etm4x_read32(csa, TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
-	if (etm4x_wait_status(csa, TRCSTATR_PMSTABLE_BIT, 1)) {
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 1)) {
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 		etm4_os_unlock(drvdata);
-- 
2.51.0



