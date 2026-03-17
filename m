Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C103EF658;
	Tue, 17 Mar 2026 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765782; cv=none; b=JCGRxYrg0NvA3oXX28iXhEHP8Bb2NEh9EK1HuraA3MAju1rZLG43R3vMnS3YHlakZOHm+ZMij7h41VQbc/vTHJ8zHqQLspmbtq512pFCUIq71//9kK0xp+vg/Kv30mbY+bMesF3n3XcABsAIzIDeWoaYjXGjzOXiv994QRKrRsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765782; c=relaxed/simple;
	bh=ymwdonBjJVJaA14e9EgdngHA1LH7rflvuqcVGnZaKF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usnxyoUsx2vHg/cvPIkOY+ghVwBnmde8h4n1+6flQf0ySswOq2QhMOTV/f0R/L0crOQy+xoF+IgtBLinJI1EA16x3ye3zhUkSb4gj9MF1dnQ96qulSnFzQO71LOP3T40Bl+bLq8Cwugz4P3YUo9lMe6SlTZJcBBRJ4NYPksstuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRcjSB//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRcjSB//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F46C19424;
	Tue, 17 Mar 2026 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765782;
	bh=ymwdonBjJVJaA14e9EgdngHA1LH7rflvuqcVGnZaKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRcjSB//MphIS+1qrghSUZNjjaGcU4P+FI+WgI0NayuWGxQCfgybGajQ2PITWCAwY
	 hcrfClJvwQS+gv5j9mqhtBLTMwvtsevh4oZHxl5tpLlo61fFj1xd+hlHjCm1F6NsWo
	 8ZtxGSaHwI/p5u6KE+hhO4v+LYxpqdhWKVoDPpXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 063/378] drm/i915/dp: Read ALPM caps after DPCD init
Date: Tue, 17 Mar 2026 17:30:20 +0100
Message-ID: <20260317163009.310550670@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun R Murthy <arun.r.murthy@intel.com>

[ Upstream commit 335b237d902c7362cb7228802e68374406b24acf ]

For eDP read the ALPM DPCD caps after DPCD initalization and just before
the PSR init.

v2: Move intel_alpm_init to intel_edp_init_dpcd (Jouni)
v3: Add Fixes with commit-id (Jouni)
v4: Separated the alpm dpcd read caps from alpm_init and moved to
intel_edp_init_dpcd.
v5: Read alpm_caps always for eDP irrespective of the eDP version (Jouni)
v6: replace drm_dp_dpcd_readb with drm_dp_dpcd_read_byte (Jouni)

Fixes: 15438b325987 ("drm/i915/alpm: Add compute config for lobf")
Signed-off-by: Arun R Murthy <arun.r.murthy@intel.com>
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patch.msgid.link/20260304072157.1123283-1-arun.r.murthy@intel.com
(cherry picked from commit 88442ba208dd5d3405de3f5000cf5b2c86876ae3)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_alpm.c | 6 ------
 drivers/gpu/drm/i915/display/intel_dp.c   | 7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_alpm.c b/drivers/gpu/drm/i915/display/intel_alpm.c
index 6372f533f65b5..5ba767bb38521 100644
--- a/drivers/gpu/drm/i915/display/intel_alpm.c
+++ b/drivers/gpu/drm/i915/display/intel_alpm.c
@@ -43,12 +43,6 @@ bool intel_alpm_is_alpm_aux_less(struct intel_dp *intel_dp,
 
 void intel_alpm_init(struct intel_dp *intel_dp)
 {
-	u8 dpcd;
-
-	if (drm_dp_dpcd_readb(&intel_dp->aux, DP_RECEIVER_ALPM_CAP, &dpcd) < 0)
-		return;
-
-	intel_dp->alpm_dpcd = dpcd;
 	mutex_init(&intel_dp->alpm.lock);
 }
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index ee258df439a7d..b6ce11267b92d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4547,6 +4547,7 @@ static bool
 intel_edp_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector)
 {
 	struct intel_display *display = to_intel_display(intel_dp);
+	int ret;
 
 	/* this function is meant to be called only once */
 	drm_WARN_ON(display->drm, intel_dp->dpcd[DP_DPCD_REV] != 0);
@@ -4586,6 +4587,12 @@ intel_edp_init_dpcd(struct intel_dp *intel_dp, struct intel_connector *connector
 	 */
 	intel_dp_init_source_oui(intel_dp);
 
+	/* Read the ALPM DPCD caps */
+	ret = drm_dp_dpcd_read_byte(&intel_dp->aux, DP_RECEIVER_ALPM_CAP,
+				    &intel_dp->alpm_dpcd);
+	if (ret < 0)
+		return false;
+
 	/*
 	 * This has to be called after intel_dp->edp_dpcd is filled, PSR checks
 	 * for SET_POWER_CAPABLE bit in intel_dp->edp_dpcd[1]
-- 
2.51.0



