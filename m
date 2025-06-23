Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0634B219E0;
	Mon, 23 Jun 2025 21:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713764; cv=none; b=ji3t8QDl7qYMuuF83GZkgc4qQGYljdWWUIeZhLRkDWI3fLxBpdjRM7VdzKKpdP4h5M/lb0hqzOUlZY9qDSI+xeFOJGy+zcyJZK9lz9i7ZsgdCQdtoLX/hSY/L9+pobqSC2vlZBf9Lj2wsX5pH+LAu8LLcdSLLG+clfIt381x8ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713764; c=relaxed/simple;
	bh=1MaoV85Ti66sAyep45GVl68koMYAPFitY/lMkI6thTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfaN/eCWawnAyfeWzgC/wOTNQxaiT9QUi7SEkQ4QcUe8mEs53sYbVVpTup/ygLykf/jT9whP5NWW+bSli6O8eQesUisAe6NW69DoD5CQGzoJYPt36StnmW07qpgk+p3A1Hv11IoXv73sWnXmtYh4Fi7ad4MgrRQ1gwLpl6RWkf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzCFYj0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzCFYj0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94313C4CEEA;
	Mon, 23 Jun 2025 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713763;
	bh=1MaoV85Ti66sAyep45GVl68koMYAPFitY/lMkI6thTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzCFYj0Gs0vaeA1gB1rWhREBtB3TyYL4KSK45uU0sZmUrtCj0x1QVNwyT5x6Scw3r
	 oPgxisbAfJQTKx4Q73eCGPiHOJjzOjSaajLcAMzvv+qGQNVZxStg/ac0ILYBmC1eKy
	 QkEcdsfmgb/aP0oooPwNI9gxOMT5Ch01VuLtdbDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/508] mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE
Date: Mon, 23 Jun 2025 15:03:10 +0200
Message-ID: <20250623130648.851641303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit 59d60c16ed41475f3b5f7b605e75fbf8e3628720 ]

The name used in the macro does not exist.

drivers/mfd/stmpe-spi.c:132:26: error: use of undeclared identifier 'stmpe_id'
  132 | MODULE_DEVICE_TABLE(spi, stmpe_id);

Fixes: e789995d5c61 ("mfd: Add support for STMPE SPI interface")
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/79d5a847303e45a46098f2d827d3d8a249a32be3.1745591072.git.legion@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index ad8055a0e2869..6791a53689777 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -129,7 +129,7 @@ static const struct spi_device_id stmpe_spi_id[] = {
 	{ "stmpe2403", STMPE2403 },
 	{ }
 };
-MODULE_DEVICE_TABLE(spi, stmpe_id);
+MODULE_DEVICE_TABLE(spi, stmpe_spi_id);
 
 static struct spi_driver stmpe_spi_driver = {
 	.driver = {
-- 
2.39.5



