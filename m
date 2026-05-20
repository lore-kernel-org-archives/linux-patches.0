Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2DB61FFE;
	Wed, 20 May 2026 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294970; cv=none; b=iLC8IyWR8VJWElHN8AtQBUzSwyZiI9C8ndOHLCN/oCaQGmNgb7SnnWsurX9VbcLBpLv2RKKHhSnGwol9RQv8tIHsng84GZkUbakkHHHC6/24Nf9qrzjA2mlZxC+FEugii9D24kVs6ISPNd72nOTmqvNVbaItlelnZdR2OD3OBg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294970; c=relaxed/simple;
	bh=s+pfpi2F5d6LOKfRbLTHRnD0rY+6tqhxrgkBDG7yeHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWIJDCfpXpwTQqSNXB9j44wW/h3zo3Pp+OGgNFm9CbyGN2knfNT8VLiPmCWpF0foV7WbAB7LpZFroCbWmNJpvTV12SK6OaCD/Gyc4SrhwCsAuXRgUIe5F5JJjvlbBj2FVX+XIc2CFycvZ9dlI/AVbUpkLN6CQlNixZx6H5aqfas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNQnCjfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNQnCjfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4021F000E9;
	Wed, 20 May 2026 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294968;
	bh=mLzACnzPHmlGkq7gdp1oY5nG0DXhWN4mLEanGCyMvDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNQnCjflCzqFTs1Gw5VvIuIA0YxW3aqH5pfHXDpMueXjKBFYSN6wWjVHqBR2ZNIAH
	 kOL6xJ8YB/B1tgcIyWgr/Bm8lFRI0Tl5PKV5kxrVQ/d5cm/Riy2eMuJL7SCgFsLHCb
	 QeaBhRAXxyj6p88GinLVOIvYMNwNlbzE+7pv9QFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0240/1146] drm/xe/xe2_hpg: Drop invalid workaround Wa_15010599737
Date: Wed, 20 May 2026 18:08:10 +0200
Message-ID: <20260520162153.674303397@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 1046bc7b416814833a43af8e66c52b0ea71c2021 ]

Wa_15010599737 was a workaround originally proposed (and ultimately
rejected) for DG2-G10.  There's no record of it ever being relevant or
even considered for any other platforms.

The specific bit this workaround was setting is documented as "This bit
should be set to 1 for the DX9 API and 0 for all other APIs" which means
that it should almost always be left at the default value of 0 on Linux.
The register itself is directly accessible from userspace, so in the
special cases where it might be relevant (e.g., Wine/Proton running
Windows DX9 apps), the userspace drivers already have the ability to
change the setting without involvement of the kernel.

Fixes: 7f3ee7d88058 ("drm/xe/xe2hpg: Add initial GT workarounds")
Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20260223-forupstream-wa_cleanup-v3-2-7f201eb2f172@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 2ee08c068adbc..9ddd21a21dcef 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -805,10 +805,7 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 	},
 
 	/* Xe2_HPG */
-	{ XE_RTP_NAME("15010599737"),
-	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(SET(CHICKEN_RASTER_1, DIS_SF_ROUND_NEAREST_EVEN))
-	},
+
 	{ XE_RTP_NAME("14020756599"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(WM_CHICKEN3, HIZ_PLANE_COMPRESSION_DIS))
-- 
2.53.0



