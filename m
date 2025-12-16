Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D35E355029;
	Tue, 16 Dec 2025 11:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885959; cv=none; b=Tk1WjGbU/9m/XkeLvOWvFgfbSZIcE84UG32kHY5B1wNnqQefDx55KxlkjE80BmFG2EBKJASaezlqEWGI7cNx3Gg9BcQ9Z/Ts63K17y8XjpIBj+ZCzvac2W36O1GwFoHO9CA7L7bjtAAW1cI/bAew78DyyAdESHN2RQKo9RKzn3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885959; c=relaxed/simple;
	bh=IZ5NdtlSmAPsxSUvJOXWM/0HfX0+Z1PTKPROmkoCPwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b09YhSM1G7v4xM/RCjQYE4aFu9fMKjhc1lwX/0nkZC/zmFUbBCbR/vuqWwEfBPmneWuf+zUJdfBf2AmQkzwLvpIzhhrcXzAAYeht/60M3vl2X0eLBuniWNH+7tXAFPTpSXaWaWs8GIzbNYBeFL5H8F1ZE36VOiA0WmEalupVimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lbtcp7Wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lbtcp7Wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A28C4CEF1;
	Tue, 16 Dec 2025 11:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885958;
	bh=IZ5NdtlSmAPsxSUvJOXWM/0HfX0+Z1PTKPROmkoCPwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lbtcp7WobCPH6cJ+TQe9tgd+OGf1snJYdc5N31PsMo0pKJUp9SIYlvbek/pYSsyyM
	 smYcANQZ/zZjDMqTbkOA86gkRFwLCNHK+WqSGOL/GhhCnGGFJhVvTrf3f14i1vujd5
	 e1CceUDe4lTnQzYAsXwJVuL7pzUeirbJNzxduZSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 296/507] ASoC: SDCA: Fix missing dash in HIDE DisCo property
Date: Tue, 16 Dec 2025 12:12:17 +0100
Message-ID: <20251216111356.199383731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 3508311f2e1c872b645f13c6fd52840418089d41 ]

The property name is "mipi-sdca-RxUMP-ownership-transition-max-delay",
with a dash between max and delay. Add the missing dash.

Fixes: 13ef21dffe76 ("ASoC: SDCA: add support for HIDE entity properties and HID descriptor/report")
Tested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Tested-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251120153023.2105663-3-ckeepax@opensource.cirrus.com
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 0ccb6775f4de3..19b12564f822e 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -1263,7 +1263,7 @@ find_sdca_entity_hide(struct device *dev, struct fwnode_handle *function_node,
 	unsigned char *report_desc = NULL;
 
 	ret = fwnode_property_read_u32(entity_node,
-				       "mipi-sdca-RxUMP-ownership-transition-maxdelay", &delay);
+				       "mipi-sdca-RxUMP-ownership-transition-max-delay", &delay);
 	if (!ret)
 		hide->max_delay = delay;
 
-- 
2.51.0



