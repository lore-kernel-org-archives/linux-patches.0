Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6591990C2;
	Thu,  5 Sep 2024 09:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529667; cv=none; b=eV5XByCivzcOzlKrzwv8arKA5DQP8jA4oD+zcWeiwuELr+kirxX7lKXR7PtoS1yDFU56NuhlBRG/vMYJe+KIgTj44hL2ovJgcrKpYqgyzSonk3oGVyMLP/sLORAXXO863SGLX7eHfidmtGJUI0WBq47sGyc+iEU1bfkU0Uwzy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529667; c=relaxed/simple;
	bh=AksDRwEnjWzrErp1/CkeRbyHidsdiIKWgCS0/guosik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHcd0DaVMzPFB4ixad+x4TdALG7GbohlDYSfqCErI2yxt8zF/xSp5Ef2Rt1Sk709zde+lKnNz7DUouIo0tGkHdgSkSdxJ1k22pL6+5Fqex8WnMs2QA/jfmhwLH5cGYpxyITIBACN9pMXT5Vx50GYDFJZDqAXuFPYEOYD5xF4hTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvivXn+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvivXn+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1BCC4CEC3;
	Thu,  5 Sep 2024 09:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529667;
	bh=AksDRwEnjWzrErp1/CkeRbyHidsdiIKWgCS0/guosik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvivXn+oOQKA83Zq3W0tZo4vNnmn12Fi0eagIlfrNOB/xYAhCZ+deZxqebh2ACC9q
	 Gk1RBsEXSLrrnHZMT6N5ayp2OPxmMM2dHl9P1ogwYpAMl5zjKYWsh8TcnQSysTOULa
	 UWnqFvQrnW7zj3yX8edzKagx/oKYMdt/DY0X4ymY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 106/184] drm/amd/pm: check specific index for aldebaran
Date: Thu,  5 Sep 2024 11:40:19 +0200
Message-ID: <20240905093736.371965874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ce941fbb9cfb..a22eb6bbb05e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1886,7 +1886,8 @@ static int aldebaran_mode2_reset(struct smu_context *smu)
 
 	index = smu_cmn_to_asic_specific_index(smu, CMN2ASIC_MAPPING_MSG,
 						SMU_MSG_GfxDeviceDriverReset);
-
+	if (index < 0 )
+		return -EINVAL;
 	mutex_lock(&smu->message_lock);
 	if (smu->smc_fw_version >= 0x00441400) {
 		ret = smu_cmn_send_msg_without_waiting(smu, (uint16_t)index, SMU_RESET_MODE_2);
-- 
2.43.0



