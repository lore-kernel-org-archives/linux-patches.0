Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA0194C7A;
	Thu,  5 Sep 2024 09:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529671; cv=none; b=fDZfgmIQ9yNKFiC299LcEpUkkNVG9XF+P6ZFSBMIjgwTWR/KqHJA62PonCzmNqlhtGcGmq0KK0wIbqXX2q84xqZ5OFrEageOUXaq/FsoyMp6CIt0q0Un7l1CKMGwvOkKUdyEFqDvkdHDF+49nZkzScJq9QDH47pmTpZkEPiVT+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529671; c=relaxed/simple;
	bh=mxLuj+of4rTD2nefF9Xeiu7lI5s8PExlBPjEV/K72W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvTWZMtb48ZgyoIZJxRX0BYf0nM6IaKXxCdJVn7MJhDnI6mdD1Z/qxwd40mDPUe8tTjxo+Xw6aivjDoVV+m4jOLx/u+fECzL0Z/oYs2MU/0+2TNAXqF8+HH3GnzYShMnFr0Q40f0I9Kncd3f42n4M7F4SJDmHHF8R4+UBiU0Bm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebJu5DVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebJu5DVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16760C4CEC3;
	Thu,  5 Sep 2024 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529670;
	bh=mxLuj+of4rTD2nefF9Xeiu7lI5s8PExlBPjEV/K72W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebJu5DVxfYOyRXHKSDZRVvlRWjLdH+OmqSKevXNOprP4pWaZo9fe4jwkCpLSY4W88
	 OZ99bY6iDTqEMQVVLwewUFEirH8DirovEZgvFQHx9Km72aloorIkAE5KNbYYxFYqD1
	 0B48ZnuQVMr2ycDI/K4b+IN+JKUz0WNU7rq5CZu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 107/184] drm/amd/pm: check specific index for smu13
Date: Thu,  5 Sep 2024 11:40:20 +0200
Message-ID: <20240905093736.410554653@linuxfoundation.org>
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

[ Upstream commit a3ac9d1c9751f00026c2d98b802ec8a98626c3ed ]

Check for specific indexes that may be invalid values.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index 4d3eca2fc3f1..f4469d001d7c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -2333,6 +2333,8 @@ static int smu_v13_0_6_mode2_reset(struct smu_context *smu)
 
 	index = smu_cmn_to_asic_specific_index(smu, CMN2ASIC_MAPPING_MSG,
 					       SMU_MSG_GfxDeviceDriverReset);
+	if (index < 0)
+		return index;
 
 	mutex_lock(&smu->message_lock);
 
-- 
2.43.0



