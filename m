Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E8D22F14;
	Sat,  3 Feb 2024 04:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933920; cv=none; b=f65UAN+D5OYRXRyu5s+e1iYc2sXVqTzl3ctuksy2hmKwyyRmyf3vn6ybMR/y7geDjZ1p8N3c0RUDuogtdrcnwTx9iRXRiyjZV3myK1K9kY8G5DkEm8V46suNv8BoLC2f+MbDU4bkM/Qs63UZZpEQywOXnTTB/4bG6r1y7gWViy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933920; c=relaxed/simple;
	bh=h/7cu8GNBa2y2afzukx59fGSrGx/HEig1kEjjw89V7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH9ICETlcRuXdlWcif1nTn4B5W9+Fd3qX9cQ33EuLj19URrjmM++di7HpSXKZ9qY/vCafvwTY7j6Pf/WdbCIYr0sl97Z1qm0exEeIj6c8Ntc0F2on3rbijoQSywcZiGvlPn7zv2Pc3aoz+v2Hh4vNaSuSUkd56XWmqarbvD1x0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nb0R7YTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nb0R7YTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C756CC433F1;
	Sat,  3 Feb 2024 04:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933919;
	bh=h/7cu8GNBa2y2afzukx59fGSrGx/HEig1kEjjw89V7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb0R7YTE7r/6JLH/coqosNHGQ2+epz5My11y+IIgEbPm/8w3+FYwvgp6YxHqB82Nr
	 UERs6RI1NfrD6u9jj9rPh2TiMqVwk6aRkWnScNkbhVgX05QsmJ2DrJn8NMJ78q0yf/
	 DADIManyaIQO3/gLUAbSlZdT5DittJixgUUZiHWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 274/353] Revert "drm/amd/display: Fix conversions between bytes and KB"
Date: Fri,  2 Feb 2024 20:06:32 -0800
Message-ID: <20240203035412.430120166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Daniel Miess <daniel.miess@amd.com>

[ Upstream commit bf282eb92b84709d99186ad5940b9997eb3c1ff2 ]

This reverts commit d0f639c5869399bf6dde4d694d5f8c0ab8c0ec46.

The previous commit causes failure to light up for 1080p
eDP + 8k HDMI panel combo.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 62ce95bac8f2..9be5ebf3a8c0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -6229,7 +6229,7 @@ static void set_calculate_prefetch_schedule_params(struct display_mode_lib_st *m
 				CalculatePrefetchSchedule_params->GPUVMEnable = mode_lib->ms.cache_display_cfg.plane.GPUVMEnable;
 				CalculatePrefetchSchedule_params->HostVMEnable = mode_lib->ms.cache_display_cfg.plane.HostVMEnable;
 				CalculatePrefetchSchedule_params->HostVMMaxNonCachedPageTableLevels = mode_lib->ms.cache_display_cfg.plane.HostVMMaxPageTableLevels;
-				CalculatePrefetchSchedule_params->HostVMMinPageSize = mode_lib->ms.soc.hostvm_min_page_size_kbytes;
+				CalculatePrefetchSchedule_params->HostVMMinPageSize = mode_lib->ms.soc.hostvm_min_page_size_kbytes * 1024;
 				CalculatePrefetchSchedule_params->DynamicMetadataEnable = mode_lib->ms.cache_display_cfg.plane.DynamicMetadataEnable[k];
 				CalculatePrefetchSchedule_params->DynamicMetadataVMEnabled = mode_lib->ms.ip.dynamic_metadata_vm_enabled;
 				CalculatePrefetchSchedule_params->DynamicMetadataLinesBeforeActiveRequired = mode_lib->ms.cache_display_cfg.plane.DynamicMetadataLinesBeforeActiveRequired[k];
-- 
2.43.0



