Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030454;
	b=znLgAf34wQPoQwIs36alXYLnQnye/Qpq2FYyJm63vSz084e7OYl2KP3bgCtfVXda3j43
	 ZdwqSoqndFe7gMre8lrO/30z/Mg3JZX2UTDfinKbR6mDRGmKJJlB+eysvEpHQVmJYG2Bq
	 sgOfLfi2oIMVYbKBocXlsdd8lx1t65QXKWcafJwsJKJyuajzdmoeZS7KrjpVdpav+Z7ya
	 JS+lqFQiweFmdcDowZdlT+ECa+2Sb1xjLEMJO9zcprJFh8Q365DUyy4EjN1l2LTLoJbkD
	 IbewAW3oWriO6C2t74gRTcojLcZP1NDNNafgg7/Usj5FVLFT58mQTm/iCVNetJb61XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6xUYVlZ4FXWmBAxVXSXGCjvmj5MTN0BDFQvdz5xb5QY=;
	b=cdqPoltM6khunZmz5XhOXggwE5BFtKZsZ7sGGgOMiRQFV3J85HvQNjW2intz4mXPJlau
	 2vkGduTOVUbOSniIIGk8VAsRLHDKp3Ld/CKNkF6jvvKaIH8VHKEOjPSMt8x0a2+iHJq2t
	 HnZKDw4niPfFnFqvHrm1k4GMGGpvfYHRU0F84S7zoa7ihxnQ9d2H+YNh9wFuD8QXKEW54
	 jNg8twSocjzKvKDJQYoQsIQ1h0h8mpZ8Pl3bhfO0i0lH60mf66+H3QtKbnbMokKHMfEEo
	 gEl6V2jmexnxF9NdADe/5zUrJfa1LCha24AY/OcTQgYE+GAxs5+pRQpv4YKRd6GJvQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B/5I+kP8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1E8606A7F0;
	Wed, 18 Nov 2026 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B/5I+kP8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5511F000C4;
	Wed, 18 Nov 2026 19:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030453;
	bh=6xUYVlZ4FXWmBAxVXSXGCjvmj5MTN0BDFQvdz5xb5QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/5I+kP8LPvGXK2cIbHZJwgH/3SoHh/IuQOd+fni9PHBZgpvB7ZZOqKBlqSIKW8ir
	 t4SHLrCPGX7IZHI/dAlDaIqcujGuiSkuKKIoACL/DqKQxn2iNSCX5C72S7TNNCuwjE
	 3LrWgrf74pxVoiBbsPknXJDCRa09pPOTJdGBMEuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0710/1756] pinctrl: nuvoton: Fix clock reference leak in ma35_get_bank_data()
Date: Wed, 18 Nov 2026 15:47:17 +0100
Message-ID: <20261118150037.651185997@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a854aa8e550502ef05c2836a4b426141d735bed1 ]

ma35_get_bank_data() obtains the bank clock with of_clk_get() and
stores it in bank->clk, but returns clk_prepare_enable() directly.  If
that call fails, the reference taken by of_clk_get() is never dropped,
and the driver has no other clk_put() for it.

Drop the reference when clk_prepare_enable() fails.

Fixes: f805e356313b ("pinctrl: nuvoton: Add ma35d1 pinctrl and GPIO driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-ma35.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-ma35.c b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
index 3330e444ede18..4ab1904c56f90 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-ma35.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
@@ -570,6 +570,8 @@ static int ma35_gpiolib_register(struct platform_device *pdev, struct ma35_pinct
 
 static int ma35_get_bank_data(struct ma35_pin_bank *bank)
 {
+	int ret;
+
 	bank->reg_base = fwnode_iomap(bank->fwnode, 0);
 	if (!bank->reg_base)
 		return -ENOMEM;
@@ -582,7 +584,11 @@ static int ma35_get_bank_data(struct ma35_pin_bank *bank)
 	if (IS_ERR(bank->clk))
 		return PTR_ERR(bank->clk);
 
-	return clk_prepare_enable(bank->clk);
+	ret = clk_prepare_enable(bank->clk);
+	if (ret)
+		clk_put(bank->clk);
+
+	return ret;
 }
 
 static int ma35_pinctrl_get_soc_data(struct ma35_pinctrl *pctl, struct platform_device *pdev)
-- 
2.53.0



