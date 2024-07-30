Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9EB1A76AE;
	Tue, 30 Jul 2024 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360055; cv=none; b=L8ZROMEPk29JY8M8EsKxmP2r9ziX9Zdq4F7yGlAJmzHFAKw8jIaPeH2/EXbopp3/z4/ndADPCakFu0ig9gWWccqouloiqWcCeo551u4/GbDlSjpjZyTygcQ/HcmBXWpWUeGH155favsF6sQJQxzuakzd7lzqASRA6uL48KuhmGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360055; c=relaxed/simple;
	bh=b9HNQeoA0/CAdZv1Unpv3sa/N50EOApoYA8fDjijQ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B685pZvsxeCzTPSxuIEJ2u5Y3AvOyijgRpljx2YQ3b6zhSflGYWVLLiIFUVqyMIYwOeMxMZg04/1jheNjXICPvlYbtY02KiLvRPlSA+rJ3CDx7bfnbaeKg2Lxgw2RNk629bzht2ZSAgTELFymSwLuWZlnZv5PgLa+VEXoqtSbIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcZ7Ph+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcZ7Ph+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64135C32782;
	Tue, 30 Jul 2024 17:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360054;
	bh=b9HNQeoA0/CAdZv1Unpv3sa/N50EOApoYA8fDjijQ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcZ7Ph+YWJEOI/Nl+tP2Mvp6+a/ui5hYOd9+3LI/sMU68RzJIt37QkS4dTK/IxPm8
	 n4X/VYdj6rBe6iWMhHMWX0Rye8ZBwomKtGpI0TtppCT1ArRdISxpBhnS4kiN4IuelA
	 IsnhoBvitI98jjRsbWBneNRtB9KhCL/S6pIyyEi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Xi (Alex) Liu" <xi.liu@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 6.10 582/809] drm/amd/display: Check for NULL pointer
Date: Tue, 30 Jul 2024 17:47:38 +0200
Message-ID: <20240730151747.816461858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -143,7 +143,8 @@ const struct dc_plane_status *dc_plane_g
 		if (pipe_ctx->plane_state != plane_state)
 			continue;
 
-		pipe_ctx->plane_state->status.is_flip_pending = false;
+		if (pipe_ctx->plane_state)
+			pipe_ctx->plane_state->status.is_flip_pending = false;
 
 		break;
 	}


