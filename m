Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710D35C6AC;
	Tue, 21 Jul 2026 21:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669344; cv=none; b=LvCgPU1IeP7fazp3/he77ibxEjnyNEInC66Rb5WSJJ0R9cx+MgpXm7ngA3+HH4QR+kqhfgRdljvbZcM8npu7dE1jDI7wYTzXrrXtEtioldLBCMV52BCSPv8KL+EKG8w89wPUCA7zPeSU9HLXOSUAlQ2Y6YEBGmyoTiF6mLiyBh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669344; c=relaxed/simple;
	bh=ZvuG3Ya3vJnP+kVPoredXl6XHcj3Op8N/eCjHurE0Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6hwOLLwJxp4PWa+pmy4eF9K2fn/kY4pZz2dGeDl3n5hf6uB0Obf5dVtxQPFE/WES6PrBxrkfADvAMafy31Wq1gpmSWxAxzBD7X+0tibvbAOTlq254XP8et4L1ZGlIyrF9PHQIBP6eeRl/Rtw2+fLskHWhMhViNwAhB9lUVN1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeWu4KVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeWu4KVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD591F000E9;
	Tue, 21 Jul 2026 21:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669340;
	bh=SotsTIa8nPK7CAfSlj6BhH7gOSbSLlPBySFLAvtilNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeWu4KVf6zYYoGMYDL4bitvrRCNaioBj0NRFc1pvGC3ki3Nmm+SCx1I/6/AsbUlp2
	 jP0VIY3pfXB1iNkfnrJzZ4s2TpSPk8iW0LTNHglDZ9OPgDVrxbMlYDK8el2t8yj+gY
	 kM09NDdSRVJIKVIg+M8RMe1zFK3miiIDTDWVNnzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0474/1067] coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore
Date: Tue, 21 Jul 2026 17:17:55 +0200
Message-ID: <20260721152435.219177839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 0616efc7cb198f..b2c55cc45a11f7 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1758,7 +1758,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 
 	state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR1);
+		state->trcvmidcctlr1 = etm4x_read32(csa, TRCVMIDCCTLR1);
 
 	state->trcclaimset = etm4x_read32(csa, TRCCLAIMCLR);
 
@@ -1884,7 +1884,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR1);
+		etm4x_relaxed_write32(csa, state->trcvmidcctlr1, TRCVMIDCCTLR1);
 
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
 
-- 
2.53.0



