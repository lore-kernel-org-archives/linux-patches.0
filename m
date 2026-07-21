Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACD344AB7B;
	Tue, 21 Jul 2026 22:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671779; cv=none; b=COkdkGU1f5EA2ZwfczTDvbPlVnXv+klvVEmfvW3KI8wGzhVM4rz3MYKw77MCnXWxW68gc3elXOtecmIjoz94pXAvr/Hi8MDgyXYF5n0X8fuwo9Qxb2tVqo9BQTrXOXT8A2CRqSXNaddeCbSekSx8Ov756lGi0Pw27B6OD/D6KYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671779; c=relaxed/simple;
	bh=iwr2tcvkQy3Rg0qnKGjEQ/sNWczKmAEGxr332BercEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8WdyQCzouuRz4nk1VRsp/gWIAZF/3iOJVebFYBEICnVKI/RMkvewgoPdKo8qrr0sCWyWnXRmNTEtKxq/fj41+BZojFfAsV/NC6IJ+QZHStI6WRunU4bgRkjniJNhGPgsDNbMhOXoJaDLevu9Mmexbrnr/YmECOpOO6MDJJajS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcVYRsCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcVYRsCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575361F000E9;
	Tue, 21 Jul 2026 22:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671777;
	bh=pIe49aN5py5HlXH+qItzm3UENWUrz8gCfdufhSCyGJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fcVYRsCV1Vy99lsPAtD1wXcE+h4cjHMPFzQOJsUCNDLDfiCK4qO9o/NJyUU+LJTbs
	 YJwOIk7bgjOvE4Hd95N2+CccqSoaV2g0dvZPKPp4mtBeqJW+IFL0V1piR8lZDgSi2A
	 hOsTfKjll1KylexN52weqwFMGNFscTW/a+jtY8Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/843] coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore
Date: Tue, 21 Jul 2026 17:20:10 +0200
Message-ID: <20260721152414.470642035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4d9b77e454df66..1b91448f546d64 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1753,7 +1753,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 
 	state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR1);
+		state->trcvmidcctlr1 = etm4x_read32(csa, TRCVMIDCCTLR1);
 
 	state->trcclaimset = etm4x_read32(csa, TRCCLAIMCLR);
 
@@ -1878,7 +1878,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR1);
+		etm4x_relaxed_write32(csa, state->trcvmidcctlr1, TRCVMIDCCTLR1);
 
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
 
-- 
2.53.0



