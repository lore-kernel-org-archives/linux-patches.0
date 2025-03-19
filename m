Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5261EF394;
	Wed, 19 Mar 2025 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394959; cv=none; b=fdyd498RNBluMYXKXAKPamseRM+VZm2IG4jJDkJoPpdEjTUllHeGpsWnXQ4jCozomBl4Yu1heQ9JSMV0StVfImcJbI57Ac+FG34WQY6Xor67iibIWGR5AALy5rFW9d5nwnfYHMX0GEuzGi+6KKaDVbd4f5YFv1/cT1YiPOtzZCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394959; c=relaxed/simple;
	bh=MaFpzjwE8YtFs6ggbdDkjPWhGSMS28aXJnK20gNJyDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiFihEg/aWO3iAXhkNUG165IhXrfeQqjhZ7sWBsKvTiT2M83/88SknF4CuPAfvTuN1IuMkzURqvl7yYYlgFKBXnwYVa29U9g2XWfiXWB3Zex5tibRc3uZZeYyfmbAmr68uTl0bQdGlQS0YhTSe7deY8uZBGOW4MH3NNhbJl9I6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXsOWUEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXsOWUEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D63C4CEE4;
	Wed, 19 Mar 2025 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394959;
	bh=MaFpzjwE8YtFs6ggbdDkjPWhGSMS28aXJnK20gNJyDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXsOWUEeWzq29wjaExcantMx9rW7AYi+eo1u/ef6S+aL9l56rpNfFt+/FUKLTCQht
	 xGhySrD28DGZXb4lF4l2uo7ingRuBA1n3gUGSHLQsUPt7DdRbdpFQTWwgy/M1GfnFn
	 JQ98g2zNAXTcJR4tPpcCSM8S0SPfoFn3o3YHy3/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 187/241] drm/amd/display: Assign normalized_pix_clk when color depth = 14
Date: Wed, 19 Mar 2025 07:30:57 -0700
Message-ID: <20250319143032.347071298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3389,10 +3389,13 @@ static int get_norm_pix_clk(const struct
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


