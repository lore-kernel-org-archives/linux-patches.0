Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B30611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FB0C433D2;
	Sun, 28 May 2023 19:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302604;
	bh=Kz/95QYcv7/WS/NtUDzHNoRes+84vIZ3k2IWLZa7uLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JM1GEhmNmU1EyTkCr4ZD8wTjK/gYmazJN7rJyIv3CMsycZPSGgmw8pIAz2r40ggZU
	 SYwQp6r7ff+EHh5K6I/aYm/KgKISemU4tbP+kie4YS+9L8650OAS0Sypsii/Gd0iHP
	 29PT2LVIchw0Arw0349TsZuZpO3FM4UR45hkivBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 043/119] drm/amd/pm: add missing NotifyPowerSource message mapping for SMU13.0.7
Date: Sun, 28 May 2023 20:10:43 +0100
Message-Id: <20230528190836.820107281@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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

commit 0d2dd02d74e6377268f56b90261de0fae8f0d2cb upstream.

Otherwise, the power source switching will fail due to message
unavailable.

Fixes: bf4823267a81 ("drm/amd/pm: fix possible power mode mismatch between driver and PMFW")
Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 98a33f8ee209..bba621615abf 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -125,6 +125,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
 	MSG_MAP(AllowGpo,			PPSMC_MSG_SetGpoAllow,           0),
 	MSG_MAP(GetPptLimit,			PPSMC_MSG_GetPptLimit,                 0),
+	MSG_MAP(NotifyPowerSource,		PPSMC_MSG_NotifyPowerSource,           0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
-- 
2.40.1



