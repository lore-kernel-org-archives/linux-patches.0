Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496961922CC;
	Thu,  5 Sep 2024 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530664; cv=none; b=SEhFX3ekuXh70tFv7UhLp4P7gDEDtkNw3cTWiO6q/AxpDYpPYG6f5PPGes5pgSZ8KH/WOF9dJ5cyYJv4DSH45UShFuVZJ7k2s8ysUcWj6zvbwMTZosT2QuoBoUECyLrLZZ6RMDp1EjI1Awe8XFv3k+WVnaRlX9ctwDiSZwseM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530664; c=relaxed/simple;
	bh=8I7p9Byg2pKB2AG6jl/p45AjYCw5Sy9/n052J3grAUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh2KtipLM1Xnn0UCP+NjPEofr2c4/suOzCmYkD8P5zuB95oW4xHaBUfkcPGX5OIR/j8Gn/LiPpdmOv6GJi9D64e3GRSyK+YRgyM3bYub5Ni/2fKHllRRKUUVATAlKwh599C7QvPr2o0qTu9RTlXM3P7LAWOC4wmfCr7yOFxtzFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRMujY6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRMujY6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F9CC4CEC3;
	Thu,  5 Sep 2024 10:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530664;
	bh=8I7p9Byg2pKB2AG6jl/p45AjYCw5Sy9/n052J3grAUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRMujY6Pfsr3t+Q0nGnTfH7cHkHmkM13egkLoBPFYbCWJmCnrpfy3eNGFX+qhO3B8
	 GypMMJk4+Jf5oW8KBg/D2yl7asvOkZFQx2IHtlVITWrKqx4kqzmmNa6KLHdJ8XUYym
	 nizsBPEbRFRoCJXH2iyKHuWmPjEljDi7SViFpDUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/101] drm/amd/pm: check specific index for aldebaran
Date: Thu,  5 Sep 2024 11:41:35 +0200
Message-ID: <20240905093718.605873085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 0ce8ef2639c112ae203c985b758389e378630aac ]

Check for specific indexes that may be invalid values.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index cd8b0ab0112a..c79bff02a31a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1939,7 +1939,8 @@ static int aldebaran_mode2_reset(struct smu_context *smu)
 
 	index = smu_cmn_to_asic_specific_index(smu, CMN2ASIC_MAPPING_MSG,
 						SMU_MSG_GfxDeviceDriverReset);
-
+	if (index < 0 )
+		return -EINVAL;
 	mutex_lock(&smu->message_lock);
 	if (smu_version >= 0x00441400) {
 		ret = smu_cmn_send_msg_without_waiting(smu, (uint16_t)index, SMU_RESET_MODE_2);
-- 
2.43.0



