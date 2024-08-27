Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F61C8FCD;
	Tue, 27 Aug 2024 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770693; cv=none; b=B2hkPrJldC3B2Df/3A44Chu5gWa3NmCnTGC5ud8z70YDuSs63WUJtb2UOtMgUGiI4fCeumxOM/WleoNrATfXCRLqe2jY7ahkWXbt21UjFBYIBuoFXdsYnENPguZ85DxQ+WUcTaD/ve1PzN6r5RAeQIiqgogr7tNcDlFXTSpRWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770693; c=relaxed/simple;
	bh=AfoDF6dWvoVWmwaMNpIck7avMk3MRi8nvltE+GXDmnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqVn33pouPFx8HLXOP7BXCnoKAObXFwXiXZ8tjneL4cG4cRBOm12k6k4JVV2+FDgc4UVHSNeI79+xv8xX2XPcS4Q/keer8CO8sysW4Ctd2yv+0KclNl4dzHPQ3pqk615i7gAaNmm9ApF6AhWyLjQJ0IFmHiqZ56Rj4UPhj3G0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCyb3mty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCyb3mty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67447C61044;
	Tue, 27 Aug 2024 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770692;
	bh=AfoDF6dWvoVWmwaMNpIck7avMk3MRi8nvltE+GXDmnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCyb3mtyieUevfCnMexUzuRmGdSfydDBE0a4gL7IB49TVclTRruhRXt5sYyQSfFMW
	 6D1NJPU5nXHQR7DJuqnNTvF+A/RbDmwHxDcw50tEfBuBIQLNDPxx0DhFCnpeZzKsfe
	 mufh1WNYEbN1x7vKnR5NSGPXl2Jk1dtOErLBsBac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/341] drm/msm/mdss: switch mdss to use devm_of_icc_get()
Date: Tue, 27 Aug 2024 16:38:39 +0200
Message-ID: <20240827143854.354392258@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit ded61d7dc5a0f8cfe7390aba33187c862d09b177 ]

Stop using hand-written reset function for ICC release, use
devm_of_icc_get() instead.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/570161/
Link: https://lore.kernel.org/r/20231202224247.1282567-2-dmitry.baryshkov@linaro.org
Stable-dep-of: 3e30296b374a ("drm/msm: fix the highest_bank_bit for sc7180")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_mdss.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_mdss.c b/drivers/gpu/drm/msm/msm_mdss.c
index 348c66b146834..67f225de57d74 100644
--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -50,14 +50,14 @@ static int msm_mdss_parse_data_bus_icc_path(struct device *dev,
 	struct icc_path *path0;
 	struct icc_path *path1;
 
-	path0 = of_icc_get(dev, "mdp0-mem");
+	path0 = devm_of_icc_get(dev, "mdp0-mem");
 	if (IS_ERR_OR_NULL(path0))
 		return PTR_ERR_OR_ZERO(path0);
 
 	msm_mdss->path[0] = path0;
 	msm_mdss->num_paths = 1;
 
-	path1 = of_icc_get(dev, "mdp1-mem");
+	path1 = devm_of_icc_get(dev, "mdp1-mem");
 	if (!IS_ERR_OR_NULL(path1)) {
 		msm_mdss->path[1] = path1;
 		msm_mdss->num_paths++;
@@ -66,15 +66,6 @@ static int msm_mdss_parse_data_bus_icc_path(struct device *dev,
 	return 0;
 }
 
-static void msm_mdss_put_icc_path(void *data)
-{
-	struct msm_mdss *msm_mdss = data;
-	int i;
-
-	for (i = 0; i < msm_mdss->num_paths; i++)
-		icc_put(msm_mdss->path[i]);
-}
-
 static void msm_mdss_icc_request_bw(struct msm_mdss *msm_mdss, unsigned long bw)
 {
 	int i;
@@ -391,9 +382,6 @@ static struct msm_mdss *msm_mdss_init(struct platform_device *pdev, bool is_mdp5
 	dev_dbg(&pdev->dev, "mapped mdss address space @%pK\n", msm_mdss->mmio);
 
 	ret = msm_mdss_parse_data_bus_icc_path(&pdev->dev, msm_mdss);
-	if (ret)
-		return ERR_PTR(ret);
-	ret = devm_add_action_or_reset(&pdev->dev, msm_mdss_put_icc_path, msm_mdss);
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
2.43.0



