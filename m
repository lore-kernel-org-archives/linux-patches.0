Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B0C79DD;
	Sat, 30 Dec 2023 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guzkFykp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247B5C433C8;
	Sat, 30 Dec 2023 12:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938344;
	bh=HcKn7HXfRFA5zEqzxllfsggxycXUXb92tmdvJu0fNAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guzkFykpT6/IqfNMLhNDKwcCQs+v0La1efuI1fRNDmjm2jdVb2udOF2X2lN7fs2k8
	 aqWxkT6lbeP/q2YOgynt8qLMrh28FGrd3vhMnQSIH2EtECHt/J/DAnvY+m5ihmZEuk
	 Ebu0pSxTPewoNEWO8BaZhqBsAMGqqNh//765OOf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 100/112] pinctrl: starfive: jh7100: ignore disabled device tree nodes
Date: Sat, 30 Dec 2023 12:00:13 +0000
Message-ID: <20231230115809.993288961@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Nam Cao <namcao@linutronix.de>

commit 5c584f175d32f9cc66c909f851cd905da58b39ea upstream.

The driver always registers pin configurations in device tree. This can
cause some inconvenience to users, as pin configurations in the base
device tree cannot be disabled in the device tree overlay, even when the
relevant devices are not used.

Ignore disabled pin configuration nodes in device tree.

Fixes: ec648f6b7686 ("pinctrl: starfive: Add pinctrl driver for StarFive SoCs")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/fe4c15dcc3074412326b8dc296b0cbccf79c49bf.1701422582.git.namcao@linutronix.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/starfive/pinctrl-starfive-jh7100.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/starfive/pinctrl-starfive-jh7100.c
+++ b/drivers/pinctrl/starfive/pinctrl-starfive-jh7100.c
@@ -489,7 +489,7 @@ static int starfive_dt_node_to_map(struc
 
 	nmaps = 0;
 	ngroups = 0;
-	for_each_child_of_node(np, child) {
+	for_each_available_child_of_node(np, child) {
 		int npinmux = of_property_count_u32_elems(child, "pinmux");
 		int npins   = of_property_count_u32_elems(child, "pins");
 
@@ -524,7 +524,7 @@ static int starfive_dt_node_to_map(struc
 	nmaps = 0;
 	ngroups = 0;
 	mutex_lock(&sfp->mutex);
-	for_each_child_of_node(np, child) {
+	for_each_available_child_of_node(np, child) {
 		int npins;
 		int i;
 


