Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C84C1D0F48;
	Wed,  2 Oct 2024 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880364; cv=none; b=dQ3XeEnO4HQ32zJsn56nvDPlJ+jPOKZC6rYQJcwlgrelEc3HuxuXzaEJvaAzGxcv/42NZfmNY5WzUHbimbr/qkoKO8xEafNT2V4gC4NY+svkn6j3TyGBE9Mg8Brg+Re5P62u5Hk7e5Jg1/8R6UR5u5ZH+BHPgf/z9+ZJ9HQ1clE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880364; c=relaxed/simple;
	bh=5zUXb6Mn5rQNUyiY19MMjU1t5p8f7X9dlUpRYs0GkX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC+zz6fhTurTeQHK9c24QLnQ87DzHojAanx8Yq1ddc0N4f4+Rj4cywFGc7MCcRsOguOBwAaRdpnCR9tTyUgBeNaCdM3XqHcIS5mD01adftKR6veUppNDuyftkMvMR2l1cooNzcdR0ZRYxddwaKLP1f6ygTdtHjg8Zj+kVqP5eDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2UUlcD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2UUlcD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC3C4CEC2;
	Wed,  2 Oct 2024 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880363;
	bh=5zUXb6Mn5rQNUyiY19MMjU1t5p8f7X9dlUpRYs0GkX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2UUlcD0SoDMyJiAZes8CWmMJnlAlANuTcNhrVN5RXKBj/OjgPm2hcMhBkLknf9ty
	 6ZT2mGQOMd0re6ZDrQdXKRvIJwQcEM9oT+41+CU+Dr1gkMIEns3+93BIEDsuwefIvD
	 oICqE4SRltmdeh0IXHPDDF3+17F2jpw2FCYjs6ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 402/538] soc: fsl: cpm1: tsa: Fix tsa_write8()
Date: Wed,  2 Oct 2024 15:00:41 +0200
Message-ID: <20241002125808.306266001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/fsl/qe/tsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qe/tsa.c b/drivers/soc/fsl/qe/tsa.c
index 6c5741cf5e9d..53968ea84c88 100644
--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -140,7 +140,7 @@ static inline void tsa_write32(void __iomem *addr, u32 val)
 	iowrite32be(val, addr);
 }
 
-static inline void tsa_write8(void __iomem *addr, u32 val)
+static inline void tsa_write8(void __iomem *addr, u8 val)
 {
 	iowrite8(val, addr);
 }
-- 
2.46.2



