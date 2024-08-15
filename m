Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9A14AD0A;
	Thu, 15 Aug 2024 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731438; cv=none; b=SIPXSZ3ohmegfzfI241rMBz4KR0u7hwZEqSULtsvFdxhGL/FVZKg3R5gahR6D6thDt+WQe3FEtO1tLiP4gCJjn1SuMKAizR8uQP6hlN3jxNfCGlRs28/mTc1Ia42UdH/blc6YmUxGNG3GqUXk1fYHNWaLc0ZFmExoZcZqBiKJuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731438; c=relaxed/simple;
	bh=+6JVi+zpOdtS3Id/GVq3/s6GA96juu78Nx+JvIGOMCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpdk6GffDVMEZ8+cz1InMHAvg3nflkkjQ83ukyVouoXIWvx9zaxymoYzPJuqahIQ0WcmyL43gnu4OW5Mv1jGsMbkpuH9OyX4lOwjCNMdzftpF4nQ9wLfNwjoUuunREyL5XdQZK2WCUISVv3G14HW1MZ8DwB9inVkGs3rq7YDK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1HSQxVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1HSQxVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0534C4AF0C;
	Thu, 15 Aug 2024 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731438;
	bh=+6JVi+zpOdtS3Id/GVq3/s6GA96juu78Nx+JvIGOMCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1HSQxVI0a7S/soj1jBVDxRjDbYiFRJSZzVLdUuSM13XNJr8b9QTCu6kCEjRyXfMw
	 T8ajiiLV2z9oXQZFHlUF9+sPKiMN3QGCpgQayp6s58P4oGkpfJvW7Q8h67JQQ9gRgQ
	 xGoyKMjgXY9725KQDST+SaV19Lxzj1bA9E6SLEps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Xi (Alex) Liu" <xi.liu@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 5.4 098/259] drm/amd/display: Check for NULL pointer
Date: Thu, 15 Aug 2024 15:23:51 +0200
Message-ID: <20240815131906.585194433@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -165,7 +165,8 @@ const struct dc_plane_status *dc_plane_g
 		if (pipe_ctx->plane_state != plane_state)
 			continue;
 
-		pipe_ctx->plane_state->status.is_flip_pending = false;
+		if (pipe_ctx->plane_state)
+			pipe_ctx->plane_state->status.is_flip_pending = false;
 
 		break;
 	}


