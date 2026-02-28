Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D104346AF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302077; cv=none; b=uN2gATJCq7vE8Ke3p3vHY9SZTTztz3gcfszoYocOq0yfs1PHn9LvwDRvMCdgycupkDZ4b3MzA/fRXIOJxdz/r1yorMS8Fadcwqy9OYyBcsxUIbfhkV3nVGf+OAGXvyuId7OINMbSPvLBTdibTNC/tsaZmaInxZDHEZkrVHo7H7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302077; c=relaxed/simple;
	bh=MlPMPaCEIrZegJ59j4w/JPSGklfdoJyku1pF6/V7SKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2zytwiQuoLE89xc3V68CrvV21fRyu6nT/i+fi+yGOmtUIX04m60AxAhEbsa3elKDfzyAaWIE5WK0QTiooYaDTHtZSkfU6/6Dw//QvSnW70gsLC1jXEZaOh+kRHHHkpanMRq7X5Engs1lTdsW2g20/82o/BOXJSxXz+MVsZp54E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDCT5Y9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDCT5Y9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB51CC2BC87;
	Sat, 28 Feb 2026 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302077;
	bh=MlPMPaCEIrZegJ59j4w/JPSGklfdoJyku1pF6/V7SKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDCT5Y9w3gNhYeuSwfAPsqp0CCT6oUegBV/FAdlOTPm/WLTm9YkAOKVnhDQfMguS2
	 Tfzq9KHxYQqv/dDuCHSQ0tdMtUK7LDbh+5k5eT6Lle44UA/d1D1TqY7JttudZAc537
	 6MXARNTDRBEUxzFyXIS15tMXQntWWt0xux4ylWyLWTBi+sqwErsf2ZZa6ZYZ09Hi+O
	 Kn6CkdQA3WKKcMRA2wIIbNZe22/LKePqi0sHPQkbl7/avZifs2RVps5OQdidNSbboP
	 tpie0E6d5B9cz8TFf4zeVCy34FCWQzKO/HJGLDdsARUDG79LG7CDT/F54fVLG0M90M
	 aDLLkEp4R2G0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/283] soc: qcom: smem: handle ENOMEM error during probe
Date: Sat, 28 Feb 2026 13:03:20 -0500
Message-ID: <20260228180709.1583486-58-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

[ Upstream commit 0fe01a7955f4fef97e7cc6d14bfc5931c660402b ]

Fail the driver probe if the region can't be mapped

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Fixes: 20bb6c9de1b7 ("soc: qcom: smem: map only partitions used by local HOST")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251209074610.3751781-1-jorge.ramirez@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 5217ff0a434f5..d039c660d04fb 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1189,7 +1189,9 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		smem->item_count = qcom_smem_get_item_count(smem);
 		break;
 	case SMEM_GLOBAL_HEAP_VERSION:
-		qcom_smem_map_global(smem, size);
+		ret = qcom_smem_map_global(smem, size);
+		if (ret < 0)
+			return ret;
 		smem->item_count = SMEM_ITEM_COUNT;
 		break;
 	default:
-- 
2.51.0

