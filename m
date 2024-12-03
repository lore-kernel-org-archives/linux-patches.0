Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1841DFE2A;
	Tue,  3 Dec 2024 15:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240854; cv=none; b=SLkRPJkK7hZlPCJNJTkxe+BfxWSQBlKyHo0LUf4XnsBb9plIcnGl+K/eoaekHcHgDH22CMeEbxRMlX05DJmM+VvoKp3bMwg8c8/mz3ZWokvvEiPfF43bt0njtbLh2ElKzctNR3zAWq0S6AbbQOhTxmun7uEtT51IQsdwLiwRaX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240854; c=relaxed/simple;
	bh=3PGld6tgBaC7xb9at7lKdctB4lqmblVEgGg7GDksyWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuMMFzJCjgeUAHjbyRdkr+pFEoM/F84JWSo01DNgxTgWZZ9RncWH0QbgsP0bHeYNpn2KjdJkgnca60fr+d0Z+lHX1sRz1Y6NJn41A0op1RKYugPwYNH3quR+SXxYQrsXnUG1GUsqSa+9+SM1Kkjy1d9vAAVvv5hcoK6WabEwyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5dyps5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5dyps5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49144C4CECF;
	Tue,  3 Dec 2024 15:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240853;
	bh=3PGld6tgBaC7xb9at7lKdctB4lqmblVEgGg7GDksyWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5dyps5zJdWKOg3OjDNVfdBzB5zSmYAN4Vk3K8ajA1K56ogvnaohgXvp4YiS7XC4f
	 PHBgsLRWIPkh9Y9j39TbQfuIls52Fl3KSR9JyXJOXnhQUe83eArpntVG9JLhIhk2el
	 GlJUJxZisrOMMyvnHNou8uh6p26DVP4BwL2yLIcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Walklin <ryan@testtoast.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/826] drm: panel: nv3052c: correct spi_device_id for RG35XX panel
Date: Tue,  3 Dec 2024 15:39:42 +0100
Message-ID: <20241203144753.713708901@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



