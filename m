Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EA742FCD8;
	Thu, 30 Jul 2026 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421608; cv=none; b=gJQFq7dCgLF4HmSOF6DeNTozeyi0nBkhObh1qt8cPhncD6rVHyX41MwLV1xjNgJtKEVFL94O4c9ah+Lsp325xdVKuSsfrGQFep8T5VwOrf+GlFNzNRHh7DN+PeK4pRm3bqtG5J6qMErNwWm0pXJrUuP3eZ34yEbvUq9IceKlQXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421608; c=relaxed/simple;
	bh=/FTTnpCamhUct2ynOBFtN8kIYr5AO/Psuu1CcwjWXvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ECNxisUGy3S2dNdHwpPNi1XxOtzzjZYDuKA9xCSmAvUrptQBWUnsFoRWE6KFLwMFuiE1lVIWY+/BCOORQ+7HGOotzVZNpyC/Rnv6J1AK5E3+6YBAgaPdMWPbMVOT9EUmLwbdrAD1WObaFJCh7RDQz4ths8tJy05HNcCHXi/wqgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKB6JADt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKB6JADt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251E41F000E9;
	Thu, 30 Jul 2026 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421607;
	bh=qBpPnG3znnjOnqz/AXNoHtc71h7Fw6RftGfAAEl0kJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKB6JADtfc5udnDrqHOtZeU0dtRpPdc/4atRVfTkXkWFTwJ7fyJnyK+acAFrOw9xG
	 EDst1o2l6CpMWQGYdwvv04Vcz5+i+IUEYQ2Wsx2fE6wKtsLdY3HAqOhHqHGjMK6BDW
	 yGhIwZQ+3XR8VydtHItT9ebnVLo5TeuL7Nfga+hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanyu Tseng <Chuanyu.Tseng@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 160/744] drm/amd/display: Fix preferred link rate for NUTMEG
Date: Thu, 30 Jul 2026 16:07:13 +0200
Message-ID: <20260730141447.693501664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 9fb646bc4d87f62bcbf0a7ea326430eb802c475c ]

When there is a preferred link rate setting, it needs to be
applied to both the current and initial link rate.
This was regressed by a "coding style" fix, which caused
the current link rate to not respect the preferred value.

This commit restores the functionality of NUTMEG,
the DP bridge encoder found on old APUs such as Kaveri.

Fixes: a62346043a89 ("drm/amd/display: Fix coding style issue")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5465
Cc: Chuanyu Tseng <Chuanyu.Tseng@amd.com>
Reviewed-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e78b0a367f8690b682029d90e75308dc84ed51de)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 782a45caa13d4a..c9c76b8c3e3ba2 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -750,8 +750,10 @@ static bool decide_dp_link_settings(struct dc_link *link, struct dc_link_setting
 	if (req_bw > dp_link_bandwidth_kbps(link, &link->verified_link_cap))
 		return false;
 
-	if (link->preferred_link_setting.link_rate != LINK_RATE_UNKNOWN)
+	if (link->preferred_link_setting.link_rate != LINK_RATE_UNKNOWN) {
 		initial_link_setting.link_rate = link->preferred_link_setting.link_rate;
+		current_link_setting.link_rate = link->preferred_link_setting.link_rate;
+	}
 
 	/* search for the minimum link setting that:
 	 * 1. is supported according to the link training result
-- 
2.53.0



