Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565642F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5375C433EF;
	Wed, 12 Apr 2023 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288792;
	bh=GOQ4SJGANziwFVc6eK4kPwU3j/EPTeqkoheRg7IUP18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE3RRDGmuluvV4V6j1Q0HzwNFZ5qW78Av7vU8ojedpE+MH93HveadZ7MCYrqvVyrN
	 u9BrhkySpWTJOsqGF0M5lyprm1SYi76SxYLWjso/7ByWTXUvxJeVQsdYdayLysccrP
	 VpLQbLdtdyqZLSSJSh5FOFvtb08rrBgHq95qX8rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Michael Walle <michael@walle.cc>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	linux-gpio@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/164] gpio: GPIO_REGMAP: select REGMAP instead of depending on it
Date: Wed, 12 Apr 2023 10:32:11 +0200
Message-Id: <20230412082837.204048169@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d49765b5f4320a402fbc4ed5edfd73d87640f27c ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: ebe363197e52 ("gpio: add a reusable generic gpio_chip using regmap")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Michael Walle <michael@walle.cc>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: linux-gpio@vger.kernel.org
Acked-by: Michael Walle <michael@walle.cc>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a01af11806164..e3af86f06c630 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -100,7 +100,7 @@ config GPIO_GENERIC
 	tristate
 
 config GPIO_REGMAP
-	depends on REGMAP
+	select REGMAP
 	tristate
 
 # put drivers in the right section, in alphabetical order
-- 
2.39.2



