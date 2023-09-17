Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3D36FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B70C433C8;
	Sun, 17 Sep 2023 19:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980388;
	bh=S8KM1Z+IhlTMHvCzMBsp73/plPCPlfIV44m8XavTalw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWQ1dD0v8YGVAA0qyQeF7U/SpQ7f7jDg2rtmKBq69IRC6G4rPEXP/HoGsCRW+nYgv
	 6l7ZsmSZ8gFeJAamqkajZq0jd+5IAcrLwbtsPhb9GdJwSM0hYxIBoTTpzREvEtF6zJ
	 l81xWSjL/OAkVG/Z1d6z7GuXebHCJM5sxJ+ZqQaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.5 178/285] drm/amd/display: Temporary Disable MST DP Colorspace Property
Date: Sun, 17 Sep 2023 21:12:58 +0200
Message-ID: <20230917191057.789210819@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <jerry.zuo@amd.com>

commit 69a959610229ec31b534eaa5f6ec75965f321bed upstream.

Create MST colorsapce property for downstream device would trigger
warning message "RIP: 0010:drm_mode_object_add+0x8e/0xa0 [drm]"

After driver is loaded and drm device is registered, create
dp colorspace property triggers warning storm at
WARN_ON(!dev->driver->load && dev->registered && !obj_free_cb);

Temporary disabling MST dp colorspace property for now.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7295,7 +7295,7 @@ void amdgpu_dm_connector_init_helper(str
 	if (connector_type == DRM_MODE_CONNECTOR_HDMIA) {
 		if (!drm_mode_create_hdmi_colorspace_property(&aconnector->base, supported_colorspaces))
 			drm_connector_attach_colorspace_property(&aconnector->base);
-	} else if (connector_type == DRM_MODE_CONNECTOR_DisplayPort ||
+	} else if ((connector_type == DRM_MODE_CONNECTOR_DisplayPort && !aconnector->mst_root) ||
 		   connector_type == DRM_MODE_CONNECTOR_eDP) {
 		if (!drm_mode_create_dp_colorspace_property(&aconnector->base, supported_colorspaces))
 			drm_connector_attach_colorspace_property(&aconnector->base);


