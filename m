Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225241C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC88C433EF;
	Wed, 28 Dec 2022 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244522;
	bh=8tFq7JLBXzqGGvy14KOYaed8BFPAxwaM75ZJKH6+DsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHAAxJnAbUYI15dv/XsnKYF+5iq7l1MCtqlf93Fp0wgFdvEsJ6A9V1/xE+ZGSf06R
	 j73rY+SoY/D5Ug5HZ7oJa8Xj2kTOHYpxTgiCo7vo63LnALyks538vcZvc+YY7h8x0N
	 Gqv/exDYXciTddIrqaIV6+D7yq0bz8uIJwkjur+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Keerthy <j-keerthy@ti.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0726/1073] thermal/drivers/k3_j72xx_bandgap: Fix the debug print message
Date: Wed, 28 Dec 2022 15:38:34 +0100
Message-Id: <20221228144347.744739073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 115a44eb4fbf..4eb4926bbdc7 100644
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



