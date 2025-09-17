Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1C7FBA2;
	Wed, 17 Sep 2025 12:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112858; cv=none; b=qko9pxsMgGdni0FXYSVaqjyRaC2GuoqVhu4poi5PkmkKxQPyI8IG6dOGTU5siLo4DzWf3muGffS4Nx73HGb6jTFVBbLZDH0XxqpEnVS3r/RuEXosafFIruc6eI809wUuvK5ZNK11dFjMMvG9lpGv3ImD8znHCM/UTFVdCPlJGNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112858; c=relaxed/simple;
	bh=woMMoMNGbFUL9PhdERZ9V0y49qWDp43dgn5OTsxKh9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKIKXlT5uzLpD77aE4Pp5tOhx8g5IrafkUksjRoZk5r+zlncyCRnaunfvuIGH8kUOezbg2wg7si0mzBtzt3y47Rfb1YXHBKEMg7apbJDONamEUHprRlc5eaUM7qSFQDdyXsOm5DTJx0W0eJ93jRRPQK2lDLMA7CMeAqC69nQCbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYH4w+61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYH4w+61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E2EC4CEF5;
	Wed, 17 Sep 2025 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112858;
	bh=woMMoMNGbFUL9PhdERZ9V0y49qWDp43dgn5OTsxKh9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYH4w+61s85mm7zpPGw4DhSMMtpPodzZBC0dpMLgqzkRU4fZg8+jFICEYe4i6Ndp0
	 irE/Ei6eNmrzHW3Y9wOPQhgfryX9Pn732xAbcJI6pTOtfm+Pe6VhhKB18/CktNcMhT
	 STnlkAQIzT0MJ/Pn9RgEJ3ww9K00MYbtNXSg9bos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Imre Deak <imre.deak@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 096/189] drm/amd/display: Disable DPCD Probe Quirk
Date: Wed, 17 Sep 2025 14:33:26 +0200
Message-ID: <20250917123354.201932085@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit f5c32370dba668c171c73684f489a3ea0b9503c5 upstream.

Disable dpcd probe quirk to native aux.

Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4500
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250904191351.746707-1-Jerry.Zuo@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c5f4fb40584ee591da9fa090c6f265d11cbb1acf)
Cc: stable@vger.kernel.org # 6.16.y: 5281cbe0b55a
Cc: stable@vger.kernel.org # 6.16.y: 0b4aa85e8981
Cc: stable@vger.kernel.org # 6.16.y: b87ed522b364
Cc: stable@vger.kernel.org # 6.16.y
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -809,6 +809,7 @@ void amdgpu_dm_initialize_dp_connector(s
 	drm_dp_aux_init(&aconnector->dm_dp_aux.aux);
 	drm_dp_cec_register_connector(&aconnector->dm_dp_aux.aux,
 				      &aconnector->base);
+	drm_dp_dpcd_set_probe(&aconnector->dm_dp_aux.aux, false);
 
 	if (aconnector->base.connector_type == DRM_MODE_CONNECTOR_eDP)
 		return;


