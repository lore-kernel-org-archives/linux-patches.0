Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0593113C9C4;
	Wed,  5 Feb 2025 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763836; cv=none; b=gLobIV2t9v7UqbKWLqdENNJtiIDNQZ/S1Vqv8p9iVnZIK6RgJdgV7Ajz/nE+w+gxE6YfcqQjVk+NrdR1TMvFHdn5Kv6UQ0oGxgfLvsRblCTz3r1i2NG38ZFrSvgg+/xPE1XqknXAiBNqEyWyBi9ma9FMPW1JZJEQouZDObhrKAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763836; c=relaxed/simple;
	bh=XQGN9BMtQcfw9hg8CfEhkhJjzeNB32CxgP9mcDeJi0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7VIG9MnfF69JZuCb8LYjibqJHX6oF9bj2xoCCdC6oU94iR39lQ1L2BxAgiEjjQ8OXEaPreZ//hBVUs3mRusG2Xcn07T3HOGOOYJVWHGjvAeAP42FANPU25a7e98hm/ZVBfIeg53/SeLv03vKdNewJ8XI+RH2Lb8MYpGZOIHrq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3gFCvtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3gFCvtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7167CC4CED1;
	Wed,  5 Feb 2025 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763835;
	bh=XQGN9BMtQcfw9hg8CfEhkhJjzeNB32CxgP9mcDeJi0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3gFCvtOEJGTQuvpee34qeSMYa3yYeDcaphMbh2TSorLxvrsKCYEZzUFnk60WDOgs
	 Ozt8QksvgOyloLIJ6hZh72ZRWo4C+pE1UesI08c+/2QBunQB9ZvjUsguNcl6IhlEiZ
	 H1kdrsWltX9Bo5m4W80FdPKT7kFPEkDNHKvsR92Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/590] drm/msm/dpu: link DSPP_2/_3 blocks on SM8250
Date: Wed,  5 Feb 2025 14:36:56 +0100
Message-ID: <20250205134457.592435626@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 8252028092f86d413b3a83e5e76a9615073a0c7f ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: 05ae91d960fd ("drm/msm/dpu: enable DSPP support on SM8[12]50")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629956/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-4-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
index a57d50b1f0280..e8916ae826a6d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
@@ -162,6 +162,7 @@ static const struct dpu_lm_cfg sm8250_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -169,6 +170,7 @@ static const struct dpu_lm_cfg sm8250_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



