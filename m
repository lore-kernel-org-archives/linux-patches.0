Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B891DE4DF;
	Tue,  8 Oct 2024 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391067; cv=none; b=VnJQzTDv2/yK2BfHoBVJ2pUt0PG0kmgAK5DrLFuStz5bYGe9fzIhyiBo3QkDaMoRz6jMfRYNO1tpkMz4JQpYXK8H54L4QQH30HbNda9Z7bKG5Tq92PcV8PD7LeyE1f4WGpMBCGhNYacaWaW71hTK0gDNPSFw+hosRAI3L8+wrJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391067; c=relaxed/simple;
	bh=0ja6nYbnuy6y1WJSX+0bTqWriYvsCj74a78pvKx6je8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHIvPL94cHx+0WIDdI16Lpb41AEnwHm1VnYyZ7NYL2AUUaPpoVWYjxwzSSfqS1iKGJoT1B7Bxvl923ixZPcwFrLhLfyC97fCNqcnk+cm4PdcWFpjFY6CchdqPVJ5nlbZdnZ+ZhznrKYfjqt1eD+UcgchTOHb29nt2OWy//7NwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwWGntsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwWGntsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275E8C4CECD;
	Tue,  8 Oct 2024 12:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391067;
	bh=0ja6nYbnuy6y1WJSX+0bTqWriYvsCj74a78pvKx6je8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwWGntslL6nQsoKWVigVLSmq8s80ENT0fvVPykSh4PjQuQaUvMV0aOLjmBAjOQlEO
	 HAHWM5UESAALLXpbKuHUb5apnfuCrWTTvgoz3tsvyTFCm7tYlBmLpucvAY/Qgk3nQ5
	 VMwBBihXifzdMMtXoKIsf2XqTQspQl7V/D7uW3cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Gabe Teeger <Gabe.Teeger@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 480/482] drm/amd/display: Revert Avoid overflow assignment
Date: Tue,  8 Oct 2024 14:09:03 +0200
Message-ID: <20241008115707.398531209@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Gabe Teeger <Gabe.Teeger@amd.com>

commit e80f8f491df873ea2e07c941c747831234814612 upstream.

This reverts commit a15268787b79 ("drm/amd/display: Avoid overflow assignment in link_dp_cts")
Due to regression causing DPMS hang.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Gabe Teeger <Gabe.Teeger@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h                  |    2 +-
 drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c |    3 +--
 drivers/gpu/drm/amd/display/include/dpcd_defs.h               |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -727,7 +727,7 @@ struct dp_audio_test_data_flags {
 struct dp_audio_test_data {
 
 	struct dp_audio_test_data_flags flags;
-	uint32_t sampling_rate;
+	uint8_t sampling_rate;
 	uint8_t channel_count;
 	uint8_t pattern_type;
 	uint8_t pattern_period[8];
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -775,8 +775,7 @@ bool dp_set_test_pattern(
 			core_link_read_dpcd(link, DP_TRAINING_PATTERN_SET,
 					    &training_pattern.raw,
 					    sizeof(training_pattern));
-			if (pattern <= PHY_TEST_PATTERN_END_DP11)
-				training_pattern.v1_3.LINK_QUAL_PATTERN_SET = pattern;
+			training_pattern.v1_3.LINK_QUAL_PATTERN_SET = pattern;
 			core_link_write_dpcd(link, DP_TRAINING_PATTERN_SET,
 					     &training_pattern.raw,
 					     sizeof(training_pattern));
--- a/drivers/gpu/drm/amd/display/include/dpcd_defs.h
+++ b/drivers/gpu/drm/amd/display/include/dpcd_defs.h
@@ -76,7 +76,6 @@ enum dpcd_phy_test_patterns {
 	PHY_TEST_PATTERN_D10_2,
 	PHY_TEST_PATTERN_SYMBOL_ERROR,
 	PHY_TEST_PATTERN_PRBS7,
-	PHY_TEST_PATTERN_END_DP11 = PHY_TEST_PATTERN_PRBS7,
 	PHY_TEST_PATTERN_80BIT_CUSTOM,/* For DP1.2 only */
 	PHY_TEST_PATTERN_CP2520_1,
 	PHY_TEST_PATTERN_CP2520_2,


