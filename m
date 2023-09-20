Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F5B2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2B8C433C7;
	Wed, 20 Sep 2023 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211217;
	bh=DFigz29b4OvnxloCQAJ7iLXwlNroOluXx0SiP9qYle4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMb9tHhZ7QlT6nA0lhASEvVPAOik493YY91GlPbAITcUurdCHljl67vB39TDvNQ0G
	 UTvj3/u/1HrHzZOV8PAK5/z2vnTs9eTZPPzrKtFwoggb5yNIPEUpBGfJKSCzIiSmyP
	 KLEHPDSOIc2n5zLu5YQx3mSVDPeUIT91skV1+e3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 012/186] pinctrl: amd: Dont show `Invalid config param` errors
Date: Wed, 20 Sep 2023 13:28:35 +0200
Message-ID: <20230920112837.298698657@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 87b549efcb0f7934b0916d2a00607a878b6f1e0f upstream.

On some systems amd_pinconf_set() is called with parameters
0x8 (PIN_CONFIG_DRIVE_PUSH_PULL) or 0x14 (PIN_CONFIG_PERSIST_STATE)
which are not supported by pinctrl-amd.

Don't show an err message when called with an invalid parameter,
downgrade this to debug instead.

Cc: stable@vger.kernel.org # 6.1
Fixes: 635a750d958e1 ("pinctrl: amd: Use amd_pinconf_set() for all config options")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230717201652.17168-1-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -609,7 +609,7 @@ static int amd_pinconf_get(struct pinctr
 		break;
 
 	default:
-		dev_err(&gpio_dev->pdev->dev, "Invalid config param %04x\n",
+		dev_dbg(&gpio_dev->pdev->dev, "Invalid config param %04x\n",
 			param);
 		return -ENOTSUPP;
 	}
@@ -662,7 +662,7 @@ static int amd_pinconf_set(struct pinctr
 			break;
 
 		default:
-			dev_err(&gpio_dev->pdev->dev,
+			dev_dbg(&gpio_dev->pdev->dev,
 				"Invalid config param %04x\n", param);
 			ret = -ENOTSUPP;
 		}


