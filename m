Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032942;
	b=FDt7ZgvamgbzvwtxvcWq+sqFZoin8ehsZQHvuGyWTShJLs7U937gNPwKurkhnH1tsvy3
	 h1ckYjiFMQlzEpTNQparbOUkGqP3umWdIjnZRie6MsLMMWnu9xOhOP5j+Jq675hiu++uT
	 XObtusW+AUMU64N8nWdQiDHYcJYB605iZbeFjapnzOqAYDSxiTxBVgV6zE9+4/uvrEUT5
	 oUOaPqi+8hcOTJq1AepMZ01IV/ZLqgTabf56chTPs3fAzYAyi2oUeh+d0B8i54d5rzhA7
	 y+Y0fKlIdNJ1/D3oiyGvwV7e+xJ1XzsbK2vcdeLozUBePtquM1YBVfDkWtXvdF97/8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i5mTKRYRwEyFOgVWLXbMovB03r9ERnQoiCmyCsKyuL0=;
	b=5syBEFZzSl0xLC5RLuhcQxFgguQzt3qiV7cRZIQb2L/ciET5g7n9INwMoHzEarK3o0Ed
	 p6TWf4jnVt+DmHelo3EgJUkQ2rKi3j+RVu76I1h9AmehHheRzSEwU8HBNnh3BOCUM9X6g
	 yDmUK6Smq4qJldca+3tVA57gI54hVBVgwwaPZ0lMCm+EI1bwFNnHPhm2pimrwD9K8K8yS
	 euGJx4c800JM6ntxWshE5K9hF5rtGHeJF+WuHdcqM99OpZQVQBBcl10H51bsc9pCJDdqr
	 4BeSaZlrWorh4urJTwUOuXYkWtssI08Yprx6xJA2MmraUJppuLB1/RphbAzhCdMo1Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=efuIlWEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE32A606A32A;
	Wed, 18 Nov 2026 20:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=efuIlWEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256B71F000C4;
	Wed, 18 Nov 2026 20:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032942;
	bh=i5mTKRYRwEyFOgVWLXbMovB03r9ERnQoiCmyCsKyuL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efuIlWEQ6cBatBINBjUJGaRq5JfvxFW1Z6a5tFHyPvVBAmD2JlUsUi0Ly7GBHnnB+
	 u/RfwnioWGZsIcxdOlH49Jj4jLiTub5votrRFwDgDqwf06VuZxSQpY6ARjuG8+r0o6
	 0m/MS0kIrxsQ3pGfB+I+q4+LutP7ytSMpAL9NXG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1590/1756] clk: cdce925: Size the PLL child name buffer for any int
Date: Wed, 18 Nov 2026 16:01:57 +0100
Message-ID: <20261118150113.247155521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit e9e6b4dc303dff637ef725aca4f4968d7600798b ]

The PLL child node name is built from "PLL%d" in a 6 byte stack buffer.
The PLL index is bounded by the chip's num_plls, at most 4, but GCC
cannot see that bound and, with W=1, warns that the formatted string
may not fit.

Make the buffer large enough to hold any int and use snprintf() with
sizeof() so the size stays tied to the declaration.

Fixes: 19fbbbbcd3a3 ("Add TI CDCE925 I2C controlled clock synthesizer driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20261014-cdce925-truncate-child-name-v1-1-00136be00c49@baylibre.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-cdce925.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-cdce925.c b/drivers/clk/clk-cdce925.c
index e48be7a6c0e2b..50634618c75af 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -617,7 +617,12 @@ static int cdce925_probe(struct i2c_client *client)
 	int i;
 	int err;
 	struct device_node *np_output;
-	char child_name[6];
+	/*
+	 * The PLL number isn't a compile time constant so GCC can't infer
+	 * the number. Make the stack buffer large enough to hold any int
+	 * so Wformat-truncation does not complain.
+	 */
+	char child_name[15];
 	struct regmap_config config = {
 		.name = "configuration0",
 		.reg_bits = 8,
@@ -689,7 +694,7 @@ static int cdce925_probe(struct i2c_client *client)
 			dev_err(&client->dev, "Failed register PLL %d\n", i);
 			goto error;
 		}
-		sprintf(child_name, "PLL%d", i+1);
+		snprintf(child_name, sizeof(child_name), "PLL%d", i + 1);
 		np_output = of_get_child_by_name(node, child_name);
 		if (!np_output)
 			continue;
-- 
2.53.0



