Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027975;
	b=o6P2wHBElmPwC8C9LsjlZUHpIo136muMbGzy19h2hg9Gh+7PKMvZFggYfGOMSq24qwAo
	 9owqzGmsAxHiu9PDmeQMXwCXudUcijcCzKiE7XobOsn93Ge8/DMN3/3H2YG3+XWlkNTd1
	 TBT67h56HNAWfahCExY9NINlqstNdKsJnQT97dIJ7MWdAw9bYptQHdOWGFn1tUHYeTMoE
	 oxeQ2novSKbVFzoA/O3g8jbyH3YPJsFZdj3sXtNJK1PwTqKn49jJj5zvR+fBh/M3b+4kk
	 FGdh+NEdZoX9clf3dftzeniZ+4/RQdRGeYXCZylyQVsEyaWFyxUstb+saF653AU3Skw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WWFATRUXppzkYz7Xx/qRi+6aABV1gVZ3Wjbub0CV/5o=;
	b=s64xT4qtb/J1UpIoyru3eJXjxh+f3yUI0WZDu5mqUv2WnvN4gkS7VF/6f+KvN5m4GYdo
	 hy/sAOuO75VKno9m/0SsosYZICLWnVjd/VpebjuTun0pzKfWVLJWnat0fi87Enet/PeOV
	 tsnmn6YH3T3lj0xYdNFzrcsxf1JYTp+fGj/Mw7ZXtXxiUKrXTnGKaqeMEY6DRkDEvG0Qu
	 uD8WDn8kjZwym5c+CMUfEXHOwp9LFNDLUaOLgkPmTpwzFXbrJiel1LaNElRqF9DWNfh1a
	 o+BH2OXTvaRWE1qUuP+/4/zrgiqL0owxw71mKPlPWggDQIiiSecoRSFNg1fA7oS1NDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/inYA10";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB93606A31C;
	Wed, 18 Nov 2026 18:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/inYA10
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FEA1F000C4;
	Wed, 18 Nov 2026 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027975;
	bh=WWFATRUXppzkYz7Xx/qRi+6aABV1gVZ3Wjbub0CV/5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/inYA101m68jm+fgKQJlcPCeKF1qq3zkJY+ErSt5DgiNvLtTYpbRTmOuJStvt0wd
	 pEOKKAGdmQ6SyxBXnO23gYDGqQGWLBa/EiMkHD7Zvu3ydkEdI/cdmIH70keFqqLXOR
	 9WHxV/3z5Pxy3FBOz4Ogpc1k/smpBhOt0J77SBVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1980/2151] clk: cdce925: Size the PLL child name buffer for any int
Date: Wed, 18 Nov 2026 16:01:55 +0100
Message-ID: <20261118150233.864275124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0b2ad21e6e4d3..384eb9227b75c 100644
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



