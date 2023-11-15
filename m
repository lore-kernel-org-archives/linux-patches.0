Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973C364C8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFiij5OY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45BBC433C8;
	Wed, 15 Nov 2023 19:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077772;
	bh=+12ROAgj1vBAsdcDsXWnHvUzadasaQT1nPg+ODuY8/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFiij5OYsxX1Stv9L9vvYJLOY9riloidmvlemjOx5eEW4Hw0z9WecPs1SVqXObJhj
	 7foW+uQWtPHHvjCiSAxkv4VI0iGh56Y+N/XCdGQmaF8NWAit2AYrETbE4rDBa9Lp8o
	 YELAvNGSmTf82FmgS4Tgv09MmBjmWUoBBZk3fwMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 510/603] media: ov13b10: Fix some error checking in probe
Date: Wed, 15 Nov 2023 14:17:35 -0500
Message-ID: <20231115191647.420645190@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d66b45e1b082462c3e14528b83e18ee92362e456 ]

The "ret = " assignment was missing, so ov13b10_power_on() is not
checked for errors.  Add the assignment.

Fixes: 6e28afd15228 ("media: ov13b10: add PM control support based on power resources")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov13b10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov13b10.c b/drivers/media/i2c/ov13b10.c
index dbc642c5995b6..8ebdb32dd3dbc 100644
--- a/drivers/media/i2c/ov13b10.c
+++ b/drivers/media/i2c/ov13b10.c
@@ -1501,7 +1501,7 @@ static int ov13b10_probe(struct i2c_client *client)
 
 	full_power = acpi_dev_state_d0(&client->dev);
 	if (full_power) {
-		ov13b10_power_on(&client->dev);
+		ret = ov13b10_power_on(&client->dev);
 		if (ret) {
 			dev_err(&client->dev, "failed to power on\n");
 			return ret;
-- 
2.42.0



