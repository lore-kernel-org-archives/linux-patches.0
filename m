Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830815;
	b=U9fwGZk6mAkeSATFCdnuL54K9rO1/dD6WlCkb13p9j6Z+4CrAY985SmneiYPuTE8MKdU
	 phfwBruuu6FKZtox5C4b17+T8AWzT2wmlptb4ut7jbKUTaxrlKelJ+fdCLWdY7SOPqQQE
	 IwaNC04n9296YjPCz0BtBs66prXsHu58gTdnvqA4QOaEycyGZScQ/aFOAlFm5yHdZhBbj
	 56UgUJ2B1aSvmNuAdoRRwAbI9iZaQpclAK8M4SQJYAIVmI8TjA5u4W4Vi57iGxcqZHwKX
	 jEkvBpnhOiOlnrVBaQAMrK9V0c13SSP+LHYNZg/zlCT6Jwctadh59KBDsWNM8inYTQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MwsA/aWEy+J2zaMXaIxItNS8qWxlH1E2FcwbtKRMMM=;
	b=C2sMtiTD3wbrAzSx19bp17qA29woJ+1+IJQ9Ltlds5hNUp8GzPk5B5W8n4wU0Sb16o6V
	 JLzP7RuwYRwSvwS2LthYtc+ohOUGpVLOph5N0cBnCOHD9YhIeEw2nRA+tQmvhWGLMzSHJ
	 aC5I2lgdCLV66OZclx8gn11RQd5+ClsLrYmXdjc7Aa2JGiO3jHlKw4SZl7n0xALfkibJt
	 VZHC8MFwLBpBUCJ1P1slXuiCVKsWCHJcDXQ5VwMPR7SdEsZFlyW/Ajiy+kIJEOJso0Juk
	 kNlY6vAlYVYxK9xegokVF5dR2GGKlJDSKfqMAIvLd/E7Q6ijdXymoWd5wCdyZXH6D6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jbZvLnZh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73822606AC33;
	Wed,  4 Nov 2026 22:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jbZvLnZh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E83A1F00A21;
	Wed,  4 Nov 2026 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830815;
	bh=0MwsA/aWEy+J2zaMXaIxItNS8qWxlH1E2FcwbtKRMMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbZvLnZhSzpWPxXXsDAHpXE+nNNQbzK91vVmQJGY1rrbzy5iRWpjH9OafOqySdVYU
	 lwraLsWhij9/Yz4v1/27apsDYnNXrRINOwdeq/99iGnosU0ez+mIdQH9KFx/WRS9/F
	 JIKLkVbSz5kJSaYR5GO4SNA/pd9Z3zVr2ecvcT34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0336/1005] drm/amd/pm: derive stable PPT limits from PPTable
Date: Wed,  4 Nov 2026 16:01:09 -0500
Message-ID: <20261104211053.366867052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 25f4a46b0c8acd77c9065b50a1fe48af27d91fdf ]

GetPptLimit reports mutable PMFW runtime state. Using that value for
static capabilities causes two externally visible problems:

- A userspace override changes the default reported through hwmon.
- A firmware reset changes the advertised minimum or maximum range.

Derive platform defaults and supported ranges from the driver PPTable
for Sienna Cichlid, Navi10, Arcturus, and Aldebaran. Reserve PMFW queries
for the effective current limit.

Runtime policy can no longer redefine immutable platform capabilities.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 25 ++++++++-------
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   | 32 +++++++++++--------
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 28 +++++++++-------
 .../drm/amd/pm/swsmu/smu13/aldebaran_ppt.c    |  8 +++--
 4 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 4fff78da81ff8..2b2d3c3aa20ba 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1329,24 +1329,25 @@ static int arcturus_get_power_limit(struct smu_context *smu,
 					uint32_t *min_power_limit)
 {
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
-	uint32_t power_limit;
+	uint32_t current_limit, default_limit;
 
-	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
-		/* the last hope to figure out the ppt limit */
-		if (!pptable) {
-			dev_err(smu->adev->dev, "Cannot get PPT limit due to pptable missing!");
-			return -EINVAL;
-		}
-		power_limit =
-			pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0];
+	if (!pptable) {
+		dev_err(smu->adev->dev,
+			"Cannot get PPT limit due to pptable missing!");
+		return -EINVAL;
 	}
 
