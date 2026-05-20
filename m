Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418E02673AA;
	Wed, 20 May 2026 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294983; cv=none; b=B6UNELgIaxKaZMJLda631XqzQC8qDWj3VQWGTn8uqOu/JTqoEWqhEWGNn2ig/DcyMeOjg4BdXzh+HH5LeCk/VikDIoauzMnEDsgbBUCjIiSnJ0LFb16SJaMs3FFZ92W3pzgh14RhiFZNLQZEavSYYyVvF56AN16Rzs8KRrkm6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294983; c=relaxed/simple;
	bh=sTKyjxMsjmDsYmL8Ff5z/0MGp7y/IXAKO94S3l2MJmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbRUdMwMrzsBrhRkoSSAHVh73piYvuiDynj9eXXnWryoCSKReurzAYigg4YfaIYm7Oagvd5ih4aOY9xBS/B0m+wgunZUrgBTXF191O8hOSdwIBOFiQtayN8sDiKdWnS+eDN2GxYMH/dIG76k6kHZ2cbTdLRdsQb0USecKRgdKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te7uU1MW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te7uU1MW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07AC1F00893;
	Wed, 20 May 2026 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294982;
	bh=ie1qFGKpMnni145PAisIldDTPnKNCfKSBLV9EW5H/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te7uU1MW+bolE3oaAMSxAAqIotvJ2Fck1rOnmd/Vlnu1ete3ZCP3f/1tnmsWLe6EJ
	 D9RMoCprA1VOkhmQnsR0x+tAn6oEa640UwiiEqpzt2EkMvjaKFJj6zKYl55VacQY/L
	 CTHUAqZ5TSzpvrtL3f1fE6dvk8IjAlg43nV06gis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0245/1146] ASoC: SDCA: Add default value for mipi-sdca-function-reset-max-delay
Date: Wed, 20 May 2026 18:08:15 +0200
Message-ID: <20260520162153.783647788@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 1bbbda5b178a1399339139eb3c326300008b72d6 ]

Add a default value for the function reset timeout since version 1.0
of the SDCA specification doesn't actually include this property, it
was added later.

Fixes: 7b6be935e7ef ("ASoC: SDCA: Parse Function Reset max delay")
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260225140118.402695-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_fdl.c       | 5 -----
 sound/soc/sdca/sdca_functions.c | 6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sdca/sdca_fdl.c b/sound/soc/sdca/sdca_fdl.c
index 07892bc3a44e6..994821a6df617 100644
--- a/sound/soc/sdca/sdca_fdl.c
+++ b/sound/soc/sdca/sdca_fdl.c
@@ -46,11 +46,6 @@ int sdca_reset_function(struct device *dev, struct sdca_function_data *function,
 	if (ret) // Allowed for function reset to not be implemented
 		return 0;
 
-	if (!function->reset_max_delay) {
-		dev_err(dev, "No reset delay specified in DisCo\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Poll up to 16 times but no more than once per ms, these are just
 	 * arbitrarily selected values, so may be fine tuned in future.
diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index dca60ee8e62c3..fd6a254c95305 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -2176,8 +2176,12 @@ int sdca_parse_function(struct device *dev, struct sdw_slave *sdw,
 
 	ret = fwnode_property_read_u32(function_desc->node,
 				       "mipi-sdca-function-reset-max-delay", &tmp);
-	if (!ret)
+	if (ret || tmp == 0) {
+		dev_dbg(dev, "reset delay missing, defaulting to 100mS\n");
+		function->reset_max_delay = 100000;
+	} else {
 		function->reset_max_delay = tmp;
+	}
 
 	dev_dbg(dev, "%pfwP: name %s busy delay %dus reset delay %dus\n",
 		function->desc->node, function->desc->name,
-- 
2.53.0



