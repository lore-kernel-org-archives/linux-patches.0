Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3221779B1;
	Tue,  8 Oct 2024 12:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391195; cv=none; b=iiFY+DyRf7Q7fpTec+gBTHt5JhEa2LvZFzjtWBWvFKj+WuPwP2jW72BYfW6GWnTHaiA/pHj5CY3s4KSf43nLKjOrcakc48oinTFwmWXhi1UI2vnHbt/t09imZnDWksGUrGg25Lov8DBaGzN32JgA0jy9I0+CPmJPWuIJRkfdvqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391195; c=relaxed/simple;
	bh=xOetyMc+WAY8wHgYztmW94kEEssVUeWWVx8TxAjeOsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUsxmo/4nledCwgcaH1nuBsKUwZIkFZ32bORPQxDV6nhqmwrEJh9+A0/Af0k99H7J3L3ZlsX9XMF7aLxEKnZMM5QC/+XVlb8nYUNEptZbrWUYpvm/mScXS/z/thdRumkh5P1EZWnpj0QczO6nq1ooHbWezixTNdBr6U27EGnT+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjB06w5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjB06w5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647D9C4CECC;
	Tue,  8 Oct 2024 12:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391195;
	bh=xOetyMc+WAY8wHgYztmW94kEEssVUeWWVx8TxAjeOsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjB06w5l/0figm9Uqs69NOFcNBNm/svvwR/Tdf4bEut8hlC8DAOiO/IFj0d/obRyM
	 E6gcWhE8ve03KCRCvc5YSlf3ECOiQNCph3XYDTd5o6eymTp7aCkK34YHQRWAJQFLty
	 M8/j7/UOsDOkJJkl68qGgBjjMmQZHpShsUsd3DXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/558] drm/i915/display: BMG supports UHBR13.5
Date: Tue,  8 Oct 2024 14:00:37 +0200
Message-ID: <20241008115702.510013219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun R Murthy <arun.r.murthy@intel.com>

[ Upstream commit fcd33d434d31a210bc9f209b5bfd92f3b91a2dda ]

UHBR20 is not supported by battlemage and the maximum link rate
supported is UHBR13.5

v2: Replace IS_DGFX with IS_BATTLEMAGE (Jani)

HSD: 16023263677
Signed-off-by: Arun R Murthy <arun.r.murthy@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Fixes: 98b1c87a5e51 ("drm/i915/xe2hpd: Set maximum DP rate to UHBR13.5")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240827081205.136569-1-arun.r.murthy@intel.com
(cherry picked from commit 9c2338ac4543e0fab3a1e0f9f025591e0f0d9f8f)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index ebe7fe5417ae4..2a7deac73b2eb 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -535,6 +535,10 @@ static void
 intel_dp_set_source_rates(struct intel_dp *intel_dp)
 {
 	/* The values must be in increasing order */
+	static const int bmg_rates[] = {
+		162000, 216000, 243000, 270000, 324000, 432000, 540000, 675000,
+		810000,	1000000, 1350000,
+	};
 	static const int mtl_rates[] = {
 		162000, 216000, 243000, 270000, 324000, 432000, 540000, 675000,
 		810000,	1000000, 2000000,
@@ -565,8 +569,13 @@ intel_dp_set_source_rates(struct intel_dp *intel_dp)
 		    intel_dp->source_rates || intel_dp->num_source_rates);
 
 	if (DISPLAY_VER(dev_priv) >= 14) {
-		source_rates = mtl_rates;
-		size = ARRAY_SIZE(mtl_rates);
+		if (IS_BATTLEMAGE(dev_priv)) {
+			source_rates = bmg_rates;
+			size = ARRAY_SIZE(bmg_rates);
+		} else {
+			source_rates = mtl_rates;
+			size = ARRAY_SIZE(mtl_rates);
+		}
 		max_rate = mtl_max_source_rate(intel_dp);
 	} else if (DISPLAY_VER(dev_priv) >= 11) {
 		source_rates = icl_rates;
-- 
2.43.0



