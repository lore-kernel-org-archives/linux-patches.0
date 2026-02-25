Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F891FE45D;
	Wed, 25 Feb 2026 01:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983084; cv=none; b=DDxM1nUUM/sHTCX7JKfP0i4AQKkSVkiPDxIx7Z3BI9DvDZ5WowLQrUeq+poHNIdMY6vb9FV00bV++HwUuwQ/mn0epfjMcPwfz3gXlYUPuGczHKXWv0mifJn8Ajd6lu2+X63WFVh/Sm61fCevnyi8iLxPs8QqlMqh0SJx25fngMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983084; c=relaxed/simple;
	bh=wpVMExUPOGwFDuOFsdsDnbQI2WFUXTUs9zLDW67x9Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMmnx0kC3E1OlOH59Tkt8QwFWI9tRy5+Fn18riBpNaxBXIw61xva2apS8LrkLROfrbQgBZtN569wY8kkwnv28ooNT1TiPt2DzVXsPS9v0tDfLHkJ6RDB+znYdAjW/sfegYlzE8nmpl6G78YbG4cy7oJDoBVtn+KUephflFRe/Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7OgxWZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7OgxWZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1C0C116D0;
	Wed, 25 Feb 2026 01:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983084;
	bh=wpVMExUPOGwFDuOFsdsDnbQI2WFUXTUs9zLDW67x9Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7OgxWZrR8IbjMm83As9jPo4XkTYbWBt5YXw2jDmWrgXvbv3l23QitziPwsHPPwit
	 7GlYKLQiY9oMm9xD3JzZcvU72w8WVOBtDYWfQ2CaWm1wzyb0MA/M+GlK41Rq9o80rS
	 cLW9rpulrUSEHQZe0hxneBe0i1gnCoZNWwQv+H6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 245/781] drm/amd/display: Update dc_connection_dac_load to dc_connection_analog_load
Date: Tue, 24 Feb 2026 17:15:54 -0800
Message-ID: <20260225012405.716630638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 57c8690a84bec025a8bc22e5f867fd660c4a3e76 ]

Update to a more accurate name dc_connection_analog_load.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 0d89268d20c9 ("drm/amd/display: Don't repeat DAC load detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 2 +-
 drivers/gpu/drm/amd/display/dc/dc_types.h            | 2 +-
 drivers/gpu/drm/amd/display/dc/link/link_detection.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a8a59126b2d2b..b31bd6fa70181 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7434,7 +7434,7 @@ amdgpu_dm_connector_poll(struct amdgpu_dm_connector *aconnector, bool force)
 	 *
 	 * Only allow to poll such a connector again when forcing.
 	 */
-	if (!force && link->local_sink && link->type == dc_connection_dac_load)
+	if (!force && link->local_sink && link->type == dc_connection_analog_load)
 		return connector->status;
 
 	mutex_lock(&aconnector->hpd_lock);
diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index f46039f642034..3e63d7bda1661 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -354,7 +354,7 @@ enum dc_connection_type {
 	dc_connection_single,
 	dc_connection_mst_branch,
 	dc_connection_sst_branch,
-	dc_connection_dac_load
+	dc_connection_analog_load
 };
 
 struct dc_csc_adjustments {
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_detection.c b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
index 7fa6bc97a9193..4f48e7ea75110 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1176,7 +1176,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 				/* If we didn't do DAC load detection yet, do it now
 				 * to verify there really is a display connected.
 				 */
-				if (link->type != dc_connection_dac_load &&
+				if (link->type != dc_connection_analog_load &&
 					!link_detect_dac_load_detect(link)) {
 					if (prev_sink)
 						dc_sink_release(prev_sink);
@@ -1185,7 +1185,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 				}
 
 				DC_LOG_INFO("%s detected analog display without EDID\n", __func__);
-				link->type = dc_connection_dac_load;
+				link->type = dc_connection_analog_load;
 				sink->edid_caps.analog = true;
 				break;
 			}
@@ -1372,7 +1372,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
  * @link: DC link to evaluate (must support analog signalling).
  * @type: Updated with the detected connection type:
  *        dc_connection_single (analog via DDC),
- *        dc_connection_dac_load (via load-detect),
+ *        dc_connection_analog_load (via load-detect),
  *        or dc_connection_none.
  *
  * Return: true if detection completed.
@@ -1388,7 +1388,7 @@ static bool link_detect_analog(struct dc_link *link, enum dc_connection_type *ty
 	}
 
 	if (link_detect_dac_load_detect(link)) {
-		*type = dc_connection_dac_load;
+		*type = dc_connection_analog_load;
 		return true;
 	}
 
-- 
2.51.0



