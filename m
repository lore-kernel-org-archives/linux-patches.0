Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ABB481AB;
	Mon,  1 Apr 2024 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986653; cv=none; b=GXBk8DrWs1jsaGyL1x4HptVHMmcHQKiW+3sJWZ1o4JyF4zIKu/d93OdYEy7XRmPtys7lqBRW/QfQL1hqxW29ZwCfiHKh5SSackPRjdJoSOtYMVYosvRVLWtQRyPcdQJjGxIfbditiogSohqnqQQAlp15zMpnJOS93pfDokbczDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986653; c=relaxed/simple;
	bh=n3MudD9ecO2B66CPCwTw0ST4GSfbWrDsX+bUtM6IUyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8KunRFT0wgv2QHkPYynHOPYP6R6cKO1zgCVOmqpAlAzsIyCAXP/5ZoxufWV5227HPLKjlAkKRGjag1Ns+BJAqoGOo0umsgJ9SyyJS2Wh+StECdnXbrBHZB6iRHtbD5b2gh65L/clL4i4Ss7Q6q7cKqV7gHExbAvcvWf+30J8Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pyra4A8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pyra4A8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2DAC433F1;
	Mon,  1 Apr 2024 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986653;
	bh=n3MudD9ecO2B66CPCwTw0ST4GSfbWrDsX+bUtM6IUyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pyra4A8I5t0m0Xo1DpstqiIRmf36D0rr/mRgj+U26T3brzkxHUg0kMqxIHpV7viQ9
	 rb2VZgc9w+RHHiMW7IesmOFqIdN+yUFjENvcS9e2iiDpE0ijdwKY/yAkzxmuXNDGNN
	 /KO7eTtD52jKqec5e5kzNGDA8IDdtB0xIWdmWbMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 043/399] drm/amdgpu/display: Address kdoc for is_psr_su in fill_dc_dirty_rects
Date: Mon,  1 Apr 2024 17:40:09 +0200
Message-ID: <20240401152550.461776532@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 3651306ae4c7f3f54caa9feb826a93cc69ccebbf ]

The is_psr_su parameter is a boolean flag indicating whether the Panel
Self Refresh Selective Update (PSR SU) feature is enabled which is a
power-saving feature that allows only the updated regions of the screen
to be refreshed, reducing the amount of data that needs to be sent to
the display.

Fixes the below with gcc W=1:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:5257: warning: Function parameter or member 'is_psr_su' not described in 'fill_dc_dirty_rects'

Fixes: d16df040c8da ("drm/amdgpu: make damage clips support configurable")
Cc: stable@vger.kernel.org
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8083e7156afcf..f3065ffa23785 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5199,6 +5199,10 @@ static inline void fill_dc_dirty_rect(struct drm_plane *plane,
  * @new_plane_state: New state of @plane
  * @crtc_state: New state of CRTC connected to the @plane
  * @flip_addrs: DC flip tracking struct, which also tracts dirty rects
+ * @is_psr_su: Flag indicating whether Panel Self Refresh Selective Update (PSR SU) is enabled.
+ *             If PSR SU is enabled and damage clips are available, only the regions of the screen
+ *             that have changed will be updated. If PSR SU is not enabled,
+ *             or if damage clips are not available, the entire screen will be updated.
  * @dirty_regions_changed: dirty regions changed
  *
  * For PSR SU, DC informs the DMUB uController of dirty rectangle regions
-- 
2.43.0



