Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3A315E8B;
	Wed, 20 May 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298691; cv=none; b=sTfLvF4XGkT8Pgl8NBe50wwOPwFAIOXfGJMEXRiPJk2W6yjsg1Z0y7W4Zc1j7TMQ9f5rdI3EmzgOmVby+brS31W0NmoFqveiQNL24bR6JwO7QLjFXXpvPWuVjuH11e/1D74QO17kUl82lNAmF0R+dTxwSZqatpNEYtv84jR+e4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298691; c=relaxed/simple;
	bh=4AjdCIT6Kpf06OY89UASPI3Hb50l7ft1Jf3ReR1HvXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzQXDzkI2m846X0+s0z79haoJochNiqZhLmo3oLhhAL1u9utJW/w9/agxCLczeYay2KNJCAfSl7VykgJseOEqjmpsvYGGizeIzhwQsq1GshFuIknGwm5vVsZVBcXVlLomwBSllvSDacs/NnQo/N0JGkwYdDJ3sIGSxGX7WcRUxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JL07drsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JL07drsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0DA1F000E9;
	Wed, 20 May 2026 17:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298690;
	bh=/S2x8Vr8k/J5RC9M1KvyovMpOqOn6bZSARe2NBZm8z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JL07drsgjd8mfZlVXZ1s95lJJ3j8RckJYwwTbA7PrebdeGDBZEVQEovVx7DKFPjR+
	 8QjPXxwdqvqOXbXUiKErtsjfNWLlfUpCaS/V/4dzEMyXB8pgBHBvm7lrZNlYpzIzWw
	 sLziNh+uO7M75D4qYUyLNo58UPX48ZAr2jw91qdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 507/957] pinctrl: abx500: Fix type of argument variable
Date: Wed, 20 May 2026 18:16:30 +0200
Message-ID: <20260520162145.528705643@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 34006f77890d050e6d80cbee365b5d703c1140b4 ]

The argument variable is assigned the return value of
pinconf_to_config_argument(), which returns a u32. Change its type from
enum pin_config_param to unsigned int to correctly store the configuration
argument.

Fixes: 03b054e9696c ("pinctrl: Pass all configs to driver on pin_config_set()")
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index fc7ebeda8440e..858fbaebcf8e5 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -852,7 +852,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	int ret = -EINVAL;
 	int i;
 	enum pin_config_param param;
-	enum pin_config_param argument;
+	unsigned int argument;
 
 	for (i = 0; i < num_configs; i++) {
 		param = pinconf_to_config_param(configs[i]);
-- 
2.53.0



