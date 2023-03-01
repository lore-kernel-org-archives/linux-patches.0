Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D96847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91650C433D2;
	Wed,  1 Mar 2023 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694292;
	bh=EiqR2mBNb2HeO81ozJwc7sAeGUmXpu05lg8Yb4g7VOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6lkaCV0xAuthB8BY+JJ1HMCiS1tLZ1w2P8VW+VlGMJ9sJDC7E6WeWAKFaTmwBHEi
	 J/DTNN4FJZsetHhnBrR3eXI3nkRz+NjuwqowWjderCv+O0knwf1fjrvmXi52938BF6
	 JJ3Ack9ZScwrPIGcZ/OuuSdxj0oCzrynOsUjg33U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/42] pinctrl: amd: Fix debug output for debounce time
Date: Wed,  1 Mar 2023 19:08:31 +0100
Message-Id: <20230301180657.499893825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c6e0679b8381bf03315e6660cf5370f916c1a1c6 ]

If one GPIO has debounce enabled but future GPIOs in the list don't
have debounce the time never gets reset and shows wrong value.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230121134812.16637-2-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 9bc6e3922e78e..32c3edaf90385 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -365,6 +365,7 @@ static void amd_gpio_dbg_show(struct seq_file *s, struct gpio_chip *gc)
 
 			} else {
 				debounce_enable = "  ∅";
+				time = 0;
 			}
 			snprintf(debounce_value, sizeof(debounce_value), "%u", time * unit);
 			seq_printf(s, "debounce %s (🕑 %sus)| ", debounce_enable, debounce_value);
-- 
2.39.0



