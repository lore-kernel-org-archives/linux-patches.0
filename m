Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591213;
	b=ofQ1YVFyOK0MONCVe3WjyAuMH3EJMZvaFMHfDZ/ni7crEpsSyeB0cv/LHCvsYelWTXdr
	 F45Cdxk6NN/Abpnw/pl27H97CrHQUx8BEESfvFSnG/kGwbgmBS923HeqWMclqH9vOwlbY
	 HEhVSgNqT8RLGGysFM8oCa8O50Hvz1xAAOwFPO/phAaut8EBFwp0Ubq4fKdLrpkkFPSof
	 Zr56K5u3XcKzQo/IppiZdItQXCRVZJLXNDwFwIOJmV4xrtzmf7UYEME40EufoYKkNO6bZ
	 8kDE1GjNhK4AB7hbqkgz/sitkY5zkQTsNd9d5U6cU2mTOPhmK+4zEt7g1bcI0kTRTkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5BC1KqzvTWOhLf2rGZoVlzhAM2N4VBDlXKJuaKeSMs=;
	b=uauxjvgPaiaQld8UBaF5JiJrCrJ696s9azZJ57JhwjjyirKuvmAaSKUS9sF7fhFP4gfK
	 qMk4bQTvVS6Ks6OnOyubgHlRlyvcvuzgMcRtTFoREBey5AUPKExVlPjeKvVOvIS+26McR
	 dYW+eQzbycgqW/d5VjMM/kFzLjm0LNpJOR/TQ6he/WRNZDxFfWFiwhaeZ7OsyZOPjj2ZZ
	 QRQrCrcdAZ61fAU3wljDq5PR7//+YCh60luGlN7tLv2foq1aRwfl5rC+DnvTvA5KMP0SP
	 zC5e7YMfA17A2esLjw7/rH52Zor1bLrMqm4Q1qA+4R7p9VxBvQFXeZPNgNQZTw+MFEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tLB/dAfW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DC06075854;
	Fri, 13 Nov 2026 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLB/dAfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDC91F000C4;
	Fri, 13 Nov 2026 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591213;
	bh=c5BC1KqzvTWOhLf2rGZoVlzhAM2N4VBDlXKJuaKeSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLB/dAfWe2KcHVV5b4aIW6m/Z9JViej3PIMh+AZHdoJf68Ns6EcAYPlvsS18/glGg
	 TV/6LYySru9Nt15iLME28/BEBEz1mbJzspAeK/nd+RxDw/+GUOrOrJ/KJPk8/RhkMY
	 xF/UnXK986IzHQGlWy75T+VL2hmpHXOz5v632wfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/670] drm/amd/display: Fix NULL deref in dcn401_update_clocks_update_dtb_dto
Date: Fri, 13 Nov 2026 10:48:31 -0500
Message-ID: <20261113153823.593835816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2ee034879f9ff..24b1103c88c86 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
@@ -511,6 +511,9 @@ static void dcn401_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr
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



