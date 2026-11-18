Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021961;
	b=fLGjumfiTX5xEKD5MFVUcexhI2SIB2igiAAULrfxx/JIjXWUtKB51dTMcpgu2GfK0upC
	 cK1TVNAV7nDk9uiwwtjZhS6mAJxcHdBMwdSszwIrtS87PLgIv2d8e1WpbG/udwdBqBAbU
	 1FQ24nLBra/fvlUkq+DjN+m7zrcrlTvRS07DxfRWxESDLbIq76t6K7Gj2VhR5iV/1WLg9
	 /Ya8IK3dTNc4hVja/YYvfhPCnrdvS1T0X60Ai9mngLFHm/rmFRRcYVtPkWyGqKGftQ10X
	 V2qTVLXKNYmqBdQaEsJ4g516kvOgE1dKhwfVBhkx/qANONOA0uZKOvBZ+pWU3g1x9gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gv5Wy4Dh8Z4MetUOSkqFbRe77kQAvH0WGYLrK5nwuQk=;
	b=ecV4t8DCTZDrawNE4Hwb88Adhe8CgDJg5QRsTx5y3TigF23O2KYnPIwrYkelMNjov5M/
	 rlsuRzTts+GRr21lCIeozB0iI9f3+fBN3rUAHodJZHE3Y4Cr9uxnOOSpTpr1W4njsVU4O
	 /lT5xeWi8BSkSSGzEIxD6ozxIoYzlHQC2+wYIGw05UWiGJ0MfayPvq8OdJA9EAGGE3ns3
	 wCPAlzNQf+nlIpCtZ57Z/WdVx6b/4Rlp+8xtFVop8uyQbbxrTkqR29UeISdzcs7gFCtS7
	 1NPbYHJ92yL9tQEncFjEMF1c5Ni92XMJFPBIZdKVCGNZJVOkPB7hp9IeksL3Nk6EIyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbvPdFmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87157606A31C;
	Wed, 18 Nov 2026 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbvPdFmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67FB1F000C5;
	Wed, 18 Nov 2026 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021961;
	bh=gv5Wy4Dh8Z4MetUOSkqFbRe77kQAvH0WGYLrK5nwuQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbvPdFmihTmj2Ubi9yjSFR0ZZYadHeVEh9aMtQyDYJCdJcUjDHb/UfFMK16C9BM9j
	 ASmP2ezCiYDrmK/rAlCfI0EjJ2BEIX9ys/K7dWAtt7SnZOZsXc5alKWrEiUs3c0iy3
	 ymA0BU4SbWnADAsbQ8UF9MWW4Y0iEQXY9985+vR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2452/2651] clk: cdce925: Size the PLL child name buffer for any int
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150413.376468250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 30d0493c77181..231e7726fdb03 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -625,7 +625,12 @@ static int cdce925_probe(struct i2c_client *client)
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
@@ -697,7 +702,7 @@ static int cdce925_probe(struct i2c_client *client)
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



