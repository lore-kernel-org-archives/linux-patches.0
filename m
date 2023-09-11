Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647841170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD57DC433CA;
	Mon, 11 Sep 2023 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441980;
	bh=5WTbxLJzVrzQhBLG95XrpPJvIZ0moMypaLHPvQgyeR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8hFy4afmtmuz1Vj8va3CVtX/eGeC5JYwrfebQD1M1a7Xeyhaz8HvwAbXk+ptPl25
	 7LLasKoS/8pk2y6XDu0HbZw/ZDUZ7W6ao6A96Ixro0F/+xBKrjXeGYAV1/VWQ76exV
	 hS02jYoeOZZFpCJGgu5kp+kOssziD6ZvvZyELz7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 603/739] leds: pwm: Fix error code in led_pwm_create_fwnode()
Date: Mon, 11 Sep 2023 15:46:42 +0200
Message-ID: <20230911134707.941190174@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cadb2de2a7fd9e955381307de3eddfcc386c208e ]

Negative -EINVAL was intended, not positive EINVAL.  Fix it.

Fixes: 95138e01275e ("leds: pwm: Make error handling more robust")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/a33b981a-b2c4-4dc2-b00a-626a090d2f11@moroto.mountain
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pwm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 29194cc382afb..87c199242f3c8 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -146,7 +146,7 @@ static int led_pwm_create_fwnode(struct device *dev, struct led_pwm_priv *priv)
 			led.name = to_of_node(fwnode)->name;
 
 		if (!led.name) {
-			ret = EINVAL;
+			ret = -EINVAL;
 			goto err_child_out;
 		}
 
-- 
2.40.1



