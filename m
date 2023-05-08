Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C4A8BF9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC97C433A0;
	Mon,  8 May 2023 10:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542469;
	bh=X2ZQBkmNO4tFyqHEhbe8mX3cVuiFc3Tmpkey0gyQouA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UE7KJKAdbPFBoIaCtTOldGfa4ZxsT3eXhYSmrK+9OB6En1CM/yNxBi58XCP2tp4cw
	 bHJVfKNTItJ48j9xvMzjB7uJFx3aFVg5Y0jVH9xuEvKNWBaQVssZtGilPayYbYb6qb
	 U7HiF48wII4uD7f0DZDj7V+1kW5w4yGAIL9a7j8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 445/663] iio: light: max44009: add missing OF device matching
Date: Mon,  8 May 2023 11:44:31 +0200
Message-Id: <20230508094442.519151555@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b29c49026c3c05a11f845dba17cad0b3ba06836d ]

The driver currently matches only via i2c_device_id, but also has
of_device_id table:

  drivers/iio/light/max44009.c:545:34: error: ‘max44009_of_match’ defined but not used [-Werror=unused-const-variable=]

Fixes: 6aef699a7d7e ("iio: light: add driver for MAX44009")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230312153429.371702-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/max44009.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/light/max44009.c b/drivers/iio/light/max44009.c
index 801e5a0ad496b..f3648f20ef2c0 100644
--- a/drivers/iio/light/max44009.c
+++ b/drivers/iio/light/max44009.c
@@ -528,6 +528,12 @@ static int max44009_probe(struct i2c_client *client,
 	return devm_iio_device_register(&client->dev, indio_dev);
 }
 
+static const struct of_device_id max44009_of_match[] = {
+	{ .compatible = "maxim,max44009" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, max44009_of_match);
+
 static const struct i2c_device_id max44009_id[] = {
 	{ "max44009", 0 },
 	{ }
@@ -537,18 +543,13 @@ MODULE_DEVICE_TABLE(i2c, max44009_id);
 static struct i2c_driver max44009_driver = {
 	.driver = {
 		.name = MAX44009_DRV_NAME,
+		.of_match_table = max44009_of_match,
 	},
 	.probe = max44009_probe,
 	.id_table = max44009_id,
 };
 module_i2c_driver(max44009_driver);
 
-static const struct of_device_id max44009_of_match[] = {
-	{ .compatible = "maxim,max44009" },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, max44009_of_match);
-
 MODULE_AUTHOR("Robert Eshleman <bobbyeshleman@gmail.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MAX44009 ambient light sensor driver");
-- 
2.39.2



