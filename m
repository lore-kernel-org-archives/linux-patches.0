Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208DB36921B;
	Sat, 12 Sep 2026 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207009; cv=none; b=OttYFLLy8aZlsTizpEdBrXgbcosUxsW1S1wuwRBlDDlTweENgK3no96vcasbsA3JqdHD+/qpSmsd7VfUTeZihmlt2Adga/eOQwuS5n/7yTldvQoLohqrrdzGCOa8Hkr7E+uKYZDILx13EIAb93SlWKKPGdZpDWJ1aQhTWPcfjRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207009; c=relaxed/simple;
	bh=19Q6Nd9qvkCFm2g7f2XKkOVgnbrPCMxZeW2MYG+1UkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVfTZPcoofkMxYuTcWqI4HCKnOhlshiNSmp8zeir0UBfSc2cwcgopLUUfrcVcK8V/u8gJv081BLIktMHcSDi0GrJHu1IzX88/ME18xJNRYFS+OIeXkdTWESnorNgRDJo5eCV24hCcdMHD+k2JHVlGQVyYiTf6FRtSoU0v+7/gtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjDcLfAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjDcLfAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C4D1F000FF;
	Sat, 12 Sep 2026 09:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207008;
	bh=mkNAbT0nukJ2t7G1lOTiCczSu+RlqT8dD5Oe2JkIYAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjDcLfASgkarZ5XBF13rUATOuyv8AwCKK/3lP+Mi5G2tKJdkgqFzwikFGW2c64Uxc
	 uyR+0tgNYm0LnOTEh4WtNOWfb2+glZ8rOhNwLo6AuOSSW2hLP4fy6z25MB8KpuJM4z
	 tosKslhvzGzk9Kul9TnzV22vb4VztbfGrinG9yrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0281/1518] iommu/msm: Return -ENOMEM on memory allocation failure in probe
Date: Sat, 12 Sep 2026 08:40:50 +0200
Message-ID: <20260912065629.838828452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit b0d50c9016c4c2959dfa61bf9549cf98f9aa19cd ]

If dynamic memory allocation in driver's probe function execution fails,
it should be reported to the driver's framework with -ENOMEM error code.

Fixes: 109bd48ea2e1 ("iommu/msm: Add DT adaptation")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/msm_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index d5e2fc9b01116..1dfa6f69c28f2 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -719,7 +719,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 	iommu = devm_kzalloc(&pdev->dev, sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
-		return -ENODEV;
+		return -ENOMEM;
 
 	iommu->dev = &pdev->dev;
 	INIT_LIST_HEAD(&iommu->ctx_list);
-- 
2.53.0



