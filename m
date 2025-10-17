Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB33370F7;
	Fri, 17 Oct 2025 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714322; cv=none; b=LBNlRrs/muGhHSIzfCjfJ/86AGEJwtRlzjs8atc2nnyk42p4whowrw+tfXg64mPpGTFp6utVxtqsWPWN1Nc+vdEeuZBmIx4k2erEv6dUfwn4JK5yRm9oQ5y7uFMZPHLb3V7UHtS5hK51X12jNEBwf6tNC1jq5OHTSNS1+bkfJ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714322; c=relaxed/simple;
	bh=OTWiNS7NCp/NPya3o2EbZSj1oJ6CE3WKEVhCPMrmMKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4yq7Z6jop2IILHdsaeEV3nDlJpyo3/i6vJ2Zhld8ZWOeZGEyJVFDNVvOMwyd5u+qO/7a3C68qxWNl+nILUtj82K7reUP0uUH0Un3o/V6VMkqVBAwPaBoo1D82uwR4wCbFUI3d90Qejo4GZUWrTV4KKLekw7fXodR2MOzrz14Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4oDZyiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4oDZyiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C92CC4CEE7;
	Fri, 17 Oct 2025 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714321;
	bh=OTWiNS7NCp/NPya3o2EbZSj1oJ6CE3WKEVhCPMrmMKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4oDZyiAuxFT7nsICfsm/XODkaKzdJVuD1fOeRQ93XYcRMl9yvIOsqjkf4nUGpXpy
	 J/rxJVAYy0xVNwA9b90W15yBjC1qrMAmCBkeJVZO1nr4Sym5XuuhdyUdtIZ92rU9wh
	 /k3gxeL4CuE1n8tbZMdv001dU5vHe6us/FeRgqn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/277] drm/amd/display: Properly clear SCL_*_FILTER_CONTROL on DCE6
Date: Fri, 17 Oct 2025 16:51:18 +0200
Message-ID: <20251017145149.734068364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit c0aa7cf49dd6cb302fe28e7183992b772cb7420c ]

Previously, the code would set a bit field which didn't exist
on DCE6 so it would be effectively a no-op.

Fixes: b70aaf5586f2 ("drm/amd/display: dce_transform: add DCE6 specific macros,functions")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
index 2b1673d69ea83..e5c2fb134d14d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -527,8 +527,7 @@ static void dce60_transform_set_scaler(
 		if (coeffs_v != xfm_dce->filter_v || coeffs_h != xfm_dce->filter_h) {
 			/* 4. Program vertical filters */
 			if (xfm_dce->filter_v == NULL)
-				REG_SET(SCL_VERT_FILTER_CONTROL, 0,
-						SCL_V_2TAP_HARDCODE_COEF_EN, 0);
+				REG_WRITE(SCL_VERT_FILTER_CONTROL, 0);
 			program_multi_taps_filter(
 					xfm_dce,
 					data->taps.v_taps,
@@ -542,8 +541,7 @@ static void dce60_transform_set_scaler(
 
 			/* 5. Program horizontal filters */
 			if (xfm_dce->filter_h == NULL)
-				REG_SET(SCL_HORZ_FILTER_CONTROL, 0,
-						SCL_H_2TAP_HARDCODE_COEF_EN, 0);
+				REG_WRITE(SCL_HORZ_FILTER_CONTROL, 0);
 			program_multi_taps_filter(
 					xfm_dce,
 					data->taps.h_taps,
-- 
2.51.0



