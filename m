Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A8646A5FB;
	Tue, 21 Jul 2026 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649697; cv=none; b=GSEC9EvyQcdsgdvSlBaTsoSABhmnM/V+FEhV72MEXH21NllgbhbHc8FzRikMJuZK+SDG/QZMpqfkQa2dQNAyvbvn0KljIeXlTet74A6W9ueMushxgN2uBnGp5mp6+fSfehGNwv0mtSyCIZ7kqQrfcH0nnSkbXLeFPRAopf1sQbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649697; c=relaxed/simple;
	bh=8kisDEXJ7fkd4LQQn68e02qSBrR+HAM9PTTtj9zVzRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFPe2efDMOHIhAsqgX+SpDdIN/uGqRiFloSrPdH6GTpQ84dHzpQq7om/B5nLA3CX07ROEd2Eu3WDotepYDd0EMcPXWLBjaycJXOrxROBBpzIG9Bimv6PGw51oneiVRKsaixFVbnJcWu0qpF8dmyx/2N3dDJJuR3t58KGZkxWVYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN13US0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN13US0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728B91F000E9;
	Tue, 21 Jul 2026 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649696;
	bh=reOlEUyK+2+hbCthzUOOXg0KrcrwsqJZHGCZ+6ey1XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tN13US0OaX1Uqa4/hFigNYym+aVCpL7H1I4DR+GTPQGiI2XJu1ARNtHtQDoAPpgHT
	 ZtkcCwjAyJZ/BWvGI6AmAp+dSL5DOijl2OcQjX12odKjsH5w3oCl4kWsUPP5BX2rse
	 JKWb+IeY+YnHd2+EMFdZkHTni4uDGOkJek0COOW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0673/2077] pinctrl: airoha: an7583: remove undefined groups from pcm_spi pin function
Date: Tue, 21 Jul 2026 17:05:46 +0200
Message-ID: <20260721152608.673183112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 7b87a686a5ab138b3f8ca3d7e3489d8371c02695 ]

pcm_spi_int, pcm_spi_cs2, pcm_spi_cs3, pcm_spi_cs4 pin groups are not
defined, so pcm_spi function can't be applied to these groups.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index b73ab60d006596..bf5ebb31e6350e 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -877,10 +877,8 @@ static const char *const pcm_spi_groups[] = { "pcm_spi", "pcm_spi_int",
 					      "pcm_spi_cs2_p156",
 					      "pcm_spi_cs2_p128",
 					      "pcm_spi_cs3", "pcm_spi_cs4" };
-static const char *const an7583_pcm_spi_groups[] = { "pcm_spi", "pcm_spi_int",
-						     "pcm_spi_rst", "pcm_spi_cs1",
-						     "pcm_spi_cs2", "pcm_spi_cs3",
-						     "pcm_spi_cs4" };
+static const char *const an7583_pcm_spi_groups[] = { "pcm_spi",
+						     "pcm_spi_rst", "pcm_spi_cs1" };
 static const char *const i2s_groups[] = { "i2s" };
 static const char *const emmc_groups[] = { "emmc" };
 static const char *const pnand_groups[] = { "pnand" };
-- 
2.53.0



