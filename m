Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF8A194A67;
	Tue, 27 May 2025 16:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365168; cv=none; b=EfhsYZGLbzVtbFNx4E4EQdYdLWcybVW1M27VH5ftkdxNlkoDeuTm6uXaivFzoP8VkV87FH8EgXL2RYw+BI+X7yz4xjKE1tZ15JWKgGDCDYA3AQFRQRemVXz+RWVY5drvUmEnywPlRYK+hS6a5wBlz3hFcyI+wHLGCR+3BS3NODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365168; c=relaxed/simple;
	bh=uCBoUqvcVP6KwwqviAwfKiWrqAtNVAsMYtZjTFqs1cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB1rkWa5pPJprT7acBkMYa+LhZ0uIfNDOP1DjA3AgsxMA7EIxBmLShEkqe+l3DoorD5TleHg97MHtV4AmB7GY0ZiaNJESuTw5Fmzbwubo6BtuF0pC3of10akNVYvTFuph6WQB8b46CPKuez0bsrScv30jWWxbQWlfANMoHCgfMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir/zA8yN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir/zA8yN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F758C4CEE9;
	Tue, 27 May 2025 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365167;
	bh=uCBoUqvcVP6KwwqviAwfKiWrqAtNVAsMYtZjTFqs1cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ir/zA8yN22l928dYBGnjAN8D2e3zr2o9wQpNlP0mj2zQKmwMZBqMbBOfOfXb6Aqdc
	 nAEzXaERls9KQ3RjV4aiE9ayCq7eE6mlD5ILTos9TyJ7NrcjfTkFymrZakUKoWkDpl
	 0q7iPjLQKldKNqp8WL6C0IznqbLsHPSSU1J1GMGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navid Assadian <navid.assadian@amd.com>,
	Joshua Aberback <joshua.aberback@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/626] drm/amd/display: Fix mismatch type comparison
Date: Tue, 27 May 2025 18:23:02 +0200
Message-ID: <20250527162456.776043841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Assadian, Navid <navid.assadian@amd.com>

[ Upstream commit 26873260d394b1e33cdd720154aedf0af95327f9 ]

The mismatch type comparison/assignment may cause data loss. Since the
values are always non-negative, it is safe to use unsigned variables to
resolve the mismatch.

Signed-off-by: Navid Assadian <navid.assadian@amd.com>
Reviewed-by: Joshua Aberback <joshua.aberback@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/spl/dc_spl.c       | 4 ++--
 drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
index 014e8a296f0c7..54c7d6aecf51c 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
+++ b/drivers/gpu/drm/amd/display/dc/spl/dc_spl.c
@@ -875,8 +875,8 @@ static bool spl_get_optimal_number_of_taps(
 	  bool *enable_isharp)
 {
 	int num_part_y, num_part_c;
-	int max_taps_y, max_taps_c;
-	int min_taps_y, min_taps_c;
+	unsigned int max_taps_y, max_taps_c;
+	unsigned int min_taps_y, min_taps_c;
 	enum lb_memory_config lb_config;
 	bool skip_easf = false;
 
diff --git a/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h b/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h
index 2a74ff5fdfdbc..a2c28949ec47f 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h
+++ b/drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h
@@ -479,7 +479,7 @@ struct spl_sharpness_range {
 };
 struct adaptive_sharpness {
 	bool enable;
-	int sharpness_level;
+	unsigned int sharpness_level;
 	struct spl_sharpness_range sharpness_range;
 };
 enum linear_light_scaling	{	// convert it in translation logic
-- 
2.39.5



