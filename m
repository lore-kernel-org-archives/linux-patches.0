Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E898F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6374FC433C7;
	Sun, 16 Jul 2023 20:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540059;
	bh=dS3RfzImIkh0u/q5OPx5Zo84ixze5DIOE0aP09OEsD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcJEDuTx8SnKBhdMnBx8EU7TEon1CTpzxL+94sUMNJkQM/6LQ6Q/BKDvd0hqE3cWX
	 rwkZIUzMeEwx95D3gvlaMdTqPORxjuS1Fn5HThl5RQiRkhxBqOU/CvQfxM4T9OIr+U
	 Cbq+VeMiqasTCDSOpAnxUafw3TWCJFzu3jdcZZL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/591] drm/bridge: anx7625: Convert to i2cs .probe_new()
Date: Sun, 16 Jul 2023 21:45:30 +0200
Message-ID: <20230716194928.817824606@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 71450f8c824f5571d4af9e6e021b733085c8e690 ]

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/20221118224540.619276-18-uwe@kleine-koenig.org
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Stable-dep-of: 1464e48d69ab ("drm/bridge: anx7625: Prevent endless probe loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index b0ff1ecb80a50..86a52c5f4fbc4 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2562,8 +2562,7 @@ static void anx7625_runtime_disable(void *data)
 	pm_runtime_disable(data);
 }
 
-static int anx7625_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int anx7625_i2c_probe(struct i2c_client *client)
 {
 	struct anx7625_data *platform;
 	struct anx7625_platform_data *pdata;
@@ -2756,7 +2755,7 @@ static struct i2c_driver anx7625_driver = {
 		.of_match_table = anx_match_table,
 		.pm = &anx7625_pm_ops,
 	},
-	.probe = anx7625_i2c_probe,
+	.probe_new = anx7625_i2c_probe,
 	.remove = anx7625_i2c_remove,
 
 	.id_table = anx7625_id,
-- 
2.39.2



