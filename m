Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104963054E0;
	Tue,  2 Sep 2025 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819549; cv=none; b=LZvEc6zHrDYo/0MONB5OhdG69oDfNU0GxTInlaPT/SwFnvu/BsdQIpn2i2O3GPAcXnymGWCCNkPLlnpIPZ9BwKVajrwE5h0OTKGLTgy9f36C1igNmWcutkfqRul/4j9mVyxhu+06Xi7KXc2G8/5S8WxuedIsmfFI2K8JnbQxPPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819549; c=relaxed/simple;
	bh=5SyZxt5wwHtNiUxXXI+Iu7/gFt7CWAYCMVefsmcf/OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKYBKe9dhoDt9xvI0ZWtlGNI8jRr+SbeVcBQINQTi504By5/Mm13FAYwk4PJOgG/LynCKCvvCoPuZ64lcXyeKrPxm06Z7O23cHe6My/LXL2OgOEqBCeOujbhLngncIzVRJnApflrBYN/MNmMWQOVAyOHaSu+STLjN8FUoppImkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fToODpUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fToODpUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ADAC4CEF5;
	Tue,  2 Sep 2025 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819547;
	bh=5SyZxt5wwHtNiUxXXI+Iu7/gFt7CWAYCMVefsmcf/OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fToODpUPjZj1ud/SIzziFsDmjHYNEU5J5+PqCM9l4se6FSAKwfJzMH5S7aJF3EIcs
	 +XkHb1Ab6GlcqyHgbpSN43ILe+M9uTrO5RDjaUhYo1sQ9CQy+1SgV8IWGJRQ2OyL1Z
	 0QpWZLLa4eorDdTjm2wsms2KyIhmoOgsR02clMOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 035/142] drm/msm/dpu: correct dpu_plane_virtual_atomic_check()
Date: Tue,  2 Sep 2025 15:18:57 +0200
Message-ID: <20250902131949.489058877@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 1a76b255eceb9c570c6228f6393e1d63d97a22ba ]

Fix c&p error in dpu_plane_virtual_atomic_check(), compare CRTC width
too, in addition to CRTC height.

Fixes: 8c62a31607f6 ("drm/msm/dpu: allow using two SSPP blocks for a single plane")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507150432.U0cALR6W-lkp@intel.com/
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/664170/
Link: https://lore.kernel.org/r/20250715-msm-fix-virt-atomic-check-v1-1-9bab02c9f952@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 421138bc3cb77..28d42eade5ccb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -1169,7 +1169,7 @@ static int dpu_plane_virtual_atomic_check(struct drm_plane *plane,
 	if (!old_plane_state || !old_plane_state->fb ||
 	    old_plane_state->src_w != plane_state->src_w ||
 	    old_plane_state->src_h != plane_state->src_h ||
-	    old_plane_state->src_w != plane_state->src_w ||
+	    old_plane_state->crtc_w != plane_state->crtc_w ||
 	    old_plane_state->crtc_h != plane_state->crtc_h ||
 	    msm_framebuffer_format(old_plane_state->fb) !=
 	    msm_framebuffer_format(plane_state->fb))
-- 
2.50.1



