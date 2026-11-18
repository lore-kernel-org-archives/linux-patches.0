Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029419;
	b=zK7KITixv9aTks40ovzcaxgXwW1StptNBKk4B3NtTbGjQ3zj5fdLD4bO6dQ35Br0yOHb
	 2jEvPZNUNPbfF/AOvyl4QoDNrFhZ39R4uNIcpuYCwUdXflpR+z34fsxHBurGbkLfpEhpa
	 1oHowdWKECaGLGvj2HwrFOds1UsWdmULqSZq25xEEk34583EkgzDDRi3La81ykUMNC8xh
	 lPFWJadTJQpZM5tSVzC8T5TsLHBlRZGKiZbSVpaO77/ZegMTS8BziZp2ntkHw67usjgJL
	 9MAqIidnX+6s+czi4fstHcDOWZW3QboGMbN5fvDiDjZidOa5ZJcUsPLE3faiRDg4kkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qzd4SmTk8eNd2ZvB3UQqKfpjcoy2EmMSiNygfRLGrYE=;
	b=v5IgPxz+KZAzyndss3PNsflMTC1ZsL8FWMxXFcYzXkENU17FkE8zOeXbMPnc7v2SAtqo
	 Jd0YX+NbakJXFbg2DiJRq7Edv5UlOdkNXIFE8H3+bZ9WfarIKvG7Io77jqV7B6VWzw81n
	 Ja6tlaLtm5mYwcMSeYC1/otPES34RcI51ToBxhCQN9ICEXdu+ENTmzz95nyuCZ/yVa30D
	 NzKIQDuzwT1+wJRRBvx8l8Fz3P4DdigG63+4q0saV2Ty1w9P+Pfo0NQ4gthPCWErjrmyM
	 VxMjuEDDhePKrc+Ywi6WzXEBgH9D/fX+F0XPKgrGJoIyr6tiF/JzeRCMLTN2vuhUgXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ep7AdeB0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B46E606A325;
	Wed, 18 Nov 2026 19:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ep7AdeB0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945F11F000C4;
	Wed, 18 Nov 2026 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029419;
	bh=Qzd4SmTk8eNd2ZvB3UQqKfpjcoy2EmMSiNygfRLGrYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ep7AdeB0rHASS0lUKDutejf5CLhIyE5XOwKmNBiCXKVz2w41cRUKKEykm57iyWwun
	 AhetQxwiagHUo/sbrCfNNjzIBJQyVuBmTo5UX1m9vPJU9dffr0oPo1fFT7gRoKoXEi
	 o7vMjzK77GeZKLRoK+0RTBJkimg4pT6kdwyTWjbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0343/1756] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:41:10 +0100
Message-ID: <20261118150022.021434784@linuxfoundation.org>
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



