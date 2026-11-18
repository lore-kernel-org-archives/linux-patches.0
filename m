Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016814;
	b=G79y0TkVtv/vVDZowHq4mPMwaEjdTcUzc2LjR71SaoND89ObD0R8BsgQRMXCZhNYxsYz
	 ESgLjkxwpitV8Ih17mZH5YEjb862b0ukbC1UXsf/wxjso3RzwSjmsdUXWpYHckrbp5YZq
	 rG/JF5QoUwtHCaf+0OpK4CYwlOZVD3Y12+5WlOrxn1UepWOW7nk5XMtdjLbaUo24gAope
	 JqyAQzABKtUkW9bClL/8L0AFzjCoI9ifnrZuJwBmC3a9Uk2jXnXjDZUIwOaC4FBacLO0T
	 kn7enJEVe+Buj0Hk7+zY8czsFFF4b8iqKaa670c2qYpdPfvVrs04guMV4ojOQy+QMnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l7QFMNcQhE7wtyYEIIDw8t+2j5hzqBFxBFWotnxnTAg=;
	b=UoAng/mgEDjGJPbMNzWmKlYbzTioTkU8o/gUvL74VTdG2fmbKyCuq+Lk/vhHQR3OC5ek
	 Dmz6J9OAf9E8SUpK/p795REcqsr3xccPGzSj8Pi5DgQ+EBxcH8pm306LbKfbWx1M2RAYS
	 A+DGuA8phgKrQqw9KP7bHr/5vDNxChxdXjWOdq/86uqbyumnpeiSUV3xbJ7wf/17Cg5QL
	 8U01j7ymH4vVOF74MIdO+o0Mgt1SGOLQ5ZZdL2QuyJNMY86EH3QjEVF6yCxrCTVGa/WPH
	 QSQGPN+m2+i9IFBkdY0wUBTZhk32bK6w3uSlZ82iuOWoV5M9JtiKlIH42QUik6jaEbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvQ0uMXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E93606A32C;
	Wed, 18 Nov 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvQ0uMXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8931F000C4;
	Wed, 18 Nov 2026 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016813;
	bh=l7QFMNcQhE7wtyYEIIDw8t+2j5hzqBFxBFWotnxnTAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvQ0uMXBvj+29G1J53U/hMQe1we9vpZVJ8z6pjlzWSQ0pgCube8anX4EGouzmpp3d
	 1R/h1Qa/FAraYUGSllZunn5jCHNKP47skCR6IJpdIuJTFuJcn28GiKdrJ9OwxrbI3g
	 F+aOq3KJbKqd2p5i7Kn+oNB4g9O2r1saedfWE9E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0663/2651] regulator: mp886x: fix pontential division by zero
Date: Wed, 18 Nov 2026 15:31:43 +0100
Message-ID: <20261118150311.743654045@linuxfoundation.org>
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
index 5efb8585fb330..537c1a1158ec3 100644
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



