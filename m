Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0162566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46C8C433D2;
	Tue, 18 Apr 2023 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821127;
	bh=IzaJUIUqzXqbTVID6vwBQYJ5wb34FkLDJb8emqLyKAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=064JZMCtlXMiF7sgOFqRkWvAxafghqwLM/+dXoRA1RefYw7etCj2FP1Q3mEumLbaQ
	 5Y3G+7hGVCA1icYq5so7gG4gG8gFtrAnv/yYndMdvijroiC4wxrjJvQiZUrP/YTtmG
	 vLK5+uiDZYVDzUWPv71CvgIMaywneWEKuPXi737Y=
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
Subject: [PATCH 5.10 001/124] gpio: GPIO_REGMAP: select REGMAP instead of depending on it
Date: Tue, 18 Apr 2023 14:20:20 +0200
Message-Id: <20230418120309.597772360@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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
index d1300fc003ed7..39f3e13664099 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -99,7 +99,7 @@ config GPIO_GENERIC
 	tristate
 
 config GPIO_REGMAP
-	depends on REGMAP
+	select REGMAP
 	tristate
 
 # put drivers in the right section, in alphabetical order
-- 
2.39.2



