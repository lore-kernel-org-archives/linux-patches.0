Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038431;
	b=MOEoRqlt/sDTQAUZf/YxwFLKzDrPgC4eMjdW74kR2UuTT06zwC+VkYHox71ScKK5pxMk
	 +Gw0U0HGnj2Ec6K66w6HVZu7QjUCQydHoCV5YVrOYvvll2Hosq69CJ7WsvYlTmcY6akXI
	 tPBxuGojH/VjNksMt1lD2xYffWcLe6CXpLRZsu+kKjJ74Oe0ih9yUCa1a0A2EB1Kh8uuh
	 UwbiaPXgUR1gUkBhGNyKGaVOYMvu0YePVc58A3gutj9Mut0s22sha1avcPijaEsQjR7Cx
	 g9kmOMl84wbKzHQtXG/i5HDp23GwKOup9JipgQDqIUzCVjFl8hFlp1toC5yl0QyO7Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WWZC5cjMmcPDveRi47TDDrXGGlL4Bx8hna9J1dP2sPQ=;
	b=ODYrjr0/93b0lyycnoqgqhLF2hVhkJlAB2761OE1wFKsOKG/h23KGwhGMzVl5As7WJP+
	 lm+UNU1XRDn3jX31zGXwfMPgTjksj1s2u3D3dDSWCr4e7dKBY7/XWUtwzi78gBQy5yVat
	 j7MWd9jsA7x63pDkipUoWC2tEm7PDEz/tEt8F4JFTd+xeHSzK5lxIgL5y0Z9M11iRJ9Nz
	 w6ITbN0kBoz8kPg0MBXFJl4k7qIN9ijBusrLTQ7ftPM0NevZfRdNNIRfMX4F/xwI7ApXH
	 Qd0XIIubtHaO3f2HmAssTIK7YweIYL4vipMJTY5zP79+LM7abHD0VAhrs/mpBpu40vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W7N4DzT/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE6606A325;
	Wed, 18 Nov 2026 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7N4DzT/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B200B1F000C4;
	Wed, 18 Nov 2026 21:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038431;
	bh=WWZC5cjMmcPDveRi47TDDrXGGlL4Bx8hna9J1dP2sPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7N4DzT/L4NFZW3Z6SFyy5SooeXdsQhRGn3hzF8vRurimoR4ldsROX7BBGCUoOy+A
	 xf5WhZACJxzV65TvCSb7+RRXHJd1Z7sB6A0qBGBw+AKg19S634LedwiM/Fn+8GXhTu
	 M6E0q4Jsf3cYCauR9KmAeQOZuFQGxOG4zggbQJI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1700/3318] mfd: twl-core: Use i2c_check_functionality as boolean value
Date: Wed, 18 Nov 2026 15:38:42 +0100
Message-ID: <20261118150412.842799925@linuxfoundation.org>
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
index ce01a87f8dc39..352a1fb88f08c 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -725,7 +725,7 @@ twl_probe(struct i2c_client *client)
 		return status;
 	}
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
 		goto free;
-- 
2.53.0



