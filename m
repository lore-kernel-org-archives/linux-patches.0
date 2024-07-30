Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40443146D6B;
	Tue, 30 Jul 2024 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357447; cv=none; b=N1DIe794O5M8KY2sPtM/LAp9NqRjhy3QDhFBHPF8SMn2fVFUS7qWMGZ/OglIznrahW4CncK7RhqIi61y/E4LJnH7cK/szLAY+wW88wCyoaqTZWnrMbiPa3QE1Y6IVIL9+GUAF3VuiHn6eb9ouYd/iPUPy+nvmBuQdEexOUEPyoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357447; c=relaxed/simple;
	bh=5/GDnpXJ+kZ7xMBW4XcgjhWJ5rmJQp8moOikH9rVkMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg3KRHiBWFlvyVBoxH9xqZHVfTNJkgfncdOecH3kADZtT56GRlrBA6LK2G/mn+kb35Pio0DY0jGnEqp0PUvUC8ygRhufqWXny2gVbLADYA5ptuDNgm8sMxWaRDpDnjrYNTkgZ8OB3ujtbTcGoojlUUHCbEUcWewcQyWXH9kwj0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3WOPEoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3WOPEoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F9DC32782;
	Tue, 30 Jul 2024 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357447;
	bh=5/GDnpXJ+kZ7xMBW4XcgjhWJ5rmJQp8moOikH9rVkMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3WOPEoyTRCEqA7WF1/xPQ+1VUfTdIc6XMv6yb1G2/+WBG+cIz4b+0m0oOX73gVHq
	 6XFgBjHLE+DwO193HLC0BiTKVTn9E8ZzZygXGm3Em7t+Bvcpusx96p9WUsaS2MsOwa
	 PHs3YkwLD4iU//Qhw72rj/dfKrMoOKRrxz2KIYY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Xi (Alex) Liu" <xi.liu@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 6.1 293/440] drm/amd/display: Check for NULL pointer
Date: Tue, 30 Jul 2024 17:48:46 +0200
Message-ID: <20240730151627.275124117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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


