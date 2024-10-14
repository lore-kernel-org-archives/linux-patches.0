Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D41AAE32;
	Mon, 14 Oct 2024 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916071; cv=none; b=EcR8e0HCGqkDDpjIgqRPUQHd3ShKqgte+0Ac8oUPx5Q8IxDPQGAnyVjkAnPz3aRAla48DWyqCLrC9/XnAwKc9TgSb7Y2ESHfyAGJ2EwGv1RBWeTrTJesa3clbEHadj9lcfb4ZhiJXfiInmDvnJIfo0B3xogKG87LSiyg4BzLKuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916071; c=relaxed/simple;
	bh=PVWBPgjN3Rjx5er8EqM9x7itslrUTiondgk8JTyXofE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvHVyWUQXb1nMFB12GkMKyUOykUdrarpQtqLc9mS9p4gXCBNOhfW4rP5rCWPH23hc0owc772F1Qxx5jGmTYN93FqMRyG1Ux1KpI3KYqSzGtYVoqnOvMa79WMcOUZFXjUw2mRkBDw8Qn/x1Oq/8dQCZ3JcvSQKg+OvpcOvwSLrgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxgLPQPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxgLPQPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E879C4CEC3;
	Mon, 14 Oct 2024 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916070;
	bh=PVWBPgjN3Rjx5er8EqM9x7itslrUTiondgk8JTyXofE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxgLPQPipVr58Xyow9fYHvsncn0P6v6UFqROr6YpmYF3g3Z/i2A2b4ygWeOiJJE+9
	 OcphATNH3z3Lm9svhW7RxMpaje4RG4uWL8Ukr3huW/Tuegs+ZwD+dbZ3qt/nt6yeH8
	 KocGoQhrF6MjlAyHhiXiTvbdKWDzSoCLk+QpnFrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 077/214] drm/amd/display: Check null pointer before dereferencing se
Date: Mon, 14 Oct 2024 16:19:00 +0200
Message-ID: <20241014141047.993715766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit ff599ef6970ee000fa5bc38d02fa5ff5f3fc7575 ]

[WHAT & HOW]
se is null checked previously in the same function, indicating
it might be null; therefore, it must be checked when used again.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Acked-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 9e05d77453ac3..900c9b2454b5a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1832,7 +1832,7 @@ bool dc_validate_boot_timing(const struct dc *dc,
 		if (crtc_timing->pix_clk_100hz != pix_clk_100hz)
 			return false;
 
-		if (!se->funcs->dp_get_pixel_format)
+		if (!se || !se->funcs->dp_get_pixel_format)
 			return false;
 
 		if (!se->funcs->dp_get_pixel_format(
-- 
2.43.0



