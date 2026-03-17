Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF03EBF20;
	Tue, 17 Mar 2026 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765561; cv=none; b=fZbf6F+XftLurQLuSl+tqKy7MG1H6S7qOHlg+P/mzpKo9AzaUBBHDzkik2xRf9KbHLGuH06tVw3I36eZ/Bi3Hey16CjB6KxllKZ6uFJMZPQfN6nIoMBjBWKlmvG4NJR9rLK0v2l4LSm6B3fZqj5jT1PRXxmpEKVzJb+P+SdZdDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765561; c=relaxed/simple;
	bh=Lxf4Gqlbk2ATcI4J/JyGGOmgB7WiAyhNGg1oM8OZTBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXarIr8XNnCJHJUcMHbqYH0rONdI4o5P5SWAlqpRdrk8tzgTqGpn0cE5IZJKp0HPNoefDyFm4ZdZgKCsIil0Vd/4cyhyeF3VYBRFEVtRAdwr8p280/U1w5FLxt7HDatEszkn6oqbZdW/HxON+uHc7Wz9Alm/Smxfa6EO8FiRKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3C3+H5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3C3+H5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D18C2BC86;
	Tue, 17 Mar 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765561;
	bh=Lxf4Gqlbk2ATcI4J/JyGGOmgB7WiAyhNGg1oM8OZTBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3C3+H5uOCcfD168dGTYEeY8d5cn445Wc3cPfKiQq8k10bOWtC5DzD8tebzJTHfWk
	 uWrjEPIpAFH9jA7MWOP8l71JXaOKQfR6cZ2NfZtDJCR4JtrQOTUPVQ1w4s14Hl5BjM
	 xkH/7sLfi6YPRMmBdMF9/RMwfDVvTrmaYk4S4O3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 039/378] drm/amd/pm: add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v14
Date: Tue, 17 Mar 2026 17:29:56 +0100
Message-ID: <20260317163008.423362271@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 9d4837a26149355ffe3a1f80de80531eafdd3353 ]

add missing od setting PP_OD_FEATURE_ZERO_FAN_BIT for smu v14.0.2/14.0.3

Fixes: 9710b84e2a6a ("drm/amd/pm: add overdrive support on smu v14.0.2/3")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5018
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b5cf07d80bb16d1593579ccdb23f08ea4262c14)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index d7642d388bc38..fa535f43876b5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2413,7 +2413,8 @@ static int smu_v14_0_2_restore_user_od_settings(struct smu_context *smu)
 	user_od_table->OverDriveTable.FeatureCtrlMask = BIT(PP_OD_FEATURE_GFXCLK_BIT) |
 							BIT(PP_OD_FEATURE_UCLK_BIT) |
 							BIT(PP_OD_FEATURE_GFX_VF_CURVE_BIT) |
-							BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+							BIT(PP_OD_FEATURE_FAN_CURVE_BIT) |
+							BIT(PP_OD_FEATURE_ZERO_FAN_BIT);
 	res = smu_v14_0_2_upload_overdrive_table(smu, user_od_table);
 	user_od_table->OverDriveTable.FeatureCtrlMask = 0;
 	if (res == 0)
-- 
2.51.0



