Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CF35A9877;
	Thu, 17 Sep 2026 15:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658950; cv=none; b=ep5O66cE9gZFIxOXvQmpIAibcj4SDLRziM1/f0hwd01GhLN3RneW1ED4CHIjJLuIaiA5WC20J3n0idNJ2bDJWMw0JIQZUZLl5kGS0Yy3uvP17BgS7bzDuN+mMKGvPJ/VosZ7Aiqvlcuf3iBMyw+BI8qVzAvopSjL3RvG2MzDFfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658950; c=relaxed/simple;
	bh=Ke0r8TEU0/Znwnjv5zN/HlUN1PMpAqmLqjWXI7Lkg1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=btgfFBw9eHrRlDlsncW6IBr4NUUHp+DsAkOFD5wh5oaCOV0BlhSOFjrlH8styMTljosPl9jkWlNj9dKO0ipM9e21hIeWcYhZSr0BUmndAAg5Z9bbtVULO8277X0UcJZNAjmMSiDag7opM0RoyV4VKc2mrqt1ZyEVltbiQVkjObQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wy6+/Cmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wy6+/Cmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60731F0089A;
	Thu, 17 Sep 2026 15:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658943;
	bh=Uy2DI1FMOJnfOtFB0/Po6WOVBrtNdqVserSNsKQSGJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wy6+/CmjZ7gURVmoyuVBM5kClP7AIzKcTdOc7nWn/frWLx5nTUb31CqgOjscKwFt9
	 LQVI+T36OXnlTzJBFvWjXaWNO77UHILDfxwWuvb/RrXHQfStqst71KiJNVbNLWOWMU
	 drE8JXgGmeUt2wCjCIYkWrXyMSgIb2CgqIGO85yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Nemesa Garg <nemesa.garg@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 092/733] drm/i915/dp_mst: Remove duplicate intel_pfit_compute_config() call
Date: Thu, 17 Sep 2026 16:06:40 +0100
Message-ID: <20260917151353.219698002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

[ Upstream commit 6463655ab2946d13d2ec5efe04a5c2bf9d675f01 ]

mst_stream_compute_config() called intel_pfit_compute_config() twice
in a row.

commit 5ce9ac1531b8 ("drm/i915/mst: Call intel_pfit_compute_config()
for sharpness filter")
was erroneously cherry-picked to the fixes tree while
commit ca97f5546f19 ("drm/i915/mst: Call intel_pfit_compute_config()
for sharpness filter")
was already in there.

Drop the redundant duplicate call.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Nemesa Garg <nemesa.garg@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Fixes: 5ce9ac1531b8 ("drm/i915/mst: Call intel_pfit_compute_config() for sharpness filter")
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Nemesa Garg <nemesa.garg@intel.com>
Link: https://patch.msgid.link/20260806074819.2631970-1-chaitanya.kumar.borah@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: adjusted commit message]
(cherry picked from commit ea9f3470d33602fb776ea55443467baacf66f23a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 0aa3e6b4c781d..bcdc504913471 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -722,10 +722,6 @@ static int mst_stream_compute_config(struct intel_encoder *encoder,
 	pipe_config->sink_format = INTEL_OUTPUT_FORMAT_RGB;
 	pipe_config->output_format = INTEL_OUTPUT_FORMAT_RGB;
 
-	ret = intel_pfit_compute_config(pipe_config, conn_state);
-	if (ret)
-		return ret;
-
 	ret = intel_pfit_compute_config(pipe_config, conn_state);
 	if (ret)
 		return ret;
-- 
2.53.0



