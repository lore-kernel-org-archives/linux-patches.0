Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C7C3559DA;
	Tue,  6 Jan 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722555; cv=none; b=gj0f/9koPRXsbJ1QKJTpzSQSnpAvtjdUNsSMEtgvuUOVt556S5RJbI52gyWjOO+iz6klQ8h9WL8z+/RN3I1kwAqM9xxuyDLKZQNbpYUBnRcz7YVCdODMvgDKlRr8u2zdhEcNgdNXOxTnjH93Hc7wET9odsHtrH4G/2pYqNVicqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722555; c=relaxed/simple;
	bh=RrNScxieM4YsJh7CqamwwlTp0ii6MUGEQ0BSXbp5SHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmIBP/xAw2Gp3fTwDLo15nuLTXm+OHovz5UAWv7GVpHHAvjb3gZXo0xb5KRxY6y1bpV3POm6CulxGZlV/O0IJKbgDVem6igwnm6zDe9lyPKcVczzxG+p6LK2pN53/T4D8zXi7h/K1Gp3qGy8dKd1Zxk/v20O8BSYi3giiw4yNfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OL/tJJBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OL/tJJBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0238C116C6;
	Tue,  6 Jan 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722555;
	bh=RrNScxieM4YsJh7CqamwwlTp0ii6MUGEQ0BSXbp5SHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OL/tJJBmyGkqvvTqnwxsK/+D1RZnyDhmNfk5q8BptKirg3c5hiBw1Pgezb3U3fN/0
	 7IBHur2BZN3SE5xLo1HDsiETEAR12/0BPD0mVu1dRm4QWO2UfCdxf73YsuQ+HiO294
	 0XGURnCp4h84pH9xjezgVqqxeHOVo1HEFfKAVggI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.18 298/312] drm/msm/dpu: Add missing NULL pointer check for pingpong interface
Date: Tue,  6 Jan 2026 18:06:12 +0100
Message-ID: <20260106170558.637376488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 88733a0b64872357e5ecd82b7488121503cb9cc6 upstream.

It is checked almost always in dpu_encoder_phys_wb_setup_ctl(), but in a
single place the check is missing.
Also use convenient locals instead of phys_enc->* where available.

Cc: stable@vger.kernel.org
Fixes: d7d0e73f7de33 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/693860/
Link: https://lore.kernel.org/r/20251211093630.171014-1-kniv@yandex-team.ru
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -247,14 +247,12 @@ static void dpu_encoder_phys_wb_setup_ct
 		if (hw_cdm)
 			intf_cfg.cdm = hw_cdm->idx;
 
-		if (phys_enc->hw_pp->merge_3d && phys_enc->hw_pp->merge_3d->ops.setup_3d_mode)
-			phys_enc->hw_pp->merge_3d->ops.setup_3d_mode(phys_enc->hw_pp->merge_3d,
-					mode_3d);
+		if (hw_pp && hw_pp->merge_3d && hw_pp->merge_3d->ops.setup_3d_mode)
+			hw_pp->merge_3d->ops.setup_3d_mode(hw_pp->merge_3d, mode_3d);
 
 		/* setup which pp blk will connect to this wb */
-		if (hw_pp && phys_enc->hw_wb->ops.bind_pingpong_blk)
-			phys_enc->hw_wb->ops.bind_pingpong_blk(phys_enc->hw_wb,
-					phys_enc->hw_pp->idx);
+		if (hw_pp && hw_wb->ops.bind_pingpong_blk)
+			hw_wb->ops.bind_pingpong_blk(hw_wb, hw_pp->idx);
 
 		phys_enc->hw_ctl->ops.setup_intf_cfg(phys_enc->hw_ctl, &intf_cfg);
 	} else if (phys_enc->hw_ctl && phys_enc->hw_ctl->ops.setup_intf_cfg) {


