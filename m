Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65F2931CD;
	Sat, 12 Sep 2026 07:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197979; cv=none; b=c4M3rXucbY47m9N/G7h6ylnvwK7LPJT9KJd7ppZChQKQAPaaIX+iukZmuqQoD0J9AwEOjAxuXmQZrBNI1SPJ3opfK8/x35ki/ww0RZZ8sEPvks7Vc8l3Om39PK9lsdu/D0Eh6B4GG4POCDzHU8icISXyNgQdhRZisXhyofQqIXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197979; c=relaxed/simple;
	bh=2ICRpKme8y4E+s8HAYsZq5XOeV0HNbcUPDRrOgHMhUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMg0yclMVC6Kp7+vXhCsvOpD3HS0yrVsZClihTmGiWAVP6FJ//KA+188sLRHKY29WFZPRC0exnx3FyyX/Ks7oKZTDF6fYMOa/Oz87suSe99zRsNMJ3HB1ZITgYXFYsoq21Ts4sw5FHCfbWQayTgYucqvUEBbxaas4xIMGbfShd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3rFsTTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3rFsTTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E081F00893;
	Sat, 12 Sep 2026 07:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197977;
	bh=LBG+AFGSzN/iWv0vZG5EchwPI1bYxUMyM8ZVEQmjz/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3rFsTTsXo2InAdlXVibHkkKsKKQntOo4b3u1yFJ23KGLWZ4d7auHgkPzYQ1NAzSF
	 /xVLmsDEtX3Phi9N/9s9uhbBwJHB8xrtoC3APO75C9f11fV+OAY3V0REuqDEkESirq
	 2OMJBCJ4xrpR+xBe5N2gC7osFB9K4GzjTPuhfnyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0287/1815] iommu/msm: Return -ENOMEM on memory allocation failure in probe
Date: Sat, 12 Sep 2026 08:33:57 +0200
Message-ID: <20260912065655.697065449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d0d926be7495c..9a3ed70563b1b 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -720,7 +720,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 	iommu = devm_kzalloc(&pdev->dev, sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
-		return -ENODEV;
+		return -ENOMEM;
 
 	iommu->dev = &pdev->dev;
 	INIT_LIST_HEAD(&iommu->ctx_list);
-- 
2.53.0



