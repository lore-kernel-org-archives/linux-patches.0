Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D159B1990BB;
	Thu,  5 Sep 2024 09:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529673; cv=none; b=RDHHjA+1x0kPiAPDK+C7oFMPNjy7ZoPDTARrwanLe99oY2bZYF9/YAxN6aKIj7VRarmEKdTVKpjed2cLYKOi0ePmzE7Wb63x8vDoD82PpJFrfNP37zK6L+bE4NV2J8Vz3bjRn61ir2SOHqhd/Al3ZOJhRi4SaXX4tZZ7mnCyx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529673; c=relaxed/simple;
	bh=9ATFhgNb0prQNsF5qJHSJZHNV9hh1+cS9MOFiaAeduY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSEI97lr4GM0JnLMyn1Ku1Sr3SXwaMBNhefISxb/PakViR/bO5aFiiwJ7yYdlF9xTPotxYbtZYHQycCcZu9l2xrwRuLFpJ5ou/TgJYQWpsNA6OqEf1G7lZLL/uKO+V7Rhc6P72bRheHHn9dvFFpblOb+bHmtvwrlb9hlc0+bDTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usYHrgrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usYHrgrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440CEC4CEC3;
	Thu,  5 Sep 2024 09:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529673;
	bh=9ATFhgNb0prQNsF5qJHSJZHNV9hh1+cS9MOFiaAeduY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usYHrgrI6RkUOmHCjVhSCt/oxlAU+oD6URfgV5SpMuIEygSaoDwY5HF1qGaCZ34kE
	 glhy9MWOZ3fepopcmrUbxpnnPul22L8SF3cblS2FBc7faHjv9LwSgCNWz/FiOuhwPT
	 u6h5g89r1SZblmxjc8TPzS/KkvA2cH0c/RBqSqkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 108/184] drm/amdgpu: the warning dereferencing obj for nbio_v7_4
Date: Thu,  5 Sep 2024 11:40:21 +0200
Message-ID: <20240905093736.450322485@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19986ff6a48d..750ce281b97b 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -387,7 +387,7 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 		else
 			WREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.43.0



