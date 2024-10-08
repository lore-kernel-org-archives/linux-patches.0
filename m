Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAA01DE3AE;
	Tue,  8 Oct 2024 12:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389508; cv=none; b=boQA92sNCNZjNHSIuxugClG6ii2YIqWEY12y3EHGxD2gWOLhblDjJYDrY7/Xien7N49Q9cirwlQLkJMXCf1TXTHQELsM+DwnE5QKuHn4ydp2Uzyfx/3hvQkik3hp5NBlyR/6vO8awFgJWV+M3PDoI98JZinXCbHcaH8OIQAxApM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389508; c=relaxed/simple;
	bh=IUSuomWohHeBlyiKvQPgLOuqPJQ2Y/4F/ozfBC3mfwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewUoLe9+6KIvPxRfCnEuugpaajpSQFA+tYDKkwbaj8azC+CdIbtyCOSvV7rGbux1pjBRfCADMrX2lgWptX9dtR/p6BMhpr/DDdnViTQfbI8X9D/09GaQWmIH0Dz4w9dS6DKNITm42UH8KXONJWqdS3G4n77fRRQru0nPDIasZog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V+Rkwfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V+Rkwfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA51C4CEC7;
	Tue,  8 Oct 2024 12:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389508;
	bh=IUSuomWohHeBlyiKvQPgLOuqPJQ2Y/4F/ozfBC3mfwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2V+Rkwfoq3lq+afCqhihyyRe9fiAPeWJa00eAqQH/uM4qO8SmaGyz0luP1xEiz7P3
	 +BowW5nm8znb7+T9JpMzabedbPW8MGS93HiC4Y3ytVVgMUxjjLPky/IjxWlsPApIuJ
	 mbcztalZFhKVKF01JScr2UjIZLW4ckyS/ElSdzyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 015/482] drm/i915/dp: Fix colorimetry detection
Date: Tue,  8 Oct 2024 14:01:18 +0200
Message-ID: <20241008115648.899188651@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit e860513f56d8428fcb2bd0282ac8ab691a53fc6c ]

intel_dp_init_connector() is no place for detecting stuff via
DPCD (except perhaps for eDP). Move the colorimetry stuff into
a more appropriate place.

Cc: Jouni Högander <jouni.hogander@intel.com>
Fixes: 00076671a648 ("drm/i915/display: Move colorimetry_support from intel_psr to intel_dp")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240918190441.29071-1-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
(cherry picked from commit 35dba4834bded843d5416e8caadfe82bd0ce1904)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index a7d91ca1d8baf..bd3ce34fb6a6c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3944,6 +3944,9 @@ intel_edp_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector
 			 drm_dp_is_branch(intel_dp->dpcd));
 	intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
+	intel_dp->colorimetry_support =
+		intel_dp_get_colorimetry_status(intel_dp);
+
 	/*
 	 * Read the eDP display control registers.
 	 *
@@ -4057,6 +4060,9 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 
 		intel_init_dpcd_quirks(intel_dp, &intel_dp->desc.ident);
 
+		intel_dp->colorimetry_support =
+			intel_dp_get_colorimetry_status(intel_dp);
+
 		intel_dp_update_sink_caps(intel_dp);
 	}
 
@@ -6774,9 +6780,6 @@ intel_dp_init_connector(struct intel_digital_port *dig_port,
 				    "HDCP init failed, skipping.\n");
 	}
 
-	intel_dp->colorimetry_support =
-		intel_dp_get_colorimetry_status(intel_dp);
-
 	intel_dp->frl.is_trained = false;
 	intel_dp->frl.trained_rate_gbps = 0;
 
-- 
2.43.0



