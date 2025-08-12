Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3E827781E;
	Tue, 12 Aug 2025 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025759; cv=none; b=h1jvF7yY6y9IcSIpp/GwGtLuSp7ogzh+LucRZ4GlddlyM05SW4cRK5vtwCYnfhD75Q9zZMQti0ydKO8ZtLXn5OB22tdp15e9E4q62rWFnFtJxiZrC+xdljvQAEZmPHbHIYnd7v4HKNioc03/ppF+55jMQQRpajDZG18YRXY9JdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025759; c=relaxed/simple;
	bh=S6s3VzDmdFWI7fjLDFrsS7nzlbj6bbm7xPKZs2ker64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQnrX5FSk+VzH2ERr+9x+msDiQ1S/E9xBUic4f1DugFjxL74t60uga+gh7eTMvnYBnfiYL5ZeeEKPOYGHq1V59wP1RIyJqTcj9NOcNVxT3ICjG2QgVxYjn9M7sv5ccOrydu5TzPzCDzkCrqQ0eXsk1cAU+1Bf/c9UQdQmYvw6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4AZN5aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4AZN5aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E0BC4CEF0;
	Tue, 12 Aug 2025 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025759;
	bh=S6s3VzDmdFWI7fjLDFrsS7nzlbj6bbm7xPKZs2ker64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4AZN5aUQr9/Yq+0/USlntfZcRfPOkTDlo7HcKGKXX1sz3kh8zJjfbM9O8G2F3rB5
	 P/Q1LOhJArF5vGhFQ2fFIkMd+0l3L1Yy1h0rm/xxVzL9taEYajdmwOzzrB7ayh4C/l
	 kg9yMMaLVgfrDA3VqddMmhohng6uJKGelz9EoWJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 135/480] drm/msm/dpu: Fill in min_prefill_lines for SC8180X
Date: Tue, 12 Aug 2025 19:45:43 +0200
Message-ID: <20250812174403.096069242@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 5136acc40afc0261802e5cb01b04f871bf6d876b ]

Based on the downstream release, predictably same value as for SM8150.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: f3af2d6ee9ab ("drm/msm/dpu: Add SC8180x to hw catalog")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/657794/
Link: https://lore.kernel.org/r/20250610-topic-dpu_8180_mpl-v1-1-f480cd22f11c@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index e736eb73a7e6..49aed344d346 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -383,6 +383,7 @@ static const struct dpu_perf_cfg sc8180x_perf_data = {
 	.min_core_ib = 2400000,
 	.min_llcc_ib = 800000,
 	.min_dram_ib = 800000,
+	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
 	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
-- 
2.39.5



