Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442E8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A72DC433D2;
	Mon, 13 Feb 2023 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300217;
	bh=u0PKcvou84Yos+Y14u38al405SB75frWkVaPbAC426A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5/NFQIYYmtj5xuXJMHbFp15eCY4edNRolHS+0ecfDzOEa9vLY6t+NCtxFFP5EfMz
	 GbQ0xhqX0RV3PvY9kOyDT1AuaEjy8eDuTK7omMRC6Zpddf7IbIlRjUJXZ8SpsXRfYP
	 C6fT39dnm/7i+1L8KxQhqdf1E5GbYLqKOkf/IpNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Jian <Jane.Jian@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 109/114] drm/amdgpu/smu: skip pptable init under sriov
Date: Mon, 13 Feb 2023 15:49:04 +0100
Message-Id: <20230213144747.854271071@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jane Jian <Jane.Jian@amd.com>

commit c6ac406cd8ff610a2d5da298b1d3071acfcde7f0 upstream.

sriov does not need to init pptable from amdgpu driver
we finish it from PF

Signed-off-by: Jane Jian <Jane.Jian@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index cf96c3f2affe..508e392547d7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -407,6 +407,9 @@ static int smu_v13_0_0_setup_pptable(struct smu_context *smu)
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
+	if (amdgpu_sriov_vf(smu->adev))
+		return 0;
+
 	ret = smu_v13_0_0_get_pptable_from_pmfw(smu,
 						&smu_table->power_play_table,
 						&smu_table->power_play_table_size);
@@ -1257,6 +1260,9 @@ static int smu_v13_0_0_get_thermal_temperature_range(struct smu_context *smu,
 		table_context->power_play_table;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 
+	if (amdgpu_sriov_vf(smu->adev))
+		return 0;
+
 	if (!range)
 		return -EINVAL;
 
-- 
2.39.1



