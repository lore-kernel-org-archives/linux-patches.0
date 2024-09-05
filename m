Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A36F1494DB;
	Thu,  5 Sep 2024 10:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530667; cv=none; b=ppZKRh5drI+hQULOY/Vto4HjJCJghKs6YivwWUnzp6bHUBo4ZJ8/ElbR2W+Ao/skm1lPOXv+lvmyaNJpIsoeIP4q/DGhU9/3TnLz1rugWoZ8Pe8xk7TV2835+FT5LEG4LuBREg0KvLih9mpwWwUpYElM6nKLp+7RtF7k/Q5xTrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530667; c=relaxed/simple;
	bh=NJJw7bkm/v7dhYSDkqAZI7cEF4rv5cBB9t56Ldx95+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGimVsvo6/am7dBT/QOMJ0vvgsxgvvnsFuhcOAGKIyHoA2Rrq6DnxnX9Aqaj6Flt0xj/Bkd2djsPCxs7OrOPB/msN2p2zboKy7iVGyCIG8lSgyyYJ0T/HrAYVOzVYTWcg77e1AiulXIXZECVmAZOAAz9hzdGl2GioaGFp3h6Qfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1hCbauW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1hCbauW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6807C4CEC3;
	Thu,  5 Sep 2024 10:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530667;
	bh=NJJw7bkm/v7dhYSDkqAZI7cEF4rv5cBB9t56Ldx95+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1hCbauWjdp/CEr458+L+hQWoIO9lINDbruBhuFZjIFk4pOzJiEedAPmm//7oRiWU
	 93jMQpRp1hIW+ps5qsxmGYCz2qUHSCjdBgYSufRRc5W2j7CUZ13xn5GFwFe+bSb58I
	 5c26geGsNFrDe1mlXhhc60Xap2pFcgP6uc+UOsQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/101] drm/amdgpu: the warning dereferencing obj for nbio_v7_4
Date: Thu,  5 Sep 2024 11:41:36 +0200
Message-ID: <20240905093718.645634626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 19455a725939..7679a4cd55c0 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -384,7 +384,7 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 		else
 			WREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.43.0



