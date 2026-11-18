Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050537;
	b=hHX66L2cmQKZWkHwK+TS4uC6q8mQ7+TEtNNRTlw1y8jak/OkbHXfbZk3OxcIJcJ+fj5M
	 i2Phc9kdJSEweEbFAi1oXNLUcrWpPZ6H8F43ib3OTve962N2zOnM9woa+XZe5aFRy5T/m
	 5WNBxg1uVX8wbeHSVjYw+Gw8mrs/y+TXvyUM8sHbDXZkFCAZ8uAhqKQYXYHQWZ9Es/PbJ
	 v8Y5lSKMORN2wErt8sPmiIS5ektIlaIpCz2mNIgrcyb/PSaN/ct1JDrOPFVmkyWgj7mRD
	 c6KYWBjJpB0wv++2IVC6qQpI6pEytVngMaYqN7BM7QglXFnGcw92Z0zNsdGZpKfXq6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pty1dhOH2XwrtwFhwrtqwWPM/y2rMHHDiYs3Kr/kRHc=;
	b=LJZ2xKn6MdqBDoAupFLDDMsiCH6qTDbl+VNFxcY/d0OGH2XrcymKPiIXDO+LWBI2R/JV
	 rwJYsBaXiVPmMJlIwzyn6ommyJZXSFDk/h238vbMVwrJzvdeT1Kenv3U0sgKWc31ZZIpZ
	 AGBhXj6tZaq2TYQb1khMvywCsIxCBBrNqqqaA0tEn1Aqp7nzhR8jACOlu3rr1kyeFN/yr
	 yynK8NtfBgEtddLXcDEtehfv+/pLCOV5azPdFd7APhnSiGSTixQqkbdFooN1M4QKhgBRg
	 exfTN7ja5id93IYOc+baRhUMv6GEKuRHaqGrUWVWeBAcikXToCRH1O9soXSNLfVxx4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHO1xYaZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD674606A330;
	Thu, 19 Nov 2026 01:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHO1xYaZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55B21F000C4;
	Thu, 19 Nov 2026 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050537;
	bh=pty1dhOH2XwrtwFhwrtqwWPM/y2rMHHDiYs3Kr/kRHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHO1xYaZ3evulu0z1EthghYe3RKpKhpKhaVDHNyPfylPk23uv68se8U15Athk9RkK
	 q4uwp+YHmK3XYTZPdvW9NwCu6UZ6fIet9lwBXrwiHKQdP65Q0RVnNYQyKuQeA0guCo
	 W+o/sYsbUzRJx6HB4tiCVv3vZf9G4UKvBZ+t7kvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2742/2857] clk: cdce925: Size the PLL child name buffer for any int
Date: Wed, 18 Nov 2026 16:02:56 +0100
Message-ID: <20261118150340.342355593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d88e1d681a2ce..aaf1271e869cd 100644
--- a/drivers/clk/clk-cdce925.c
+++ b/drivers/clk/clk-cdce925.c
@@ -655,7 +655,12 @@ static int cdce925_probe(struct i2c_client *client)
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
@@ -727,7 +732,7 @@ static int cdce925_probe(struct i2c_client *client)
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



