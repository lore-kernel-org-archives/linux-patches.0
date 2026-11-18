Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048129;
	b=LK2Qu6eF4v5lk5ShZf6SMuL3CGTjeQoiIcCRVX6NDA3x45xuT19ef8Q52pitP4LXTEHJ
	 3iPWozVsv9HjZQhtmuxtj0ogbq42sBZOVa2PYjBMwP7om7Vdw3BETitP9BvjCE4J0CX86
	 4Uy/xez1APkwjXSCTSYiqMUtPgHPqCB2/zbYfz7vFEj8kdpGE0X9CUOqiBY7sczomlNHz
	 CYPIUK8DHQbiOqgrtVMk39wu2M/BAMR4GD8W1jqcxvTYdHgULsjPi4vP1Qmjhhn8MHf0/
	 lzN5IIPn6dRbhVDxZK4Dueo62ldiKtEJFIScYe0lACzu38gxSW0nSnlDPWRDg9x2mRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f15jWmEtcK/uUH2+HTKAjGja+7eHDWy6nQEPsu/PSnE=;
	b=AIEgyCuqQ5xCGkKmXhQgsAqU4dA+9LYbLbdCEwDLd2S+UB4gsFn2AxoxpbdR0Z/WCkuw
	 9aGzK51NFYLO0GJJgI18nAPLXJI3q0IPTvKAjL0M8PZ1ZaFjazRv57sPHOpyMzDHhH0q2
	 11wp3n4bF8sfdEgtcmS/aP4lAbTCNAA/1fOxE8WOXUFFwfAyHKHNe3bK8KgBTVyO6SJcC
	 tO5fcLGzsmnaOrAtbmxAtwZ0Wp3Dcs5S1xperH0MusiKUI8EwPShVNp6akivc/JS1MnJ1
	 dtXI47BHxltbvc7M6UOEamgG+vgtWR9k6kMn441mMJsL5cK8l0T6NSFRU/DDbjuFpoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13M8v2nq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52E6606A31C;
	Thu, 19 Nov 2026 00:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13M8v2nq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036CB1F000C4;
	Thu, 19 Nov 2026 00:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048129;
	bh=f15jWmEtcK/uUH2+HTKAjGja+7eHDWy6nQEPsu/PSnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13M8v2nqVjZabVzmV9VLpyQK3oi+HngT2hXqs/7RZMRCUVkIgOfvnPjIIP1cBbIjb
	 857rjyQy8Yt40aLXa4UP4MR5qTFc7EjgP2OzYMftF4LCj8hLn2fLNGW+pTH2wRyOh8
	 ykfR2Hb421qTg30VYttyTf197ZfRLDc/Z5QQb8BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1885/2857] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:48:39 +0100
Message-ID: <20261118150309.104165566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



