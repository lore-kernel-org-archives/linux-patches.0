Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4783E1CF28B;
	Wed,  2 Oct 2024 13:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875658; cv=none; b=rYixJ4hvmrF2sFDiLTWPEG7ky/rIgEuy46mc9m82qTgW3OLO5YyJFUgJdlH0DxRF+ZkXTcQPx6jp4QAuRoWOt27DL15su11c7lfQqbLy2X4c6wld2EkOwV2noDam6XW5N8T86J/cydNze7YaXIhq+rQulgsWA050Jj2F78HUctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875658; c=relaxed/simple;
	bh=Leg9bqWEtb7mUybWziAi7F3xlg+BO/4H/4p5d7qcqRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2iqvAys5djfDaG1oRRX5hFh5DzPVIZtptzoQsU3tA0VwJM1PXidWx7z+Q/SKZLS/bgaR8xM1Tq8KXshriX3DpyLjaNZu7Oda0XputS4DtVVZTRd18r8Nb1fFPveVehbMKJ0JW10r7+dEBAAox29IpyTse309h21zCANODaHFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL9rJtvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL9rJtvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59FBC4CEC5;
	Wed,  2 Oct 2024 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875658;
	bh=Leg9bqWEtb7mUybWziAi7F3xlg+BO/4H/4p5d7qcqRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL9rJtvyR5aTKhCWbLNhlvFs0w6/qLdc9dXSKspVPkdMAk1H6LY66+9Gfp7GMryGc
	 S8JMUQlW8bdejHrLEetJcPnT9NxmC763z8Ia+Yx9rrUTbcdNys9DUhHWmeQyY00EG6
	 aP45JKMo3jYYgbG9QNZjDyC5PrR4jNGqAbvkHXQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 176/695] iommu/arm-smmu: Un-demote unhandled-fault msg
Date: Wed,  2 Oct 2024 14:52:54 +0200
Message-ID: <20241002125829.497861277@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 98db56e4900837e4d5d3892b332dca76c8c9f68a ]

Previously this was dev_err_ratelimited() but it got changed to a
ratelimited dev_dbg().  Change it back to dev_err().

Fixes: d525b0af0c3b ("iommu/arm-smmu: Pretty-print context fault related regs")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Link: https://lore.kernel.org/r/20240809172716.10275-1-robdclark@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 723273440c211..8321962b37148 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -417,7 +417,7 @@ void arm_smmu_read_context_fault_info(struct arm_smmu_device *smmu, int idx,
 void arm_smmu_print_context_fault_info(struct arm_smmu_device *smmu, int idx,
 				       const struct arm_smmu_context_fault_info *cfi)
 {
-	dev_dbg(smmu->dev,
+	dev_err(smmu->dev,
 		"Unhandled context fault: fsr=0x%x, iova=0x%08lx, fsynr=0x%x, cbfrsynra=0x%x, cb=%d\n",
 		cfi->fsr, cfi->iova, cfi->fsynr, cfi->cbfrsynra, idx);
 
-- 
2.43.0



