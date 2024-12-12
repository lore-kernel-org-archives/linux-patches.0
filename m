Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365B020C495;
	Thu, 12 Dec 2024 12:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734005845; cv=none; b=a5GkFYn4/S0sFR/v87unFGT3iOE4W6W3noggKEtQTExdH2mmM+gBF51mmujXPxI0t6xTu+NixiqfCj2ub0xSEeX/jYVfiFpCQ06bcmlUOuSyZoRWYCQTxZO1aIckTmnPIEr+wG0kDWJJK1ZHRlc4DzkoDzOM7njDNUx3v0trHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734005845; c=relaxed/simple;
	bh=UIM6zMna/s3NSzkCEg6xzfrVqD4UMcFm3qN3oRpS6Yg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=lPe0C3b8oCnigdhR96kI01aQEfWysVgBBzxhs2yExTRw24wtuygNMkqxvwXz7I0YWe6OEuW6RKntr+xTmBI+JRQE8t/GmMxH2ggSm9rT4KF7Kavu+uhOH6nE7AK8yZyODLakWrUyJxYaiPxORbBAqe7VhiAYmLc15zXikBQxrH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kt/nNy29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kt/nNy29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FD5C4CECE;
	Thu, 12 Dec 2024 12:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734005844;
	bh=UIM6zMna/s3NSzkCEg6xzfrVqD4UMcFm3qN3oRpS6Yg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Kt/nNy291C7cMxRdPH44FBbb1XCVIYsEoC5TgY+SRMLXcl1+ugit5Lwubvt/y5sP9
	 BnF3eN0HNuOZwqOvja8ok/er5PKoKHj2q6HOpxJ9f7m06zryKuEEfPlCRe/fnPvGhH
	 RaKwmuocWbOIuNK8x55jMpueDjEX/WqZGmgiY9BU=
Subject: Patch "[PATCH 6.1.y] drm/amd/display: Don't refer to dc_sink in is_dsc_need_re_compute" has been added to the 5.4-stable tree
To: Jerry.Zuo@amd.com,Rodrigo.Siqueira@amd.com,airlied@gmail.com,alexander.deucher@amd.com,amd-gfx@lists.freedesktop.org,christian.koenig@amd.com,daniel.wheeler@amd.com,daniel@ffwll.ch,dri-devel@lists.freedesktop.org,gregkh@linuxfoundation.org,harry.wentland@amd.com,jerry.zuo@amd.com,jianqi.ren.cn@windriver.com,patches@lists.linux.dev,sunpeng.li@amd.com,wayne.lin@amd.com,zaeem.mohamed@amd.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 12 Dec 2024 13:17:19 +0100
In-Reply-To: <20241211101544.2121147-1-jianqi.ren.cn@windriver.com>
Message-ID: <2024121217-rephrase-doctrine-7415@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    [PATCH 6.1.y] drm/amd/display: Don't refer to dc_sink in is_dsc_need_re_compute

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     drm-amd-display-don-t-refer-to-dc_sink-in-is_dsc_need_re_compute.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From jianqi.ren.cn@windriver.com  Thu Dec 12 13:11:21 2024
From: <jianqi.ren.cn@windriver.com>
Date: Wed, 11 Dec 2024 18:15:44 +0800
Subject: [PATCH 6.1.y] drm/amd/display: Don't refer to dc_sink in is_dsc_need_re_compute
To: <wayne.lin@amd.com>, <gregkh@linuxfoundation.org>
Cc: <patches@lists.linux.dev>, <jerry.zuo@amd.com>, <zaeem.mohamed@amd.com>, <daniel.wheeler@amd.com>, <alexander.deucher@amd.com>, <stable@vger.kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <christian.koenig@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <Jerry.Zuo@amd.com>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20241211101544.2121147-1-jianqi.ren.cn@windriver.com>


From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit fcf6a49d79923a234844b8efe830a61f3f0584e4 ]

[Why]
When unplug one of monitors connected after mst hub, encounter null pointer dereference.

It's due to dc_sink get released immediately in early_unregister() or detect_ctx(). When
commit new state which directly referring to info stored in dc_sink will cause null pointer
dereference.

[how]
Remove redundant checking condition. Relevant condition should already be covered by checking
if dsc_aux is null or not. Also reset dsc_aux to NULL when the connector is disconnected.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 1acef5f3838f..a1619f4569cf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -183,6 +183,8 @@ amdgpu_dm_mst_connector_early_unregister(struct drm_connector *connector)
 		dc_sink_release(dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 	}
 
 	aconnector->mst_status = MST_STATUS_DEFAULT;
@@ -487,6 +489,8 @@ dm_dp_mst_detect(struct drm_connector *connector,
 		dc_sink_release(aconnector->dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			MST_REMOTE_EDID | MST_ALLOCATE_NEW_PAYLOAD | MST_CLEAR_ALLOCATED_PAYLOAD,
-- 
2.25.1



Patches currently in stable-queue which might be from jianqi.ren.cn@windriver.com are

queue-5.4/drm-amd-display-don-t-refer-to-dc_sink-in-is_dsc_need_re_compute.patch
