Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590516;
	b=VYO7ked0Lw4Qt986Aal78tvsfAQaP924AvHOma6FaoZAzTyNoRxLOsRqL4UgjXbx262z
	 Dyni5Zl8xWw3XZMDGC4jiyESGLSqwqFq1hJCfUx3JuGoJywisRbMY7rIM8i15YWX4W3GR
	 aVDe6ZHDHudkTUgKww6kLC5iSUhziG+kpRCF/IklddIcdRMmKCCzjwGCE+j3NrW8u19CF
	 j7wiobMJYD9YmaqnqEJGInBJRZaYILn1VPoLi33hmgzE7qwEmHpG3L8wG7N817w6V9beB
	 y33aiY/QmpGwKV7zIJE1nQsBR9rmOxX8o7bAuBVigxEPdnXGuYFBMYJp79Hrq9dO9Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CEtCfOtQEJ4evPz5H4kvkCsu5gQTUVv78QPROoKI4lg=;
	b=1NoZ0fDDgSND4S4U0QESXoOUodseZGDY2bUzApnqTPLGc2IUlutaDPafiIooZd4/PG2m
	 Oqh7LiRHUHqTqJx6a0EiYGUGW401xQWQs33W6b+l1HQHnny/m2w+/gioZjS+lUmZkMm9d
	 ZP4Xsccwi6Y5YPIprUCjicmxf2cNSyrmNYiUWkdw2iEItxPBET7O5pxnZV1A6m5bQcOWb
	 NCWolNXNPXUj34Nce7FZhe0qiGSUZCcCdMYf7Y0ETpEW5LGdpnUTth6NbAPTaySZ1E8b8
	 4LfQnynIk+A96BhYxE3q5FFph0hB4FVXG9TG+DtO3JSVQEAsQfjHdjrTdh3oz+HGrnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RV9CMVaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FAE606A8A7;
	Fri, 13 Nov 2026 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RV9CMVaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0625F1F000C6;
	Fri, 13 Nov 2026 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590516;
	bh=CEtCfOtQEJ4evPz5H4kvkCsu5gQTUVv78QPROoKI4lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RV9CMVaRwhfCLAzpG1dxSLytn/TS6pnX+pTBltlB49qQ/vJPnbkE2khgFfIL7fqwq
	 S+zbX8X5FnXLnGEu9SZNxg5QzKlQZQN/GPYq2fSHB+9OdlhQyFtEMKuFD+Qc0idGpL
	 JZXdTmJASV+OwhGuswkG3+5JtQI1o5JHGv8Uc+nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/686] drm/amd/display: Fix NULL deref in dcn401_update_clocks_update_dtb_dto
Date: Fri, 13 Nov 2026 10:49:01 -0500
Message-ID: <20261113153834.806270064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Demidov <roman.demidov.nn@gmail.com>

[ Upstream commit 7fac15d009cf236677a8cddf6bc0e8c85666ac3b ]

[Why]
resource_get_otg_master_for_stream() can return NULL if no OTG master pipe
is found for a given stream. The current code dereferences this pointer
without a NULL check. This may lead to a possible NULL pointer
dereference.

[How]
Add an explicit NULL check and skip the stream if the OTG master is not
found. This is similar to dcn60_update_clocks_update_dtb_dto().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b6d508533fa1 ("drm/amd/display: fix a crash when clock source is reference for non otg master pipe")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ffde3d74c1faeeb645b66d02d02fdae3e073941b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
index 306016c1f109c..8f53a1f228f59 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
@@ -535,6 +535,9 @@ static void dcn401_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr
 		otg_master = resource_get_otg_master_for_stream(
 				&context->res_ctx, context->streams[i]);
 		ASSERT(otg_master);
+		if (!otg_master)
+			continue;
+
 		ASSERT(otg_master->clock_source);
 		ASSERT(otg_master->clock_source->funcs->program_pix_clk);
 		ASSERT(otg_master->stream_res.pix_clk_params.controller_id >= CONTROLLER_ID_D0);
-- 
2.53.0



