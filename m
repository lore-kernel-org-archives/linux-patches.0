Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3923382C3;
	Sat, 28 Feb 2026 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301500; cv=none; b=BvBxVt1l4oSBaFE0ZfsU6pdiq+5aaIkI0w91X9nO5HK2IdTDo3dlFBSmi9IBkY43i6tQEj36k6UkOzsOH206tKY7TbTUcw2F102CMhIq2fRPsPNNL0/kqphWfcVjGcSwhKdQ522zmMQI6pnC7vUWglyQFVJtIEYYN3eTMq/tmUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301500; c=relaxed/simple;
	bh=6nj11AkLtWQxIa78AOEDTUX1bUEgcX2hoEIeXFyozq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ek+JTdfQNk+tuWjo6WEmLJCKqlGni6buUubKtt2sfVG/Xh7isH0mDfb2thFEq1NmidVNMh2izKmwH2bgRobdlfNSaWnVYcLvNajyfnQyocXqjtpnWhQTLUYH+tTGw5S4RIQjB49kKv7XP6FmE7MOavKPFIyU0VDsTsIuobTQugQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gv91afra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gv91afra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D86C2BC9E;
	Sat, 28 Feb 2026 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301500;
	bh=6nj11AkLtWQxIa78AOEDTUX1bUEgcX2hoEIeXFyozq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gv91afra/zQGRUb9xCf0dhxT5irxpyJu0JU258eqQOveyUZWGugFrKL/biahAiAOD
	 qgEGiozmGyIdUZg/BRfHj/6ee67KoEtZkxenSm7zkf7Q2CxI/9utLki1m1IpdTpMKt
	 d5ueoqUpEhrS/FJcWSHV/CePJX1XKFQOQGbX2qE+N3PzXAXnKTDs6s1L/9g1yvZeq6
	 pnREUrvI3/RgpvaOmkbQJQL5IhjlAM2GWWiWxXwu1+i6jJaQ0voghJwCT6rpGn3i2N
	 xtdGebQUvel/SilFTerPsq/sMJRYt+HO4ultpoMjnLgx781AxbK1DcZGv1iSczdWsb
	 y43XOL4i2/cAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	stable@vger.kernel.org,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 684/752] drm/i915/quirks: Fix device id for QUIRK_EDP_LIMIT_RATE_HBR2 entry
Date: Sat, 28 Feb 2026 12:46:35 -0500
Message-ID: <20260228174750.1542406-684-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 510e7261a7bcd6232e90f0b6b9f93303bdd29f8a ]

Update the device ID for Dell XPS 13 7390 2-in-1 in the quirk
`QUIRK_EDP_LIMIT_RATE_HBR2` entry. The previous ID (0x8a12) was
incorrect; the correct ID is 0x8a52.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/5969
Fixes: 21c586d9233a ("drm/i915/dp: Add device specific quirk to limit eDP rate to HBR2")
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: <stable@vger.kernel.org> # v6.18+
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20251226043359.2553-1-ankit.k.nautiyal@intel.com
(cherry picked from commit c7c30c4093cc11ff66672471f12599a555708343)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index d2e16b79d6be1..1abbdd426e587 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -239,7 +239,7 @@ static struct intel_quirk intel_quirks[] = {
 	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 
 	/* Dell XPS 13 7390 2-in-1 */
-	{ 0x8a12, 0x1028, 0x08b0, quirk_edp_limit_rate_hbr2 },
+	{ 0x8a52, 0x1028, 0x08b0, quirk_edp_limit_rate_hbr2 },
 };
 
 static const struct intel_dpcd_quirk intel_dpcd_quirks[] = {
-- 
2.51.0