+	default_limit = pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0];
+
+	if (smu_v11_0_get_current_power_limit(smu, &current_limit))
+		current_limit = default_limit;
+
 	if (current_power_limit)
-		*current_power_limit = power_limit;
+		*current_power_limit = current_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = default_limit;
 	if (max_power_limit)
-		*max_power_limit = power_limit;
+		*max_power_limit = default_limit;
 	/*
 	 * No lower bound is imposed on the limit. Any unreasonable limit set
 	 * will result in frequent throttling.
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index a2fcf678182b4..4737ceb2a5434 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2393,22 +2393,26 @@ static int navi10_get_power_limit(struct smu_context *smu,
 		(struct smu_11_0_powerplay_table *)smu->smu_table.power_play_table;
 	struct smu_11_0_overdrive_table *od_settings = smu->od_settings;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
+	uint32_t current_limit, default_limit;
+	uint32_t od_percent_upper = 0, od_percent_lower = 0;
 
-	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
-		/* the last hope to figure out the ppt limit */
-		if (!pptable) {
-			dev_err(smu->adev->dev, "Cannot get PPT limit due to pptable missing!");
-			return -EINVAL;
-		}
-		power_limit =
-			pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0];
+	if (!pptable) {
+		dev_err(smu->adev->dev,
+			"Cannot get PPT limit due to pptable missing!");
+		return -EINVAL;
 	}
 
+	default_limit = smu->adev->pm.ac_power ?
+		pptable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
+		pptable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
+
+	if (smu_v11_0_get_current_power_limit(smu, &current_limit))
+		current_limit = default_limit;
+
 	if (current_power_limit)
-		*current_power_limit = power_limit;
+		*current_power_limit = current_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = default_limit;
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
@@ -2422,15 +2426,15 @@ static int navi10_get_power_limit(struct smu_context *smu,
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+		 od_percent_upper, od_percent_lower, default_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = power_limit * (100 + od_percent_upper);
+		*max_power_limit = default_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 - od_percent_lower);
+		*min_power_limit = default_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 31c2c0386b1f9..d553c6fbab47c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -632,20 +632,24 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 	struct smu_11_0_7_powerplay_table *powerplay_table =
 		(struct smu_11_0_7_powerplay_table *)smu->smu_table.power_play_table;
 	struct smu_11_0_7_overdrive_table *od_settings = smu->od_settings;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
-	uint16_t *table_member;
+	uint32_t current_limit, default_limit;
+	uint32_t od_percent_upper = 0, od_percent_lower = 0;
+	u16 *power_limit_ac, *power_limit_dc;
 
-	GET_PPTABLE_MEMBER(SocketPowerLimitAc, &table_member);
+	GET_PPTABLE_MEMBER(SocketPowerLimitAc, &power_limit_ac);
+	GET_PPTABLE_MEMBER(SocketPowerLimitDc, &power_limit_dc);
 
-	if (smu_v11_0_get_current_power_limit(smu, &power_limit)) {
-		power_limit =
-			table_member[PPT_THROTTLER_PPT0];
-	}
+	default_limit = smu->adev->pm.ac_power ?
+		power_limit_ac[PPT_THROTTLER_PPT0] :
+		power_limit_dc[PPT_THROTTLER_PPT0];
+
+	if (smu_v11_0_get_current_power_limit(smu, &current_limit))
+		current_limit = default_limit;
 
 	if (current_power_limit)
-		*current_power_limit = power_limit;
+		*current_power_limit = current_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = default_limit;
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
@@ -659,15 +663,15 @@ static int sienna_cichlid_get_power_limit(struct smu_context *smu,
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+		 od_percent_upper, od_percent_lower, default_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = power_limit * (100 + od_percent_upper);
+		*max_power_limit = default_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 - od_percent_lower);
+		*min_power_limit = default_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 18d5d07045098..9e67e57d70b75 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1281,8 +1281,12 @@ static int aldebaran_get_power_limit(struct smu_context *smu,
 
 	if (current_power_limit)
 		*current_power_limit = power_limit;
-	if (default_power_limit)
-		*default_power_limit = power_limit;
+	if (default_power_limit) {
+		if (pptable)
+			*default_power_limit = pptable->PptLimit;
+		else
+			*default_power_limit = power_limit;
+	}
 
 	if (max_power_limit) {
 		if (pptable)
-- 
2.53.0



