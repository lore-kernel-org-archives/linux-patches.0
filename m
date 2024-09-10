Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6E117A589;
	Tue, 10 Sep 2024 10:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964783; cv=none; b=eMTV04imPpFqq2bHkxKNz9tmEP03ry66/N475cV2GWZFRqWA+2/9n2H7TdBbHdINf0xhmgxLbg44nRiwH0g3vLMaOfIL74T+lRqH4C04K3Jt5aUxyweSuPbAQD0kJsTH3uTJqknIME5t6b3W/6XiDFlKPB2mnuki09w35RZpPHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964783; c=relaxed/simple;
	bh=uKZ4Mf4tyOda3Xpt9QCkFJl718zRGsto1sAXwid/JLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2SRBenGavWLKb9lB4DVlm764+j2U/2RcW/R1YvSkGXppQiW6f52d2xt3dPFaYv/3GOcLp/AbQ6U/J/WCVt5k6vzP36e+WMqTShyP1lFKHJQk1tDaat4M78gPc45pdnOTaIcom0Bu5H6L7S33KKf4KLXnW5lCY3RdHHfsY7WiGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ba1L9/9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ba1L9/9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7289CC4CED2;
	Tue, 10 Sep 2024 10:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964782;
	bh=uKZ4Mf4tyOda3Xpt9QCkFJl718zRGsto1sAXwid/JLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ba1L9/9tGj0mDJBzk9LuVaKFdsWq3NRS75sHad2aLT2sHcUX3TbU3Un4DYco9nuO6
	 wTBke/invHwXm6rX7BRZp3s65JpKQuGpaMRFzep0Gl+tAWWJdGSAZ90Hph1bhPxsTU
	 UoIPQrvDbIV/epbBq+z79WjEbc74/gSHG8DkPKcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/186] drm/amdgpu: the warning dereferencing obj for nbio_v7_4
Date: Tue, 10 Sep 2024 11:32:04 +0200
Message-ID: <20240910092555.785653857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit d190b459b2a4304307c3468ed97477b808381011 ]

if ras_manager obj null, don't print NBIO err data

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index eadc9526d33f..b81572dc115f 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -313,7 +313,7 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 						RAS_CNTLR_INTERRUPT_CLEAR, 1);
 		WREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.43.0



