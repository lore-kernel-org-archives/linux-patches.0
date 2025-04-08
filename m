Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A932690DB;
	Tue,  8 Apr 2025 10:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109786; cv=none; b=Ntdka2yrSYyMN0e0Wk+OhZ8V8KunOCIuDUqcpG/+hh0hevuKdkI4yS3UK+fh+J5bn78XxuC6KWd1Zp2mOxcBMqFFSwLMr2LufGQpoTHk54izVC2ZWzJrZc8TYzolNYoZpi+TApclQ89x5FzBOvPnr0DVUSkSCohS7rgIK2ab37Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109786; c=relaxed/simple;
	bh=uG2hytOgYvEseBu8k5R/QznssrLbia2xe5e/0C5qcNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOXhiUGyZ72CPTmw3MDNHK5yOfs9MJ42TXRHXfgzt5mzUPfAfmdYDK9GB0PpKstSSQULHesxr0RA/AZF2efAMNw14HYwsJ9p85GUZxcZfqyhgaz/1qzoSNezy5WTiCVW/8YJXTNLuJMzHp/nQhHqB0k1e0Y7jWXBQwT0V8SpA3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQE66kHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQE66kHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C70C4CEE5;
	Tue,  8 Apr 2025 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109786;
	bh=uG2hytOgYvEseBu8k5R/QznssrLbia2xe5e/0C5qcNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQE66kHDQMIih/COLkZ3bR1R6b6E66FL+GN9MACUI573FuljB6mrVVLva6PZ7C+rM
	 LBPj0b9IlJdZG63Q4NlczMwYbuvs5nqoTSASHAdqpHyA4WNc6gmC4VdAjvFQfzs/XQ
	 7xKJDBfarr/3YpISzTnPN83e57qhEYon/sIPpbzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 053/227] drm/amd/display: Assign normalized_pix_clk when color depth = 14
Date: Tue,  8 Apr 2025 12:47:11 +0200
Message-ID: <20250408104821.989469272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1975,10 +1975,13 @@ static int get_norm_pix_clk(const struct
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


