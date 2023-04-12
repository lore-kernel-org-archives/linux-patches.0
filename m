Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771582F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3677C433D2;
	Wed, 12 Apr 2023 08:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289245;
	bh=TmVgtrcayJOHHCETtAj2Z1Xq+rIbApmhoK92MLxWiEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShsuQgbUJhkcRUmUTr+iB9VWQlECM8M7v+T76XMkakv8Rw4/1L1zzh8Iqmue9Qxxg
	 fUyib+sZAcBiZ78UK8dXbVudTOd1/5AWfAbo5ho6vK1azhMYhlc6SqAuCSe9OBimn2
	 G86Or/ckjutUieSjCpJojQ0CFqY8gvNM3mH7oDXQ=
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
Subject: [PATCH 6.2 007/173] gpio: GPIO_REGMAP: select REGMAP instead of depending on it
Date: Wed, 12 Apr 2023 10:32:13 +0200
Message-Id: <20230412082838.427252919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
index e9917a45b005a..42e5042d01495 100644
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



