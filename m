Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2292436C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302330; cv=none; b=eSVvyfWC4JlTQmHhKyuT0ADFREVIBHAZAVhjCLNz7VdlMMMqjOQNAH/mtMqBEzrtZ2sU554h87a/G8oLoFfpK1iglqPi9Hv3vD0C8Jit1Bxn7PIB2x5B7VggTQd0PbE56Wa/Xpxq+z8os3G/Mx/fQa2Ater19Q0QvwXqwl8JR9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302330; c=relaxed/simple;
	bh=EGYTZ0DO46yWsqcrhYN7Ob5508yC0WjrxiRHcypcrt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKc04f7r5AZh6mi8i6d7orBxM/AQcfKh2pfhbK3Vi/vg5RlwlXdsGgZK7RT8gk5ar2fVSU/Go8j7LxizbqVMuU+VZikHuAivzjHA60CeKzuU3VDZEgy0T9pmZ493o8SxqFb99PG83mEoS3nChHSJdIDCQGNdzPdWb3aN5zD00uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0D8fcI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0D8fcI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D874C19423;
	Sat, 28 Feb 2026 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302330;
	bh=EGYTZ0DO46yWsqcrhYN7Ob5508yC0WjrxiRHcypcrt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0D8fcI7coJlr7bvOTNha6Nq8T/CFShiHMz8Y/G2a0K0kOyZzFM+8rZ1qV6RwXwE1
	 lINPsJ0iDSOWm8YmQVwdp6sQenX//v15cPU2qUgQyohr0E+IRxZoYjKuZR0PnDzQOE
	 3VpVKoiyRpIrooCj468pMPUpWfHpROvjAyZTyFipwnoHPDvNBXbC3k+UYPqj/iLsvW
	 uajSx1loY+eIxky2a7/4KNaXz298Phi8zBz9Qu+FDUYpHQk1EwFmb8QxO+fFgjSq2E
	 5/oHuriquFyx9v85ZiIEac5d3hnUybeV2Jacv2DoyOsdysPzoSwMx7VW/fVryJZBwe
	 ve29IcvQa45xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/232] soc: qcom: smem: handle ENOMEM error during probe
Date: Sat, 28 Feb 2026 13:08:23 -0500
Message-ID: <20260228181127.1592657-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 06958de43f8ca..ab5c839511e88 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1130,7 +1130,9 @@ static int qcom_smem_probe(struct platform_device *pdev)
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

