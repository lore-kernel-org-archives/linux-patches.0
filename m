Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024113;
	b=Yxaqk43p45gEEw4c+13356CN/cwcQUxWhMn2QDleVWFDqCQaDfS0Lv/BJ3k/Eem2NZNr
	 ToxAYwk/BQqESX5rZQpkwAtDH79KJ3B1gt3bh0hIPLJ7jTcxQlHsbCyG1MTsQWIpVwisT
	 PGTBosrN7Di+stqe5SYpwlVP7eEXK+fFIg076Ws8jhOY7tIeUGtTidsoBpDLg9i15aPJ6
	 nXeAX6j0eBv9v9NOD91rF6JyrKBpzQS1S4CsEk4jCnjX/h19NL2u3dl+ZIcWbbO1WpHp3
	 tdTbqd79wh7BCBra590wmQS5k7JMytONvXET4YqtvEu7T7qR5mq7StXlhF15JB39SqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T25L+Fw+rsZGI8tVjU1LNqHu88g0HEXSD53NAcuvdVU=;
	b=izJjfd8Wcstu0YUvsSgZTvJDAJBzaygV7IDZk4b+u/ptGGHAunADI44k9bIJqLVC4/TU
	 Gvt45xl34UkrRxy0bYFxnw5uXmrG/O5moqD6stW9U/0Fj+f+kYKTMq3/++j8jXXAwjU0x
	 D3jyd3NiIUVx/s2PrIMn0ukPZEfGb5I6rOOOMZVBGbXApV36xeQukSFuL4gN5xu5I2Ao4
	 NzX7fuzLWBXC+aXzILhNsPv/WTyKfZzlDXu8ujMhvPsJttc6yXZiKsYKXYtqhGNNsAQip
	 a2VhjrXlRJIhYawRP8tKc/jbL9dT1CA8W2ZZKKOhUD8c3DMXSZcMECmwfPGb/SznbTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lxdrvoet;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE998606A31C;
	Wed, 18 Nov 2026 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lxdrvoet
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173101F000C4;
	Wed, 18 Nov 2026 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024113;
	bh=T25L+Fw+rsZGI8tVjU1LNqHu88g0HEXSD53NAcuvdVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxdrvoetuPlqOQns5OJFhWc4ulje2sRq/1FnH9G2kz4lSOEBFFh3rvUnSvxN92TDH
	 dc9x1G1MeXJ3DF7BUaCg2f9mA+VqpRCKMbB4yxGbHl30EfkK0A4e7Z1O75k5STIxgF
	 toSboB8NoxEhJVTWK01V9w0su/qCTq3zirs8Ib1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0603/2151] regulator: mp886x: fix pontential division by zero
Date: Wed, 18 Nov 2026 15:38:58 +0100
Message-ID: <20261118150143.910137279@linuxfoundation.org>
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
index 6bad7ff40aa9d..99450398c19ff 100644
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



