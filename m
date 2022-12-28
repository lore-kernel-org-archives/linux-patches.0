Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823621C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03666C433D2;
	Wed, 28 Dec 2022 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244954;
	bh=FvOVMjnj+QMZKs3u4sBYEJyYInIsw3DB5uRBc499JI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIwCN1rEbAxe9qAJCmA4S0aGcsungH/3vtlkLu9Z9JxI0x1rXuUcPpcxmM0+O1gI9
	 RsPWvnd0/fOtXwo4lI+4nx4M3a7kQTZJw7eFAjqqZxFq9KC3R9KU6gBB88SFJznrme
	 odOY7bXbyLh+r97oe8310JOz0RyuV62s2eou1CsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Keerthy <j-keerthy@ti.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0750/1146] thermal/drivers/k3_j72xx_bandgap: Fix the debug print message
Date: Wed, 28 Dec 2022 15:38:09 +0100
Message-Id: <20221228144350.516226420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keerthy <j-keerthy@ti.com>

[ Upstream commit a7c42af78b19a11e98a5555a664c343e3a672632 ]

The debug print message to check the workaround applicability is inverted.
Fix the same.

Fixes: ffcb2fc86eb7 ("thermal: k3_j72xx_bandgap: Add the bandgap driver support")
Reported-by: Bryan Brattlof <bb@ti.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Link: https://lore.kernel.org/r/20221010034126.3550-1-j-keerthy@ti.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/k3_j72xx_bandgap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/k3_j72xx_bandgap.c b/drivers/thermal/k3_j72xx_bandgap.c
index 16b6bcf1bf4f..c073b1023bbe 100644
--- a/drivers/thermal/k3_j72xx_bandgap.c
+++ b/drivers/thermal/k3_j72xx_bandgap.c
@@ -439,7 +439,7 @@ static int k3_j72xx_bandgap_probe(struct platform_device *pdev)
 		workaround_needed = false;
 
 	dev_dbg(bgp->dev, "Work around %sneeded\n",
-		workaround_needed ? "not " : "");
+		workaround_needed ? "" : "not ");
 
 	if (!workaround_needed)
 		init_table(5, ref_table, golden_factors);
-- 
2.35.1



