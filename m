Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060700;
	b=e3B05oTJ8gopbFGdkvW2buf+vOsIDkTedM58cD4bj1QAUW82K5CHxi2jMbGaJxusDA7W
	 sBHGQOuQkrgqWbYgVkhuv0Jq398TMGKW8k77e6uBqL1KWpwmgeZbBKCG9H1GOAiM+b0MW
	 TXz0LPBFiOCe1uJP+95jE9fVITcQARcqoco8GRZ0H4HAwTQBup67PHBsTBTQ5O6qJ7DSB
	 NbyVc43XdKifbvs+3FbVq0iQIwjP1w7M7JU9Gy0vgWXfxWqZXSWpiGXfiglJ54y/by67p
	 k4FC6511LFNT88Yqh7RCyS4/n14kg6d57H/IvLVV3ATEbC4qeyLZ9v7uvUsqKMeV/lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aNUswlnlj0gFb9ipMHAlCc5F+4xrn1r2mhIFPSO0bI=;
	b=fts6JoB8N29Vl6MVEIE9ztkA1Fvl/miC/D9Hd7cKSGKQo1UUKDygFiG4F6dhRXfzeEht
	 Y6Of2IMQB84r3EvDyHqZkP05aDu4kkrk6P2wFt+23Wb6fqa+xPUDp97Agk8+ndBEqpMtq
	 v5VxWxiSvKucDw8X5nhOHxxlcLOYveMOr2J11u0QeP+5GSmG+rAXLtog75XnJJki4y052
	 oAKwm7U7CCpHn6+6i+zKwrERbkF/jG76BDUT2Za0QoBwcLIv8DsDxKdQE6C4UKRpLlqnH
	 DVqRqSVfZzERXes3BwEEdgZaHyOa5Su90WzITBqEQO5vFR2J/ezM8D0Oeq4odXXefTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k96f+/Qs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F9B606A325;
	Thu, 19 Nov 2026 03:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k96f+/Qs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED441F000C4;
	Thu, 19 Nov 2026 03:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060700;
	bh=+aNUswlnlj0gFb9ipMHAlCc5F+4xrn1r2mhIFPSO0bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k96f+/QsZiGTvQuNvmP2La3MEZrcy7ool7owEG9+EhT5ERVMr5hwxGUWoQGwTPkxK
	 wo6LaVXU7EYcVoY7wy5G6n6fqkGQjtSJYaDfTjXMtIqfUlyDexJCswPyTRNm7PZbvP
	 7Z9opCRbjIHI2B+gZt3MqMuyKgNwRBd4h/B1kiFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1294/1848] regulator: mp886x: fix pontential division by zero
Date: Wed, 18 Nov 2026 15:55:32 +0100
Message-ID: <20261118150013.711835633@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit d16ef5debccc4289c1f25309a2cccfbbe879601a ]

If the "mps,fb-voltage-divider" 2nd var is 0, there will be division
by zero bug.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260901043123.5401-1-jszhang@kernel.org?part=1
Link: https://patch.msgid.link/20260909143957.9284-3-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index f42572d0f94e5..ae45a8dbdb27b 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -317,6 +317,9 @@ static int mp886x_i2c_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
+	if (di->r[1] == 0)
+		return -EINVAL;
+
 	di->en_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
 	if (IS_ERR(di->en_gpio))
 		return PTR_ERR(di->en_gpio);
-- 
2.53.0



