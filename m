Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D681DC759;
	Tue,  8 Oct 2024 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391335; cv=none; b=ah9PhTSayVPV90rbB48mQ/eFYqtIOU5M5FY/DJ0W0ZGb2lZcKP/R7lTANRKO/+4+6Kw4RS2wqzmF5hFXyCLkrgqR+G9dXrLG6Y2EGHGgvFh6KAYTO9YVNa0qvwtxWJ9rItrukdydHsLAVEKv26jEwBChJg0G7vCIhkJn5D484G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391335; c=relaxed/simple;
	bh=A4ea+acqlTK08R+UYmEVwLbJtaqAdscJ3+bxUQNSbPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShAOCK6k2YSv9qX1/wbucXPBxyuz+9D14BzlbvIVyTuBy0f8OxXYUd14S9RD+s7Vn0XG+/wtyzD6Ls0dFq8Y2CMgV9UJmY5q8dzNSdCJkTBD4fVuk6rbHRF6v0OwhF98TsGkLSxOsvmm+g35yv45yim/PcPGt8uUYgp6kWYqsbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3NLqnN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3NLqnN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BABC4CEC7;
	Tue,  8 Oct 2024 12:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391334;
	bh=A4ea+acqlTK08R+UYmEVwLbJtaqAdscJ3+bxUQNSbPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3NLqnN4CwLAT6zCJhPet6r0REKiSuibesC3fj/lfprLvvqaZkGby0whrYdyV3jPU
	 WAWNQQFdQlsDgaVWIVJ9H037Nmhi2VjKEd68ybADPZ1MBalsP0PlMo00I1qwLoD/Wn
	 jOK7DO7xsX+c3bsco5kaKIEVYsYF90MraHxEnVXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Borsboom <arthurborsboom@gmail.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 082/558] drm/amd/display: Re-enable panel replay feature
Date: Tue,  8 Oct 2024 14:01:52 +0200
Message-ID: <20241008115705.602030780@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit be64336307a6c3ee71fe1337c1b9f0495aa83c50 ]

[Why & How]
Fixed the replay issues and now re-enable the panel replay feature.

Reported-by: Arthur Borsboom <arthurborsboom@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3344
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9ee54c5ce4a61..f6cbff0ed6f94 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4919,18 +4919,14 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	/* Determine whether to enable Replay support by default. */
 	if (!(amdgpu_dc_debug_mask & DC_DISABLE_REPLAY)) {
 		switch (amdgpu_ip_version(adev, DCE_HWIP, 0)) {
-/*
- * Disabled by default due to https://gitlab.freedesktop.org/drm/amd/-/issues/3344
- *		case IP_VERSION(3, 1, 4):
- *		case IP_VERSION(3, 1, 5):
- *		case IP_VERSION(3, 1, 6):
- *		case IP_VERSION(3, 2, 0):
- *		case IP_VERSION(3, 2, 1):
- *		case IP_VERSION(3, 5, 0):
- *		case IP_VERSION(3, 5, 1):
- *			replay_feature_enabled = true;
- *			break;
- */
+		case IP_VERSION(3, 1, 4):
+		case IP_VERSION(3, 2, 0):
+		case IP_VERSION(3, 2, 1):
+		case IP_VERSION(3, 5, 0):
+		case IP_VERSION(3, 5, 1):
+			replay_feature_enabled = true;
+			break;
+
 		default:
 			replay_feature_enabled = amdgpu_dc_feature_mask & DC_REPLAY_MASK;
 			break;
-- 
2.43.0



