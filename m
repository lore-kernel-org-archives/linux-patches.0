Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F3168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C182CC433D2;
	Mon,  8 May 2023 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539663;
	bh=lb0ED0QQcGOo041iin7sch07zo3hfLjBX0QC2vgAKDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k27tL4XfdJK3Ux1OPZhVM6/ZICxuq2Q6bWf3JvLZsuuURxyHGeLqm7aVQKZoCj8IN
	 drnecQOyMV/rxANlqi0xy1Ej2G5IwhuJIqsHrNYNRuUPPvQZxwX/Qrb7h4iEC8MDvY
	 J3xTrMG3CR8z0lEIk/CyO19NpL+PQ2PijR90tGwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Songping <yusongping@huawei.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 097/611] swsmu/amdgpu_smu: Fix the wrong if-condition
Date: Mon,  8 May 2023 11:38:59 +0200
Message-Id: <20230508094425.361461265@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Songping <yusongping@huawei.com>

commit 484d7dcc709da46a5976c9530eeff931e9ecba82 upstream.

The logical operator '&&' will make
smu->ppt_funcs->set_gfx_power_up_by_imu segment fault when
smu->ppt_funcs is NULL.

Signed-off-by: Yu Songping <yusongping@huawei.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -161,7 +161,7 @@ int smu_get_dpm_freq_range(struct smu_co
 
 int smu_set_gfx_power_up_by_imu(struct smu_context *smu)
 {
-	if (!smu->ppt_funcs && !smu->ppt_funcs->set_gfx_power_up_by_imu)
+	if (!smu->ppt_funcs || !smu->ppt_funcs->set_gfx_power_up_by_imu)
 		return -EOPNOTSUPP;
 
 	return smu->ppt_funcs->set_gfx_power_up_by_imu(smu);


