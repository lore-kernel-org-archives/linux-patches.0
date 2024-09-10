Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA8191F9E;
	Tue, 10 Sep 2024 10:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963368; cv=none; b=G3NvreYiHh9H0oM6UEhY2xU8oHXnaFnZKXJ8Im3E2hiMBsoa+qCgzCcU6MliPW0WiQ6aW2SL2j+1DEUdapXlH2E4IPSQCtVWoMivJVOkUAvbeio+FTbPGilsBYmYZnC9nJyd1PX0jHyQJXxiJCbR4V31os6Cjw1ewLNlbf5XkVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963368; c=relaxed/simple;
	bh=mRIRoP3UL6azlO9FrkgG1bdUtkvbxDHa33Tma2Qagk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTqdxWboy1/VSSIjC+yKLYEHyO5C5Q19KdXtMXEsCuoIVbeceEuZzc8lizdX82ODVJxb3bZkbNLNVkJg6Z/kQL1gCN3IR2cJpi8hlNWB+gntzx0ETPnixjzaLFFiZqkjMQMsW5UCnaRiwcdCX6Qi045/Azk5cVaqkUsk3tug+PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4B93ke8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4B93ke8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A9C4CEC3;
	Tue, 10 Sep 2024 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963368;
	bh=mRIRoP3UL6azlO9FrkgG1bdUtkvbxDHa33Tma2Qagk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4B93ke86G9ZiHzVynLCcUkZgvU/V5IlXRNxY/LCN6uDmbUkdJffXTDFTYEg7z0MW
	 Npw7/KpwoyzN4nJnCsC3CcdodbMF0F7DWNznKgMQcH8AnKg4yAH8e/yxU7+7AcIhUZ
	 j67mEUhVwz/IGWwl6B6TCX9upq/MAO/7f6TwVf1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/214] drm/amd/pm: check specific index for aldebaran
Date: Tue, 10 Sep 2024 11:30:56 +0200
Message-ID: <20240910092600.165458308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0c6b864d00a..31846510c1a9 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1775,7 +1775,8 @@ static int aldebaran_mode2_reset(struct smu_context *smu)
 
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



