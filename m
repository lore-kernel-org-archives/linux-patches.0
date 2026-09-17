Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D040851A135;
	Thu, 17 Sep 2026 17:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667019; cv=none; b=YfkAU+LrEk8m6gHX6FNGNwOpeq/chaRPA2vKu2pMWORjrpU9CK+9W4a32KxDXufmyEseaivWSPy/xX1Oc0F5j391ZpDzumo2fLOLAah6WnZg9kSkzxhcXcwWsAq6eF5qJUoQkobILXHk7WI2Kras92La59l5k6kxIyAt0KkFGTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667019; c=relaxed/simple;
	bh=C6EQWvEVceLQsxjTMxLRRmkzuXTCvMoBnaG/RW98P/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSR22q+kiLQbKwR1iqaFGVShMZ3tHsWyPXo1vnnrdlEWGjQp/FRgi8kKh5YaHzPSyRpdqDaZKoBqDAkilKVNitfa5HO3fjrzjtyUPsZKe2Lp+jfQn/8mztf/0h8hNYTRseGZ36CqrZ4CiaS+FAeR/Pful3Up1WStilZ9pchgvGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9qZ0gl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9qZ0gl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3579B1F000FF;
	Thu, 17 Sep 2026 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667017;
	bh=+lAKwihKtKKxYcFkWXxCxnMJ51VZX5CYoZBSPV6n9Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9qZ0gl1gv07H5BDZhW2gAHv3aEAqbY0WTGoJZNROpANoCjF2M6j4mR1QunS6Lc2g
	 8oI5A233PZtUm731ZA5W1cujRf8P/nhsZPK5a94nRTJWXK9xSLbqWgcCUhqnQU1nNF
	 Azo6Zss3VHU4Qurf7ynxaUWuD2zWlDTaUGFnlsmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1202/1250] drm/amd/display: Propagate HDMI RGB quantization selectability
Date: Thu, 17 Sep 2026 16:16:37 +0100
Message-ID: <20260917151624.860927047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyajit Roy <sroy14@alum.utk.edu>

[ Upstream commit bdcd0411d7d186225a52458fd42bb70d54ca917a ]

DC uses dc_edid_caps.qs_bit when constructing the HDMI AVI InfoFrame
quantization-range field. Although DRM parses the sink capability into
drm_display_info, DM never copies it into the DC EDID capabilities. The
field therefore remains zero and the AVI quantization range stays at its
default value.

Copy rgb_quant_range_selectable for HDMI sinks and extend the existing
EDID-capability KUnit test to cover it.

Fixes: 6eb4c13a3845 ("drm/amd/display: Support "Broadcast RGB" drm property")
Signed-off-by: Satyajit Roy <sroy14@alum.utk.edu>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 892659399f64642e33072562a11ec1b2e7bd2263)
Cc: stable@vger.kernel.org
[ added a standalone HDMI condition because the upstream HDMI/FRL block is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -156,6 +156,9 @@ enum dc_edid_status dm_helpers_parse_edi
 
 	edid_caps->edid_hdmi = connector->display_info.is_hdmi;
 
+	if (edid_caps->edid_hdmi)
+		edid_caps->qs_bit = connector->display_info.rgb_quant_range_selectable;
+
 	apply_edid_quirks(link, edid_buf, edid_caps);
 
 	sad_count = drm_edid_to_sad((struct edid *) edid->raw_edid, &sads);


