Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16213CA93;
	Thu, 12 Dec 2024 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024219; cv=none; b=g+10rHl3PH09I3ndtkIJH/PshXVh1DyGFNkm3SVUxhP13DeVXsJ+XajtPsl5aUzXqo7IeStOoczQBE1ktDLafh9Emz7BP+Z34qewPdzXqxY54Qn+E/4uIWsth3IH1dlFEkiGsi0nkZe0NYQ74xqITr1WWSgZD6zI6wpk6rKtJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024219; c=relaxed/simple;
	bh=E/KKvT2K3OO6vKa/5Wc2WVyLIcjee/I+A2Pe5x3Nu0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdeklWyZGs9NAFAHkGLCGlrHI7J6DK8gUI20y9cGOf/xaSLghJdlIHd1u4+ue7pJ7Y3+FwQpt+7HGtMgjpkWq9GcIJWwDYO1YRTkYwGZQVULT8FZgpawEzRV0T3JYG0OmaFIL21z+L5xowSRE74jnaRm9WUlUb0b3axz2p36D/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzkacX0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzkacX0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE852C4CECE;
	Thu, 12 Dec 2024 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024219;
	bh=E/KKvT2K3OO6vKa/5Wc2WVyLIcjee/I+A2Pe5x3Nu0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzkacX0HN2riQlnF0M8qrvYZZZJwSYEm9qCwMwQJqLqIPBi9Xi9jAEWBrNFBrQfdI
	 3WeAdmQUwsgS7NSIAkF++xzt/bUab9atxfgATRu6YbyFMv2P28ACMLAGjwfrCbwwOD
	 QjtTi7yoo/ev04/S/tMSv7Rou5f5/c1zpcaCm51U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/459] spi: atmel-quadspi: Fix register name in verbose logging function
Date: Thu, 12 Dec 2024 15:59:23 +0100
Message-ID: <20241212144302.457625723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 2ac40e6d0ccdd93031f8b1af61b0fe5cdd704923 ]

`atmel_qspi_reg_name()` is used for pretty-printing register offsets
for verbose logging of register accesses. However, due to a typo
(likely a copy-paste error), QSPI_RD's offset prints as "MR", the
name of the previous register. Fix this typo.

Fixes: c528ecfbef04 ("spi: atmel-quadspi: Add verbose debug facilities to monitor register accesses")
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Alexander Dahl <ada@thorsis.com>
Link: https://patch.msgid.link/20241122141302.2599636-1-csokas.bence@prolan.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 8aa89d93db118..17217cc5e4052 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -182,7 +182,7 @@ static const char *atmel_qspi_reg_name(u32 offset, char *tmp, size_t sz)
 	case QSPI_MR:
 		return "MR";
 	case QSPI_RD:
-		return "MR";
+		return "RD";
 	case QSPI_TD:
 		return "TD";
 	case QSPI_SR:
-- 
2.43.0



