Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2540B26056D;
	Wed, 25 Feb 2026 01:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983481; cv=none; b=OW3pTeBwAn79Ij5oXY09aLvd6mgsFI0ho/HZbeLWoEUhvOkik8FlZVgrXC1R5OaOO+2Bepye2PJUFMH9RqMlf+fF6p5NyJaCUzJIsTuXTX2VuvW51IisFFaSBmagReKPoGci+vRSdD9zvwku5axCrA+AGvwON3gZsthz28ltQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983481; c=relaxed/simple;
	bh=5aCXIE5ANmaBvu5Q0JtmezK7dxkrFa/uLpTmlVYphMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWlB2u+cv76o0CeXWzSOyshCx3axeWGzhEgMI16MTsRN1DgwaR1gEuYOSh5HexB6L2f91L1uZp+lEep7uN3bTwOyOoIPL4n6elf4EFhbEDzT29Dhq3AyFfHQIlBrTQJOrhXEitUezeDyO17YTtT10EUc294UCoDw8BkOP9A+XIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lf5jUtNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lf5jUtNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F297DC116D0;
	Wed, 25 Feb 2026 01:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983481;
	bh=5aCXIE5ANmaBvu5Q0JtmezK7dxkrFa/uLpTmlVYphMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lf5jUtNMaLd76lHS0JU+B6YKnFBqiSnpH9u4z1A6IEktoPN1bBTw/y/qQWQfB7oxs
	 aupXSncfSRahIrWnTHdd9OvYaZwcmMnBlPhTo38/tOMbtIEdMfR/HIsvh4nqgm+h0P
	 EoNJszD7AycqB1quU6OPWGk2wPr7jnIz3RKLwdpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 594/781] nvmem: an8855: drop an unused Kconfig symbol
Date: Tue, 24 Feb 2026 17:21:43 -0800
Message-ID: <20260225012414.368213944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4796eaafd6a170db012395a40385d2baf4f4d118 ]

MFD_AIROHA_AN8855 is referenced here but never defined, so drop it
from the Kconfig file.

Fixes: e2258cfd9b98 ("nvmem: an8855: Add support for Airoha AN8855 Switch EFUSE")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260116170846.733558-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index bf47a982cf629..74ddbd0f79b0e 100644
--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -30,7 +30,7 @@ source "drivers/nvmem/layouts/Kconfig"
 
 config NVMEM_AN8855_EFUSE
 	tristate "Airoha AN8855 eFuse support"
-	depends on MFD_AIROHA_AN8855 || COMPILE_TEST
+	depends on COMPILE_TEST
 	help
 	  Say y here to enable support for reading eFuses on Airoha AN8855
 	  Switch. These are e.g. used to store factory programmed
-- 
2.51.0



