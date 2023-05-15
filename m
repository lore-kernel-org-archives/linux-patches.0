Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84242FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0CBC433D2;
	Mon, 15 May 2023 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170670;
	bh=uBCu9ZyeeopvD/INzCFebKngTZmfR0eGk5DzcVGNg8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au9z/ppfOCqOKeUoTtyDfkoemMBjHGSABLZfWFN2a+oZOsP0WDayT1n623eUU1atN
	 hngZBPtoC0Zi5dQWbtqtnSiWqR8Q8k/ickUQG09aXgzuvnWURIVtOIJiIMYJgpp671
	 vxwDoJirEIH0HldtoGUelXh5xGSnEQs/UfSuyLPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/239] drm/amd/display: Update minimum stutter residency for DCN314 Z8
Date: Mon, 15 May 2023 18:27:47 +0200
Message-Id: <20230515161727.849211274@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 0215ce9057edf69aff9c1a32f4254e1ec297db31 ]

[Why]
Block periods that are too short as they have the potential to
currently cause hangs in other firmware components on the system.

[How]
Update the threshold, mostly targeting a block of 4k and downscaling.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d893f39320e1 ("drm/amd/display: Lowering min Z8 residency time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 67c892b9e2cf5..ca3aabdf81d2f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -884,7 +884,7 @@ static const struct dc_plane_cap plane_cap = {
 static const struct dc_debug_options debug_defaults_drv = {
 	.disable_z10 = false,
 	.enable_z9_disable_interface = true,
-	.minimum_z8_residency_time = 1000,
+	.minimum_z8_residency_time = 3080,
 	.psr_skip_crtc_disable = true,
 	.disable_dmcu = true,
 	.force_abm_enable = false,
-- 
2.39.2



