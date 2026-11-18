Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039973;
	b=d0GHB8rrGhpNQmyv8gC/9EkBroC3RklJqrqusglEA5aok3X8lQ9j1ISIwdpznaA4qxue
	 0WNdnhx+dQGBd4HBcKhFrix3Drp9G+GNy1cjnmntxanBF/lx1whFHkX0e3eO+qhaBrK6f
	 jYAwaYySuuER3FljfmzgeKsVW+ETs1Gq/iPCFryH7M4iw6UnnlX1GBVneIZZGBzuGaIrW
	 gHoMF5LLxfd1so9iOgBU6akm9Fga3ntJaEUIfh0wUyYrCkzHbzEQ7n1eAWS0HLZDHr3Yk
	 Vz9sqLeW0alkV9uKSRaC/NiMzD2ijybGwzeEaYBT1uILLj8rjYYZWo0b/k7G/Pv3/8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jN6Kh3Bk5rnQAjOc+ApUZJ2LGaMfnBCDbOpFJhkbQHY=;
	b=VA3x0MYpIghe5MUU2xfz32WyYMPGwHVHrsqwDmmbkC1CMQmkH3oz8LRWsO/IcYBJzGG7
	 I6bfjYiTsT778ysyi/ip20vvq5BgPoLT+2UTX+asLxMYj3QI5UOj3IEl6DEaHcS6cIlYs
	 7Tab+NTlncm5iWVnY1X1velpf5nPqMy3u2fWzmwWUwJ3wOmkivAMpPmG57UoU4QZAOZHM
	 t1/bcG8s/BOiWFtBQO4gtlxB9IwdPZ6XAHyG7ELCqO/awVVB3V6xQxoK87i7PnXY0lJHR
	 ZoCzwPC2NePnG/kC7gdoMW0WuzRUp06B6LvfJi2E3nwubF0LaQhLKnY1seGRqY13aKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mgn/f9ye";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4D606A32C;
	Wed, 18 Nov 2026 22:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgn/f9ye
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941311F000C4;
	Wed, 18 Nov 2026 22:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039973;
	bh=jN6Kh3Bk5rnQAjOc+ApUZJ2LGaMfnBCDbOpFJhkbQHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgn/f9yeUnHxcozrsJcL6znKFeFIchnBN2Ng+68nzO9lIg8cyaumSo7xefuC/53pF
	 lqb2IFfurdYWwdfGL20dGDUtWD7J+dic/pfE6rVZpGaguJlBFL0ILiJPeEH4Icd+gc
	 JV9vAd48niIlcw0c/vqY65dfyxDGVgqMLJ9hD1hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2291/3318] regulator: mp886x: fix pontential division by zero
Date: Wed, 18 Nov 2026 15:48:33 +0100
Message-ID: <20261118150430.472814869@linuxfoundation.org>
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
index ec475adf9d22e..7ed118ea82f37 100644
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



