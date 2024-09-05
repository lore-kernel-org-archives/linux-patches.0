Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D0B18D65E;
	Thu,  5 Sep 2024 09:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530192; cv=none; b=GDvO+86mj1Fn03IPpE7PHies1rhlMadVofm27QfmrvftJDS4q4N0F2qXKk8TbwL22gIzhQFb+HZ7ePMGT02ae6vaej5e+3GZGyZVpidtol+vcNjlUTUFejTKLDtLrUuXwn96r6Wdy1hvS9lC6YSXdOJOlDKtOMD7o8QUSKunqwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530192; c=relaxed/simple;
	bh=xDYgB/eo7c4acBTud7kpcRbDRwQol14OedTPFcQLMxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8fSLD5gHz6DuA0PKZRf4kzfXbbyc9e2ux5stSnF+ZbANZdSqY3HICGaoGM3ZwwMHWlRggbDGgsSocL9os+sZbbuiKmYZKYdYbisENe0fwTuTuHAetkAE1PWL7U80ly03E+eOV7aNmjrreSN2S+CzPbFhjQHMI5/HxRCs63rrTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iunUYR6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iunUYR6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC995C4CEC3;
	Thu,  5 Sep 2024 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530192;
	bh=xDYgB/eo7c4acBTud7kpcRbDRwQol14OedTPFcQLMxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iunUYR6Xn+bbSKKtKJq7EzOx03uDN0EqIk4xNfCr811HmsWSBlvtDpkMN1DPqhaR0
	 CPuKWEfsYwUIjf/dZ+HPgNxZ1C27RIi7y61F1ZBSMUpJAMC1AY2mIhHRZtZt3zmrWH
	 8kUJunCGP7y+tv9/BCAe7iXvhSBTYJjAgNxqmIYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/132] drm/amd/pm: check specific index for aldebaran
Date: Thu,  5 Sep 2024 11:41:09 +0200
Message-ID: <20240905093725.439537388@linuxfoundation.org>
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
index 5afd03e42bbf..ded8952d9849 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1931,7 +1931,8 @@ static int aldebaran_mode2_reset(struct smu_context *smu)
 
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



