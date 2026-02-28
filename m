Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9394A3419;
	Sat, 28 Feb 2026 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301315; cv=none; b=tFal6F3+O/mACP0x/i27rIqE0V8GMo1u+LGT1RcAVow/cbYx7I3Gb2nExZJy734CsG3Y0d8P4FzSWGOW2bDt6ikiWOqctyoTGjw+wHTF8rJrqHvkOcb2k5gEiMe3DnAl8rqB3/HBx+yyriiXgpY8+JmQuX19KZufar1tZ+V/C2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301315; c=relaxed/simple;
	bh=utHPXQc9RqqcaVu8J4sNgSzfIU0UZzlEg2GttMHPoY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj0llepgetlReEsHu/tP5bb1NkE331lHwlSSZK8/hfKUE40ucV+XkTzhOjvqWkvJARO7NPFSQxAWLC+rQzCj6Z2D3Qx2btZRiJGWezsU9e5r7bNU7k+FiOi1jn3Nn8pBcNOEK8R8ft0GSQvJYkmsdRklz2z5ePxKSL+uKaZmJs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tt0hHbtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tt0hHbtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1766EC2BC87;
	Sat, 28 Feb 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301314;
	bh=utHPXQc9RqqcaVu8J4sNgSzfIU0UZzlEg2GttMHPoY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tt0hHbtlyiOH6B/GO3z+mPkcb35kuSlvY/rdCi8+RfeaxBim7NBDoF/Fz8/WtOZv7
	 6DiyUFAKJyKL2IxgC9JtcU78ANkkeS+euKsZr9zKNgCaPSPS+SWQfViK5Zq9b6m6tJ
	 b3Yq1xAYrzhZ9YcdwL1pz7bxTbjGlOuOL0yq5fh33YVmAHFgBMsXCGfg5nSyKdo8N4
	 YzaAmbwfw/DCpvCL7kaSgywdcrxb5lsqcl4hzB9KkKkK0qYq5RPScVRhUlDm2Gsf0v
	 kBTSZ5RfuMnCompixJ79FgntOm6pNf1I7C+tQupRzSyhJk8Jw8i1be2rfdHFIGHMr0
	 qnl0wp60cyLTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/752] pinctrl: meson: amlogic-a4: mark the GPIO controller as sleeping
Date: Sat, 28 Feb 2026 12:43:31 -0500
Message-ID: <20260228174750.1542406-500-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit d6df4abe95a409e812c5d9af9657fe63ac299e3a ]

The GPIO controller is configured as non-sleeping but it uses generic
pinctrl helpers which use a mutex for synchronization. This will cause
lockdep splats when used together with shared GPIOs going through the
GPIO shared proxy driver.

Fixes: 6e9be3abb78c ("pinctrl: Add driver support for Amlogic SoCs")
Cc: stable@vger.kernel.org
Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Closes: https://lore.kernel.org/all/CAFBinCAc7CO8gfNQakCu3LfkYXuyTd2iRpMRm8EKXSL0mwOnJw@mail.gmail.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index f05d8261624a4..40542edd557e0 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -895,7 +895,7 @@ static const struct gpio_chip aml_gpio_template = {
 	.direction_input	= aml_gpio_direction_input,
 	.direction_output	= aml_gpio_direction_output,
 	.get_direction		= aml_gpio_get_direction,
-	.can_sleep		= false,
+	.can_sleep		= true,
 };
 
 static void init_bank_register_bit(struct aml_pinctrl *info,
-- 
2.51.0

