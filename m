Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E788192D73;
	Thu,  5 Sep 2024 09:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530254; cv=none; b=EM1giUmDQ7hUfeaI7ZAGksRIDtM6CRQWevS6ukZ/nzU3sGiIHgGW1bhQUDv019VwRdX/X/S0in7vPm6ERuG5lD/Xa4O9I97PcI3mhZ8rj+J16EJ87jOhEcF4B4xMxt7LFHebqeMDv15/XE8a3S1Jq5z04PDfJuQuyg9R69PArGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530254; c=relaxed/simple;
	bh=AvvpfeMIoGkm5Sn+/34q+yoeN5S0INUZjUkaEDKxdY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVcstacgRACNVPBTB5nRdF/dYg5kQlCI5ZXGqBfUi2RGsuZ2VxsFrfZQTHRC1IMU2+AgT1sgOr5uSaXi12DcBMxyYBwu291gUwt+HSwOP8lhXomBF33iPO8R4GqYwXDcRuUoO5u1Ko6DB4YHJIDNQArIYlW5+B0ApHpteCO/Xgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpquiuMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpquiuMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000D5C4CEC3;
	Thu,  5 Sep 2024 09:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530254;
	bh=AvvpfeMIoGkm5Sn+/34q+yoeN5S0INUZjUkaEDKxdY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpquiuMCWLKBzW7Fo2mShSnaycz0M74ioV/l7ojH8Zlm0/ahczVm+p8IPyCYHpwfv
	 PGPTSeTeNJaQamf7V/BGULIN/2eRlStKWSdPiz8wcCu94ocpPqldgxoBC26Q9qXABV
	 8o+GXi7a9nFeIeAZDnL8MHQhhVkfnY4pett9IMZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/132] drm/amd/display: Fix Coverity INTEGER_OVERFLOW within decide_fallback_link_setting_max_bw_policy
Date: Thu,  5 Sep 2024 11:40:47 +0200
Message-ID: <20240905093724.590934135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 83c0c8361347cf43937348e8ca0a487679c003ae ]

[Why]
For addtion (uint8_t) variable + constant 1,
coverity generates message below:
Truncation due to cast operation on "cur_idx + 1" from
32 to 8 bits.

Then Coverity assume result is 32 bits value be saved into
8 bits variable. When result is used as index to access
array, Coverity suspects index invalid.

[How]
Change varaible type to uint32_t.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 9a0beaf601f8..16f4865e4246 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -528,7 +528,7 @@ static bool decide_fallback_link_setting_max_bw_policy(
 		struct dc_link_settings *cur,
 		enum link_training_result training_result)
 {
-	uint8_t cur_idx = 0, next_idx;
+	uint32_t cur_idx = 0, next_idx;
 	bool found = false;
 
 	if (training_result == LINK_TRAINING_ABORT)
-- 
2.43.0



