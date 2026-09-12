Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399793ACEFB;
	Sat, 12 Sep 2026 18:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238534; cv=none; b=IESN4zlPDKxXNLa7ndvjuTUVX+npKIum5iDU7HQ1iOlZDCHC8yFiBAzfXhsVcFE4xEOaQwpRqBCF8YrsV/E70x8lf0wCkO4AfSx9Thn2P9ruSZS0nSjQOwc9vA9n4YBbKgzZUgJtw3mkVB/uikfH4v+HpgxpbwTQCkBIDzWFAi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238534; c=relaxed/simple;
	bh=sNoMy+R5NPbKD7vbxQ1+/zVjzgjYfu+ups+7hBeSeVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC5gMa+OSxSe0bO3kROtN07TbLk57MHYHWtju4qo8XwVOkNoRjze4d2gNebhRmOXa1WmtV/T+bB/mXDCIZ/MvdoqSaEdoi93pcGqAr9/k8cUhincLIlhp5NXsN9qd7JGid21sBsThRie5hLlzLOzZeCER1CeyUbDwzQi8KmJJeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA6nGbrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA6nGbrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A381F000FF;
	Sat, 12 Sep 2026 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238532;
	bh=ihrPCl+aJxCo4K4NRWcZTOzYcO3OE82LaW4ZAz1Om3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA6nGbrlaPkfMoe3Dy8vJA+oiw78AYC17zvcDhqEtzEEPX5ob5pH+v8uWz8+/rSWC
	 NykrIWoGTCR/bFQ4KdtHtTR6Oqb43yJV8bmFdRwa9ZBWvvYbXkx5P5hlBum/Ui37C0
	 Ird+vZdo/COWg2Sy6jhUDIEQ7n75c1scxAbV3s6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/935] iommu/msm: Return -ENOMEM on memory allocation failure in probe
Date: Sat, 12 Sep 2026 08:58:30 +0200
Message-ID: <20260912065537.832613748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index c9eaf27cbb743..1ce56f4932c7d 100644
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



