Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039967;
	b=gXB5t8UNirlsjrZvqpXy46B0OKarUfgHydLh823jRKjb62dI1bXfj3K6svx7dWnWARA6
	 qtog6rQydg9i/vvQFYmf/jH2ZPpFyF186v/toySih6DrIMt9MWSIFOY5VS9lQJs1MLgrH
	 yEedQfXhIcnVQ8X5FYFIu6fg0IkWBVieGjUIjdUmOmV6O5To97VLSbZpZilyGQKdLFFcd
	 n5S0c2yBBmry47X4R03BZ5kD3a/i+/9kIWlUJPujy/ewBRllWB3DeLvkRnW18JQ5LZZHa
	 XykwHOrZ/zINQgXB4ZE7D+1TVINSa0Bv/HJmjyiNVO4BUEpMk8NCruMyFLjGIMVy20g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FedsCLZKczVYOA1mPdhYjSPPdQwMoqb1uRF5iQbnvS0=;
	b=FN7pZ+hTZJFHletoFzhR7Njy6EYwjBVqkK7NWxDmcB7E87EAWVGpHF7h3YKoAamN30C6
	 DLa98TXUnihEPHbpSNJHecz/CSsjYx6WYOIwGKXmnLz8Pi1C1H54TV0SjCdf8NGXql9c0
	 Xl6uQnzyjIhdBDW/PK1esq/w43B7/HEC8xxI3D1o1rp7QPBfEBI9BJXHBuL0l2Vqj4ohh
	 FO4vjOL/w2EBqfwLVUR/kueHB7lhxUcElHxsE/6Yyzxms4oRz7EBNBHmYkzJRBMji9NAf
	 BN7IPEf7hWCduEqi5TcRt3zCduqztRY2diUZjZEXlCTsu5GKeEjn1HSqNIxJqeIZQjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLoYzuOT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E023606A320;
	Wed, 18 Nov 2026 22:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLoYzuOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37E51F000C4;
	Wed, 18 Nov 2026 22:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039967;
	bh=FedsCLZKczVYOA1mPdhYjSPPdQwMoqb1uRF5iQbnvS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLoYzuOTD7T9PDnKCGjPlcDkqLNeqkKVi8Y8C0r/KIwgsgyBogb4Rz4rwrY/GvaPC
	 DN9AkkrEWmu4ZS7u85nO6jqYQdh1OXyM+4CfaJILz8LvYix5OWzGvrZwiGrB0nl0g3
	 lAIsbBRjtueS35RKkjHyH3IBZyHVGUr48agc5u3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2290/3318] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:48:32 +0100
Message-ID: <20261118150430.445702742@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 87121c42fadc7683469aee96ad833bc560197a55 ]

The get_voltage_sel() can fail, resulting in negative error codes
stored in unsigned integers and corrupted state logic.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260901043123.5401-1-jszhang@kernel.org?part=1
Link: https://patch.msgid.link/20260909143957.9284-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index fbc0f726faaa9..ec475adf9d22e 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -256,6 +256,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 {
 	struct regulator_desc *rdesc = &di->desc;
 	struct regulator_dev *rdev;
+	int sel;
 
 	rdesc->name = "mp886x-reg";
 	rdesc->supply_name = "vin";
@@ -277,7 +278,12 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdev = devm_regulator_register(di->dev, &di->desc, config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
-	di->sel = rdesc->ops->get_voltage_sel(rdev);
+
+	sel = rdesc->ops->get_voltage_sel(rdev);
+	if (sel < 0)
+		return sel;
+	di->sel = sel;
+
 	return 0;
 }
 
-- 
2.53.0



