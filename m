Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E812A37DEBE;
	Sat, 17 Oct 2026 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254746; cv=none; b=o3B37H6XzEww7qPHaMeLa8v0fsQyqoSf66A32K6txHTZ70CjG+OeW9vBOmwkN1SkExKqdH07mM21i9VKsGpH91YjixtT+XHvbriHDpW64qh0DCqH8PnXgNNfUvfoom0BnKRLi5KQss5eJrSL0Fk9lTXgdlqD10BaHqQlBtc6cdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254746; c=relaxed/simple;
	bh=8PIVyy959YGC118kdRzFOW0N9yateoAm8frnTVt9UxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlsxMmxIAL1BjXjDdtQs5mfikA5KMfY66ZA8QLWotH0CWKda8l5paHKQcwyEZiyaL3/xFlfLT3gKMJaLQNzUmfzLhhtkD2/TlXA01XGYFdxcVPldIvjNKFwoWEXpkBeSBlyKBHn8vZXBA/d84zZYfSa7EVZZ2XdC7MUuqTogiLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQg+hq2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQg+hq2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B88E1F000C4;
	Sat, 17 Oct 2026 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254745;
	bh=wLDsB1MiirhSMQjy30qH6/56+KDq6v0Pp2QlqburseQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQg+hq2GauV5fL7PzDilIx3bJS13gydIlVYd6ROcf4Obxn6QUpzTTTJaLwmZC3Af3
	 uIR1TfySlHEtpoe2k+uLgFwbrHjuagyfhMV9WaIaQyFRlFFCJZNE+X7lVYoe8ZnfZ0
	 1Mi0xjMLztgpdXe2cdaCV+RqPvh2fEEDOUn/6Tq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 547/869] drm/amd/display: check if dml21_add_phantom_plane() is successful
Date: Sat, 17 Oct 2026 17:56:28 +0200
Message-ID: <20261017160051.116196758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 51d491bffa324..3f656e5dacf89 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_utils.c
@@ -457,14 +457,13 @@ void dml21_handle_phantom_streams_planes(const struct dc *dc, struct dc_state *c
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



