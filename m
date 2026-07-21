Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AB63A874B;
	Tue, 21 Jul 2026 19:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662434; cv=none; b=rveAwngbq2aUIKEb1hbMpKbTvPJ+Y3VRxybWAMoi5whB+D09U9mQweaAyTb3aNycdzesIiUCZAngTgczbgKnU7/ysm3nnkZWliR9/ZGyQzsvwNYWoTS5fuYamlzSoVvs/2SBBpRfDfSGpK3dF60mTh6rSemNK4dCQFnyM6qRhTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662434; c=relaxed/simple;
	bh=95wBRCxfFMqJjx00aw6RyY7+zcn2d9kfA6APHHM9PX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpHm+JmxEI4T141esKu79W+qbnYTvROpYUK9/gIzgFeOA/hkG7I3s7dnNPAQWXxre1NpkcujtzqxKzDpSgoVMIvYtwHMhZAI9jKwxatSKyotceRGT1SQiJarK2RPq/5SlIMoM1DjJoQkPowmSNQXaSDkJOzGJX8AE8bJskLArBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBmk1nK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBmk1nK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74D51F000E9;
	Tue, 21 Jul 2026 19:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662433;
	bh=/wfaaILbTUeLPdeUJmOqocVXHZrnye/PQyRNhl0TbFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBmk1nK4Fn3ECYk/APDqDZvLlsTzSb0jyZaOewp2jFxUmCzQ8z9H35+jeCHV/obFc
	 fp2mebLgl6+NhVjhTHx93YiFBkgh+bdvUWfCMwnHIDyKGBOU8phiN9XvbQ9rrzVsJ2
	 kBoH+gCqV+7RYMz32lHDEdNhuwAkN488pbb9+hLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0416/1276] coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore
Date: Tue, 21 Jul 2026 17:14:19 +0200
Message-ID: <20260721152455.408061389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 0ec0a8785d21f63db520bd9d2a67c55e855d36a8 ]

It is a typo to use trcvmidcctlr0 to save and restore TRCVMIDCCTLR1.
Use trcvmidcctlr1 instead.

Fixes: f5bd523690d2 ("coresight: etm4x: Convert all register accesses")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260408-arm_cs_fix_trcvmidcctlr1_typo-v1-1-6a5695363b46@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 730ba893bf4cd3..05958827b3bbc3 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1876,7 +1876,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 
 	state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR1);
+		state->trcvmidcctlr1 = etm4x_read32(csa, TRCVMIDCCTLR1);
 
 	state->trcclaimset = etm4x_read32(csa, TRCCLAIMCLR);
 
@@ -2002,7 +2002,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR1);
+		etm4x_relaxed_write32(csa, state->trcvmidcctlr1, TRCVMIDCCTLR1);
 
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
 
-- 
2.53.0



