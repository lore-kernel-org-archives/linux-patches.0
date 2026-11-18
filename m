Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062185;
	b=BQtXN9h9AzP9toqvkShhdISDtr65w+cDk/bH6zSo49GISHLw9pja5n9weIxrYfYE9fJS
	 OK65ayEf7zSfm1lh7U5/j9g40XYdrnvLx47q360DAv48CLXWwBgRJwLXeQxgCBqaernnk
	 4bxklQE5FCgerY+cNA3iVHklraJjYKwLpZXE7Wgid19DIyddgkAr7w+Wu6h/AgJ8gF6eK
	 1OnvOM1If9pV+d1D9Yh1zb8VhHJZNoN1IjFLkyAPGOaLciOq/1DyzcjZUVHrns+DUzcXB
	 qRfpRoAUbdqkXMQTZwc9+nU3H+PvQi6HvgZi/PMMkfw7o/UpLJ4LTl3ASbtM80fWqTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6rTqmxbcVUDG4mLQcmzeAotKccLByDp88u5TMK4vWQ=;
	b=sGnvDhjKRGyXIJmM78UpmSvFMrEj6Pr1+E4XcJnYINzPR+N4FQlYzedm23ttfTSAmoyp
	 tjvVSHQXu4hvCbaB1vlBpq8tcybc+sVI67QRFcvf7WL8HhFz0bUdkp9ANGs7BEz65LCts
	 86kmxTnNwtCuLwXonyLLaNVX1/JBuVuvPXOBCs0+gMA5Zhg/eERWaDa/jLsK7/yLCFexC
	 dQL6wk2JZh+U71zGnzWwuf66KEROLRreCmL7LPNZ934YID6mC4MBtZzbrHY8JXUxTVDYh
	 L1FUgSWK9YZ0ST4wEtYtMfuYaIMxxya448XzhzVi4GbtcauW2YJtyplLtfbdaVZjnsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHS1QTXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E5606A32A;
	Thu, 19 Nov 2026 04:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHS1QTXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCB31F000C5;
	Thu, 19 Nov 2026 04:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062185;
	bh=/6rTqmxbcVUDG4mLQcmzeAotKccLByDp88u5TMK4vWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHS1QTXQst6MXVVWA4KvunN86X0pcy8ouSb9BeipO6HTNqIwkdf76xWb8CjQYHTmi
	 7yrZU/4HSYjqpEB6umhgxI9lRgIacxXAmdq57mh12lhkQMdGcWBUzgh7m0IhP2tSTM
	 VDMRFhb9/XTltMGRwj6BJneadX+Pn86NOLGDl494=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1779/1848] clk: cdce925: Size the PLL child name buffer for any int
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150033.826334980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 470d91d7314db..f118205ffe13b 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -646,7 +646,12 @@ static int cdce925_probe(struct i2c_client *client,
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
@@ -718,7 +723,7 @@ static int cdce925_probe(struct i2c_client *client,
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



