Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AF326B086;
	Thu, 13 Feb 2025 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458693; cv=none; b=HvARWgJpq+eC01j92O9d00qSWsgCDUYgK0hqzYqyjnzfVfZxX0iTGWpy3ElAOtYQUtGcl7pVdxRxKb3pWfnvfxY8ds4D6wwg7LaWUJRUOMW5MVCRUnANnE9RLuZ0idOVUlnCrX3UC8GLR2fVlu6EFAetBb9hjmt0vjtqLPqsV0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458693; c=relaxed/simple;
	bh=Y9s7IGnxPX1xkib6ecwh/Ts3C4GJWahBeiavThO7Ogs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2ccQBzSi7fg3K8eYlAQudyPOrYOb0wSVgoDBcUPpCGL6rYp0VS27NgoV7Cc/MpGn5467Uv6LHojioaz9rJKDkkePIuyUzo/i6QFsa/+0SpOoKEx5vwVwPJ++nBBN3mRvPF/LmtE/rJOHbzP/zBZpjJd/+afROZZuGQSN+gUhMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1QIwALF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1QIwALF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E41C4CEE7;
	Thu, 13 Feb 2025 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458692;
	bh=Y9s7IGnxPX1xkib6ecwh/Ts3C4GJWahBeiavThO7Ogs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1QIwALFHiAQpnPQzd7YkRkgOBqYCNMF5nKp4++aWoX3B6fGiDPQR8lfsBHDi7wQB
	 w1f5m44n6WNlFmqinkM8SCOXcdXPDJ4Yz5+jA8oN8z90r4twKrBOuB3oGex2bBGJjq
	 8Ju0mxQHMF43UQboGD4p7nDAuze/uc2m2I1vMxmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Gabe Teeger <Gabe.Teeger@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 051/443] drm/amd/display: Limit Scaling Ratio on DCN3.01
Date: Thu, 13 Feb 2025 15:23:36 +0100
Message-ID: <20250213142442.590591396@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabe Teeger <Gabe.Teeger@amd.com>

[ Upstream commit abc0ad6d08440761b199988c329ad7ac83f41c9b ]

[why]
Underflow and flickering was occuring due to high scaling ratios
when resizing videos.

[how]
Limit the scaling ratios by increasing the max scaling factor

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Gabe Teeger <Gabe.Teeger@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/resource/dcn301/dcn301_resource.c  | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c
index a9816affd312d..0cc8a27be5935 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c
@@ -671,9 +671,9 @@ static const struct dc_plane_cap plane_cap = {
 
 	/* 6:1 downscaling ratio: 1000/6 = 166.666 */
 	.max_downscale_factor = {
-			.argb8888 = 167,
-			.nv12 = 167,
-			.fp16 = 167 
+			.argb8888 = 358,
+			.nv12 = 358,
+			.fp16 = 358
 	},
 	64,
 	64
@@ -693,7 +693,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
 	.performance_trace = false,
-	.max_downscale_src_width = 7680,/*upto 8K*/
+	.max_downscale_src_width = 4096,/*upto true 4k*/
 	.scl_reset_length10 = true,
 	.sanity_checks = false,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
-- 
2.39.5



