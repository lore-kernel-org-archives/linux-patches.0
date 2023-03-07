Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2EBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDA1C433D2;
	Tue,  7 Mar 2023 17:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209331;
	bh=MyUA9rbAb493vf7H+6aUqbpXryh2hS5od6dCujTAE/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgtWxK30bwU+PrirTf0agd/hQLU+HEOZ8Y5WjhM5axOfPM62tBbbCC/5P9JMJ/shD
	 /8iCEL8ABRzPJiKkUF+Tcq/S7EgSr+oRmlwfsrGmnfb+7A4PjTiDfxhF3UWI+55HcO
	 p5byO/avtpNjGFdGfVTbLOhioBUjNKJHzagm9kNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0183/1001] platform/chrome: cros_ec_typec: Update port DP VDO
Date: Tue,  7 Mar 2023 17:49:15 +0100
Message-Id: <20230307170029.835374328@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 8d2b28df6c3dc1581d856f52d9f78059ef2a568f ]

The port advertising DP support is a Type-C receptacle. Fix the port's
DisplayPort VDO to reflect this.

Fixes: 1903adae0464 ("platform/chrome: cros_ec_typec: Add bit offset for DP VDO")
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221228004648.793339-6-pmalani@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 001b0de95a46e..d1714b5d085be 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -27,7 +27,7 @@
 #define DRV_NAME "cros-ec-typec"
 
 #define DP_PORT_VDO	(DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | BIT(DP_PIN_ASSIGN_D)) | \
-				DP_CAP_DFP_D)
+				DP_CAP_DFP_D | DP_CAP_RECEPTACLE)
 
 /* Supported alt modes. */
 enum {
-- 
2.39.2



