Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0AE7DA9E;
	Thu, 15 Aug 2024 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729717; cv=none; b=omH8RDkYMIT8gPvkz1yU2O39Ea2ApweFIjAtcdiZrj5sypWqO3CavIE6R/YrkKKJzrbR11YVK/xYz1OJNDX19m02odqYxshV8ZyvYPAz934UJR9xFA3eVIjzwajvtpcIsF9Opc32pgHHtt1tVEn0Hgl43qjnbW+cn6a6hblYiHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729717; c=relaxed/simple;
	bh=JhOjEHZD7XRQjpAMffuZi8NLc1VII+ZAlcYneU653yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddaLyzz803Fd/F7RBbFPR4pE3zXgNfHP2kpiZCx8Z+AIV+F2zl8o/GiHpVe/w51pbG+Nu+cmwu11/f97/DKH0qsr4CDZkWMRCYy2H8NgMpK1FRXCYC/yfVGvMvuAAGFjQD9NrnWrWKC9MnohrLtX2m5cWYx714XQgS7Dv4kYbAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGm9HZt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGm9HZt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE13C32786;
	Thu, 15 Aug 2024 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729717;
	bh=JhOjEHZD7XRQjpAMffuZi8NLc1VII+ZAlcYneU653yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGm9HZt8icpO6ljKl8BeaQ2nuE+kVjRWe2pHLA2GIF8NknVGZ+w5SWE1NG2ZCyXcJ
	 Qj0AyDGzyrXkprAxN7fyKUsiaOypzW5svI27Jo51DbiEDPJNI4gkzQFpmmts8UVO1P
	 SS6gSz9CIH0Dj9NPW71B7+7AoJgEDqQj/vF7htX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Xi (Alex) Liu" <xi.liu@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 5.15 185/484] drm/amd/display: Check for NULL pointer
Date: Thu, 15 Aug 2024 15:20:43 +0200
Message-ID: <20240815131948.560641059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Joon Kim <sungjoon.kim@amd.com>

commit 4ab68e168ae1695f7c04fae98930740aaf7c50fa upstream.

[why & how]
Need to make sure plane_state is initialized
before accessing its members.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Xi (Alex) Liu <xi.liu@amd.com>
Signed-off-by: Sung Joon Kim <sungjoon.kim@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 295d91cbc700651782a60572f83c24861607b648)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -154,7 +154,8 @@ const struct dc_plane_status *dc_plane_g
 		if (pipe_ctx->plane_state != plane_state)
 			continue;
 
-		pipe_ctx->plane_state->status.is_flip_pending = false;
+		if (pipe_ctx->plane_state)
+			pipe_ctx->plane_state->status.is_flip_pending = false;
 
 		break;
 	}


