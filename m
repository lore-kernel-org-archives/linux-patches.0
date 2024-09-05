Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A571155730;
	Thu,  5 Sep 2024 09:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529584; cv=none; b=k7oGla7hba9h8qZVrfaHq9roL8POVCQfWppk5Skp9Md1AH0rxtNg/v1CaSiQrC62y9dFEV+2vQEpiQoZC+6ipzI13CMipGjLZHnPs9+GrREAzBbhUtgqKUdRRBn6vgdGBlpuLM10wIPr9LTpFC+qFskrfDBw4Vn/zumZCheindE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529584; c=relaxed/simple;
	bh=MCZ2P3bBJ8FjrpxLGDjAM7yrDn1kIdOj2pmrLBHkJ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwwWnmncb/ZDVjp+6gv24jYsmST9YLOvgoFUxP/iGFtayALOiVSJcXr8oG2rJA2iDPkV0eqV0CvuJ3v0gerT8vwUW4chTxTj9q01Ea77G2UsqJsDWL6IBjmWcse9h/ubMTrU7NyZsbr95CLHcJxMGkG3ktIHiDjVu2Vq3m6Eipc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGFrG11v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGFrG11v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733CBC4CEC3;
	Thu,  5 Sep 2024 09:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529583;
	bh=MCZ2P3bBJ8FjrpxLGDjAM7yrDn1kIdOj2pmrLBHkJ4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGFrG11vTVxXT2V/0uD+e2HzQxOTW/493vlVNnVbVrfpt1+5OciOfm0KZnyXppdkj
	 +HyUwcY6QimlR/cS0e2fYg9z3je105myUg7MsWtzCaWpMPtMRwd00ywOUAYNy1ddsW
	 R2V12r7glP1Qkvv1rUxI1Ezqwst2vaGTk3UWKyAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 079/184] drm/amd/amdgpu: Check tbo resource pointer
Date: Thu,  5 Sep 2024 11:39:52 +0200
Message-ID: <20240905093735.324517690@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 6cd2b872643bb29bba01a8ac739138db7bd79007 ]

Validate tbo resource pointer, skip if NULL

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 89cf9ac6da17..13b54e00a247 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5012,7 +5012,8 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
 		shadow = vmbo->shadow;
 
 		/* No need to recover an evicted BO */
-		if (shadow->tbo.resource->mem_type != TTM_PL_TT ||
+		if (!shadow->tbo.resource ||
+		    shadow->tbo.resource->mem_type != TTM_PL_TT ||
 		    shadow->tbo.resource->start == AMDGPU_BO_INVALID_OFFSET ||
 		    shadow->parent->tbo.resource->mem_type != TTM_PL_VRAM)
 			continue;
-- 
2.43.0



