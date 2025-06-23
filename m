Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080C82505A9;
	Mon, 23 Jun 2025 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685024; cv=none; b=EIrOX28rndbOwryq9VvQ3yMrRCHV3GTETY9rPmhvj/JQJynWBYyzotGlS0OtGVXw5arSiB/fDezLHYEaHyh1S7+J4F7nAqcfxEkWrIEb7oq10E3qc9CgeKAcUqWNKoJEDdZiKozapKfW+ZeAaRpV5R5uXkxMkLVlYPLogKExsJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685024; c=relaxed/simple;
	bh=FzinTkye06jx3GD+q835tKfvjQ6hubgE91dEJ/Do/H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULnluHrqXHMjyajvr33a5vXwL85Ki+MOH2zwXJGiDhUy/kCvsG79seGleWOdKnIiONiJwGdP2iadpP9efII3BYL3Iha9xQqPFZ4ptGrgNp8mwlDEv7Sw003JKF4X25aTm1ybiP2QMmOOYiuffK9+Vo36E8vmpth7tMF0rvDvn0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT/5FcVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT/5FcVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8AAC4CEF0;
	Mon, 23 Jun 2025 13:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685023;
	bh=FzinTkye06jx3GD+q835tKfvjQ6hubgE91dEJ/Do/H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GT/5FcVxpprQ4xSbfibc35HW40lCu1/mg4rdWFA+8ZW/F7beqWukB1wrNEgA3yrar
	 ZEvqxfcu0pnMUTQm/Vx5YLIvxOJLQuQzVibuMux7tBHwHrocP8rOjhJUF/iRFXIB+L
	 s2/Sn2ZhYnHytZoY3GxyHHh7uu1R0JINC3yiU7l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/222] mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE
Date: Mon, 23 Jun 2025 15:06:34 +0200
Message-ID: <20250623130613.887872479@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7351734f75938..07fa56e5337d1 100644
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



