Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8C41F7577;
	Tue, 17 Dec 2024 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456441; cv=none; b=I/fP0PNpofH5FL5lrhDezQfgXpUger7zs44BmcYLmsRLhfeM40/j9wDPb13CUa7K0LqjL+LvogCKGmi5Rhrzz8qRK6CK55Sq7EKhAANVI3KxfRw/STqSQragcjBQARnnhO7728rD45jzTA+sBqC3QaUTdXgEJ/bc7UveEncAHAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456441; c=relaxed/simple;
	bh=MgCMVRIxgButlAGM1jq4uzLK9G1lL2e8Yym2V1K6HLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dck5O1zD8BDKF8IdQH5Ib+2Geczp7aL0dnLfTilyKpvZ2lfAh0nmF6ulWK7NyW5MxavaGYL8vP2BItoqbYMBwerLGVOz3sEw3XcOp00zQoYGHSmEpNDCrhEG57AuO8wZ+en1fjlSuD9yqLLG+WaVkAIlj33GOb8OdhiX1+wqMag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCOvjQNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCOvjQNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512D7C4CEDD;
	Tue, 17 Dec 2024 17:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456441;
	bh=MgCMVRIxgButlAGM1jq4uzLK9G1lL2e8Yym2V1K6HLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCOvjQNPC/95o994thL+lxLEZnv9PnDWMzcBbzG/nAhuxBQxQOmTjESMluLYSFe86
	 bfNeL8+Z24Xd7+dSn9i/44Y8hvijejGjuN/I07zlV1CVbEfyLp265PVkT5I7mwYwPy
	 roHfsCaPq45z5helSVXIRXELRUuTrY3zpzIgXlq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 062/172] drm/amd/pm: Set SMU v13.0.7 default workload type
Date: Tue, 17 Dec 2024 18:06:58 +0100
Message-ID: <20241217170548.850313382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

commit 3912a78cf72eb45f8153a395162b08fef9c5ec3d upstream.

Set the default workload type to bootup type on smu v13.0.7.
This is because of the constraint on smu v13.0.7.
Gfx activity has an even higher set point on 3D fullscreen
mode than the one on bootup mode. This causes the 3D fullscreen
mode's performance is worse than the bootup mode's performance
for the lightweighted/medium workload. For the high workload,
the performance is the same between 3D fullscreen mode and bootup
mode.

v2: set the default workload in ASIC specific file

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2717,4 +2717,5 @@ void smu_v13_0_7_set_ppt_funcs(struct sm
 	smu->workload_map = smu_v13_0_7_workload_map;
 	smu->smc_driver_if_version = SMU13_0_7_DRIVER_IF_VERSION;
 	smu_v13_0_set_smu_mailbox_registers(smu);
+	smu->power_profile_mode = PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT;
 }


