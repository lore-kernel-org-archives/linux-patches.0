Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF856FAF;
	Tue,  5 Dec 2023 03:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRwf+I43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3504C433C8;
	Tue,  5 Dec 2023 03:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747006;
	bh=TwQreJSv98emWBiRnr3mrfEB+aT02kbK4lTDwWB5h8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRwf+I433H+AUMHP+1d0xjX42m7151IifJHC+sdo7YY8qzkvFd30FcBATu+vu5IZi
	 6yK0QllgP3FnT97tYrH/1GniiVmgQRhw+DFdwI1+z/csOna0LOXyiW/MySkr/Mq8Xn
	 ROokaZMWje89yv6L6k1h4TVLdyj+FSZdzSTSe10w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Hassan <syed.hassan@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 024/107] drm/amd/display: Update min Z8 residency time to 2100 for DCN314
Date: Tue,  5 Dec 2023 12:15:59 +0900
Message-ID: <20231205031533.112008269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 4636a211980052ca0df90265c8a3ed2d46099091 upstream.

[Why]
Some panels with residency period of 2054 exhibit flickering with
Z8 at the end of the frame.

[How]
As a workaround, increase the limit to block these panels.

Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Syed Hassan <syed.hassan@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -884,7 +884,7 @@ static const struct dc_plane_cap plane_c
 static const struct dc_debug_options debug_defaults_drv = {
 	.disable_z10 = false,
 	.enable_z9_disable_interface = true,
-	.minimum_z8_residency_time = 2000,
+	.minimum_z8_residency_time = 2100,
 	.psr_skip_crtc_disable = true,
 	.disable_dmcu = true,
 	.force_abm_enable = false,


