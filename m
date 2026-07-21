Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6843846D570;
	Tue, 21 Jul 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656961; cv=none; b=K5jE+KbIkiX+VV8dbaO0JgKVfBzfFJhciHhK9UyHDM+Oi/PQtTi+iYQPmNdf6YqbN2MaGS7a4XSbr07AoCqBcRqMOZVcMwV/eEbAmjjXQFzNybJXA64+EQy3OCip8i2Dzl6e8vUPTdErw5UWivHeasYJdlOCA4xACfgUbvxzB7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656961; c=relaxed/simple;
	bh=zjs4RKx9KDLLcZmQcn3r0qdV75ZPHsyBpL0/zDBXmpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=td2Xe+QmgJmufNPD6Eg2Brf4NnDWzMahodbUNsZywp8JgfJBpKG7dZ0qnUncIKCRuIm+zJ5bGOtB/cTD+90kdKtgR7PEntEffTCpRIGBIhDvPrdnTUQF+4RuqT7sILOnZp+1PAJTOGi2DlDXovRZTllMLU4D110M215NE51Q4jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlrUZBQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlrUZBQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2661F000E9;
	Tue, 21 Jul 2026 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656960;
	bh=WkOu4drC0L4HQQdEVLrPJgJs32jwRf6veIQDld8bync=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlrUZBQmPUIiMyHzO0sgWDfeCYm38eeBUGcLbnljlg2XrGU96cmgGG14ZupK9rHw3
	 dQwmCib0/4HlVvcGcK9+ac3q4/ydrPxoYHF8Gw3A82UH4QN8DCagTWPigCSKmIZ4EM
	 7TQ5UsDHfniKPLZ30IImQuoNW2DDV765nTEfKUV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0584/1611] coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore
Date: Tue, 21 Jul 2026 17:11:40 +0200
Message-ID: <20260721152528.514861484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 97fab4b3ca284d..2271f5ea812148 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1941,7 +1941,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 
 	state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR1);
+		state->trcvmidcctlr1 = etm4x_read32(csa, TRCVMIDCCTLR1);
 
 	state->trcclaimset = etm4x_read32(csa, TRCCLAIMCLR);
 
@@ -2064,7 +2064,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR1);
+		etm4x_relaxed_write32(csa, state->trcvmidcctlr1, TRCVMIDCCTLR1);
 
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
 
-- 
2.53.0



