Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0125C266EE7;
	Tue, 25 Mar 2025 12:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905699; cv=none; b=f9p/vTh+ymW08+7tAd1UQrn0jlcBX+q44Ix9fV9a7H5ufY95PIt+JCQtugRJtZ+dW4mwHXGE5HB2zXE2fGaah2GdlHuzyZwhBXjD3znhLfdTVd2qi6DhZrR4I/V2tkP6NLxM5X/BEeNvN8fcS8P0HCMDlC0j0cE+Mrf8Z+1GF/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905699; c=relaxed/simple;
	bh=l0N2e4HZuAacpJv03erl0sfOZx3P6ppXRPvHvWNEvwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL5PzsCJQ7R2lP/S+5DcyutzKzjOKoFV+1UnH+YZdQFz2oLwJFXMfveO5bCvZS4GfGjvPv/0xocyZapzSLVDAnca08PykPkGwLiLjieZokcuyTHRaGd4GsLqAingq4T+BdAmYbpjfi5NMGF7JV7R1u1omZYd35CdnYihEVaFjRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0C5a32wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0C5a32wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F9DC4CEE9;
	Tue, 25 Mar 2025 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905698;
	bh=l0N2e4HZuAacpJv03erl0sfOZx3P6ppXRPvHvWNEvwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0C5a32wj7FmIvBxqdFH09CN3GBcDqid99quT+FvCnYH24H52B/p4g6o0bhq8GGbo4
	 NWOkqAqnJ8aCoF9TxeYu95ZeAQWiNztR2YVbIjTkV5sMiy25zhxoa6QwwWp26MCd4B
	 XNI9OFWayXW98i9DiH9UAaMmS3KrgLC+TqucwGuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 116/198] drm/amd/display: Assign normalized_pix_clk when color depth = 14
Date: Tue, 25 Mar 2025 08:21:18 -0400
Message-ID: <20250325122159.698265937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2328,10 +2328,13 @@ static int get_norm_pix_clk(const struct
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


