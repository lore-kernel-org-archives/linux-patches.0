Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017049;
	b=y/yB9DQZJplE6BNu7Gb6Ga3tvAm0rb016jX+uQLXy3JliPm5UxM2fW8S16W7utbPtS+r
	 CA33JWU5x7b4wpicfJSRisYvicw9JAdF4ZBtI8g8diq7v4gfilegbR6kBrOXcypnYGQot
	 tGRPi1MBnAiqDohd0kdd+BuRq/9TWkUBHAbpbAbA7tYgTS0L62KJp6ruEOYYljbTkp8kJ
	 jim1Kw6S4Mj/FAGNjbIueuT0GNePI4Tg93tPb46H6/i04rrAl8m0gH8WTckVSxLiogmDY
	 k32CuGqq4L8UARmpgMbB8xrL8h4uxyYXFIdbZnjDWjYi3pyuyZccIZSw+OeMg4C3gzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XPhsutl8LNdELLrbRkqfQ3AJb6BdN80+gH0887Ls+R8=;
	b=LpkQLSJgYkxEzym4ssg16haS1zLgNwZdB7Su4iiCcYmOmeWEaoM/vEhuDLPo5NrtohD6
	 FB1nWVNbrPqgaOZB+1swPZUbQvslDXIm4BhNKKOwUO6Kvn95f9u7OhnzaQRDWhBApHaKZ
	 jp0QE0mZjsvX+4WK4ahxcaotbsnyZGSzResKowdjK/VNrVEvQO9BhXCObPoOSgwAcWnzd
	 ENh0heTe0RTGMIs4eaV7HK2e43dyWELJ7OEuJ+32OHwTYh/blRAhGhyfy+M+R9SFoTwDr
	 zeocaiVCyMU3b8Z0DfvcjTCtuLeLvPg3+POnXQVcMA/w9zdVaKbMl/hbJtQcjT/RnLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ+YZZgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F51606A31C;
	Wed, 18 Nov 2026 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ+YZZgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335A41F000C8;
	Wed, 18 Nov 2026 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017049;
	bh=XPhsutl8LNdELLrbRkqfQ3AJb6BdN80+gH0887Ls+R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJ+YZZgB/gk3FzrrUQcdQnF3bCU6H6OHoT+NsU67+VJgAL0HKYkaQC5Iju6aFGjM5
	 FzxNj68WcYTPyMIS4N758XUcmE0E9Cdxj+ZELz9Oz/vGby6BH8esWZ6zvmjn2ieNbw
	 Z7KTlV327DVQrRXjXSNvJB8mOc/E/6xJYg6YjYCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0747/2651] drm/amd/display: Restore FreeSync VCP code check for HDMI/PCON sinks
Date: Wed, 18 Nov 2026 15:33:07 +0100
Message-ID: <20261118150314.772468062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <jerry.zuo@amd.com>

[ Upstream commit e4dca268eea60bcae566262daecc5e067799528d ]

[WHAT]
Folding the MCCS FreeSync checks into the do_mccs block dropped the
other half of the original condition: the check that clears
freesync_capable for HDMI or PCON-in-whitelist sinks that expose no
EDID FreeSync VCP code. That check does not depend on the MCCS caps
and must run regardless of do_mccs.

As a result, when do_mccs is false such a sink without a FreeSync VCP
code is still reported as FreeSync-capable.

[HOW]
Restore the VCP code check outside the do_mccs block so it is
evaluated whether or not MCCS caps were read.

Fixes: 115bf5ca318e ("drm/amd/display: Consult MCCS FreeSync cap only if requested & supported")
Reviewed-by: Roman Li <roman.li@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: George Zhang <george.zhang@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c
index c1f1809b7935a..bfcc8ad75295b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_connector.c
@@ -3975,6 +3975,12 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 			amdgpu_dm_connector->min_vfreq;
 	}
 
+	/* HDMI/PCON without an EDID FreeSync VCP code is not FreeSync-capable. */
+	if ((sink->sink_signal == SIGNAL_TYPE_HDMI_TYPE_A ||
+	     as_type == FREESYNC_TYPE_PCON_IN_WHITELIST) &&
+	    !sink->edid_caps.freesync_vcp_code)
+		freesync_capable = false;
+
 	/* Handle MCCS */
 	if (do_mccs) {
 		dm_helpers_read_mccs_caps(adev->dm.dc->ctx, amdgpu_dm_connector->dc_link, sink);
-- 
2.53.0



