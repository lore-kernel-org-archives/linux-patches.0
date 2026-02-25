Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32A24A05D;
	Wed, 25 Feb 2026 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983119; cv=none; b=am18fk072hAPEZy5pErr3J5KupIKPNcgQW5mxZsvP2K/cbz3gV7uklgp+AP2XEpGYQZhIAI744xq0NndWVgJzgLmAeBwh4s2o1wzql71YhDpgMy4VI/x3qOqZGH6phFWu0v4xoJTaOzi12N+q6mJkW2NPBNCHhYMe4bcPawAuZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983119; c=relaxed/simple;
	bh=ZzcYt2BE+TkSO4toOYyfAfwIgY5RX6pPEiakiydwleE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOi4NB5y48ZAnUMz9fkWv3M4YlXcHW2TPMNdzN0vrwcCi81/p7fN98Zl+jNcClqGMDo2dRCVb/eCstgfQp/zvgX3VHPEk4/G1+YFnYFVW8DLBMwg4nnfPI6CzeV3Vc8gd1AWOX1JP9MJoct87pJywsiJ6r6QW1Pi7q7qpTz5kl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaFBO+cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaFBO+cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67E9C116D0;
	Wed, 25 Feb 2026 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983118;
	bh=ZzcYt2BE+TkSO4toOYyfAfwIgY5RX6pPEiakiydwleE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaFBO+cqb22OWobRQ7UoGtlSRngeUo1Jv5k6BfzpzC+AY6knctfVep4dhWRumpE35
	 X8dH0aNyU1D1ubAwqwoEQfd+lONhBdJpajCClambzh2M64JW+8RRefdZH7C62C9GvT
	 E2GI4c9vzS2c3BDXggZuHoOrcXSIR7s6WVENZohI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Val Packett <val@packett.cool>
Subject: [PATCH 6.19 278/781] drm/msm/mdss: correct HBB programmed on UBWC 5.x and 6.x devices
Date: Tue, 24 Feb 2026 17:16:27 -0800
Message-ID: <20260225012406.514306843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e6177c7a2401b87b016728b75992926971d871fc ]

As in the previous generations, on UBWC 5.x and 6.x devices the Highest
Bank Bit value should be programmed into the hardware with the offset of
-13.  Correct the value written into the register to prevent
unpredictable results.

Fixes: 227d4ce0b09e ("drm/msm: Offset MDSS HBB value by 13")
Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/699274/
Link: https://lore.kernel.org/r/20260119-msm-ubwc-fixes-v4-1-0987acc0427f@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_mdss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_mdss.c b/drivers/gpu/drm/msm/msm_mdss.c
index bf9a33e925ac8..910242f5a71f2 100644
--- a/drivers/gpu/drm/msm/msm_mdss.c
+++ b/drivers/gpu/drm/msm/msm_mdss.c
@@ -229,7 +229,7 @@ static void msm_mdss_setup_ubwc_dec_50(struct msm_mdss *msm_mdss)
 {
 	const struct qcom_ubwc_cfg_data *data = msm_mdss->mdss_data;
 	u32 value = MDSS_UBWC_STATIC_UBWC_SWIZZLE(data->ubwc_swizzle) |
-		    MDSS_UBWC_STATIC_HIGHEST_BANK_BIT(data->highest_bank_bit);
+		    MDSS_UBWC_STATIC_HIGHEST_BANK_BIT(data->highest_bank_bit - 13);
 
 	if (data->ubwc_bank_spread)
 		value |= MDSS_UBWC_STATIC_UBWC_BANK_SPREAD;
-- 
2.51.0



