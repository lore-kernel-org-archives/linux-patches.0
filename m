Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023445;
	b=ERQ88nRgy9ybf11k6kAcgm0tEymThYZ8usFBk+Jf6GRBwULV8OfCt80qYuoVE6lYzYE3
	 nax+6NKglStqG4UZ36OGVw5YHprrBuf8BYg7L8WegbGK/Nmx79RF6PorsYA6sz2TVLYAo
	 7uueHnJgEvTv/EOiiQ+jz3SLVsOp225I9Y59pckifz2nKrCUvdcIrsXFjnCHbKKSiERwK
	 dc4H2uIlo32lZM9yNgIDCL53eTIiQSfsHW7Z6UQa/ohUGJ0f3RGjm2mL7V7DIToSw875j
	 l5GOXy2ROEwFC2NlW4b3ZYr3LxuN/UySjEOzUJweXIAGRNrMVxR1tPzSj9XRdlR5nZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQBk6adfYdx6UAAoUo/GNQTe4FbTAociNoeURJhQ+vs=;
	b=oyGgqTqRJsNERHjH4ICtFXCdKbL6X+5LinqED3PkLBCH2cmv3KiLLV+kkp1tNY9gddsZ
	 wHWkkO0Pspc0ZH5EhySOxPdm54mUBjaAm9JmZB9FN47KKyFBqCN4fhSxJAPw+btXv3OGy
	 cu2vQjn8tpCwhiq92j5QUVKsFDEGBEL9PoIIfg7cXWc4CiX61kjYZpY8F1/l2skqjomxN
	 PBmooO9aNd/BLbvfCntY3ViEQ2pN6yC4EtNOBn2Gy3uf9plwx9huCTwiZ8NIgdkIrV0oo
	 LVyxKF34O5l43hcJ+PbeKvrEmwrz6f9EY6PlZ+uK/yegQFVWV/J7T4imoR2IIaypFbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGaoo5yW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0DF606A320;
	Wed, 18 Nov 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGaoo5yW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE6A1F000C4;
	Wed, 18 Nov 2026 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023445;
	bh=MQBk6adfYdx6UAAoUo/GNQTe4FbTAociNoeURJhQ+vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGaoo5yWBqscRxKo3R7HgdbF+8TVldMGdQ0UC/cww3I9d4OzeCfEDy6HiKjtkrQQe
	 Zokd1WdeWc4/4ioZEafqHzcxRv0FasN+d38TqvK+hfHfIdg9BcMwW+9bAbDwLvhpPc
	 8X2iAOBqV9qA6tsbLCjKmsb49KbWHlQjQ/tvQ5D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0371/2151] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:35:06 +0100
Message-ID: <20261118150135.601309688@linuxfoundation.org>
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



