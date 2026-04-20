Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC0F33F8B7;
	Mon, 20 Apr 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700238; cv=none; b=DpSqv6hBAgoxRcfHygs0agMPsXXKCQSTUNi0VGyNA1kPUmtG43cS2jz7VFEblWvP1B1jIO+8E383PYM6Gz7H5whKxLGOY20Jp7ooiG1pxM13M9bknu1JNWcHfsoNsBlwU5aaMe3SaVfJLlsPVHLb1Om+wEkUeeutMC5eD5jfI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700238; c=relaxed/simple;
	bh=qJLnIsh0qqA0Z9CJlEaHqsWfQjFzS+JVYGIp7tEkIes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp4lHmLbIh1oFlvFINettnljLcD4HLGhmDqBuucyWZeGGkmGSlUGaZzjWlLxmg5Z0X/gRpN9YwPlc6GP1tiCSCo1Jo08rO9vwt5FGLIkjH57BAO1LZ7kg0jPl5nTYPMky35RHZJi+dnujkdDWV9gj4VQt/wYscE7RBjqXohtZzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ezlso1Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ezlso1Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C614BC2BCB4;
	Mon, 20 Apr 2026 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700238;
	bh=qJLnIsh0qqA0Z9CJlEaHqsWfQjFzS+JVYGIp7tEkIes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ezlso1TdqguOwtBFoIPOPFRZvqlSQN/bHwFxESdnrxpG/JoPkh1Epq3Gv6PSQQ2M7
	 /ZSDgUiQ8VDQU//1PK+xiveZCwDdlS8qhcYLyiVtWCAbD2U0gmufHD5qJpuRGD1mpk
	 LH7fxdX+EL7fb1jyo/o1xGW5MdbM3YMiENa9NFN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 094/220] ASoC: SDCA: Add ASoC jack hookup in class driver
Date: Mon, 20 Apr 2026 17:40:35 +0200
Message-ID: <20260420153937.418518453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 99a3ef1e81cd1775bc1f8cc2ad188b1fc755d5cd ]

Add the necessary calls to the class driver to connect the ASoC jack
from the machine driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251215153650.3913117-4-ckeepax@opensource.cirrus.com
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 4e53116437e9 ("ASoC: SDCA: Fix errors in IRQ cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class_function.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/sdca/sdca_class_function.c b/sound/soc/sdca/sdca_class_function.c
index 0028482a1e752..416948cfb5cb9 100644
--- a/sound/soc/sdca/sdca_class_function.c
+++ b/sound/soc/sdca/sdca_class_function.c
@@ -19,6 +19,7 @@
 #include <sound/sdca_fdl.h>
 #include <sound/sdca_function.h>
 #include <sound/sdca_interrupts.h>
+#include <sound/sdca_jack.h>
 #include <sound/sdca_regmap.h>
 #include <sound/sdw.h>
 #include <sound/soc-component.h>
@@ -195,6 +196,15 @@ static int class_function_component_probe(struct snd_soc_component *component)
 	return sdca_irq_populate(drv->function, component, core->irq_info);
 }
 
+static int class_function_set_jack(struct snd_soc_component *component,
+				   struct snd_soc_jack *jack, void *d)
+{
+	struct class_function_drv *drv = snd_soc_component_get_drvdata(component);
+	struct sdca_class_drv *core = drv->core;
+
+	return sdca_jack_set_jack(core->irq_info, jack);
+}
+
 static const struct snd_soc_component_driver class_function_component_drv = {
 	.probe			= class_function_component_probe,
 	.endianness		= 1,
@@ -351,6 +361,9 @@ static int class_function_probe(struct auxiliary_device *auxdev,
 		return dev_err_probe(dev, PTR_ERR(drv->regmap),
 				     "failed to create regmap");
 
+	if (desc->type == SDCA_FUNCTION_TYPE_UAJ)
+		cmp_drv->set_jack = class_function_set_jack;
+
 	ret = sdca_asoc_populate_component(dev, drv->function, cmp_drv,
 					   &dais, &num_dais,
 					   &class_function_sdw_ops);
-- 
2.53.0



