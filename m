Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86C1C0DE7;
	Mon,  1 Apr 2024 16:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989211; cv=none; b=m20k8hbMRhd8kqH74S5U3NmFHRsgw9W73P1gHIcfp2St82ExpW1Y0ALlUlSBSuOa+In2qliN21nayF5KH+8Nezr7GSHGtk/pELrLaO9o2FmeJyIq67odfV3GSd7YkvErfVbd/v2nuxYpzNVxVoRED2FHyipCY1i+RLhCvWKJS7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989211; c=relaxed/simple;
	bh=bjSN10FV9pPlHmSd4iKxbnrlzJPSFcQORQ6vEgcbmes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFvWVtfPWL6jI3NsEWPDr5JM7ezajXNY2L5EaEqL7uTIw7+i/3hNGW/whDBwvXlOYIJbEf2Z9Z6ub6cvPHrfQzJLEc00DsQkfuZAg7YNhapcJ75Npq+phXJ4hhA8En4xHe3OHuJd1FF/5YEsVac7z6NSq7O1369MTJU8nHclZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZknTJHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZknTJHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD66C43390;
	Mon,  1 Apr 2024 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989211;
	bh=bjSN10FV9pPlHmSd4iKxbnrlzJPSFcQORQ6vEgcbmes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZknTJHGO1J4Thl4JD6auJgXqpaXvtn7bHKVs8X84wI1gGFJuLmoiL9RnFxYZ3Iq4
	 7rGLn/xtGG9WsKXus6E9EUsHU2hfDen2LvTQNr8D7EuGNxCd8RSUbnQnLovgQgSh5T
	 t0Ai3bUWVArpIH5r7wg/M7m7cnHIPQTsGhABBNsQ=
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
Subject: [PATCH 6.7 386/432] drm/amdgpu/display: Address kdoc for is_psr_su in fill_dc_dirty_rects
Date: Mon,  1 Apr 2024 17:46:13 +0200
Message-ID: <20240401152604.829603589@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 342e41c78fb34..dafe9562a7370 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5129,6 +5129,10 @@ static inline void fill_dc_dirty_rect(struct drm_plane *plane,
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



