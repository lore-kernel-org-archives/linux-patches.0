Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073C81D0BBB;
	Wed,  2 Oct 2024 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878711; cv=none; b=WPLEsJ35i717No44kmLhp6LxDhnUC27K+kru02FPaPilze4BrvMryeNg5EsxG9rBf4jzBchw6ElkfumNo+5hiFernrxwbk1uPrP0kZ3Oeq+aeF/ZQ4DuSTdiALMjmt7/+7Wf8XVpbIeIGfrAQc6EE+bWqoVs52Ws8ylXoolQ6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878711; c=relaxed/simple;
	bh=etkAVL2bUxA7jXkgQ3rFh663seFk4s0fjeM+wvtpLOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx/WON71or9m7TCR+VLaMY+Ql8hfCnHtlp0dBs6ZT/cdb0D+h6hlYAetz3A1E8f6ufFPKoondXfvoOd5WygLzBfuy6QDFg9Vbjoz3rhre14OBAtdYqZQNdO/52JwRuqoHcsWKwOJf8WyoMOnpYXrETIg7GWtOysYrpGSzwjtkcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aE1xpbd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aE1xpbd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D43C4CECD;
	Wed,  2 Oct 2024 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878710;
	bh=etkAVL2bUxA7jXkgQ3rFh663seFk4s0fjeM+wvtpLOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aE1xpbd0iZqP3v0lTDYKmkLp6xBTpXfZdKCuIumRCIOcIiilj0fEQV5VEwPVAhvAG
	 I2suWmGSFwtHujveJBJ9A/SDhh74zq8KdlAjY634Dq4IUHQO79577ebuO3J6Dl16Mz
	 LQZT92yF1lrsZOCQB+FK+v3gns5L9xA/2fRDjKeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.10 476/634] soc: fsl: cpm1: tsa: Fix tsa_write8()
Date: Wed,  2 Oct 2024 14:59:36 +0200
Message-ID: <20241002125829.895135340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 47a347bae9a491b467ab3543e4725a3e4fbe30f5 upstream.

The tsa_write8() parameter is an u32 value. This is not consistent with
the function itself. Indeed, tsa_write8() writes an 8bits value.

Be consistent and use an u8 parameter value.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-4-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/tsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -140,7 +140,7 @@ static inline void tsa_write32(void __io
 	iowrite32be(val, addr);
 }
 
-static inline void tsa_write8(void __iomem *addr, u32 val)
+static inline void tsa_write8(void __iomem *addr, u8 val)
 {
 	iowrite8(val, addr);
 }


