Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538318B465;
	Tue, 10 Sep 2024 09:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961608; cv=none; b=WXspX4HvrwT4zWa0VlNz4RUJ2vYLyUy0nvFV0fQGK9bRebwdQEHWUBkul4Tgpo4TlzLUlspA2BmAWsSpCs/jqSS5l6FCdXGFjXs/2jdrVAzTL6QO9MKJQ5tOjuImPV9i6pS3Nq8Q3HPP+Olf0e9ZPjjWqPRelOe4w1IOYYb3gvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961608; c=relaxed/simple;
	bh=3C0nHkmfx8IRE1apL76m8s9UWTDaQ3jCIN1kErE1BKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFEvxrSo07UNhrlu1dqKtXhVo0+v1pnJvRbSjiAePDNm+xA/B1vcMcNEC6yb6sWw7Lzz3DT5WA/EFrm9t4DSgwJFTCKWzfMT6ClKlwOuuXvQxra9Zjl45Sefu5VmSOMtoTnwqjKbhZ2oYaTaV6bn8SU0wmPTuDq+O3PBNnk0fLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT9uxF6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT9uxF6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A85FC4CEC6;
	Tue, 10 Sep 2024 09:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961608;
	bh=3C0nHkmfx8IRE1apL76m8s9UWTDaQ3jCIN1kErE1BKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gT9uxF6Ogwx9gXQm/ARr0vKpi4r6qzypVsXREn03ghbybs3tprp5oDzxCjoTdZtM9
	 CG5CdPw3ks1z7UUGegeIrySdl+zrYBiffFLdB/2PivxuFxP/JiQqsbsE4cFMzpqesV
	 XYsqkHxA7gIHBQD5OKR8hQderUcnEmFzOsF7/7oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 127/375] drm/amdgpu: Fix smatch static checker warning
Date: Tue, 10 Sep 2024 11:28:44 +0200
Message-ID: <20240910092626.697295693@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit bdbdc7cecd00305dc844a361f9883d3a21022027 ]

adev->gfx.imu.funcs could be NULL

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index ad6431013c73..4ba8eb45ac17 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4293,11 +4293,11 @@ static int gfx_v11_0_hw_init(void *handle)
 			/* RLC autoload sequence 1: Program rlc ram */
 			if (adev->gfx.imu.funcs->program_rlc_ram)
 				adev->gfx.imu.funcs->program_rlc_ram(adev);
+			/* rlc autoload firmware */
+			r = gfx_v11_0_rlc_backdoor_autoload_enable(adev);
+			if (r)
+				return r;
 		}
-		/* rlc autoload firmware */
-		r = gfx_v11_0_rlc_backdoor_autoload_enable(adev);
-		if (r)
-			return r;
 	} else {
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_DIRECT) {
 			if (adev->gfx.imu.funcs && (amdgpu_dpm > 0)) {
-- 
2.43.0



