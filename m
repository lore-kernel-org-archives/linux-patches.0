Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D971466B58;
	Tue, 13 Oct 2026 12:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893837; cv=none; b=XRTR4HGYzOlt9OKRarH0PlHV2pTJWx6bozqoYBLVnVgAn7l8O/R7YPKn5vM/zc1TN/rKZj7Sy4mwDzcj7wtx6t0KnxbP1cr8ADZq5khoiY2PcNWmPzItX1aQ+zaHEkpBX0Pfp10+rCacvfr0B9I7i/JrkDfBweNRYKL2oukIdmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893837; c=relaxed/simple;
	bh=nwQMid1JLwPTLORmTtAik4ijX5KuldWGf2dj8G8iXuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHfZz4CAlifcmlU4zxluCaIRCuJO7s+jHAz0HEbhsi0fNDuxSyRO35kDkMoibvJFjab/nmTkCof+CK/nfW66XHIlw8799H99Bfxesg3SUEFsFMDO1Jt//pcfH66BNww4PqxVo04rB58ppvTn+jcv3maK4Mqp80jqr8UR/vbjC/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhekN7Go; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhekN7Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F641F000FF;
	Tue, 13 Oct 2026 12:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893836;
	bh=MFFKQMWdItgEKkBzxTDfGRE8yS/lZF/zN864WHH2puQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhekN7GoMUQfBgLABKzVRwzWi9is+BJLTX4iuGgMM+D/Wul/IEYCBObXeBO6UVFNb
	 Ri2JNwcbNYpBTGzB2UOxOH9nXSwL7dRjl6y2ShTRCwUdJfJfUuVFHsMxWjBt2BTnLK
	 JxDjfRVTBcbuNg19fB3HOsRlu/Dup2/CqYtgSIBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/621] drm/amd/display: check if dml21_add_phantom_plane() is successful
Date: Tue, 13 Oct 2026 13:35:55 +0200
Message-ID: <20261013112929.392202164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 000acb4ce7fb9feba3072ce468ad681f6585cd5d ]

Verify that the phantom plane was allocated to avoid a later
segfault.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4970
Fixes: 70839da63605 ("drm/amd/display: Add new DCN401 sources")
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5adb54abe5a8e82cbff7f8806db30a5f4924329f)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dml2/dml21/dml21_utils.c   | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_utils.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_utils.c
index ee721606b8839..971d0756c2ad2 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_utils.c
@@ -357,14 +357,13 @@ void dml21_handle_phantom_streams_planes(const struct dc *dc, struct dc_state *c
 					main_plane = main_stream_status->plane_states[dc_plane_index];
 
 					/* create phantom planes for subvp enabled plane */
-					dml21_add_phantom_plane(dml_ctx,
-							dc,
-							context,
-							phantom_stream,
-							main_plane,
-							&dml_ctx->v21.mode_programming.programming->plane_programming[dml_plane_index]);
-
-					phantoms_added = true;
+					if (dml21_add_phantom_plane(dml_ctx,
+								    dc,
+								    context,
+								    phantom_stream,
+								    main_plane,
+								    &dml_ctx->v21.mode_programming.programming->plane_programming[dml_plane_index]))
+						phantoms_added = true;
 				}
 			}
 		}
-- 
2.53.0



