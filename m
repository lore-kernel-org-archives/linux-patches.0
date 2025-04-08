Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469D219AD5C;
	Tue,  8 Apr 2025 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112415; cv=none; b=rA4WhZ8xQTzb/Y0Ol8tiZXWmvwFnxSPAo6j3sNVbl7cyfxvvCKICojSY7IjiacrdqPDZjwut3Vg7GtqJtqbS28jkuTjngpI/LleFUK2CcHbRv7tsBv1XY/Ty7ramzTjvFXesIR1u8JFd3I/5oEnkbbUa4iKq1LkxlQBZQlPR3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112415; c=relaxed/simple;
	bh=tBTmtXtbuV0CBIO3SnzTj3oa2+2Gjo8W92spcremO/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAe9kxg3PGUg0Tq5w0YSE2tPeT5tW+TJepCrM0tjpP5GiWStMTrJQwIMF65tx7OZlzOfuPOQ8p2iL62tEii6fm04nUvxyVQZ9masimtLBinjn4pqj+Pb6SWlcvgNyxngvMISR8mkc0xRHdCnXeRpfeM+ZG/Dv5od5dR18QUOlZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVrv8xFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVrv8xFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBEFC4CEE5;
	Tue,  8 Apr 2025 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112415;
	bh=tBTmtXtbuV0CBIO3SnzTj3oa2+2Gjo8W92spcremO/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVrv8xFV/JKEYFYrdw1I8vWakY+VbnMYB4qcJh7GhUbbdFfcynphyPRpcGDEy6m+Z
	 eOQFBnosgvp9J33tjLwWfXe2+WDUlxaEDbG/uTScK9ZuO31Fn0DfVmADvOx0ftqStx
	 WFr82QP4d1yorrOs0KcE4tZVfbWYb5NOCJo+C2PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 060/279] drm/amd/display: Assign normalized_pix_clk when color depth = 14
Date: Tue,  8 Apr 2025 12:47:23 +0200
Message-ID: <20250408104827.973750166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Hung <alex.hung@amd.com>

commit 79e31396fdd7037c503e6add15af7cb00633ea92 upstream.

[WHY & HOW]
A warning message "WARNING: CPU: 4 PID: 459 at ... /dc_resource.c:3397
calculate_phy_pix_clks+0xef/0x100 [amdgpu]" occurs because the
display_color_depth == COLOR_DEPTH_141414 is not handled. This is
observed in Radeon RX 6600 XT.

It is fixed by assigning pix_clk * (14 * 3) / 24 - same as the rests.

Also fixes the indentation in get_norm_pix_clk.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 274a87eb389f58eddcbc5659ab0b180b37e92775)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1901,10 +1901,13 @@ static int get_norm_pix_clk(const struct
 			break;
 		case COLOR_DEPTH_121212:
 			normalized_pix_clk = (pix_clk * 36) / 24;
-		break;
+			break;
+		case COLOR_DEPTH_141414:
+			normalized_pix_clk = (pix_clk * 42) / 24;
+			break;
 		case COLOR_DEPTH_161616:
 			normalized_pix_clk = (pix_clk * 48) / 24;
-		break;
+			break;
 		default:
 			ASSERT(0);
 		break;


