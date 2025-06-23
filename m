Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D0221545;
	Mon, 23 Jun 2025 21:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712911; cv=none; b=kGF1ElOvQNIxZbfSIWVHLfYfCdEuMdrat3TcjLV7jYsDZvnJEgdolK5MFeJAui9phSxf/V7XSIhgL7zrlzGa5/75nSHaq1g1nnqNUqSSwC1E0V/LCBUoXU1SuKeFc6k9Kr+PLmQLNpPd21yYpDzrBD/2jPP2OwfyyK1HfvAMVdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712911; c=relaxed/simple;
	bh=gWIbUmHzYALz6ttfCMAPmqo12ble2N9WSqMsCQgitE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+TDAu2H4vhH8ZmQ2YMvAWrRii5NVyldh1skI011gvVxsusyZsR7rrI6moG1huvA8PJ6Q5oqOBYqC6RSuW9YMJH4CZzZGP6CBCotsI7VFvqq5nLjyPbVIco2VK44N1I1oT4UK4W9WUMq2F1G0I8m5vpiYcPrRKQhjY5B5z+QVYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cexD/rzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cexD/rzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838C9C4CEEA;
	Mon, 23 Jun 2025 21:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712910;
	bh=gWIbUmHzYALz6ttfCMAPmqo12ble2N9WSqMsCQgitE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cexD/rzQdFPsEEPTwoat/82g95wlVg4vgN0eygRvjtrjB+QZ8lvlMYIB6PI8AFET6
	 gOlP2a2AeFjtv8f4aLKsZ28bEPYT9O+NLYkUQ5SG3HTFkg3BIk6l0JU2QqgCuzHKCv
	 ctDJy728b6kb6o4z6HG6BO4NfroEjV7JHfufz+OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Samson Tam <Samson.Tam@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 291/592] drm/amd/display: disable EASF narrow filter sharpening
Date: Mon, 23 Jun 2025 15:04:09 +0200
Message-ID: <20250623130707.289568425@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit c8d7e0be8183f4375a5cf5c3efd0c678129ea4de ]

[Why & How]
Default should be 1 to disable EASF narrow filter sharpening.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c b/drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c
index 28348734d900c..124aaff890d21 100644
--- a/drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c
+++ b/drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c
@@ -1297,7 +1297,7 @@ static void spl_set_easf_data(struct spl_scratch *spl_scratch, struct spl_out *s
 	if (enable_easf_v) {
 		dscl_prog_data->easf_v_en = true;
 		dscl_prog_data->easf_v_ring = 0;
-		dscl_prog_data->easf_v_sharp_factor = 0;
+		dscl_prog_data->easf_v_sharp_factor = 1;
 		dscl_prog_data->easf_v_bf1_en = 1;	// 1-bit, BF1 calculation enable, 0=disable, 1=enable
 		dscl_prog_data->easf_v_bf2_mode = 0xF;	// 4-bit, BF2 calculation mode
 		/* 2-bit, BF3 chroma mode correction calculation mode */
@@ -1461,7 +1461,7 @@ static void spl_set_easf_data(struct spl_scratch *spl_scratch, struct spl_out *s
 	if (enable_easf_h) {
 		dscl_prog_data->easf_h_en = true;
 		dscl_prog_data->easf_h_ring = 0;
-		dscl_prog_data->easf_h_sharp_factor = 0;
+		dscl_prog_data->easf_h_sharp_factor = 1;
 		dscl_prog_data->easf_h_bf1_en =
 			1;	// 1-bit, BF1 calculation enable, 0=disable, 1=enable
 		dscl_prog_data->easf_h_bf2_mode =
-- 
2.39.5



