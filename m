Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC34A7DA7D;
	Thu, 15 Aug 2024 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730348; cv=none; b=Vp3duf6ATFGBkxxRfDdphyaDM0/2LQ2wdmvZAURDawYyYQnHOI/+3VDAA89XIXGgQM8lCfeN8sAGKySWSmiXFV8fBCf0IsqZ2kr3mfyvpeBeTG01hW8UEI40J6bOHP9R1AL+O4rlkP3XZo/nBnOJjbTtPijZ5tGG7GtjGrdnNYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730348; c=relaxed/simple;
	bh=ddUYUdbAQJV+LiwHjDXRaHW4wWUBUHTg26cNh6/OV54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN0DdDcV+u1zYOHbM11VSwqyNlJg8JdSG7Yyp1C9qSSsh3f55uhqV75bl+PDUNLbV4gv1CbnCf2zJ9B6SRmIF4mvUDlUsE818aXo5LaISUo68RaLQzroIsfSfw2VXDF8Wm9ZwUQ3MM4Syx2JU01Q8a/EpkbuvqsWfUWgeao3ST8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0doLod7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0doLod7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EC4C32786;
	Thu, 15 Aug 2024 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730348;
	bh=ddUYUdbAQJV+LiwHjDXRaHW4wWUBUHTg26cNh6/OV54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0doLod7VntVmqvhPq8C4uolhAjo61fCElx0I0zNXbhaWC2RrmlGFjjvdHG7bFx7Jl
	 q1hgY9lbMibnPEJpXmBW9jxBscakSEG4YhEdxp+QppMXsrDU/4RHGVtdtCb0LshxT3
	 EAhkLQnti5+MrKUcF59ofjOC/+CZMf6+xjWI5vqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 381/484] drm/amd/display: Add null checker before passing variables
Date: Thu, 15 Aug 2024 15:23:59 +0200
Message-ID: <20240815131956.163090443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8092aa3ab8f7b737a34b71f91492c676a843043a ]

Checks null pointer before passing variables to functions.

This fixes 3 NULL_RETURNS issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b821abb56ac3b..333be05418935 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2431,7 +2431,8 @@ static int dm_suspend(void *handle)
 
 		dm->cached_dc_state = dc_copy_state(dm->dc->current_state);
 
-		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		if (dm->cached_dc_state)
+			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 
@@ -6884,7 +6885,8 @@ static void create_eml_sink(struct amdgpu_dm_connector *aconnector)
 		aconnector->dc_sink = aconnector->dc_link->local_sink ?
 		aconnector->dc_link->local_sink :
 		aconnector->dc_em_sink;
-		dc_sink_retain(aconnector->dc_sink);
+		if (aconnector->dc_sink)
+			dc_sink_retain(aconnector->dc_sink);
 	}
 }
 
@@ -8218,7 +8220,8 @@ static int amdgpu_dm_connector_get_modes(struct drm_connector *connector)
 				drm_add_modes_noedid(connector, 640, 480);
 	} else {
 		amdgpu_dm_connector_ddc_get_modes(connector, edid);
-		amdgpu_dm_connector_add_common_modes(encoder, connector);
+		if (encoder)
+			amdgpu_dm_connector_add_common_modes(encoder, connector);
 		amdgpu_dm_connector_add_freesync_modes(connector, edid);
 	}
 	amdgpu_dm_fbc_init(connector);
-- 
2.43.0



