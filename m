Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573DCFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A6EC433D2;
	Mon, 15 May 2023 17:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171464;
	bh=NID4KUmXriX4ekkz0vYmBRkVlbhxHL5dCiwxSe+d5tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoCOyLA/QCy9ej42qPKh8oOyZdG17z4c58DcqIEQ2DSympvRVLIU8uqupBdGu+rNs
	 vLU2maLSLKQgEgSSHZvZs3m06OpLXS+43ViTt0GPNGXbLlmHmL1UeEatHSO/qDAyZU
	 lX6ONM31L3r3zHrbm8fjMf2o3Is5Oo/7CHODZApk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Leo Chen <sancchen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 218/242] drm/amd/display: Lowering min Z8 residency time
Date: Mon, 15 May 2023 18:29:04 +0200
Message-Id: <20230515161728.464253574@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Chen <sancchen@amd.com>

[ Upstream commit d893f39320e1248d1c97fde0d6e51e5ea008a76b ]

[Why & How]
Per HW team request, we're lowering the minimum Z8
residency time to 2000us. This enables Z8 support for additional
modes we were previously blocking like 2k>60hz

Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Leo Chen <sancchen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 33d8188d076ab..30129fb9c27a9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -887,7 +887,7 @@ static const struct dc_plane_cap plane_cap = {
 static const struct dc_debug_options debug_defaults_drv = {
 	.disable_z10 = false,
 	.enable_z9_disable_interface = true,
-	.minimum_z8_residency_time = 3080,
+	.minimum_z8_residency_time = 2000,
 	.psr_skip_crtc_disable = true,
 	.disable_dmcu = true,
 	.force_abm_enable = false,
-- 
2.39.2



