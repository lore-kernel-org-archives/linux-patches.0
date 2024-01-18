Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7FA1774B;
	Thu, 18 Jan 2024 10:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575430; cv=none; b=HC392R9hWxF31A1bjHzJjh86GttGbqf8bs0yiLfd4DMzlD0vEfbxwcmNPrLEK+gZDCto4KUHL89ZEIpjFcmnUqKMEmcDwAyXz7JxZh254K5ftwAG1cAIs04g3TrAUzbewSKKj9L0vABHW/Nt6CgGUZ00OQt4yfeh6CGHj/Pz+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575430; c=relaxed/simple;
	bh=jLg1XBLM1Z3bs/uRBeARl5h7rW20vEAoNVjgxYzkZds=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=HmhJK76z11Uqmr1tN1vLzYerGPJCYCepxa7wD+XW8ELF6TYvCHiomKm5XRjzyPxpcpRgVz/g/5UkAqDi+yAl+7m4Eyr14EGWrQXMz5UWNyjlrT3txwlsIUu8RgQ8sE8x3mI0aPyx8lUnppDNahYzzhsjpShL+3IxkS/6pNIk/Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQPhGWto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQPhGWto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF64C433C7;
	Thu, 18 Jan 2024 10:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575429;
	bh=jLg1XBLM1Z3bs/uRBeARl5h7rW20vEAoNVjgxYzkZds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQPhGWtoQ8KIYJHy4vA1GtjklfC+RATv+4kgEgGDrIHIEnUQQtui3TmnYcMptE0Ye
	 O31KFJiWujDUPdfz3h6Nwz+eIyfzjK6IFU/7viwOPHhFueeLU2XJ7e4AxmInRuctzG
	 OMqQbvLrlO4faZLxsHBBTtsQ97KUgKEFFPlcv+co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/150] ASoC: cs35l45: Use modern pm_ops
Date: Thu, 18 Jan 2024 11:48:32 +0100
Message-ID: <20240118104324.119734837@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit 12e102b1bd22ee00361559d57a5876445bcb2407 ]

Make use of the recently introduced EXPORT_GPL_DEV_PM_OPS() macro, to
conditionally export the runtime/system PM functions.

Replace the old SET_{RUNTIME,SYSTEM_SLEEP,NOIRQ_SYSTEM_SLEEP}_PM_OPS()
helpers with their modern alternatives and get rid of the now
unnecessary '__maybe_unused' annotations on all PM functions.

Additionally, use the pm_ptr() macro to fix the following errors when
building with CONFIG_PM disabled:

Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231206160318.1255034-2-rriveram@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45-i2c.c | 2 +-
 sound/soc/codecs/cs35l45-spi.c | 2 +-
 sound/soc/codecs/cs35l45.c     | 9 ++++-----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/cs35l45-i2c.c b/sound/soc/codecs/cs35l45-i2c.c
index 77e0f8750f37..bc2af1ed0fe9 100644
--- a/sound/soc/codecs/cs35l45-i2c.c
+++ b/sound/soc/codecs/cs35l45-i2c.c
@@ -62,7 +62,7 @@ static struct i2c_driver cs35l45_i2c_driver = {
 	.driver = {
 		.name		= "cs35l45",
 		.of_match_table = cs35l45_of_match,
-		.pm		= &cs35l45_pm_ops,
+		.pm		= pm_ptr(&cs35l45_pm_ops),
 	},
 	.id_table	= cs35l45_id_i2c,
 	.probe		= cs35l45_i2c_probe,
diff --git a/sound/soc/codecs/cs35l45-spi.c b/sound/soc/codecs/cs35l45-spi.c
index 5efb77530cc3..39e203a5f060 100644
--- a/sound/soc/codecs/cs35l45-spi.c
+++ b/sound/soc/codecs/cs35l45-spi.c
@@ -64,7 +64,7 @@ static struct spi_driver cs35l45_spi_driver = {
 	.driver = {
 		.name		= "cs35l45",
 		.of_match_table = cs35l45_of_match,
-		.pm		= &cs35l45_pm_ops,
+		.pm		= pm_ptr(&cs35l45_pm_ops),
 	},
 	.id_table	= cs35l45_id_spi,
 	.probe		= cs35l45_spi_probe,
diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index be4f4229576c..b1d0f2c8f2ca 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -810,7 +810,7 @@ static int cs35l45_exit_hibernate(struct cs35l45_private *cs35l45)
 	return -ETIMEDOUT;
 }
 
-static int __maybe_unused cs35l45_runtime_suspend(struct device *dev)
+static int cs35l45_runtime_suspend(struct device *dev)
 {
 	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
 
@@ -827,7 +827,7 @@ static int __maybe_unused cs35l45_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused cs35l45_runtime_resume(struct device *dev)
+static int cs35l45_runtime_resume(struct device *dev)
 {
 	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
 	int ret;
@@ -1289,10 +1289,9 @@ void cs35l45_remove(struct cs35l45_private *cs35l45)
 }
 EXPORT_SYMBOL_NS_GPL(cs35l45_remove, SND_SOC_CS35L45);
 
-const struct dev_pm_ops cs35l45_pm_ops = {
-	SET_RUNTIME_PM_OPS(cs35l45_runtime_suspend, cs35l45_runtime_resume, NULL)
+EXPORT_GPL_DEV_PM_OPS(cs35l45_pm_ops) = {
+	RUNTIME_PM_OPS(cs35l45_runtime_suspend, cs35l45_runtime_resume, NULL)
 };
-EXPORT_SYMBOL_NS_GPL(cs35l45_pm_ops, SND_SOC_CS35L45);
 
 MODULE_DESCRIPTION("ASoC CS35L45 driver");
 MODULE_AUTHOR("James Schulman, Cirrus Logic Inc, <james.schulman@cirrus.com>");
-- 
2.43.0



