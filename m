Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7371F5FA;
	Mon,  4 Mar 2024 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587858; cv=none; b=ZZUAsbE8akvMwlrr/6lF0GxlwtTrCkQGTqtJtAkJBaE+q5kTG6M7G+sBEwS+s0042tjPSvr5jP8uFQ69wKsLZtehaqWpOolDuSNlXO2k3mBHLpo6KlgeFoImub18fLyx+7shcNTIE7EJv+qe6k0t+0O4mCwE9RHIl0567Y0bu7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587858; c=relaxed/simple;
	bh=OjWG5efRpnMQWRxRfx8+jsyLsymzjsSY5ugN9oI8x2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHTzyHUahOICutcQrvMueNVk+nzh30hqwISb50Rm8oxrRxqrnjbHYcmFF4gDtwxHHZwW7vVjAniHSWXUjCxhuIpL36Cmh6H86LBD7SkhbLDAacgDZrXjD+928ATPeNxzSxbTeicjlHmhrmX+td0XO0LDgMPncLcyvVEfM+018XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mly2NmCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mly2NmCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712D1C433F1;
	Mon,  4 Mar 2024 21:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587857;
	bh=OjWG5efRpnMQWRxRfx8+jsyLsymzjsSY5ugN9oI8x2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mly2NmCRAjyvau2Ign7IwXMJB7hEEZbeZADYlbYA5ks03dg3Ee1wbgVDZKIi5i41L
	 rwraAS6/amfzFoHs1lieyCSxiD0ArJiOHZ8tx2V1ZY4AuqXnA/sBB7xlzZMYp8a0Bm
	 nABcmP5vFzAdKj0adeGaWu53EPl6BOE6uT1apUS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.7 092/162] drm/amdgpu/pm: Fix the power1_min_cap value
Date: Mon,  4 Mar 2024 21:22:37 +0000
Message-ID: <20240304211554.787630174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

commit 7968e9748fbbd7ae49770d9f8a8231d8bce2aebb upstream.

It's unreasonable to use 0 as the power1_min_cap when
OD is disabled. So, use the same lower limit as the value
used when OD is enabled.

Fixes: 1958946858a6 ("drm/amd/pm: Support for getting power1_cap_min value")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c       |    9 ++++-----
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         |    9 ++++-----
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    9 ++++-----
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c    |    9 ++++-----
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c    |    9 ++++-----
 5 files changed, 20 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1303,13 +1303,12 @@ static int arcturus_get_power_limit(stru
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled) {
+	if (smu->od_enabled)
 		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-	} else {
+	else
 		od_percent_upper = 0;
-		od_percent_lower = 100;
-	}
+
+	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 							od_percent_upper, od_percent_lower, power_limit);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2357,13 +2357,12 @@ static int navi10_get_power_limit(struct
 		*default_power_limit = power_limit;
 
 	if (smu->od_enabled &&
-		    navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT)) {
+		    navi10_od_feature_is_supported(od_settings, SMU_11_0_ODCAP_POWER_LIMIT))
 		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
-	} else {
+	else
 		od_percent_upper = 0;
-		od_percent_lower = 100;
-	}
+
+	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_ODSETTING_POWERPERCENTAGE]);
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -640,13 +640,12 @@ static int sienna_cichlid_get_power_limi
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled) {
+	if (smu->od_enabled)
 		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
-	} else {
+	else
 		od_percent_upper = 0;
-		od_percent_lower = 100;
-	}
+
+	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_11_0_7_ODSETTING_POWERPERCENTAGE]);
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2364,13 +2364,12 @@ static int smu_v13_0_0_get_power_limit(s
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled) {
+	if (smu->od_enabled)
 		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
-	} else {
+	else
 		od_percent_upper = 0;
-		od_percent_lower = 100;
-	}
+
+	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_0_ODSETTING_POWERPERCENTAGE]);
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2328,13 +2328,12 @@ static int smu_v13_0_7_get_power_limit(s
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (smu->od_enabled) {
+	if (smu->od_enabled)
 		od_percent_upper = le32_to_cpu(powerplay_table->overdrive_table.max[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
-		od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
-	} else {
+	else
 		od_percent_upper = 0;
-		od_percent_lower = 100;
-	}
+
+	od_percent_lower = le32_to_cpu(powerplay_table->overdrive_table.min[SMU_13_0_7_ODSETTING_POWERPERCENTAGE]);
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
 					od_percent_upper, od_percent_lower, power_limit);


