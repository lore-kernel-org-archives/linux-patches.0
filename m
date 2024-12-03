Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66451F891D;
	Tue,  3 Dec 2024 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238450; cv=none; b=LMdy6c8+evLkU+R9Q2NhwEsHHmonMaGg+OQ2d4CEZgVApaZogTMHdp7dLpaPmppDzQ3pXDWcTn6GsUhIeEDTKgrMYYKCuO8QawSr5n84av957JVkh+dYBUPXpx62r11gWp1aORIh4H/EtTnrDImrKrFyb0AEU5sGxcKGURhXuQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238450; c=relaxed/simple;
	bh=GFEdQ966hKH/HDkQZ2R2AHgKmL3VIKq231wfliFaCG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAyKNR3niakxU5KkKGAb9gG/xfTKC9YGJuN9Ad0jDsQ9So2t4e8UMB0ZLuKjswdxDmTHunTSv6YMciKgcSVwNkg06hhhGZbInSzPiFPhsXFfVjHpgHfUzduUYtu2rETeoiergQl/58/jLM/Nd1AFewdczvnx8LI+RrQw7uDX4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmyfOhZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmyfOhZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB29C4CED9;
	Tue,  3 Dec 2024 15:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238450;
	bh=GFEdQ966hKH/HDkQZ2R2AHgKmL3VIKq231wfliFaCG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmyfOhZnwP8N1x+kSbpVAEQ6OcAIM6D78aq5vob3c2jlm3PvY1364eqoTbxIFMRHf
	 h5IeQ/apQvwRBDMjcrOzw6MgIzJct10cXSTtpv2VXUUL0g9CTwqnIGIKTGLIMZChbf
	 NBVlUFSEW/njkCap6YUvS3y+kE2H7TDB/BDQsXv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Walklin <ryan@testtoast.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 282/817] drm: panel: nv3052c: correct spi_device_id for RG35XX panel
Date: Tue,  3 Dec 2024 15:37:34 +0100
Message-ID: <20241203144006.813500812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Ryan Walklin <ryan@testtoast.com>

[ Upstream commit 45608a3eb4902f32010a8328c0a01ccda4b38c9b ]

The Anbernic RG35XX devices use an SPI LCD panel from an unknown OEM,
with an NV3052C driver chip.

As discussed previously, the integrating vendor and device name are
preferred instead of the OEM serial. A previous patch corrected the
device tree binding and of_device_id in the NV3052C driver, however the
spi_device_id also needs correction.

Correct the spi_device_id for the RG35XX panel.

Signed-off-by: Ryan Walklin <ryan@testtoast.com>
Fixes: 76dce2a96c0f ("drm: panel: nv3052c: Correct WL-355608-A8 panel compatible")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241020083836.175733-1-ryan@testtoast.com
[DB: corrected the Fixes tag]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-newvision-nv3052c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-newvision-nv3052c.c b/drivers/gpu/drm/panel/panel-newvision-nv3052c.c
index d3baccfe6286b..06e16a7c14a75 100644
--- a/drivers/gpu/drm/panel/panel-newvision-nv3052c.c
+++ b/drivers/gpu/drm/panel/panel-newvision-nv3052c.c
@@ -917,7 +917,7 @@ static const struct nv3052c_panel_info wl_355608_a8_panel_info = {
 static const struct spi_device_id nv3052c_ids[] = {
 	{ "ltk035c5444t", },
 	{ "fs035vg158", },
-	{ "wl-355608-a8", },
+	{ "rg35xx-plus-panel", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(spi, nv3052c_ids);
-- 
2.43.0



