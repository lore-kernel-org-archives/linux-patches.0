Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E399AD55;
	Tue, 13 Feb 2024 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845644; cv=none; b=DOZFKVvrDdPhhUeGsBWFHwrSGIKvKN/d3i8UZjoIwU4z6MR0Z241OKeUkb7KCnitLyuBwbx+ApNqrB1rDBxedJrgHHMej2HmKMqr5WgljFBwCRULVNMesuMrdwWmkmOW5TIEma6U+nuroH3APnx4i0E6EkaHzyynG4vE6DUALlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845644; c=relaxed/simple;
	bh=OThqcCZPJfzahwK/wLyHad3MUj68v8MhKMaCWbP39wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ymq1cwrn/R2eWgoNXlMLc9lAi/Q02UDba7EywAz7MI5C9USNmDyYbqQVQbzaUfbX0AedEhZLdGXvQBTUKnzIUn47kcRR/VNNH/p+A4GkmzNnyGunoMuJVSdwNvbYITdhzOkWy8NZyYZaOxP23MTMbc2GVVt2kxjWtK9UyoZBNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n835Lf81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n835Lf81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B5CC433C7;
	Tue, 13 Feb 2024 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845644;
	bh=OThqcCZPJfzahwK/wLyHad3MUj68v8MhKMaCWbP39wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n835Lf81Y6qke0pFH5HC4rB66kBDeCCOsdJdcMAXqzgbA0052e8xQzLMVXMr96EtA
	 /NwNzIPl5oRjd+eh/Uf7lQkyTgmZRIdxRtrWhkPIWx/perC7dAQJlTY+mjlLHMIP5j
	 CPXtGbIAbYUnYVvl2d4OM+VtmTCtrDk6TBWTfMwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 018/124] drm/msm/dpu: check for valid hw_pp in dpu_encoder_helper_phys_cleanup
Date: Tue, 13 Feb 2024 18:20:40 +0100
Message-ID: <20240213171854.265442582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 7f3d03c48b1eb6bc45ab20ca98b8b11be25f9f52 ]

The commit 8b45a26f2ba9 ("drm/msm/dpu: reserve cdm blocks for writeback
in case of YUV output") introduced a smatch warning about another
conditional block in dpu_encoder_helper_phys_cleanup() which had assumed
hw_pp will always be valid which may not necessarily be true.

Lets fix the other conditional block by making sure hw_pp is valid
before dereferencing it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: ae4d721ce100 ("drm/msm/dpu: add an API to reset the encoder related hw blocks")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/574878/
Link: https://lore.kernel.org/r/20240117194109.21609-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index b9f0093389a8..cf0d44b6e7a3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2075,7 +2075,7 @@ void dpu_encoder_helper_phys_cleanup(struct dpu_encoder_phys *phys_enc)
 	}
 
 	/* reset the merge 3D HW block */
-	if (phys_enc->hw_pp->merge_3d) {
+	if (phys_enc->hw_pp && phys_enc->hw_pp->merge_3d) {
 		phys_enc->hw_pp->merge_3d->ops.setup_3d_mode(phys_enc->hw_pp->merge_3d,
 				BLEND_3D_NONE);
 		if (phys_enc->hw_ctl->ops.update_pending_flush_merge_3d)
@@ -2097,7 +2097,7 @@ void dpu_encoder_helper_phys_cleanup(struct dpu_encoder_phys *phys_enc)
 	if (phys_enc->hw_wb)
 		intf_cfg.wb = phys_enc->hw_wb->idx;
 
-	if (phys_enc->hw_pp->merge_3d)
+	if (phys_enc->hw_pp && phys_enc->hw_pp->merge_3d)
 		intf_cfg.merge_3d = phys_enc->hw_pp->merge_3d->idx;
 
 	if (ctl->ops.reset_intf_cfg)
-- 
2.43.0



