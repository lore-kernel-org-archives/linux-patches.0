Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7861170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5E2C433C7;
	Mon, 11 Sep 2023 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440545;
	bh=9tqaolkp0gDEJMetlaUSlJ5ZRF2bADD70NiGL1Rh+sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgtKEWvMxPaQQEpBO2Z2+LknQJG44ZLl+XfrPXUsFegpcWBJZYPEzQOl932nLPwag
	 V3+AKqXMcrTjR8uyQV8qvx3j/Vz3KHWllsFEv5duZePMenzWLUv21s49qEBheuOWvW
	 bDkRwcSgVPlUeo/BE6UeGFjHP8Sk1H4pkzOGVXQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 099/739] can: tcan4x5x: Remove reserved register 0x814 from writable table
Date: Mon, 11 Sep 2023 15:38:18 +0200
Message-ID: <20230911134653.867419538@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit fbe534f7bf213d485b0ed5362b24a41bf3e18803 ]

The mentioned register is not writable. It is reserved and should not be
written.

Fixes: 39dbb21b6a29 ("can: tcan4x5x: Specify separate read/write ranges")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://lore.kernel.org/all/20230728141923.162477-3-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 2b218ce04e9f2..fafa6daa67e69 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -95,7 +95,6 @@ static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
 	regmap_reg_range(0x000c, 0x0010),
 	/* Device configuration registers and Interrupt Flags*/
 	regmap_reg_range(0x0800, 0x080c),
-	regmap_reg_range(0x0814, 0x0814),
 	regmap_reg_range(0x0820, 0x0820),
 	regmap_reg_range(0x0830, 0x0830),
 	/* M_CAN */
-- 
2.40.1



