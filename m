Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF847254B;
	Sat, 12 Sep 2026 11:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212668; cv=none; b=LQPBBJrku7eWvpfiKTUDudkZ8TBFn56DxODYkXOQB7LkaPZIkoRY5pCesIKKfyppMK/mfpX362oxdRvj5Ssj+ZyJeRBvDKkmydTndIMlZVhIF0yIV9g0wjCVBN1BEmTpbgpHzltoQqY4VNLFCJXh9mw+hn+IjEkL/e2pn81gl/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212668; c=relaxed/simple;
	bh=kU2xMskCgjqlhQ0dRKOJcX9eVa8ms8sLuqqLbpWJXd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwhhNFt7DDu55nEJfKqyekD6UyPfl9J5QDlkrI9jMjyf6dOPCwnTntT5ESh3kFIDLyM6yUoP5w/JC7mHuMtt8VLiN/nLl8f4kfXV2WY3yfijvCfU8b18WVm9Lj6odKfFq1X+7YGUEbWtKOOhFxugZuLo/uywXx9iTrvg8eKyZwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grJd/Hg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grJd/Hg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032B81F000FF;
	Sat, 12 Sep 2026 11:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212667;
	bh=fMTfugQSVjOKf22ouIE3bquQ/E5t+ovQQdp5jti49Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grJd/Hg3N6eHdLzK0f4PnSW36m9fgwBoUpus5VoCBqIBGuzyLs69WnWeiIHlBwigQ
	 5iv4OY8GbTmOg7CS4PbKo51jNQbVbj9QqbYdtrWfY5G/9xRHHtY+57lJBYwyuELBvt
	 qMXopmUwSmkQOdC2nPORZ5C2SMGs1MJrzQyWjvXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1484/1518] pinctrl: airoha: an7583: remove undefined groups from pcm_spi pin function
Date: Sat, 12 Sep 2026 09:00:53 +0200
Message-ID: <20260912065657.132090208@linuxfoundation.org>
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
index ec304ce570275..22986d033430b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -900,10 +900,8 @@ static const char *const pcm_spi_groups[] = { "pcm_spi", "pcm_spi_int",
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



