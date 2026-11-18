Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060496;
	b=puiWs8S3e1MCyVK1IWbGDOindBmUWnwdQmgCoRiLv9wm+2QdbaBNJ8qI8I8NZrSe3dCK
	 b6K5He0e8TdMpmov/1VJoaXqlaSaSD3WSxbtTPnc8X5W40gF6ST7IFdhunNMoJ4rFTIzq
	 bolqhhh2QyMU+vDM8vS3lv/Ba+WiDS/gMUe3wjUYQ3syVjAaPEgyZlC3OHSP4Aaz1/wFj
	 OjH/1wQkEoIC0vNTaEBcUW7zTMXuhEnTN4N8hZSJJF8i9ZTXhhCN2dVbRuMPRa5YRckOW
	 CKfzJ4T4TEBu5bHWZsxVFyALJddp2H1U+gMLXtP16ZhywOi1fHsQCPTBQ5puhzVigjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zcUGXJUbU3i1Cuz+DibOH2jCI+CEUPnU9bA0TKt2wuw=;
	b=tHju6KPworeUAQsJxG1oakUWkEpjCH2C0o3FAUpxs0i+KOvd6Q5sFdCmEvwEw93S+3v1
	 P2cntTLQy1h4venjtmh5/LtEafxjZvImlZuCFQ7PlZAax4vhfeTZrFqre+pUkRFKc3arm
	 FVKxKBATUIgjaC0rBoW/VfmC/wQg/AavW7+yeQW8eCeea3dtOJXo0oNIdmt+xn+x7UR+K
	 6Ixc6d7nWzdes6SMrLaVx8XRLi8FlGOElNpYHKJMonyH5PShLcQAoF4FlUNZJM6g6oZJ2
	 YyzE2hGrtN5BQg0sQWPeCyFxIlP/flpCGSZxbu4agQ1rGBwx2OG+GI3Dvt1cfl1Et/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dkfOeSzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B6F606A320;
	Thu, 19 Nov 2026 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dkfOeSzk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404251F000C4;
	Thu, 19 Nov 2026 03:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060495;
	bh=zcUGXJUbU3i1Cuz+DibOH2jCI+CEUPnU9bA0TKt2wuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkfOeSzk2t9CP0Ul/E1JY0kOhRM+avwBe9W1uNghi16ZOvzWmNitjP/avSC3nPb7E
	 C+DMyyB7utFKvkqsrDB+ntSOSwW10Ianmpy1+E31YSL+UWzPF8SEVfxu5mmGre4yP8
	 fc60aYKeYBuvPfz3BxVLe1xjMyJ9ct53h0MOXPjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1219/1848] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:54:17 +0100
Message-ID: <20261118150010.994001556@linuxfoundation.org>
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
index 47b8b6f7b5715..66f71bc705d95 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -151,13 +151,13 @@ static const unsigned int fixed_2050000_voltage[] = {
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



