Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935533F366;
	Wed,  3 Dec 2025 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777270; cv=none; b=dYLdzebwEJmlV7tnTQWNNLHlfIF+fwPFd8BmUc3dS7F7PMatuCfIWbufiG8mUsv3N5eC6rugE+/n3FoUXgVpaGq0UQBPh4TCPANaoTvNOTGlhrCeGpeSl701eEnxjKFYUTRDTnn+eaCxl6SEYxzOVom8fe8zuijbaybmp1Gmwww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777270; c=relaxed/simple;
	bh=ABeoAXc0kg0oqr6iq+uxa6WuRrByfqpF1HQE08isirI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkGBGiDvEFPkO1AcIwbQ1dDcY6hH2n5jUSgfKGO98TOHaq/daBGl8KH5AagVBrD45V/fErlwWKR+yOM0udAyCDfj+014yuEnD6GF7XSPCcxyTBLSdxrOJM0KE9G468ZQNJGKwF3RJuN5cBoPno96uMPqLtWWpAJlPw1txEA4Dbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEKe/i5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEKe/i5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F2AC2BC86;
	Wed,  3 Dec 2025 15:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777270;
	bh=ABeoAXc0kg0oqr6iq+uxa6WuRrByfqpF1HQE08isirI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEKe/i5Dg0AU5Qn/hUv1ei8+HY1JcdjTqsrnB0KolEhEJYQiHd5xnx89Rl0S5v9eq
	 FbL961g12hmwCHJjsJuGSOB9EklBg5QW6WsAyZaTyjDcIwiNzBtCsEximPjpI/kI7o
	 o26T5NrR0OCDIYREuMbEvipwZSl0xipJVvb9LbfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.17 133/146] drm/amd/display: Increase EDID read retries
Date: Wed,  3 Dec 2025 16:28:31 +0100
Message-ID: <20251203152351.339178859@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 8ea902361734c87b82122f9c17830f168ebfc65a upstream.

[WHY]
When monitor is still booting EDID read can fail while DPCD read
is successful.  In this case no EDID data will be returned, and this
could happen for a while.

[HOW]
Increase number of attempts to read EDID in dm_helpers_read_local_edid()
to 25.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4672
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a76d6f2c76c3abac519ba753e2723e6ffe8e461c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -996,8 +996,8 @@ enum dc_edid_status dm_helpers_read_loca
 	struct amdgpu_dm_connector *aconnector = link->priv;
 	struct drm_connector *connector = &aconnector->base;
 	struct i2c_adapter *ddc;
-	int retry = 3;
-	enum dc_edid_status edid_status;
+	int retry = 25;
+	enum dc_edid_status edid_status = EDID_NO_RESPONSE;
 	const struct drm_edid *drm_edid;
 	const struct edid *edid;
 
@@ -1027,7 +1027,7 @@ enum dc_edid_status dm_helpers_read_loca
 		}
 
 		if (!drm_edid)
-			return EDID_NO_RESPONSE;
+			continue;
 
 		edid = drm_edid_raw(drm_edid); // FIXME: Get rid of drm_edid_raw()
 		if (!edid ||
@@ -1045,7 +1045,7 @@ enum dc_edid_status dm_helpers_read_loca
 						&sink->dc_edid,
 						&sink->edid_caps);
 
-	} while (edid_status == EDID_BAD_CHECKSUM && --retry > 0);
+	} while ((edid_status == EDID_BAD_CHECKSUM || edid_status == EDID_NO_RESPONSE) && --retry > 0);
 
 	if (edid_status != EDID_OK)
 		DRM_ERROR("EDID err: %d, on connector: %s",


