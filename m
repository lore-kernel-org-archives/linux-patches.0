Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD30F1DB92A;
	Tue, 12 Aug 2025 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023912; cv=none; b=pTcS/0ayMUhlNVWrzY2ygc+ADy3COvVAsN8EfzBLlgwqSBy2DYq+eZ1oFUvoPzE/PcyLYF200LEYIAR6ltJ7fbsX50zqW2uiAB5sg1pSUp16pn9mWi9yeJtFWAEeXH1rnibWCFaMnbjR30sC+Ntj86StnFmo903ZQAy6aftY4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023912; c=relaxed/simple;
	bh=fVb5Zu7ek5JDpfWXJJG7jlPU8ohF0YTy/oZ6abWTGWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncQ+QVl5dcUMS8i1zkYGvqIbPch6lTkIdsVDnNyGanF05hoHwJE1wiUJVADbETxXxssu/R5mzSPU5vD8pePoMbNxWhx8mdleWf3mYn2eFKYyYxKRAFZH67oRwE7b2mpfFy6AqU1FSntqo4Cy5r56g/U36qm+/Pljf4T/9klxajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzRBDn92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzRBDn92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E414C4CEF0;
	Tue, 12 Aug 2025 18:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023912;
	bh=fVb5Zu7ek5JDpfWXJJG7jlPU8ohF0YTy/oZ6abWTGWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzRBDn923RFt/KDiG/kOZIU2naBRNRIAN4LAk7J1wzEwESCYHMOmOVD8WGpdNjaUP
	 yCMAj786majwk8LFp5sETb+WPq4prHv0plsqYE/GvrWVgAUGKIZcV2xhUrmivTg1sQ
	 MFBs0fVvj7AITgRQvOm84vIFU30GERAT35BiwzUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 219/627] iommu/arm-smmu: disable PRR on SM8250
Date: Tue, 12 Aug 2025 19:28:34 +0200
Message-ID: <20250812173427.614176335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b9bb7e814cd0c3633791327a96749a1f9b7f3ef4 ]

On SM8250 / QRB5165-RB5 using PRR bits resets the device, most likely
because of the hyp limitations. Disable PRR support on that platform.

Fixes: 7f2ef1bfc758 ("iommu/arm-smmu: Add support for PRR bit setup")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Rob Clark <robin.clark@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250705-iommu-fix-prr-v2-1-406fecc37cf8@oss.qualcomm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 62874b18f645..53d88646476e 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -355,7 +355,8 @@ static int qcom_adreno_smmu_init_context(struct arm_smmu_domain *smmu_domain,
 	priv->set_prr_addr = NULL;
 
 	if (of_device_is_compatible(np, "qcom,smmu-500") &&
-			of_device_is_compatible(np, "qcom,adreno-smmu")) {
+	    !of_device_is_compatible(np, "qcom,sm8250-smmu-500") &&
+	    of_device_is_compatible(np, "qcom,adreno-smmu")) {
 		priv->set_prr_bit = qcom_adreno_smmu_set_prr_bit;
 		priv->set_prr_addr = qcom_adreno_smmu_set_prr_addr;
 	}
-- 
2.39.5



