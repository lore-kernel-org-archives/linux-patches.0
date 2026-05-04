Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332DB20DD51;
	Mon,  4 May 2026 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903033; cv=none; b=VQOVepmG9CAgAOozDKPL+Ng3pOq/uz8y9F1ivCPEqBOGi/j51FFoLv7YMhZOs3UZg6LPJwn/SgxNkBLKfhz4oDHs7JqpFr0KfLRGWObPxa+Hlu9TvU9b1S77Bi2lnt+TvD6Fh7OPLcl4D8adKiWCzWeWtV8+Uyr8fsziLucoCUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903033; c=relaxed/simple;
	bh=tQMm1w1KbTqoD/5e0F/q5+607LGY/qVlVx2WwGOouSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfowPY9bBqIrWTPVbdqhc932ci0D2M2Qj+gi+o4xAa/jWjiTqMWOh06H+OLS3fVWNfq1sfFEEsyscYHdMbPP6EOkEncqdO8IT1tIUSwQ7xcb8Wjy6E5JHOnTMFOXHjUhnXpXa4RWPwahlO2ZG3PeiSOkseag4jp5Z3j0+wRM0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0w/mMxcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0w/mMxcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF52DC2BCB8;
	Mon,  4 May 2026 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903033;
	bh=tQMm1w1KbTqoD/5e0F/q5+607LGY/qVlVx2WwGOouSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0w/mMxcnCVndlEqqTKDUTQ1j1ZR52N4QqfwVWfTs+c1nIM31qLa39WCuVe5I7njX7
	 zWI+0JG93iXSb2abwWS1ESTyqreG0hZMO2QTMSt6QB5f/vwc3QH5xWBkwYwhHAhduf
	 tnADbtvZktZnZ2tcK0jreBceWO5cWWhYPBZNQOHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Paul Elder <paul.elder@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 078/307] media: rockchip: rkcif: fix off by one bugs
Date: Mon,  4 May 2026 15:49:23 +0200
Message-ID: <20260504135145.747838042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit e4056b84af0fc18c84b4e5741df04ecd8ca17973 upstream.

Change these comparisons from > vs >= to avoid accessing one element
beyond the end of the arrays.
While at it, use ARRAY_SIZE instead of the _MAX enum values.

Fixes: 1f2353f5a1af ("media: rockchip: rkcif: add support for rk3568 vicap mipi capture")
Cc: stable@kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Chen-Yu Tsai <wens@kernel.org>
[fix cosmetic issues]
Signed-off-by: Michael Riesch <michael.riesch@collabora.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkcif/rkcif-capture-mipi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/rockchip/rkcif/rkcif-capture-mipi.c
+++ b/drivers/media/platform/rockchip/rkcif/rkcif-capture-mipi.c
@@ -489,8 +489,8 @@ static inline unsigned int rkcif_mipi_ge
 
 	block = interface->index - RKCIF_MIPI_BASE;
 
-	if (WARN_ON_ONCE(block > RKCIF_MIPI_MAX - RKCIF_MIPI_BASE) ||
-	    WARN_ON_ONCE(index > RKCIF_MIPI_REGISTER_MAX))
+	if (WARN_ON_ONCE(block >= ARRAY_SIZE(rkcif->match_data->mipi->blocks)) ||
+	    WARN_ON_ONCE(index >= ARRAY_SIZE(rkcif->match_data->mipi->regs)))
 		return RKCIF_REGISTER_NOTSUPPORTED;
 
 	offset = rkcif->match_data->mipi->blocks[block].offset;
@@ -510,9 +510,9 @@ static inline unsigned int rkcif_mipi_id
 	block = stream->interface->index - RKCIF_MIPI_BASE;
 	id = stream->id;
 
-	if (WARN_ON_ONCE(block > RKCIF_MIPI_MAX - RKCIF_MIPI_BASE) ||
-	    WARN_ON_ONCE(id > RKCIF_ID_MAX) ||
-	    WARN_ON_ONCE(index > RKCIF_MIPI_ID_REGISTER_MAX))
+	if (WARN_ON_ONCE(block >= ARRAY_SIZE(rkcif->match_data->mipi->blocks)) ||
+	    WARN_ON_ONCE(id >= ARRAY_SIZE(rkcif->match_data->mipi->regs_id)) ||
+	    WARN_ON_ONCE(index >= ARRAY_SIZE(rkcif->match_data->mipi->regs_id[id])))
 		return RKCIF_REGISTER_NOTSUPPORTED;
 
 	offset = rkcif->match_data->mipi->blocks[block].offset;


