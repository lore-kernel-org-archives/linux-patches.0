Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591438;
	b=ZGwRPcuTrat+GDCaFx719nSTfDdsiU6GR4HDbc1+z/QpyaTSDEfjthVDE2ldS/p/a0Un
	 HEvTL2l1KxSX2VVrPcO954+tZ+voN322NVg0X1GTn6UvqGpcgJ11J0rBb+DU1QqKKfO2T
	 HOc4/ZDtzpQpQDW0I8N7eXxulG/bI80z9JD0O7r/N0vWewdBoWftGDgqeL9K8WVhwSBOS
	 AURbBj5TfpIaxAbo8ImVX0ws76gnv/Z3SkP8RXURHifuqjU9gSKY+auKfL029HRFQfTGh
	 wyuUN+CRrEKp6ByDTr+0TE9oOjHzQEDbHHnjAOJvle4mwI80Enmodskgyus+aZXieOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P5ZAzBN8b84Q77xPsN5dvKb+1K5jTVffbSU1dfoO+XE=;
	b=kbr3KETonFfL6n9gVqMT0YIG+2NRBXcgPtSKQgcEL60dijTlwxOdh5HX3UpQ/D50blcO
	 rTL4u1uZ3kS3Ma0alL/+Xbj7kycFaVlWcUy5e6eb2nYb7+thEDs9Ag5pTH2Z7AjuWPB5K
	 JPdDQpYSZ9AojqHTPO1QiHSS1TcCuldfUpnMMZ9gDKAbL8GTK52mKEsalDGldoK4aBsrG
	 kL7SOzqhGx0lqDbuOxJ7SRpDk/3+gb1lfggqI7UgbbAKV/twrZAsPVlIjqh4ksOn/aXng
	 WfDs0o48h1/IYZHHN1c3Jk3EP6sMycuOrbjSWm+iGcWDK7ARMUz3Kd09G9QoG0ZNeKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FW5ucCiT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B64607C344;
	Fri, 13 Nov 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FW5ucCiT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C91F000C4;
	Fri, 13 Nov 2026 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591438;
	bh=P5ZAzBN8b84Q77xPsN5dvKb+1K5jTVffbSU1dfoO+XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FW5ucCiTRQBSXSt8HpHnt1VIl4yKKpFSl0ltDtOm5jW3ltKPXajkFynLpcl4Zlxxg
	 KHc6CUIj6+pFwww5gMKTvQk5bPjEYNY/ZagYQGuJ1WtV1r4JfLW4KoO81kpS3hUvII
	 jH+IQ27WCgKl6iyJU2tKubl4JtgUvLeQ0ZUnI/nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 530/670] mfd: twl-core: Use i2c_check_functionality as boolean value
Date: Fri, 13 Nov 2026 10:51:34 -0500
Message-ID: <20261113153829.875700787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index c130ffef182f1..c53be506311a3 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -750,7 +750,7 @@ twl_probe(struct i2c_client *client)
 		return status;
 	}
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
 		goto free;
-- 
2.53.0



