Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590653;
	b=avu6QTXtKmJcc63ZdxXn27eFNU39a8D63Hx6n+NmqRTNXnJQ7uIL9GJWCYYnKenO9q87
	 JPmHVsaY+ZBRBZ5lnQpM9WmK9gIPRIPo/71VOwYaf5Db46nCxuxXFAaqGyyV4RyydVYeW
	 /7/B1lYWssuU1npRg5ZaHCl+5VfuwYJI45Y+BuuP7B++rwvub9tQf2cYjFEJkvlSoCfnT
	 WiD7PnDLO+IjSYOuSqBp7VKbzzT+4LYouZ0TjBBxRpQvbQQ7XOcAxFJHwdJBEGn8JuGNk
	 CF+4JLuWJdFcJBsQykSjzAFspXUVu1wQeFpxVzYrQkHIT6omhdfsN0acENZYtBNOBmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v3f344F680IN/o5EW56MqDI+9vBU1vbd33Ba+xxhmrw=;
	b=5h0vY3sCEyxklC800578EsDsCeMePNSHDVpqmLB1PSZeCxcin7AFuws24UtIvMvbCxs7
	 KCX2cdB9jwKyv4MEelUNLxdjzFKjEOTOf9Ek/7dJWwjKUI54d7aHKxYgn+3YU3r+kNlGX
	 9oTcQ/zOrud/UQtmBkjIgm+PCgYVYbyJfp61atfToA1O1EEkfFR3RiWnsKFogn5unIY3p
	 WDDBnjVFyN2U+K5uEdz0Pw/WOr51Z+lKsX0f6cq6zdK7kipEcW++tgjm5Fk6kAuGvhwkl
	 gWnfWBQMiIyrFx+3USd9Ml03tOqkq6RFlVm1v/5zWJq3QLQHBMU5I2CBobRAuUVJ3CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=va1fUFXb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529896077D7D;
	Fri, 13 Nov 2026 17:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=va1fUFXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40581F000C6;
	Fri, 13 Nov 2026 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590653;
	bh=v3f344F680IN/o5EW56MqDI+9vBU1vbd33Ba+xxhmrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=va1fUFXbBPI7HWBuu4ixO9U7PjqCvk92ruFVu1oTvKCK/6q89BaUDKea6V643tuQM
	 nBWXA9BknwJO3wd3BBXT3F0RvBN3Nd8KOMq4d83+9vQX27iHRbnaSNu9Kk6GOb1pPn
	 q0txCCBOUz8PIbiwBb52KOtF2HAw80IWpBOY4heM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 573/686] mfd: twl-core: Use i2c_check_functionality as boolean value
Date: Fri, 13 Nov 2026 10:51:46 -0500
Message-ID: <20261113153841.077255320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 7ee4fa2674e51a0d100b9240cd8a50355141362f ]

i2c_check_functionality() returns a boolean status rather than an error
code - directly use it as a boolean value.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260505114543.159381-2-thorsten.blum@linux.dev
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 3c5c55d979dd ("mfd: twl-core: Unregister the auxiliary platform device on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index f89eda4a17fe4..c024a28b057e3 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -754,7 +754,7 @@ twl_probe(struct i2c_client *client)
 		return status;
 	}
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
 		goto free;
-- 
2.53.0



