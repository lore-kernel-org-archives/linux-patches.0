Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AC01774B;
	Thu, 18 Jan 2024 11:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575701; cv=none; b=dO5k+G3xWvTUAUTxHZSTk+3mbnJQD3mmOweHdnXUBd1jy7OHVjSFBvNmVhbbmT3QhH4XADnneTovZ904FNifFazgMFr5h5Zxwz/ktob7gBAVmsOsJoLWaCpK90TquhYNSu2pjdWMV4HyCAt+zjF11PsUMaHgqk+hGCh7CzA1654=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575701; c=relaxed/simple;
	bh=2uL0sTiBtEiA3lEcIVRyl8S+ZCpqKsIRfackowyN93c=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=BJ8lm3GO4d4zDKcFxbI34Xygowp3nKlUYLtpZ6lqExTUtaETT2JCROVaXvBeP7jAFkaYnnlm7Vxp84ftRyIyCd2uNNEh3oAdqdWwGD09clzG9NK9JIH4ea1CxFi8lIE/cnWj7hbPbxGuSg3JY8CyP6TOf1NpCw/7MVVbuFeH6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQF57XnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQF57XnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196D0C433F1;
	Thu, 18 Jan 2024 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575701;
	bh=2uL0sTiBtEiA3lEcIVRyl8S+ZCpqKsIRfackowyN93c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQF57XnTJFSloqIdYEaVaXrOlBNfbc06pV9SA/todVehfFZfdKIcvcOW9ikNE4dAR
	 edE1PTu3aCJLP9sGsDOBdmiQmv49t9Y5xOS4l6zLtXeZsv+ZUpuJJswH/wt+x/5Dgf
	 dpiQQcBelj5h7qN+DPS914/SzyokA4usNeFG0sfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/100] pinctrl: cy8c95x0: Fix typo
Date: Thu, 18 Jan 2024 11:49:23 +0100
Message-ID: <20240118104314.168970259@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 47b1fa48116238208c1b1198dba10f56fc1b6eb2 ]

Fix typo to make pinctrl-cy8c95x compile again.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20231219125120.4028862-1-patrick.rudolph@9elements.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 68509a2301b8..99c3fe4ca518 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -857,7 +857,7 @@ static int cy8c95x0_setup_gpiochip(struct cy8c95x0_pinctrl *chip)
 	gc->get_direction = cy8c95x0_gpio_get_direction;
 	gc->get_multiple = cy8c95x0_gpio_get_multiple;
 	gc->set_multiple = cy8c95x0_gpio_set_multiple;
-	gc->set_config = gpiochip_generic_config,
+	gc->set_config = gpiochip_generic_config;
 	gc->can_sleep = true;
 	gc->add_pin_ranges = cy8c95x0_add_pin_ranges;
 
-- 
2.43.0



