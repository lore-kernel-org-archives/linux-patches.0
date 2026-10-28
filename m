Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213841;
	b=zFv2LchYZED8ZXNnRMLMmahdA77WSGk+3IA4Dlu88LSmCZNOmjXNAds6EECR0FlCWPVt
	 iQ8Apdcw6QKWndFXSFdAoiys26EkRSFBZ0S0AsX3WnRkObJDee9e9uzBMc1xCBYJwXtiO
	 XMBYvxknEdZJfL2GYMXUpHIzAnl0Sl9oJyofQTNeFJUUT3G0tFkMMT49vGWZmmGEKaixP
	 V2hcFcmdmtLD5POk0jlg1zV16B6lGliuhhFyNrDX1pH198SN8m8znCPKLo8aiucPzLoaR
	 aWZSwUHsCsWimCQqpBJhu5sPQZYIC5REeNFDYFRRJ6Yp8cc6+tF50uPayxcF5YIEqzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/EWbGidE1sXB7pPo6UPom1JHXdQkPP/nMoaBxxiokQA=;
	b=X+7DQel9RaJE3AczXWqftBmLHKgF1FIU87K1/oDVwWwG94r18+Dmy1ytuACmFyRLheMD
	 tVfEEWe/+WebJ8FnK0UGs70NwmeFOzH6poRBKhcyjvVAy56CDpPfUYObhNBChWQx1vy/l
	 /9kn2uc/U0oiJzMHNUt5TV6m9alyv1fKc1xxQxcjzAoT6RFmYDgiFcJ7C8g8g5FdOp2kM
	 k+WGr9ncOuO2UCDrBVZCAJyeSHVSiYkXs4sdb3wobc3RgGia9UI4r4dhS16LdP285G9C0
	 hKsOFXgyNwsdY2AWSz3+28v2vXmAvwrsEd+54xa/LV+AuYLZZnWlXJuz0UliENpyqLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IRKebXbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37278606A31A;
	Wed, 28 Oct 2026 18:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IRKebXbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C34D1F01825;
	Wed, 28 Oct 2026 18:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213841;
	bh=/EWbGidE1sXB7pPo6UPom1JHXdQkPP/nMoaBxxiokQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRKebXbkgq8DoGdVfTjWPzQtfVBzoDa4rP4AcOxFsh3/MZwmyrEyBNW9+0IySQdgK
	 0aVgsrG4gISI3t59aDhdblD1x8vG12+DUih1USA8hdO8+1H4PCIe2gwntQ5jczO8tM
	 vZeVKt5JUulfTujl11qTid0UAliDuAUfvEYaPK7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0648/1887] drm/amd/display: Check index for aux_rd_interval before using
Date: Wed, 28 Oct 2026 17:45:44 +0100
Message-ID: <20261028170514.157371184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 9ba2ea6337b4f159aecb177555a6a81da92d302e ]

aux_rd_interval has size of 7 and should be checked.

This fixes 3 OVERRUN and 1 INTEGER_OVERFLOW issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 1d3d9a82c4637..717e36172a718 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1676,10 +1676,10 @@ static enum dc_status configure_lttpr_mode_non_transparent(
 			/* Driver does not need to train the first hop. Skip DPCD read and clear
 			 * AUX_RD_INTERVAL for DPTX-to-DPIA hop.
 			 */
-			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA)
+			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA && repeater_cnt > 0 && repeater_cnt < MAX_REPEATER_CNT)
 				link->dpcd_caps.lttpr_caps.aux_rd_interval[--repeater_cnt] = 0;
 
-			for (repeater_id = repeater_cnt; repeater_id > 0; repeater_id--) {
+			for (repeater_id = repeater_cnt; repeater_id > 0 && repeater_id < MAX_REPEATER_CNT; repeater_id--) {
 				aux_interval_address = DP_TRAINING_AUX_RD_INTERVAL_PHY_REPEATER1 +
 							((DP_REPEATER_CONFIGURATION_AND_STATUS_SIZE) * (repeater_id - 1));
 				core_link_read_dpcd(
-- 
2.53.0



