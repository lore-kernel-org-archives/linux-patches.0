Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6A3285043;
	Tue, 12 Aug 2025 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025840; cv=none; b=b2s5IwQXOr8Sb9xzrAsYNmSOxw+KdefCbRhoRZlxyqlYDGanL4iW+0y1m2uboyT3awjIf/r+q0rxfb9plMJZNnuBty0F2dUIkXZW19Ok3uZ0l8V/6Mna+U/I/tKow5mzo11UNjmPCRABUzUEPaVDuZY1RonMzaKSLzIIYlv3/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025840; c=relaxed/simple;
	bh=qAxuNLYLgW9UVtI24zLRpbu3gx/IHFE7dzwlsgYDmYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3509Kr8Jf/Atqg6P9aS7xlhGNO7GghSJK+fv4M7FOLydialJ4PBsqN8DjNKxQwkIbyK+MMgvPIjexLcah1Zw1pcSbRSuli4HazajGaH3X7O6Q7nGOXlaS+fZpg2/Og3KrkXHdtHm8hEJ4UDqOTnw8dq6QGL7XNBEgK/sj+ByS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdIGoAlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdIGoAlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43F8C4CEF0;
	Tue, 12 Aug 2025 19:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025840;
	bh=qAxuNLYLgW9UVtI24zLRpbu3gx/IHFE7dzwlsgYDmYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdIGoAlQVJ59WTr4B/0BOqFb9J/JDAaWEapN8pGK2xMAe7l1ORloTCRw2FaqtVKz2
	 BaShoWkfgheK1oSiPlHwTASKmp6AZwBkRw3h8n1v2dHJTDqtNTuPaMMJECZtjCmNTq
	 SIahvEUUtV0wCbcC3GXYzJ4Lc/SHiCelA5NUsp8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 160/480] iommu/arm-smmu: disable PRR on SM8250
Date: Tue, 12 Aug 2025 19:46:08 +0200
Message-ID: <20250812174404.120050076@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59d02687280e..4f4c9e376fc4 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -342,7 +342,8 @@ static int qcom_adreno_smmu_init_context(struct arm_smmu_domain *smmu_domain,
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



