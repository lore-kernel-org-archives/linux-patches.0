Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089144C77;
	Mon, 14 Oct 2024 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917685; cv=none; b=iHWzOauRvWsdqZkCYwcq3gYtcKSrNgZTSKATt2seaOp0SgxwOJ762nA7URLGquCCCohGOdQi1ZFiZlIl43IAzmV7qys77uIgX8EYol3xaJ1dZmeafpvFRzDhVj3PuC0A1HqlTLin022sAipEqpZar4SQ7aWwXm5IcbclOGNQFlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917685; c=relaxed/simple;
	bh=L9aPXILutUX+Unl1NxOi5T8DZreEfrsDtgPaYqu+E2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqgY9Qrm1t/FTNyKuApuJP9DBdIJHD0s04M2U9N0utMi7gmSyGt4OqCGGSVeJh7qhDkEw23Mg9ASDoWHIBX/Lu7Qm9ZpWvnj0wRzA6fKaFaAM+eH21oazgZn9dR6hMFrDTXtyfhxPPSjUh2Hi3xoAgPVihpeEP85vXA7JmQHTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFR0M9tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFR0M9tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50939C4CEC3;
	Mon, 14 Oct 2024 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917684;
	bh=L9aPXILutUX+Unl1NxOi5T8DZreEfrsDtgPaYqu+E2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFR0M9tb+N9/d+80HMa6NVbJnxxpebr/XOatSTZ7pbB6vAs2r6Ox9gcOeW9dFY307
	 77sZPQGVBBMaT5gzrrA3mZ9bwenU+e/lYAajWmdfldypWNspEgg6LLSEZfwjER1kWT
	 Zen7hgXArlQY5OzVrFczziyT7f9psHKX2wesrjnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/798] drm/stm: ltdc: check memory returned by devm_kzalloc()
Date: Mon, 14 Oct 2024 16:10:58 +0200
Message-ID: <20241014141222.015025835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index b8be4c1db4235..b8c1636168cfa 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -1581,6 +1581,8 @@ static struct drm_plane *ltdc_plane_create(struct drm_device *ddev,
 			       ARRAY_SIZE(ltdc_drm_fmt_ycbcr_sp) +
 			       ARRAY_SIZE(ltdc_drm_fmt_ycbcr_fp)) *
 			       sizeof(*formats), GFP_KERNEL);
+	if (!formats)
+		return NULL;
 
 	for (i = 0; i < ldev->caps.pix_fmt_nb; i++) {
 		drm_fmt = ldev->caps.pix_fmt_drm[i];
-- 
2.43.0



