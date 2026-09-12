Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397DA35201F;
	Sat, 12 Sep 2026 10:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210605; cv=none; b=JsGCI0RUa0T5b9jT+ndRObTK1jv+oSJi2n9LuVNYYrwTgA151A7MF1ZJTn3tFmCyUg+kHmxZJpLfYy5pJanHHoTStB/OcZs0Ar21cg6ngA6j2ZEQymKWvU419/UF+6/B9Uw1VFHgWOrF9Bg+e+U9rFunkPB62snwsVU5ZwYolCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210605; c=relaxed/simple;
	bh=J4DG4YSISeWswc6I+HQxWjOClsrCjDUjWq2dEjMPDoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0LZ7v5tk/qS2hAIfRxrlPTKp5lV1/1NfVsbyqRWFu79iucN59H9MfS0dS5KpneSIL/vTC9LRebeOuqcbI1ODsH38+NEHQzhPE8COv/0PJhplChy4P6iAh25E8MHgrds+wwHyJL7y+8xgVdKUp10VMGm7MRdW0vITgdQ8Fiiiv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exiYsrDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exiYsrDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC1E1F000FF;
	Sat, 12 Sep 2026 10:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210604;
	bh=n/ypIHjqYUOcDboV8GZVfBd/wGPzQw6tNRaba64n69U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exiYsrDqbXp6oAGqc2ttA+IUAcNDF01w85pP/Jot1VtDmuxZglqj6mgZAp8Fvb4zW
	 K/u+lWJYDM7kU0Lf/UJswwozSs3PZ9aza4Pk3ohDPUBqq1FKeFa1z1Y/GCPNWmE6F5
	 JcTmtMYRvvBnK7dSLhlGsLSyG6bFt9Sj0cI2oe/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1017/1518] pinctrl: airoha: an7583: fix spi group pins
Date: Sat, 12 Sep 2026 08:53:06 +0200
Message-ID: <20260912065646.458900147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit ccc41d25590645096bdbf420b43e7c22627b3f59 ]

pcm pins were used insted of spi pins. This patch fixes an issue.

Thanks to Daniel Schwierzeck for noticing it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index ae56574041cad..eb099baf74dd5 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -738,7 +738,7 @@ static const int an7583_jtag_udi_pins[] = { 23, 24, 22, 25, 26 };
 static const int an7583_jtag_dfd_pins[] = { 23, 24, 22, 25, 26 };
 static const int an7583_pcm1_pins[] = { 10, 11, 12, 13, 14 };
 static const int an7583_pcm2_pins[] = { 28, 29, 30, 31, 24 };
-static const int an7583_spi_pins[] = { 28, 29, 30, 31 };
+static const int an7583_spi_pins[] = { 45, 46, 47, 48 };
 static const int an7583_spi_quad_pins[] = { 25, 26 };
 static const int an7583_spi_cs1_pins[] = { 27 };
 static const int an7583_pcm_spi_pins[] = { 28, 29, 30, 31, 10, 11, 12, 13 };
-- 
2.53.0



