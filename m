Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C8C14B080;
	Wed,  5 Feb 2025 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763812; cv=none; b=e7Tvj9zQh4OunO+UjaJdEtoOesIaXCdw/ANHUJ2g69t32rjrgSlLfAeLnYB1e4H0o0AJkEDYiPY5kmI30AZjL9hBwrDBiS//kc2fqTAEfKg5eQIwFD8cSk5Im4dFAJA0mmOYiPR9iDasNbVO5VLFsN3TUqFbWFtDMNRyNhFAo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763812; c=relaxed/simple;
	bh=8ZtPxN8X71y2row+NSUvPWc+DzMyL5SJxPfVauyAsb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOqZ/ph4PnQNqxxl+5QymKgxHQma//I8fW/dDAI8R7Ody+h+kRp7x/dacL5xpV774J8kvLYS+6mRfJ9YCsxK0sAgVtWGXxKnDgvZNZubq55cfybf1kq6sTt3bbQuByUPLgmqXgM0hOWYve41NHOxjHzEkGKkUwQJMcT4LjicERk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiOOTd6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiOOTd6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B362C4CED1;
	Wed,  5 Feb 2025 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763812;
	bh=8ZtPxN8X71y2row+NSUvPWc+DzMyL5SJxPfVauyAsb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiOOTd6aSE2VfJZ5/J9bBqskGAz9NrMZRBz3XbUzSA53UhqD6wJ5t7UsN4ZrKrEhA
	 kMxEnld5HJsh51YW/YhSp7pFzFvpMI10I4cO4sJYA1bsJgbpcZgPx6cjZCPv1ndMZg
	 YL4AakAkQS7vgOEuqWKNjC7ux7GlJY0uJn3FXcfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/590] drm/msm/dpu: link DSPP_2/_3 blocks on SM8150
Date: Wed,  5 Feb 2025 14:36:54 +0100
Message-ID: <20250205134457.515870452@linuxfoundation.org>
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
index 6ccfde82fecdb..421afacb72480 100644
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



