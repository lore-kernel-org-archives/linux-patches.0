Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A608E29A9;
	Fri, 15 Nov 2024 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653192; cv=none; b=gCBQAPUc4Tipy/qYvbL/Ja7tmCrrSSkxR8pZdbnd7eOACdxDbghfy9MxPftVDqNgscwOPjmbM18yWxpkDfGr1Wm3gdr9KgrtyEjlPl5MXP+dB+wnCYPRgrAke1NyVGUGbIC4rxVcuV+XpnJpMZLjLamKDQ7+oyUH+4dPXpUL08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653192; c=relaxed/simple;
	bh=K27TvtFgj3X1LbmGaiNq27DYFpNTBPTYV6tKbad0HPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baowZxOrA310F77N1j9ems35lM8fO/ThiOABaKWf4xUVQDdZOYGrTptAMOr5Xkr1WXHGZ/alQ5ly7HGCnbGYQHMQW/pcLXA6AebMG2B/wLtaTBsTW9RpSZkumcQuNNL9+S0QaYHjEhQbe/KWRo0vRxQoQH2qJG7YKyzE27fYg3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANcuJw95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANcuJw95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1551FC4CECF;
	Fri, 15 Nov 2024 06:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653192;
	bh=K27TvtFgj3X1LbmGaiNq27DYFpNTBPTYV6tKbad0HPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANcuJw95BSBye/Io1FZ6JO2OCeNEF3eILy2PApNDnuFp07s60Oz9z6+FH6alDoCAQ
	 sm44HNQQwGQN+O03Ge1IezQArvVHyMHlAWl9Ws+43RQ0H9Xz5RzFOwPQO9xP//VlIn
	 mgh9zkh+LSRVcexLy5+vJn0TKC0ov/KlQcCa8/RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 14/63] iommu/arm-smmu: Clarify MMU-500 CPRE workaround
Date: Fri, 15 Nov 2024 07:37:37 +0100
Message-ID: <20241115063726.409982464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 0dfe314cdd0d378f96bb9c6bdc05c8120f48606d ]

CPRE workarounds are implicated in at least 5 MMU-500 errata, some of
which remain unfixed. The comment and warning message have proven to be
unhelpfully misleading about this scope, so reword them to get the point
across with less risk of going out of date or confusing users.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/dfa82171b5248ad7cf1f25592101a6eec36b8c9a.1728400877.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-impl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
index 9dc772f2cbb27..99030e6b16e7a 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
@@ -130,7 +130,7 @@ int arm_mmu500_reset(struct arm_smmu_device *smmu)
 
 	/*
 	 * Disable MMU-500's not-particularly-beneficial next-page
-	 * prefetcher for the sake of errata #841119 and #826419.
+	 * prefetcher for the sake of at least 5 known errata.
 	 */
 	for (i = 0; i < smmu->num_context_banks; ++i) {
 		reg = arm_smmu_cb_read(smmu, i, ARM_SMMU_CB_ACTLR);
@@ -138,7 +138,7 @@ int arm_mmu500_reset(struct arm_smmu_device *smmu)
 		arm_smmu_cb_write(smmu, i, ARM_SMMU_CB_ACTLR, reg);
 		reg = arm_smmu_cb_read(smmu, i, ARM_SMMU_CB_ACTLR);
 		if (reg & ARM_MMU500_ACTLR_CPRE)
-			dev_warn_once(smmu->dev, "Failed to disable prefetcher [errata #841119 and #826419], check ACR.CACHE_LOCK\n");
+			dev_warn_once(smmu->dev, "Failed to disable prefetcher for errata workarounds, check SACR.CACHE_LOCK\n");
 	}
 
 	return 0;
-- 
2.43.0



