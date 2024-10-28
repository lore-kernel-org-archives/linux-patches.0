Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A662C697;
	Mon, 28 Oct 2024 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097680; cv=none; b=ByYELYci8seOnOkwmI0AGe1W249pnvl7PEpELas8v219AgUEq5/m8OnSM4YT2DTgkbUHygtfJHHFhJXBTYmNGDkzKMhvFlS7V47ZfkKaqB/LBqZY3nMi09rDYQPyV+JxFexUYEQzFLPByCh6tVHpz4ZhsMnvny1FFEHqodRpMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097680; c=relaxed/simple;
	bh=QDn0xkD66CXfE5G0X0GmTP0euRR8mpBmpFiUD8sw8KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk0GAoqsoDFM26K2+BM6sIAgcWnLRlS84FZZrBLfRXl+zlOSdGkrUbj3837jz+3c4iLgmx6IeI7hzGCzrRYnmD+aIA+uSx/hgJhi8Hzo2DPyE5xHOvVCheA7YnGxQ7Qn47BOEKw4bUlf20HWwePl7FA26xHlQX3GQldqUbAwgdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lU1mB9+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lU1mB9+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31957C4CEC3;
	Mon, 28 Oct 2024 06:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097680;
	bh=QDn0xkD66CXfE5G0X0GmTP0euRR8mpBmpFiUD8sw8KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lU1mB9+H8VPux+d2tG3bKykeZ3AFhPK+qOUDTsQ+c87KnmT3prh29ViUSPc/+iykg
	 JD1JCWLoiwWK5j0oOm0usaTJfRBJ6Rq+dQzJiK2HJICmHNJdZgrwMbQ52y+lGRbPja
	 0nE+pqi0q4iCelx8uXs6EDHZ43XTX+qdazbqzmJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/208] drm/msm/dpu: dont always program merge_3d block
Date: Mon, 28 Oct 2024 07:24:04 +0100
Message-ID: <20241028062308.230405138@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit f87f3b80abaf7949e638dd17dfdc267066eb52d5 ]

Only program the merge_3d block for the video phys encoder when the 3d
blend mode is not NONE

Fixes: 3e79527a33a8 ("drm/msm/dpu: enable merge_3d support on sm8150/sm8250")
Suggested-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/619095/
Link: https://lore.kernel.org/r/20241009-merge3d-fix-v1-1-0d0b6f5c244e@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index daaf0e6047538..20c8b9af7a219 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -280,7 +280,7 @@ static void dpu_encoder_phys_vid_setup_timing_engine(
 	intf_cfg.stream_sel = 0; /* Don't care value for video mode */
 	intf_cfg.mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
 	intf_cfg.dsc = dpu_encoder_helper_get_dsc(phys_enc);
-	if (phys_enc->hw_pp->merge_3d)
+	if (intf_cfg.mode_3d && phys_enc->hw_pp->merge_3d)
 		intf_cfg.merge_3d = phys_enc->hw_pp->merge_3d->idx;
 
 	spin_lock_irqsave(phys_enc->enc_spinlock, lock_flags);
-- 
2.43.0



