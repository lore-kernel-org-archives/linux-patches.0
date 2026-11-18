Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030798;
	b=FuRd+ZSUD732Y1CJiiPKcAFT337CSG4+3H0IGsCZaI4FNI4QsmLRhX+hT9ukV6UBZVKc
	 V2m5V3pUwuYiOqnjoN3ZyQtanF/8+LbOt+C829dyMLMjyocS8Pr+ejWyP6UmwE0aLhIFx
	 KgEhVQrMBEzUSBqssp4YIndb3YLde6DviDPOefdP64d2kqvvBkQoSWhZNGwu+/b3cjwbu
	 MKd2BUNjgtOwIx0NutQh05sef0E+HVx/1FqEWzbmklW7gpACDuQGp29HoF0Mbd0+r13XS
	 PjaGFUm8jHV0VCE1qviieN9oL3wvoax1kg0Fhd+23F032Qp0WhlH54Hv5hixAk6qDBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uy377rLGYQ9QWbZ0r3ayzlIiUdGJDVTDZ5UmLCPy7Ww=;
	b=K8X8al8TXKj3NGy4Vee1iyevsUBpS6g86vBGrMgJkaUYvSoZKBIlU24Sc7g3nJfNfesw
	 jWNJUkQ/gi9SmBfd8NKkuLrYlKGe3TtVvCkAyalgiLJUwCTqXNo62C5j9o59CEnLE85KG
	 HlJN7gzPP2OAfJcEZHnRjmmK5+gnnSyo7c9ym1kADl/OBgraMlgZUaSryDy5SKkovf8FO
	 FGI4PtAMj62sWUV31ulDPIUzX2NeBxS8wa24/OOYBWYaP56hYIB9xogV1f6oKYoVr2kus
	 bVVAIojsjTW7alcB7HeW7fJoBzZbk5ydJw1kdZK89WjRUeu+wtF9+KdteLBW2xzHReQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QwqpnsWb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055CD606A92E;
	Wed, 18 Nov 2026 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QwqpnsWb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEB21F000C4;
	Wed, 18 Nov 2026 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030797;
	bh=uy377rLGYQ9QWbZ0r3ayzlIiUdGJDVTDZ5UmLCPy7Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwqpnsWblSK34kn/sU392bY41jk9k1HfLP2ySrC5qY5bh2zm4pCZpYXfukauEAqRI
	 9Hs79vLfQAk94XZtrFykFma7gjruUlUMqg0k4e590UVpRNzIvgsbL0kO3tvS/g1UxN
	 UaGrS5slz69ixQ1xmDxo7U7GI3G3/kFet2J7K0f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0830/1756] power: supply: ab8500: Preserve battery termination current
Date: Wed, 18 Nov 2026 15:49:17 +0100
Message-ID: <20261118150042.548159436@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3b33eda4067494658d51db0792377fef98787e3f ]

The battery-info parser uses a negative value for an unspecified
termination current. Testing the value as a boolean instead replaces
every valid positive current from the battery description with 200 mA.

Apply the default only when the property is unspecified so batteries
retain their described charging termination current.

Fixes: 9c20899da46b ("power: supply: ab8500: Standardize termination current")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-6-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_bmdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index 3e6ea22372b2d..0a6ea935fdc0f 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -174,7 +174,7 @@ int ab8500_bm_of_probe(struct power_supply *psy,
 	if (bi->constant_charge_voltage_max_uv < 0)
 		bi->constant_charge_voltage_max_uv = 4100000;
 
-	if (bi->charge_term_current_ua)
+	if (bi->charge_term_current_ua < 0)
 		/* Charging stops when we drop below this current */
 		bi->charge_term_current_ua = 200000;
 
-- 
2.53.0



