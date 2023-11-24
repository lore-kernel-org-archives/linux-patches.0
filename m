Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005CD364A7;
	Fri, 24 Nov 2023 18:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJgtJzrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AD9C433C7;
	Fri, 24 Nov 2023 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851491;
	bh=0+EsvImk43SeTnm6yrFUYl9kui2L6E5yH3XOKIgXotI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJgtJzrPyJaXPk17ps12oHvQZdoYn/5SAvKRuL5GIR55ONn/BEbjNSmipWQ7h9prb
	 F6Pv54flOpEoeg/eTb1V8CwPZZmmmVZIzK39Of3lnVCnDqoD6Xw6HpqcIm1GBDplzc
	 4eiddN/XNJO5RJ3d9rEatyj6cXPKrKmXI2WKRmV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Robert Foss <robert.foss@linaro.org>,
	Phong LE <ple@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Robert Foss <rfoss@kernel.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.5 470/491] drm: bridge: it66121: ->get_edid callback must not return err pointers
Date: Fri, 24 Nov 2023 17:51:46 +0000
Message-ID: <20231124172038.750176839@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 81995ee1620318b4c7bbeb02bcc372da2c078c76 upstream.

The drm stack does not expect error valued pointers for EDID anywhere.

Fixes: e66856508746 ("drm: bridge: it66121: Set DDC preamble only once before reading EDID")
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Phong LE <ple@baylibre.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Robert Foss <rfoss@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20230914131159.2472513-1-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 3c9b42c9d2ee..1cf3fb1f13dc 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -884,14 +884,14 @@ static struct edid *it66121_bridge_get_edid(struct drm_bridge *bridge,
 	mutex_lock(&ctx->lock);
 	ret = it66121_preamble_ddc(ctx);
 	if (ret) {
-		edid = ERR_PTR(ret);
+		edid = NULL;
 		goto out_unlock;
 	}
 
 	ret = regmap_write(ctx->regmap, IT66121_DDC_HEADER_REG,
 			   IT66121_DDC_HEADER_EDID);
 	if (ret) {
-		edid = ERR_PTR(ret);
+		edid = NULL;
 		goto out_unlock;
 	}
 
-- 
2.43.0



