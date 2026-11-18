Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055046;
	b=pBjC2w/1PBj+kP5GqRPh7L/Wdep3B3Xa/C6rbLuY9O3TLingMIT6YR2zK/Xev9YkzRpZ
	 hgbLxrE0BpGrTkIkJhR9r0Cqu4mwRGtaaku2L9Ol+on+Y+rVF25uZrKZAErk7WAyx2joX
	 5UZuwHwdr6etRqn+c64Tjoy5VKVagIkfUQWMtrmc6u3ptau9AwKJVCqAQNpL83YPYejmQ
	 JKjs/FSKugerDc8KGIB+bQajnPjYqfBwknouBAzhaP7RzViLyEZ9wYbcTB9Qa0wkIYVi8
	 TL+ShTiC4/f24DcWObpdtZs1bpH8vRTPVuTRLBPnYJJgbei5oOVKZJl00EEu4zpGJBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uNuxwzlklm8BayCPAuB8CuH6NWtqZG1bmh4Ezs+lSM=;
	b=M6jdZ6C+EKwkajwP696gR/TQz7nMaVVIacmekIWpu8IdW/0GEG7fZWSkMxx77N/Zq1cE
	 LgNRSxBNlvxWqe0Gyn5z05eQNT023gnBS7TPPx4ivbAIAakhCHBWWU1yaDKeoMkcBgLD/
	 W7Qx4iuuKB5sLSwnTh4nBhsOjfZrGL5Cd0DOjMA1Z+iz9V6OU0uLSMb4tZmqsWz/DTfLZ
	 oBgF0x/6gGRuuJueS8/4LQ9iMBdWAubJyp6ZlTu+Ppdj2tPJMfUERhBXWXYkTINNbnt2I
	 sdWWkXsUcnvJeIulneT/LV4yXh/HNJaHsi9fSmpV+16q5TQNTUDZYNOQT8HbMFpr3pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Da72pWfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE6606A32A;
	Thu, 19 Nov 2026 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Da72pWfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5371F000C4;
	Thu, 19 Nov 2026 02:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055045;
	bh=4uNuxwzlklm8BayCPAuB8CuH6NWtqZG1bmh4Ezs+lSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da72pWflmvGXCwagTKfwWHyajliWz9XmEXbdoqNVbF4pr/45P56Bey7JNKx7/v1jm
	 /Ph5CWaa6UzKosPtoUN7Q3wypu80rnERvXYV5o158p8kttcPCVwFkWGP+yknM4o9Hj
	 OZvoKlgDrkzVv2PRkZJbBWGUfFEtA+DrIwh6kHus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1464/2214] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:52:20 +0100
Message-ID: <20261118150109.735675641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 23a401734a987..d603d7b9f6821 100644
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



