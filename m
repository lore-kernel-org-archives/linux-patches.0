Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5681DE881;
	Mon,  2 Jun 2025 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873858; cv=none; b=Yjnvj5yhNdxfhXd0B2AVWP1OXjTGz0P8tYtEb5iswy8V9n3OtXbEbPrxkqAGejiK5Cb/bq7G2DhXUXjiu3UcvgDjj6Vdx/kGW6eSQgX0H0cX/H5Mnbe0xPLZ1Cuvw3ktHqSS1iI91l493zCO/S9KDwQN6L2Mh4jcxzNmGFqknjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873858; c=relaxed/simple;
	bh=Vsm+ynkPJzTMBzIsJ356KaoSR6oQWO/UBmTOunqgRVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQMLrw2B7J9JEQoRHs0p7KUAqjZh5wrMmZ7B1o9jMRrqcE8SdB6VSHF5g4lg70dcxQB1n2KwBZouvg+mN5A4TO+ckgW0xEq5Cs6udz4RRDJZi8EjAsaklqJArdf8SolZaH7qYW/EDOBh+fvL5gcMGuWDV8K0ngOrYPNwFqX858I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqO38wQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqO38wQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DA2C4CEEB;
	Mon,  2 Jun 2025 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873858;
	bh=Vsm+ynkPJzTMBzIsJ356KaoSR6oQWO/UBmTOunqgRVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqO38wQPQpD+/LXw86SsSKKaAyXKWW9FFvsqkgoDar+mRQJ14oid3C/tSPG7PWoUa
	 vEpBVDgA1shXHmSwJVGet9pGgAXSqUavMXQcmhh/rJ6JrXWuyJK3WH7ikSXsfC9vBD
	 8lyacXmH8y6jMnSr3XEuOKryljyaboCWZHgK9KbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Strauss <michael.strauss@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	George Shen <george.shen@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/444] drm/amd/display: Update CR AUX RD interval interpretation
Date: Mon,  2 Jun 2025 15:45:10 +0200
Message-ID: <20250602134350.903951107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

[ Upstream commit 6a7fde433231c18164c117592d3e18ced648ad58 ]

[Why]
DP spec updated to have the CR AUX RD interval match the EQ AUX RD
interval interpretation of DPCD 0000Eh/0220Eh for 8b/10b non-LTTPR mode
and LTTPR transparent mode cases.

[How]
Update interpretation of DPCD 0000Eh/0220Eh for CR AUX RD interval
during 8b/10b link training.

Reviewed-by: Michael Strauss <michael.strauss@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/link/protocols/link_dp_training_8b_10b.c    | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_8b_10b.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_8b_10b.c
index 2b4c15b0b4070..52261e7c11c0b 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_8b_10b.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_8b_10b.c
@@ -36,7 +36,8 @@
 	link->ctx->logger
 
 static int32_t get_cr_training_aux_rd_interval(struct dc_link *link,
-		const struct dc_link_settings *link_settings)
+		const struct dc_link_settings *link_settings,
+		enum lttpr_mode lttpr_mode)
 {
 	union training_aux_rd_interval training_rd_interval;
 	uint32_t wait_in_micro_secs = 100;
@@ -49,6 +50,8 @@ static int32_t get_cr_training_aux_rd_interval(struct dc_link *link,
 				DP_TRAINING_AUX_RD_INTERVAL,
 				(uint8_t *)&training_rd_interval,
 				sizeof(training_rd_interval));
+		if (lttpr_mode != LTTPR_MODE_NON_TRANSPARENT)
+			wait_in_micro_secs = 400;
 		if (training_rd_interval.bits.TRAINIG_AUX_RD_INTERVAL)
 			wait_in_micro_secs = training_rd_interval.bits.TRAINIG_AUX_RD_INTERVAL * 4000;
 	}
@@ -110,7 +113,6 @@ void decide_8b_10b_training_settings(
 	 */
 	lt_settings->link_settings.link_spread = link->dp_ss_off ?
 			LINK_SPREAD_DISABLED : LINK_SPREAD_05_DOWNSPREAD_30KHZ;
-	lt_settings->cr_pattern_time = get_cr_training_aux_rd_interval(link, link_setting);
 	lt_settings->eq_pattern_time = get_eq_training_aux_rd_interval(link, link_setting);
 	lt_settings->pattern_for_cr = decide_cr_training_pattern(link_setting);
 	lt_settings->pattern_for_eq = decide_eq_training_pattern(link, link_setting);
@@ -119,6 +121,7 @@ void decide_8b_10b_training_settings(
 	lt_settings->disallow_per_lane_settings = true;
 	lt_settings->always_match_dpcd_with_hw_lane_settings = true;
 	lt_settings->lttpr_mode = dp_decide_8b_10b_lttpr_mode(link);
+	lt_settings->cr_pattern_time = get_cr_training_aux_rd_interval(link, link_setting, lt_settings->lttpr_mode);
 	dp_hw_to_dpcd_lane_settings(lt_settings, lt_settings->hw_lane_settings, lt_settings->dpcd_lane_settings);
 }
 
-- 
2.39.5



