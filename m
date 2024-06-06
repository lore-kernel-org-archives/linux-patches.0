Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1A198A16;
	Thu,  6 Jun 2024 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683052; cv=none; b=d85ylXsbtw2IDIESqJXNYELyDVKsWptT6+3Rdd0nvY+qSjHsTMfXp+7n7YF0rGuVH6dHvnyDaueN0ssmxDjIa4XRrR94awpcWxXUXYgtiIJepR2Z/lLSuOZNoQYhKmgRz8Mz3y9yVa/L4MmbBnc6pji4G+Nl40sx6+LdoRiIm6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683052; c=relaxed/simple;
	bh=9cQPr4ldOj7AAzTSDxDSCFrHiaDN1QznG7w83BbCaDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jq9sZs4peWQ16Uox1myP0tqGgJ9efNHX5DMkw6Skt5FgiG7SPP8IZKBBQ1ftxgw0NcYsiZJpRQOW8GscPdl9AhmvGghIoST6lHSJ+OsEue/RHU20X1nYksEmn+UNgLCpk0HrmTbb6DPsa3xyrPgz/5/aa38Kp49zr6F2DFfvJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSwPER52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSwPER52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C49C4AF08;
	Thu,  6 Jun 2024 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683052;
	bh=9cQPr4ldOj7AAzTSDxDSCFrHiaDN1QznG7w83BbCaDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSwPER52Ldfzj0ePl6te6AvMLJ/P1HOBRXKwd5gqnE8CqOS8QyspKWpN7NpY8phnX
	 xXMTZt1y311Rrv25NoRTwtLvxZJe7MoDya2dozUE3LNG+TuNSYhLHK5e01YBSAKS+E
	 pttYFuWi+8rzdj84LISdFGvyij6cFv21wLdudcQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Tyler Schneider <tyler.schneider@amd.com>
Subject: [PATCH 6.9 294/374] drm/amd/display: Enable colorspace property for MST connectors
Date: Thu,  6 Jun 2024 16:04:33 +0200
Message-ID: <20240606131701.725931085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8195979d2dd995d60c2663adf54c69c1bf4eadd1 ]

MST colorspace property support was disabled due to a series of warnings
that came up when the device was plugged in since the properties weren't
made at device creation. Create the properties in advance instead.

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Fixes: 69a959610229 ("drm/amd/display: Temporary Disable MST DP Colorspace Property").
Reported-and-tested-by: Tyler Schneider <tyler.schneider@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3353
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index cb31a699c6622..1a269099f19f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -613,6 +613,9 @@ dm_dp_add_mst_connector(struct drm_dp_mst_topology_mgr *mgr,
 		&connector->base,
 		dev->mode_config.tile_property,
 		0);
+	connector->colorspace_property = master->base.colorspace_property;
+	if (connector->colorspace_property)
+		drm_connector_attach_colorspace_property(connector);
 
 	drm_connector_set_path_property(connector, pathprop);
 
-- 
2.43.0



