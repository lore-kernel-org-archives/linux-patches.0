Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4BD6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BEFC433C9;
	Sun, 17 Sep 2023 19:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980245;
	bh=XOTKxfj42CFeblWeB+0+qoA3/FNifzJPsH35X1RwJQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAkU44BcMjJEoDCY18hhZhUGucmLbmJLqNC6VmS0ibphUjQZgQhaSRuGEwlpacOmg
	 nnINqK42QwS+UeYiLgeY2YtsiqbkVV2c6PRabwGafNTlLw4T+Q6CN9+jUsqWCcty8J
	 TfgYdzh5zbHUSm/yb+1DbTjMWsPY32KCEj47wfuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 099/285] regulator: tps6287x: Fix n_voltages
Date: Sun, 17 Sep 2023 21:11:39 +0200
Message-ID: <20230917191055.109582420@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit c69290557c7571dff3d995fa27619b965915e8a1 ]

There are 256 possible voltage settings for each range, not 256 possible
voltage settings in total.

Fixes: 15a1cd245d5b ("regulator: tps6287x: Fix missing .n_voltages setting")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com
Link: https://lore.kernel.org/r/20230829-tps-voltages-v1-1-7ba4f958a194@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6287x-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6287x-regulator.c b/drivers/regulator/tps6287x-regulator.c
index b1c0963586ace..e45579a4498c6 100644
--- a/drivers/regulator/tps6287x-regulator.c
+++ b/drivers/regulator/tps6287x-regulator.c
@@ -119,7 +119,7 @@ static struct regulator_desc tps6287x_reg = {
 	.ramp_mask = TPS6287X_CTRL1_VRAMP,
 	.ramp_delay_table = tps6287x_ramp_table,
 	.n_ramp_values = ARRAY_SIZE(tps6287x_ramp_table),
-	.n_voltages = 256,
+	.n_voltages = 256 * ARRAY_SIZE(tps6287x_voltage_ranges),
 	.linear_ranges = tps6287x_voltage_ranges,
 	.n_linear_ranges = ARRAY_SIZE(tps6287x_voltage_ranges),
 	.linear_range_selectors = tps6287x_voltage_range_sel,
-- 
2.40.1



