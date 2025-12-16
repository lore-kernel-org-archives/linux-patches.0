Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4101313E13;
	Tue, 16 Dec 2025 11:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884280; cv=none; b=MhgVLdVDLHp4zoYXUWacoCKtN/AkuXNdfp0WB8Mg0S3GwnFXEGGKOoa2NBDw7RlzQHDQSJGCEGiMLMUgkyVG1usayKdvfT+P1kpCMX0dbdZ7sChKGwKK6wvCEsYETCu52IVQNFSN5Q+9en/lFIVtrqSzXEFsZRqbfM1g1zYI/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884280; c=relaxed/simple;
	bh=86srxkA0c1PvT/EE3k4nl1ox9P2GlWhbkc5T+hKuBzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diizb3ShVmkDSpP04qUDpM7uvoXsi4ed2tv6Ks2HsN0Wx1+lUdlKcF+aisbvjOfZs0//vpbjfxRlyMTMuzNTbl+o/NMiEIlZFImq+bcmuA5aazQJR7LbXoqHe5q7Khb35v3d58+WbKagYXV03SDlT5KZcxVlKEyWz/wrBYBC8qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODC7bgw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODC7bgw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55181C4CEF1;
	Tue, 16 Dec 2025 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884279;
	bh=86srxkA0c1PvT/EE3k4nl1ox9P2GlWhbkc5T+hKuBzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODC7bgw69NXbZEp9kbAZSa/c7ICtxV2Wy77UZXkWKKekmJL7VQGvllAcS5+/g4jf4
	 bEwBuHsqoIfJgqJp/r0bDL9q7QObDOSoGav/zdpcaiHQ98SXc2FMTio5PwJLnoBAc/
	 f8Ej+aCZKMLUTQkzLFhIVHS93dDiLOO+9IhrleDg=
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
Subject: [PATCH 6.12 146/354] coresight: etm4x: Correct polling IDLE bit
Date: Tue, 16 Dec 2025 12:11:53 +0100
Message-ID: <20251216111326.205909690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 7b9eaeb115d21..9164e134814ae 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1844,7 +1844,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trcpdcr = etm4x_read32(csa, TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
-	if (etm4x_wait_status(csa, TRCSTATR_PMSTABLE_BIT, 1)) {
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 1)) {
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 		etm4_os_unlock(drvdata);
-- 
2.51.0



