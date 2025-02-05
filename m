Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C07152196;
	Wed,  5 Feb 2025 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763313; cv=none; b=FC35YBzE3TTggyYOO/N3C0Jd4QnVfzrG+ctInbInxeBEiZc0z8C8RDqzvovIHBgDrAc37r9vHuvXdhJWxW+38HINlDHfhynW8TBrLyFYges/41fCpOr7ycSgOqMNqLrqR5wjPzCQ/jQRTpiJplXIQGaLHiy60tXQ9y9MVMYxiB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763313; c=relaxed/simple;
	bh=GKGEXyqoy4CIFJiW6WY6AhQuXg+GYlwz7GYposOcpBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2vsGlA+MMNDcE50MYXLrdu/VIxv5xmigMOF4nLdGobxEeCKGZygaNimKOZnw6cMcDMnquTTXrKOTcZuXByzWa3B+NQ3LKfmrqcEPb730oP5eVEVH1x+S2/qVNjXMn8PuYQ2qI8+uwTo02ltXvKmezhPryac6oqzHxYy2gbpv3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6enM85C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6enM85C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AB7C4CEDD;
	Wed,  5 Feb 2025 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763312;
	bh=GKGEXyqoy4CIFJiW6WY6AhQuXg+GYlwz7GYposOcpBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6enM85CUo9wYzBDiNNQM+H3TEGycpJYy2zg83s37UKs6dAKeEbO0/fi2fpndVy8J
	 Hf9ulZafnLY930hmWJgrcq/vr/xF2hB/kM3/p3PQR9yanyJTxKggKQLl26FM/B7dJh
	 OSg0t10H2QbszTCRY5Rq7/Qzn2tQdQ9y16ou4IO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/393] drm/msm/dpu: link DSPP_2/_3 blocks on SM8150
Date: Wed,  5 Feb 2025 14:39:17 +0100
Message-ID: <20250205134421.759904098@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ac440a31e523805939215b24d2f0c451b48d5891 ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: 05ae91d960fd ("drm/msm/dpu: enable DSPP support on SM8[12]50")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629952/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-2-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
index f0c3804f42587..76b668f36477a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
@@ -164,6 +164,7 @@ static const struct dpu_lm_cfg sm8150_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -171,6 +172,7 @@ static const struct dpu_lm_cfg sm8150_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



