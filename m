Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7BE8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09B2C433C7;
	Sun, 16 Jul 2023 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539925;
	bh=/f/qe/x5uw5guA6TWeQzDNDdWGfZFolipMOvbV/kCZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJ/d0tPRjrpejvNXw/oFn/eh7nGUvNLsYFxEculYG9QJbVbLr/EXtXzdb6aGo1qoy
	 c9TpNOyiMTOjc8fBrocNDXyNG999Ev2e3eoEJeEAQHhbcdwV2BQTVg8XGtDH13iWF7
	 ARLUPeqv60iyFwnImNh9cmCEiygpCoqNDmgKPGEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/591] clk: vc7: Fix .driver_data content in i2c_device_id
Date: Sun, 16 Jul 2023 21:45:02 +0200
Message-ID: <20230716194928.082850237@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit b5e10beeafaa3266559c582dde7534ae3fe8cefb ]

The .driver_data content in i2c_device_id table must match the
.data content in of_device_id table, else device_get_match_data()
would return bogus value on i2c_device_id match. Align the two
tables.

The i2c_device_id table is now converted from of_device_id using
's@.compatible = "renesas,\([^"]\+"\), .data = \(.*\)@"\1, .driver_data = (kernel_ulong_t)\2@'

Fixes: 48c5e98fedd9 ("clk: Renesas versaclock7 ccf device driver")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/r/20230507133906.15061-2-marek.vasut+renesas@mailbox.org
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-versaclock7.c b/drivers/clk/clk-versaclock7.c
index 8e4f86e852aa0..0ae191f50b4b2 100644
--- a/drivers/clk/clk-versaclock7.c
+++ b/drivers/clk/clk-versaclock7.c
@@ -1282,7 +1282,7 @@ static const struct regmap_config vc7_regmap_config = {
 };
 
 static const struct i2c_device_id vc7_i2c_id[] = {
-	{ "rc21008a", VC7_RC21008A },
+	{ "rc21008a", .driver_data = (kernel_ulong_t)&vc7_rc21008a_info },
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, vc7_i2c_id);
-- 
2.39.2



