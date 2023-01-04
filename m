Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E88AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ECDC433D2;
	Wed,  4 Jan 2023 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849653;
	bh=jUGgu+jjn4oh8uZCNtxL5R0bZaJS06RGDqho/5O8FE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Osko409fRl/vFMnYXxL9URUIcmQmQys7FBPYBzw/ufGXBz6HNgA2xFJDhVzbP7peQ
	 YWLqqqTnFNKzqRSf342fjFWoRNh5ovtoPCZPo1rPwv8XnzF9IluYuDAGgfm8F8XrWN
	 uogCE02Mr2MxU5PCX3Nb5pIuzB2ecxhPP8od/fuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 174/177] drm/amd/pm: add missing SMU13.0.0 mm_dpm feature mapping
Date: Wed,  4 Jan 2023 17:07:45 +0100
Message-Id: <20230104160512.949606906@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit 592cd24a08763975c75be850a7d4e461bfd353bf upstream.

Without this, the pp_dpm_vclk and pp_dpm_dclk outputs are not with
correct data.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -187,6 +187,8 @@ static struct cmn2asic_mapping smu_v13_0
 	FEA_MAP(MEM_TEMP_READ),
 	FEA_MAP(ATHUB_MMHUB_PG),
 	FEA_MAP(SOC_PCC),
+	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_table_map[SMU_TABLE_COUNT] = {


