Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C834010960
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD1EC433C0;
	Mon, 19 Jun 2023 10:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172283;
	bh=e7tWL6wTRy34K2JWIZX6jDI78R1WuLGLxqA768ehrHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONMqz5GcvySqRRA1MGaAPb8qrmUHXtY2UABGxC13aKSzzb1W+ea8WzSRhhJymoKHM
	 ziplgqAlc8/omDjK5+quzXDjxxdLatTEgjwliePdhf4ZlFeK0JlQYr5cDTC73zgkvG
	 PWbnnLtxWzP/CI3Y8NTQEkj9tvXHVFigSjlkMQKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milo Spadacini <milo.spadacini@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/107] tools: gpio: fix debounce_period_us output of lsgpio
Date: Mon, 19 Jun 2023 12:29:57 +0200
Message-ID: <20230619102142.172015086@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Milo Spadacini <milo.spadacini@gmail.com>

[ Upstream commit eb4b8eca1bad98f4b8574558a74f041f9acb5a54 ]

Fix incorrect output that could occur when more attributes are used and
GPIO_V2_LINE_ATTR_ID_DEBOUNCE is not the first one.

Signed-off-by: Milo Spadacini <milo.spadacini@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/lsgpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/lsgpio.c b/tools/gpio/lsgpio.c
index c61d061247e17..52a0be45410c9 100644
--- a/tools/gpio/lsgpio.c
+++ b/tools/gpio/lsgpio.c
@@ -94,7 +94,7 @@ static void print_attributes(struct gpio_v2_line_info *info)
 	for (i = 0; i < info->num_attrs; i++) {
 		if (info->attrs[i].id == GPIO_V2_LINE_ATTR_ID_DEBOUNCE)
 			fprintf(stdout, ", debounce_period=%dusec",
-				info->attrs[0].debounce_period_us);
+				info->attrs[i].debounce_period_us);
 	}
 }
 
-- 
2.39.2



