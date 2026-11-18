Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042468;
	b=hBnqmGeQa/25CGB9zaFzq+UXmi7lPYlwehfMAPIgfmULth/26oJfKQQDsuqPQKTI2ql4
	 LbizeOq8Z3AlDhT+kziLjeswWf7x3MYc61X5O1irG3ffA2vBVFonIilq8wLGID/wn5Htt
	 p6Ksxqd75b9h0imTWsu7iOVftiAaqCKWmvO0fnSW+wn/q+YRaBzpAn6CLuIpKmUtOkxDj
	 YeG++BNoT8vXa9Iv/Q086C74K6E6tpkwivyYfUVrO39FrL/vTiarMgMUGYDJiMgItDeVb
	 s4qAe2hwkgAG3LkVohbzKaLunAr0x5a45E4fLCgbJAYIGDtgToH5DvVlEcjGyvmMBsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gDFivPtPRjHIvE4A7IL6Dt5c+7HO2wGj9V1SR1Pvi7U=;
	b=NMdbOPx6P+S0GHho33axgkG6F5b8zLcCxMFQC/ze1YizjY3b5lj5P6/RLE+8cW/4p5RC
	 tGOZVPgBDO+aVSPS/UckpoGwQMkWiREdw21bQLR1s/s+KTyDxOT0EkKqXsUhTLBTLbruO
	 jAV8BFo+HobRzknU/a3brq0kcZeoDaTBfPBfD/QexK2qgGrYZw1cWDzKJ+j72XkOAkcFv
	 ohq3snmucNcrphONhmmipaSP9cgIIVpVHffDeRr1xZCSSuCY2lyLwrHlwru4Z/+4oA8L0
	 T8vzjqPdjRTFrmK136d/tby4pskInxHghVWX+Rq567GSblO2aRtI5qKfY9MqG+93h7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwxciQSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1A606A325;
	Wed, 18 Nov 2026 22:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwxciQSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09E61F000C4;
	Wed, 18 Nov 2026 22:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042468;
	bh=gDFivPtPRjHIvE4A7IL6Dt5c+7HO2wGj9V1SR1Pvi7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwxciQSEEcpgalGQWPZYlhjZiw52kxfGsnucxKNrjL89k6598k5nUo6ffarrCnMEg
	 lGRAI2UJg3VVVQCUgOlfARwUPgSHgUiceokTtSY8234R9VNZ4QFsePQ6dvaGTzoDT7
	 2T2/Cynpq/ekqZmyMBdUmMKUHb5cbJP1uITHRJ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3181/3318] clk: cdce925: Size the PLL child name buffer for any int
Date: Wed, 18 Nov 2026 16:03:23 +0100
Message-ID: <20261118150455.246283025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cdee4958f26d0..77beafa9d9a96 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -642,7 +642,12 @@ static int cdce925_probe(struct i2c_client *client)
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
@@ -714,7 +719,7 @@ static int cdce925_probe(struct i2c_client *client)
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



