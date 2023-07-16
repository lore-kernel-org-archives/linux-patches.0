Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E858F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C716C433C8;
	Sun, 16 Jul 2023 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539955;
	bh=w2Tpmx/bz90YF49IncMjvrLCL5bDHhLA4hEKtxmUeFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiTf+T/c+Y1oSNC1boTB/shVh3AZ+jvluwA1sCt1IKmMk0g3q7xktimh0Tvv6lmXU
	 hR0yLflrzd1EU6343f4IOgMbbSLCOx5s0MO2k1FhEYisq0lIQeGMTiWax+eAFVW7yo
	 wRkVRL112BqkVWNCSnf3d1H0mOcqovKVUIP5+uBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/591] clk: rs9: Fix .driver_data content in i2c_device_id
Date: Sun, 16 Jul 2023 21:45:03 +0200
Message-ID: <20230716194928.107779155@linuxfoundation.org>
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

[ Upstream commit ad527ca87e4ea42d7baad2ce710b44069287931b ]

The .driver_data content in i2c_device_id table must match the
.data content in of_device_id table, else device_get_match_data()
would return bogus value on i2c_device_id match. Align the two
tables.

The i2c_device_id table is now converted from of_device_id using
's@.compatible = "renesas,\([^"]\+"\), .data = \(.*\)@"\1, .driver_data = (kernel_ulong_t)\2@'

Fixes: 892e0ddea1aa ("clk: rs9: Add Renesas 9-series PCIe clock generator driver")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/r/20230507133906.15061-3-marek.vasut+renesas@mailbox.org
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index 3e98a16eba6bb..35b2519f16961 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -353,7 +353,7 @@ static const struct rs9_chip_info renesas_9fgv0241_info = {
 };
 
 static const struct i2c_device_id rs9_id[] = {
-	{ "9fgv0241", .driver_data = RENESAS_9FGV0241 },
+	{ "9fgv0241", .driver_data = (kernel_ulong_t)&renesas_9fgv0241_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, rs9_id);
-- 
2.39.2



