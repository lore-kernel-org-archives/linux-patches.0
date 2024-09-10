Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A9190496;
	Tue, 10 Sep 2024 10:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963371; cv=none; b=KgcE8ThJ6mP2nWFHLDsVCkmV/o8R+ztouakA76HALtitNnw5AEEZhSS6+bzc4JF1sPvh0vWB261QmjXzu33ek1twwadNUaRvY+jMBl/8zn7gWrAYHgMP2+AE25+zagjMC511JBrzEhmZc0L9Hh84kKwoJuTiZVUhzI3R0AIZV80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963371; c=relaxed/simple;
	bh=bTY3v/gGizhSfJuqG0c+gSm6+CmORv0Qat/uPTusOnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPVnlJ3qGZxP3B1GeZ24D5WpKkidFNUWXUvvaGSeLO6e8OdLZqzd0V7ptimQY8C6QcEwWhAc9aMW93UFeswZWJSXDSzBDWFRkv0A+dp5UJ316Cc1OGi3jEe2eNuv6IJUkVIFlbkbNN0trEhGbyFgwejnqplbcG9xGJD1xPoW4H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpcvFthv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpcvFthv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE7BC4CEC3;
	Tue, 10 Sep 2024 10:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963371;
	bh=bTY3v/gGizhSfJuqG0c+gSm6+CmORv0Qat/uPTusOnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpcvFthvxIlj9MoLGZ7msGr3Je/q/2gCMm7Q/LkvfHuslXjwnFKP/vrfwE06cQXWK
	 L+T8RbI65/gc8MhJMc7sf1c15lGnD7a1iyHgR9O7HC2jrjM4TIaQcmnXFqt9Y1pJfa
	 24fCpEW7SP405GTcMUd1mb2GOvoSbbFRP7MOaLnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/214] drm/amdgpu: the warning dereferencing obj for nbio_v7_4
Date: Tue, 10 Sep 2024 11:30:57 +0200
Message-ID: <20240910092600.201222142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 74cd7543729b..af1ca5cbc2fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -370,7 +370,7 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 		else
 			WREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.43.0



