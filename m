Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D6C33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1961C433F2;
	Mon, 16 Jan 2023 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884519;
	bh=1n05J/7+M/4ELp6j5x3U+at4NYvESuZwoJowQTNZcUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7hgLBsyXMjE5ek5z5DQSw5Iq/724rI0B92mkLnc+gZLhSDipqV1cKDnTEydLG0CF
	 j/CYtghQdABtQet/Y6AYJ76+THcvnMgrP73qWRnbnWofTf6P/tqemvsXR8sivVAvHd
	 UyQUO4+dVqg3uTSbPFZ4NP9ryYdTjksGpwusJ3ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 035/183] drm/amd/pm: add the missing mapping for PPT feature on SMU13.0.0 and 13.0.7
Date: Mon, 16 Jan 2023 16:49:18 +0100
Message-Id: <20230116154804.859114131@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit 318ca20893c19ead02845a08204c3f9249bb74cd upstream.

Then we are able to set a new ppt limit via the hwmon interface(power1_cap).

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x, 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -189,6 +189,7 @@ static struct cmn2asic_mapping smu_v13_0
 	FEA_MAP(SOC_PCC),
 	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_PPT_BIT] = {1, FEATURE_THROTTLERS_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_table_map[SMU_TABLE_COUNT] = {
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -191,6 +191,7 @@ static struct cmn2asic_mapping smu_v13_0
 	FEA_MAP(SOC_PCC),
 	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_PPT_BIT] = {1, FEATURE_THROTTLERS_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_table_map[SMU_TABLE_COUNT] = {


