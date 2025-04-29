Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1209C242902;
	Tue, 29 Apr 2025 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946470; cv=none; b=rgtxN7XXSUHxnzKVwuceXuMe1AQ+lEZPhaDzY/YdtQf/EQv8s5D326OkRYsrtWwppKR27n5nHocsF/Pn2MAG9P+SeOZ8tPXXBaSFGxApa7Dgfjn4EW8T1NAXFwLE9EwpWWWmU0KEc8O4ovaORZsK023+9OyhTyTD2xmU/DMPzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946470; c=relaxed/simple;
	bh=KyFtS04/tkpnh7ehqZJcn6nUMhp7cKCn7gBmA4BSGek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx3gJ7hDBBeEifVGKWxnwLpVPIEDByEQF82U0M/L/rNnfT1vjRlMIhuXDU+an+2yD2fkePKr83QYeWzp7dUH3U7tWp6vXdccT7LTztASgI9y2CVAelTINn3UcWZZMjumpgLwGNCxbUjFZc/EcYAlyLZiFNXCDftyHOCEwnmB9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNWb4v9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNWb4v9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B901C4CEE3;
	Tue, 29 Apr 2025 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946469;
	bh=KyFtS04/tkpnh7ehqZJcn6nUMhp7cKCn7gBmA4BSGek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNWb4v9Hn5Zb5yZ+Yo9jVbYZD0Dw1jBJEemNGFq4530kzkKi3lS5jcrmleh9dQS5B
	 9IkD4TFoDTeyB+oK2aDQh9i47PGuAgNM+XcCRaWm7RrNFQELG2aVvwSIeRBNC/uXLd
	 PU2S3H8pGGiz40+hJMt+rDU0lWWiSKXhnEBLkzZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weidong Wang <wangweidong.a@awinic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 276/311] ASoC: codecs: Add of_match_table for aw888081 driver
Date: Tue, 29 Apr 2025 18:41:53 +0200
Message-ID: <20250429161132.323426350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weidong Wang <wangweidong.a@awinic.com>

[ Upstream commit 6bbb2b1286f437b45ccf4828a537429153cd1096 ]

Add of_match_table for aw88081 driver to make matching
between dts and driver more flexible

Signed-off-by: Weidong Wang <wangweidong.a@awinic.com>
Link: https://patch.msgid.link/20250410024953.26565-1-wangweidong.a@awinic.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/aw88081.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/codecs/aw88081.c b/sound/soc/codecs/aw88081.c
index ad16ab6812cd3..3dd8428f08cce 100644
--- a/sound/soc/codecs/aw88081.c
+++ b/sound/soc/codecs/aw88081.c
@@ -1295,9 +1295,19 @@ static int aw88081_i2c_probe(struct i2c_client *i2c)
 			aw88081_dai, ARRAY_SIZE(aw88081_dai));
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id aw88081_of_match[] = {
+	{ .compatible = "awinic,aw88081" },
+	{ .compatible = "awinic,aw88083" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, aw88081_of_match);
+#endif
+
 static struct i2c_driver aw88081_i2c_driver = {
 	.driver = {
 		.name = AW88081_I2C_NAME,
+		.of_match_table = of_match_ptr(aw88081_of_match),
 	},
 	.probe = aw88081_i2c_probe,
 	.id_table = aw88081_i2c_id,
-- 
2.39.5



