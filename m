Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1C0350D74;
	Fri,  9 Jan 2026 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961791; cv=none; b=JJ+8yHqJkAIf8Gxhk6wkTEdEM1TeLdwqCizcekc41nc6qJwz7N+xUeKI2l0qOP5Zna+MHvDhliznDNC2QS6cHfQvkmoi6C5Jtbn87A8pE9kak+k3oFIO0h2oRLzVf/7AoMPbhhuh6+PrfxOsIUuOE96mEmPpJj2o7g753Y9DNck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961791; c=relaxed/simple;
	bh=OXJanGHf+9KX90NEfw+FSW7UuqlhPiKyib/FmnVKFPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kM7zAGKSmbfdW9l6O8WnJ2IBuUwTRVNTNE7fYaUOdfTkO3M2CYNObBdmAVGCWU7yx8mRk6G2vRo/KI2SC4m7YH6jxZTtocfuLihQQpdiKV7pljtOHAuJBVM3LCav77QDmiiW9fNEz/4yqHfokU6MDBUxVbZOWY4/hr6uTjjLE/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBf4R1I3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBf4R1I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DECC4CEF1;
	Fri,  9 Jan 2026 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961791;
	bh=OXJanGHf+9KX90NEfw+FSW7UuqlhPiKyib/FmnVKFPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBf4R1I39XQLHz21J/zVtaq+g+0Ja56cGith8wQStFQ18EUbhHZiGKvddBUY7pnLm
	 DUeg9/v1Hb+sGUCkF4idLwuctefIjp2v3oUyD/3T/2+YbyUyrcBAHSdJLlJ0aD7MpW
	 PfSC56mDQefOJS5I1NciDZ1HOLQYpFf6lz1AKK5A=
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
Subject: [PATCH 6.1 104/634] coresight: etm4x: Correct polling IDLE bit
Date: Fri,  9 Jan 2026 12:36:22 +0100
Message-ID: <20260109112121.345850809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d89153d0517ec..a3553f9ca0786 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1726,7 +1726,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trcpdcr = etm4x_read32(csa, TRCPDCR);
 
 	/* wait for TRCSTATR.IDLE to go up */
-	if (etm4x_wait_status(csa, TRCSTATR_PMSTABLE_BIT, 1)) {
+	if (etm4x_wait_status(csa, TRCSTATR_IDLE_BIT, 1)) {
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 		etm4_os_unlock(drvdata);
-- 
2.51.0



