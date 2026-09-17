Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C4B318B9C;
	Thu, 17 Sep 2026 16:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660842; cv=none; b=mS+U/B1yvmREtDEpqBknzsDN3lY5pTItTf6IJyzAV5rmw2sEyE7YsKcZpsJ6qnHNulrJfZ7QAqYkB+dAVMVZ7LIlRgjC6m+1Tq6VzzgVhWxWaln3FaNryHbyMor18CDZdAfhC/6N8Yyy5TfdhlaXSLFwlnGIgAcHGPLi3o7pzZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660842; c=relaxed/simple;
	bh=iQzCPfWTomikvGtMSgEgP3mH9lLy07QfJ9uA0qdVh3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezA9TSPc5FBBQOMy9RVvM03UHdFqYgBFDEKaoatMBO+ks4SvCbmPezYGyvnTo8ImeRzGCedzA+964LM3j+aIuI4Rb9B45yevSqJrmdC4fKUcezoqAQvH/LfNOUpUCmFUW6LE8njYo4Qxv+84vp4ZniJrfNgM+2ehfRzlrjIhxug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4ttSXQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4ttSXQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6519F1F000FF;
	Thu, 17 Sep 2026 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660841;
	bh=xIkIZSIibSregESMebnA1lqSwI2yJWjRAbRjDpuJdx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4ttSXQKTHlyM615WzCHGghWyGcQz4b/4y1k1Vp3/JyQkMKCbAEqalZ5RP6hVChRZ
	 OHt8z4qX1wwsctrRPqsowlqq+B1yLIS02GhrFm5v1TXvSoWE7zEFzYQMDA9d/RmxUb
	 PQmamxSTkDqqTNI1oneX/lGd5IKmGDUB2ufkrj4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 726/733] drm/amd/display: Propagate HDMI RGB quantization selectability
Date: Thu, 17 Sep 2026 16:17:14 +0100
Message-ID: <20260917151411.063960368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyajit Roy <sroy14@alum.utk.edu>

[ Upstream commit bdcd0411d7d186225a52458fd42bb70d54ca917a ]

DC uses dc_edid_caps.qs_bit when constructing the HDMI AVI InfoFrame
quantization-range field. Although DRM parses the sink capability into
drm_display_info, DM never copies it into the DC EDID capabilities. The
field therefore remains zero and the AVI quantization range stays at its
default value.

Copy rgb_quant_range_selectable for HDMI sinks and extend the existing
EDID-capability KUnit test to cover it.

Fixes: 6eb4c13a3845 ("drm/amd/display: Support "Broadcast RGB" drm property")
Signed-off-by: Satyajit Roy <sroy14@alum.utk.edu>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 892659399f64642e33072562a11ec1b2e7bd2263)
Cc: stable@vger.kernel.org
[ Omitted KUnit test additions because amdgpu_dm_helpers_test.c and its supporting infrastructure are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -197,6 +197,7 @@ enum dc_edid_status dm_helpers_parse_edi
 	edid_caps->edid_hdmi = connector->display_info.is_hdmi;
 
 	if (edid_caps->edid_hdmi) {
+		edid_caps->qs_bit = connector->display_info.rgb_quant_range_selectable;
 		populate_hdmi_info_from_connector(link->dc->config.enable_frl, &connector->display_info.hdmi, edid_caps);
 		drm_dbg_driver(connector->dev, "%s: HDMI_FRL [%s] max_frl_rate %d\n", __func__, connector->name, edid_caps->max_frl_rate);
 		if (edid_caps->frl_dsc_support)


