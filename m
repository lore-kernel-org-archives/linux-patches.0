Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108462580E4;
	Tue, 25 Mar 2025 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906030; cv=none; b=bQ7pxABqsU8DmXWIUEEtdl5WqZkKDXF3lpwJBfpvZDwgS+WfRwlGX0cfIgwm5pnC7sx1MOSppSXtRj9NHB4yB/8kIgHj1mmk2keGVKMYVBG80qLQNU3PWAnf3WElsQKBtJ+ttkUAkjvZQ80X0NKGJ6h75AJIuYSlohDuxm4aDAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906030; c=relaxed/simple;
	bh=r2KiH2BD3E2+HuyiR7ZzLGPF3LAJlQ7vcCnYk2rTReY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3pYjHEDhUgREXM+FOFzrzoFn/PZrC5DYRWG01fqCywAh71Q00uMPedTAUICDV+scWjWBOYh7IDxfvuKET0Giu3JnAGRXHrayg7ypuzsByjazLtUHVkVC1RTZizecHDhbXRvwdFjlEaU9qjn1Rmz1TGmOB51aWIv85dh03F5fXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta2O3su8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta2O3su8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A8AC4CEE4;
	Tue, 25 Mar 2025 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906029;
	bh=r2KiH2BD3E2+HuyiR7ZzLGPF3LAJlQ7vcCnYk2rTReY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta2O3su8zk6JEh0AfUCiDZNZ8r3Kp74TL7fR5Un+ql2PNREWaxZmWmGF7+lG8A0yx
	 EtrKjseK4asOY1rUcVoOVj+B8WtsGBvVF53mLQ0WWqFhLSu1N01r/Sg8k5kG/GtXjP
	 SScwUl23GALVUb2TIvMZ38gE0O9sOZcl2XJZUdvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Yilin Chen <Yilin.Chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 097/119] drm/amd/display: Fix message for support_edp0_on_dp1
Date: Tue, 25 Mar 2025 08:22:35 -0400
Message-ID: <20250325122151.538742655@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yilin Chen <Yilin.Chen@amd.com>

commit 35f0f9f421390f66cb062f4d79f4924af5f55b04 upstream.

[WHY]
The info message was wrong when support_edp0_on_dp1 is enabled

[HOW]
Use correct info message for support_edp0_on_dp1

Fixes: f6d17270d18a ("drm/amd/display: add a quirk to enable eDP0 on DP1")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Yilin Chen <Yilin.Chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79538e6365c99d7b1c3e560d1ea8d11ef8313465)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1744,7 +1744,7 @@ static void retrieve_dmi_info(struct amd
 	}
 	if (quirk_entries.support_edp0_on_dp1) {
 		init_data->flags.support_edp0_on_dp1 = true;
-		drm_info(dev, "aux_hpd_discon_quirk attached\n");
+		drm_info(dev, "support_edp0_on_dp1 attached\n");
 	}
 }
 


