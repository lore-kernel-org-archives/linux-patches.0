Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB011D043E;
	Wed,  2 Oct 2024 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876609; cv=none; b=VWBBUnDBRw8fU6vT/EVkKHWDPVFjVC6edS5WElw29V5G3LwsekERFi6TolqMlnZPCe3BHmLHXcGb9w3GecW17RO7dcnjCZFkE61MN8u1K4FliQ5E812w5YGipAbfETgbJaA0TdXmi5+LOkLAqtLzvtbZaQUUBgaGihCvULgQegg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876609; c=relaxed/simple;
	bh=GnrRfY+fa8GwnrqX17Fu5n/l+f3JNCYqiEh72PDm2fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc34zZnPaSAlybgPdMCXinh8PgxteJOe07TpaJI/MoE5NT9tl+tkrDiYwmHLtOVfFXT7v4Ki/tsjtpIjYTb1jIXg59zFw40FhZSt/UJokvs3FktWfWpMegDpR81OWediU38vNy/kppsgvUDboUQrhjG078eKWHwB+anKfvbtaig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5l+1QPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5l+1QPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163EDC4CED2;
	Wed,  2 Oct 2024 13:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876609;
	bh=GnrRfY+fa8GwnrqX17Fu5n/l+f3JNCYqiEh72PDm2fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5l+1QPn5riE9slTgZkkZ+byRI0kfhDhyQtnfnQALQQ4N/Cw+ht4MEysoH21SuMPi
	 NvgppCFJhOGrVQ3iH3wAnLU9LEx/9/xAMCZaxZvelGzIsyOaEYJnWPtWVH5EyM+IY4
	 biPSQTY6Y41vdZpB/sLPJkTMoL7RwvxG4e9hmKG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <superm1@kernel.org>
Subject: [PATCH 6.11 503/695] drm/amdgpu/display: Fix a mistake in revert commit
Date: Wed,  2 Oct 2024 14:58:21 +0200
Message-ID: <20241002125842.557647995@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit 7745a1dee0a687044888179e6e7fcd6d704992a9 upstream.

[why]
It is to fix in try_disable_dsc() due to misrevert of
commit 338567d17627 ("drm/amd/display: Fix MST BW calculation Regression")

[How]
Fix restoring minimum compression bw by 'max_kbps', instead of native bw 'stream_kbps'

Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1072,7 +1072,7 @@ static int try_disable_dsc(struct drm_at
 			vars[next_index].bpp_x16 = 0;
 		} else {
 			DRM_DEBUG_DRIVER("MST_DSC index #%d, restore minimum compression\n", next_index);
-			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps, fec_overhead_multiplier_x1000);
+			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps, fec_overhead_multiplier_x1000);
 			ret = drm_dp_atomic_find_time_slots(state,
 							    params[next_index].port->mgr,
 							    params[next_index].port,


