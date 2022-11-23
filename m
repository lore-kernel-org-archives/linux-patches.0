Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E33A1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BCAC433D7;
	Wed, 23 Nov 2022 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197169;
	bh=AAKqkl3uqeuK4e2cWRPZJ4l3NWqe3HZuYSnLijkIz74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMNyelZcP4Betv7CqJHKibp9ZPrUQnPP0dp/c+zXJzp6/FN/wWhs6YV4N1cz+U84y
	 JtwhbUyxP4t8vpPUYzRMZchSuR/+w08bFiW2/TvP45EySuLOsx55IgyvWFl4n6uIZx
	 7PeA1WWED0gpHUKy8FPNccmnT+hnNlXFYJj8mg1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 218/314] drm/amd/display: Fix optc2_configure warning on dcn314
Date: Wed, 23 Nov 2022 09:51:03 +0100
Message-Id: <20221123084635.420464398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roman Li <roman.li@amd.com>

commit e7e4f77c991c9abf90924929a9d55f90b0bb78de upstream.

[Why]
dcn314 uses optc2_configure_crc() that wraps
optc1_configure_crc() + set additional registers
not applicable to dcn314.
It's not critical but when used leads to warning like:
WARNING: drivers/gpu/drm/amd/amdgpu/../display/dc/dc_helper.c
Call Trace:
<TASK>
generic_reg_set_ex+0x6d/0xe0 [amdgpu]
optc2_configure_crc+0x60/0x80 [amdgpu]
dc_stream_configure_crc+0x129/0x150 [amdgpu]
amdgpu_dm_crtc_configure_crc_source+0x5d/0xe0 [amdgpu]

[How]
Use optc1_configure_crc() directly

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
@@ -237,7 +237,7 @@ static struct timing_generator_funcs dcn
 		.clear_optc_underflow = optc1_clear_optc_underflow,
 		.setup_global_swap_lock = NULL,
 		.get_crc = optc1_get_crc,
-		.configure_crc = optc2_configure_crc,
+		.configure_crc = optc1_configure_crc,
 		.set_dsc_config = optc3_set_dsc_config,
 		.get_dsc_status = optc2_get_dsc_status,
 		.set_dwb_source = NULL,


