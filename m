Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70C826ED46;
	Sat, 12 Sep 2026 19:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242446; cv=none; b=jXXX4FWtIcqVMdvf+ZRmuVhoYGlTUTrL3APhVHcSA0ukOijni3uMK1EtFbTg71ZbDYmKXBSTJKUPOjVXYPf6gmeSXIV0b1r6h6SgjRGkSMpp5HZ8lLBtQQnvPhFb6f1LCPVBthECmMfUsB58p7e0EkesQ2y7aUUHvtU+/FpKKpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242446; c=relaxed/simple;
	bh=zOJ8YUU5fSRW8qY7sqrj7Bio7yBki8v53sgu3uj2GYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ0p2pAKWJ/X2liQkecL3BV7T1tMCn9AE7+1YwpexDPpWNbC91pOuu4260xK6b9q9oxjdci7PKxWh/JA3vj0pq1Z3ys2wHIeyGo4Y3TKyUilDh5SUS2PUSZNEZGwKeleJP3oTZII3k1gy12jndX13Ly58f1XbGgENk6hmnidVuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLugORi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLugORi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2891F000FF;
	Sat, 12 Sep 2026 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242444;
	bh=bRcPGemcrVmOo7fQjVXk6K47fZptY+4zk9Uj7XGr3gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLugORi78CWaUcr0BEu4Z+T4YMianmDuY4gIF4n3iDN25hiQUmpy5Hz2t+KEjajlk
	 kJxyGrVEfZPllFYmHk/ePimH8ZnTk/Kuk9QFfBq+dNQW7VSLH+tA4jc3D7q/oMq5ni
	 sqMzroWeFXg4l4cWnyBz3kxzdFRPEad56kUIcPlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/798] iommu/msm: Return -ENOMEM on memory allocation failure in probe
Date: Sat, 12 Sep 2026 09:00:34 +0200
Message-ID: <20260912065526.453167617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 149f2e53b39d4..3bc159b4d163f 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -707,7 +707,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 	iommu = devm_kzalloc(&pdev->dev, sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
-		return -ENODEV;
+		return -ENOMEM;
 
 	iommu->dev = &pdev->dev;
 	INIT_LIST_HEAD(&iommu->ctx_list);
-- 
2.53.0



