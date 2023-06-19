Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602ABE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A758C433C0;
	Mon, 19 Jun 2023 10:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172097;
	bh=zZz1jc8ubBpVgvTtyr6lb67hGIGys3B+2ipic9l6JS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcUliotvhePFDAyiR+1ZN5yJGdZiq6nf/n1ED8P4Suosqfwmi2qoQ+qxUAGg1D1V/
	 t2TY+28625xUR/+X9gB/O+I3SSTFWcWXPW+SOaQhOrjTn8grErWhcJfS2JHBGEoGK6
	 yX9D5DopQKm7/sciukIxtyWDMT9i6vDSedno7tyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milo Spadacini <milo.spadacini@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/89] tools: gpio: fix debounce_period_us output of lsgpio
Date: Mon, 19 Jun 2023 12:29:58 +0200
Message-ID: <20230619102138.755469846@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
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
index 5a05a454d0c97..85a2aa292f5d5 100644
--- a/tools/gpio/lsgpio.c
+++ b/tools/gpio/lsgpio.c
@@ -90,7 +90,7 @@ static void print_attributes(struct gpio_v2_line_info *info)
 	for (i = 0; i < info->num_attrs; i++) {
 		if (info->attrs[i].id == GPIO_V2_LINE_ATTR_ID_DEBOUNCE)
 			fprintf(stdout, ", debounce_period=%dusec",
-				info->attrs[0].debounce_period_us);
+				info->attrs[i].debounce_period_us);
 	}
 }
 
-- 
2.39.2



