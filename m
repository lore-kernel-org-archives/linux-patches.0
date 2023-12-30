Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418C8473;
	Sat, 30 Dec 2023 12:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hW+XhHHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F62C433C7;
	Sat, 30 Dec 2023 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937999;
	bh=GMLTJx8evgUE3TZzyjmYnl5Ws3Hjq5+h4Z9XurbEOzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hW+XhHHMwk2djw/Xe4k5jinuvzJKBXkn185WpgjexVw6+gJG4p2aRD3ZL+LNLVfcm
	 8mW2RAO/Q+yfdTJp0EzmIOnsBJWyfTVt8FU7obgSBfW3IwWHmLbQLEmjTaw89ziHGz
	 HNjoD+a4UauKLVDY8kONYLgAYfyQ4ecXmnGdYN0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 145/156] pinctrl: starfive: jh7100: ignore disabled device tree nodes
Date: Sat, 30 Dec 2023 11:59:59 +0000
Message-ID: <20231230115817.059737391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -492,7 +492,7 @@ static int starfive_dt_node_to_map(struc
 
 	nmaps = 0;
 	ngroups = 0;
-	for_each_child_of_node(np, child) {
+	for_each_available_child_of_node(np, child) {
 		int npinmux = of_property_count_u32_elems(child, "pinmux");
 		int npins   = of_property_count_u32_elems(child, "pins");
 
@@ -527,7 +527,7 @@ static int starfive_dt_node_to_map(struc
 	nmaps = 0;
 	ngroups = 0;
 	mutex_lock(&sfp->mutex);
-	for_each_child_of_node(np, child) {
+	for_each_available_child_of_node(np, child) {
 		int npins;
 		int i;
 


