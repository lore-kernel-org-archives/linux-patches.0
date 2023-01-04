Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DE9AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADF2C433D2;
	Wed,  4 Jan 2023 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849543;
	bh=Cp4Xey+5WpKc028XxyYs27sWKy+hn7eJfH7Ol3j+gxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwTMfelwMS+L8CZf4zP61Mgc6WuFv48zTioL2tQRtuCJ8cXruUExcEVRoTvsocbtX
	 9G0gTz/IPv0Hi09IL/pCi23qtNEU0FNg/z++44xMTY4nw9BeLQUa69FGf46/uQoLrk
	 ngss9jHKnDmoCYlLWRCSTDuPRRkeawNUfygUQL2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 205/207] drm/amd/pm: add missing SMU13.0.7 mm_dpm feature mapping
Date: Wed,  4 Jan 2023 17:07:43 +0100
Message-Id: <20230104160518.422651048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit e0607c10ebf551a654c3577fc74b4bf5533e1cea upstream.

Without this, the pp_dpm_vclk and pp_dpm_dclk outputs are not with
correct data.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -189,6 +189,8 @@ static struct cmn2asic_mapping smu_v13_0
 	FEA_MAP(MEM_TEMP_READ),
 	FEA_MAP(ATHUB_MMHUB_PG),
 	FEA_MAP(SOC_PCC),
+	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_table_map[SMU_TABLE_COUNT] = {


