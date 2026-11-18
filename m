Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039604;
	b=siK5RnMM3Uk5tSW3v3X7cei4cIZ0XdbvoH3HGK3K7SKKKHbKe1nWL64wZHTPNuvWuG8R
	 Yti1FqbY1FbwANLbX5XGAwSPsrxr8fWmC4iNmguevQ4AJASZDP/cuUTcBDUJVC7Ero1t5
	 hLkTaRsqG66qkHyAB+4vU6TMPJelPPvACqCEAxU5J98zud+7w4bYICDYS3WZcdtzgfEj5
	 vEmmOYmSCzkyOKC23cAmBfAl0TpzTmlOTAnHH1BJuEcGTmKgFlXEE5Ns1qk3RPxS6goJr
	 QmdvlnrX8gKAevigXu3fMuE7G9YI5KNVbdsYZ2ijnXMzFsg12DgUpdbaskhwo/KvTIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GSn+T9X1mx1pnQFhGl8ApUlL+q0IYrFCGnqLz/+D0l0=;
	b=460qIdlJLvuoQG7F8q7eNdXgzNwRZriCTsl0wQ8xKQY5ikI7Dx8kjS6n02/O12LUEQDy
	 JM1V0rgzzx6Hphg24po+X1AS9GRbV/hoYvAkfPXIBAJwjjSnLXtpWiLxZAFw+Brgl/KfP
	 7v6rujqsYp6gC8kB1qUmZSm+UhZQ1HpPAaFRoIY9KhKi6dxIi5FevnIGZdSfQKE8jRGcc
	 1Xs5+xKLW6hFO00Yd/qTU1U9MSlCj+trS1OMKt+zPmW14GrpFZlzbDQz/aANj1cfCXHzS
	 fMZ1pxBo+S8XqZAPnrH+VRfDTH/8dr8YJZjKClNK3+K1eieTPO6uHGNeGcpY2lmL6Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E+0QNWQZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E841606A320;
	Wed, 18 Nov 2026 22:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E+0QNWQZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06341F000C4;
	Wed, 18 Nov 2026 22:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039604;
	bh=GSn+T9X1mx1pnQFhGl8ApUlL+q0IYrFCGnqLz/+D0l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+0QNWQZ6b2855yTJP+7EzTOyuXwnQGzf83P1N6oXDjBhL+weHiAZ6S8sDH+Y6idC
	 v+LmcZFnQXJu9dxQNxUT1GkC7A/2qISsvDUhU4eWcjIjYDdoB7/Dkv7fpL/0X/nMGw
	 7sQGdDTZG5nagWIj7AHHulka1NetI9HVYBdpITnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2160/3318] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:46:22 +0100
Message-ID: <20261118150426.811165911@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit dfdfda2a95843706428a9d95ab546cb10983e684 ]

The AB8505 VANA voltage table assumes selector 0 represents 1.05 V
and all eight selectors increase linearly. Selector 0 actually
represents 1.2 V. Selectors 1 through 6 cover 1.05 V through
1.175 V, and selector 7 represents 1.225 V.

Correct the table so each selector reports and programs the documented
voltage.

Reference: AB8505 User Manual, DM00046744 Rev 3, p. 257

Fixes: 8a3b1b8703fe ("regulator: ab8500: Add voltage selection for AUDIO and ANA on AB8505")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-1-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 6b4a3a3d83851..26accd604c395 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -265,13 +265,13 @@ static const unsigned int fixed_2050000_voltage[] = {
 };
 
 static const unsigned int ldo_vana_voltages[] = {
+	1200000,
 	1050000,
 	1075000,
 	1100000,
 	1125000,
 	1150000,
 	1175000,
-	1200000,
 	1225000,
 };
 
-- 
2.53.0



