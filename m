Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2631D8DFB;
	Mon,  2 Jun 2025 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874883; cv=none; b=qt202LeyjKtskPXSw/SrXiPqrQgHVOz06kE18uLpKiaNL94Gu3OblTgO9eCZEhTBLXOproIKCkZnB1VX6FGqhqKPePW8ZcGJ2q1q4vwhXV9qglTcPuoPXcKsAdG9vojkg21Kxq9hRUFED9nPdJ2vVVjxC4gLSahqlz1xRvCJZ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874883; c=relaxed/simple;
	bh=UfZ/r1JuYiI+1wbU5AAzV/J/rjXchKUzgXcc94wS+Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAG4mNpZ+lxGShwAjOiceJ6f4wQR/mkP6XUXDkjRwTMRj3OhPF8uUNvXfqsKRZ0kmk39A5iHJgJ46Rimebl09jM7/yoPBVbFrO3edFXRlqvOCpMWgoDJfFFlWQhGO8r8HFz0Ug0HoPLFTzx8dUt+uMXzI8U84zjfoJufCFD/sh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCr4nEbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCr4nEbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC222C4CEEB;
	Mon,  2 Jun 2025 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874883;
	bh=UfZ/r1JuYiI+1wbU5AAzV/J/rjXchKUzgXcc94wS+Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCr4nEbZe61usF2p4iAKWv8MLm3Ljg8koPCtbQN3XYSdsyZeiNyeORYYYJrGh+DvX
	 VThj3CdnCXLXCI8zxJtgEiwNofRVMMHkYY1reorzByzAsUVJLN0IEzG9mA9LB1Ac1Z
	 Q5Ld7zsrdUaxDQw+cZYQWbxRMkGh7PcPHSdJYRTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/204] pinctrl: meson: define the pull up/down resistor value as 60 kOhm
Date: Mon,  2 Jun 2025 15:48:18 +0200
Message-ID: <20250602134302.142761096@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit e56088a13708757da68ad035269d69b93ac8c389 ]

The public datasheets of the following Amlogic SoCs describe a typical
resistor value for the built-in pull up/down resistor:
- Meson8/8b/8m2: not documented
- GXBB (S905): 60 kOhm
- GXL (S905X): 60 kOhm
- GXM (S912): 60 kOhm
- G12B (S922X): 60 kOhm
- SM1 (S905D3): 60 kOhm

The public G12B and SM1 datasheets additionally state min and max
values:
- min value: 50 kOhm for both, pull-up and pull-down
- max value for the pull-up: 70 kOhm
- max value for the pull-down: 130 kOhm

Use 60 kOhm in the pinctrl-meson driver as well so it's shown in the
debugfs output. It may not be accurate for Meson8/8b/8m2 but in reality
60 kOhm is closer to the actual value than 1 Ohm.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/20250329190132.855196-1-martin.blumenstingl@googlemail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson.c b/drivers/pinctrl/meson/pinctrl-meson.c
index aba479a1150c8..f3b381370e5ed 100644
--- a/drivers/pinctrl/meson/pinctrl-meson.c
+++ b/drivers/pinctrl/meson/pinctrl-meson.c
@@ -480,7 +480,7 @@ static int meson_pinconf_get(struct pinctrl_dev *pcdev, unsigned int pin,
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 	case PIN_CONFIG_BIAS_PULL_UP:
 		if (meson_pinconf_get_pull(pc, pin) == param)
-			arg = 1;
+			arg = 60000;
 		else
 			return -EINVAL;
 		break;
-- 
2.39.5



