Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BF41DFFB;
	Thu, 15 Aug 2024 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732302; cv=none; b=Jq+FMDww5DRsB3lpVT/fwskHV29RmZK4gXZUczd4uhq8TmKtAd7w6ZDzGOg3/nEeA9cAtM10h/Ugaz1gJK/TJHPwppjpbdHYeIQIG3GoHvCaTlqnfDduC02ofrA5xRbsvJ9qrSBHNcoZbwUeNPsh4Lpl12OhnSSBo87de1IB1v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732302; c=relaxed/simple;
	bh=evtyuRPXWwoHkcVnKUEi91Vso1pcdJAfhtEa3F4OVE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRqgtqDDs080oWY4HQPPU/LoPve/kUoUy4vgiE0RfwuuXCOGbF50ZWbkHfWZv/aICIWpwfsMwHvzwIcr/mO6pkSco6HA8lVsHWQtsdUif19DBrmvFLy+jfjLlAuD0Hrs+ZsxfWU3zzjwhJKTYGnran/olngl8z/04mufCRTidZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnC2qpp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnC2qpp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0CCC4AF0D;
	Thu, 15 Aug 2024 14:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732302;
	bh=evtyuRPXWwoHkcVnKUEi91Vso1pcdJAfhtEa3F4OVE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnC2qpp9+MHZwlmbCmQQIGpdYlaqKN2zUhrOJA8hnoYsPYSIbLGksPAW4rz0hfJR9
	 VcB/1wEgmJHmmQhxZhKPuDzF+6YYiGYOWMdmUvzx2lk8umxyp1PXcJgjq4c87x9sKx
	 njGiNkYMVOJ0e9INblmiRI8dlB5nYpz4IIV8JmRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Xi (Alex) Liu" <xi.liu@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 5.10 137/352] drm/amd/display: Check for NULL pointer
Date: Thu, 15 Aug 2024 15:23:23 +0200
Message-ID: <20240815131924.550474002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


