Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10F1D0DF2;
	Wed,  2 Oct 2024 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877744; cv=none; b=Zbdkmjlakgj6iFGGjpWZt+71xRuYw797Q0TBy//9yzCHH8MpeknkXLNTiW3LclTTgivRVBSm1EuKVb8l1FtV82APWI8NKvC7JDwuR4lPfl0Zao5kr5NCE9CF5Pun5GEOsKcJ0bI0LAGNigDWTR891GmJNEmHrEJJ9wRjV/gO+O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877744; c=relaxed/simple;
	bh=AOAu6gpmNmTzLGEIf5gqV3VCvfn29BVcwSFYEPJeNEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+uTgwtiZJq4Rj0Mdzq42X7ct1akKGD+42HIUnd+t/n9QaIhfDFt12bojMfTIfAGefUWF9L3hI0AUo8+NSkRjuzUJmPmA9zdFzNc5/h/OJCYLCX7Q1y+VvPbFulin7LHQo/Ikf8hHfEb6teCfVBi0Fclhgv1OZ5Szr15hWu5m+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhJsHFYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhJsHFYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523B2C4CEC5;
	Wed,  2 Oct 2024 14:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877744;
	bh=AOAu6gpmNmTzLGEIf5gqV3VCvfn29BVcwSFYEPJeNEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhJsHFYPz/WrycQjrZPtr5yMn/iU/XE8KjUB4Z5RT1TJS6fS2cRI8ODCnrfTSWEXe
	 aEgRUCxVzQPxDHFWBtuLfH86FiznU7X9BUOj/3LrO3mPY/v1RZV/Hnu7fpMPNGvs0L
	 pF2Juj9KS6OXoelHOYLDczbFs0OYtG9+l9lJ8/fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 180/634] drm/stm: ltdc: check memory returned by devm_kzalloc()
Date: Wed,  2 Oct 2024 14:54:40 +0200
Message-ID: <20241002125818.213241135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit fd39730c58890cd7f0a594231e19bb357f28877c ]

devm_kzalloc() can fail and return NULL pointer. Check its return status.
Identified with Coccinelle (kmerr.cocci script).

Fixes: 484e72d3146b ("drm/stm: ltdc: add support of ycbcr pixel formats")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230531072854.142629-1-claudiu.beznea@microchip.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 5576fdae49623..5aec1e58c968c 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -1580,6 +1580,8 @@ static struct drm_plane *ltdc_plane_create(struct drm_device *ddev,
 			       ARRAY_SIZE(ltdc_drm_fmt_ycbcr_sp) +
 			       ARRAY_SIZE(ltdc_drm_fmt_ycbcr_fp)) *
 			       sizeof(*formats), GFP_KERNEL);
+	if (!formats)
+		return NULL;
 
 	for (i = 0; i < ldev->caps.pix_fmt_nb; i++) {
 		drm_fmt = ldev->caps.pix_fmt_drm[i];
-- 
2.43.0



