Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BB71952E
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AC1C433EF;
	Mon, 12 Jun 2023 10:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565891;
	bh=Tbu2ok51QPVVY5W7T+bALWIj77KRewtAb9WN5gCVu5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFovGpxqEqshT6NaxATrMpmhR8YKAlIHtwzZfKcbO3knUsvg9bjoSmuaVdhCPwRnc
	 AklZadPWWjCgESxLbcfKItXgyVXvEKdAIZZSlegnhRyDjtTHVPmp3qKzTyg84oQZ6u
	 YbdKAxTmpq8ibVnfsVaXIYGh2sSA2F9nVWkGGO8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Rokosov <ddrokosov@sberdevices.ru>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 31/45] pinctrl: meson-axg: add missing GPIOA_18 gpio group
Date: Mon, 12 Jun 2023 12:26:25 +0200
Message-ID: <20230612101655.913256087@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Hundebøll <martin@geanix.com>

commit 5b10ff013e8a57f8845615ac2cc37edf7f6eef05 upstream.

Without this, the gpio cannot be explicitly mux'ed to its gpio function.

Fixes: 83c566806a68a ("pinctrl: meson-axg: Add new pinctrl driver for Meson AXG SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Hundebøll <martin@geanix.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Link: https://lore.kernel.org/r/20230512064925.133516-1-martin@geanix.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/meson/pinctrl-meson-axg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/meson/pinctrl-meson-axg.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-axg.c
@@ -400,6 +400,7 @@ static struct meson_pmx_group meson_axg_
 	GPIO_GROUP(GPIOA_15),
 	GPIO_GROUP(GPIOA_16),
 	GPIO_GROUP(GPIOA_17),
+	GPIO_GROUP(GPIOA_18),
 	GPIO_GROUP(GPIOA_19),
 	GPIO_GROUP(GPIOA_20),
 


