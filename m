Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C3E1DF754;
	Wed, 19 Feb 2025 09:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956266; cv=none; b=DdlG9hbsN59CU3j0DfIhVwAw3WugCPcfrMx27Z9pYn8ZQPkUVa3+QtZmGb0Vjai/N4W6Ard2SK9x13hbxYQBhY7cx5LhtGTXXBOd/BEiFRebGtS3vBpHAfZB3EZW9e+H7Ym03yhAXWYVaDukychYL5XE6v2gyB2X6WwEhPvk4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956266; c=relaxed/simple;
	bh=V4PoUPxHPq7D5m9txOaV+d3XsGKDHPncjZMMSiiuI1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eyi1GBhWBJS40LvTmGZqvKuGajXZ0ZOaJ/0s3erKSf54RLmLP35sdR55sHdNvchkWvJzJ6qb90ZfbDn30bOHF6blAFxl8EBAIZYuiwATZpxAbBcAAIczlHgHn9aYJwPSz5qTolxYwuQvsAqb3zkpvyX2Ti61c8V951qcNe0b6nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxBEFz0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxBEFz0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA5C4CED1;
	Wed, 19 Feb 2025 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956266;
	bh=V4PoUPxHPq7D5m9txOaV+d3XsGKDHPncjZMMSiiuI1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxBEFz0mEzUiNhS0dJDA6RusliiivVW81GTofK2FSZ4tXuaRWns1bLdC/S+m3liyQ
	 G/yny8p+yQsMX2j+HXb6xp8i+NCbf9pp5ii5MBqMTcCM02dNRViSnoMfCpv3R8ntkC
	 5ZS0QzFVuyTeSjmtX4j4F73GPBj8jWfl9pPzBZKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Valentin Caron <valentin.caron@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/578] pinctrl: stm32: Add check for devm_kcalloc
Date: Wed, 19 Feb 2025 09:22:06 +0100
Message-ID: <20250219082657.782581910@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b0eeba527e704d6023a6cd9103f929226e326b03 ]

Add check for the return value of devm_kcalloc() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: 32c170ff15b0 ("pinctrl: stm32: set default gpio line names using pin names")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20231031080807.3600656-1-nichen@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 451bc9aea9a1 ("pinctrl: stm32: Add check for clk_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index ae2b146544758..7599c66abdf06 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1377,6 +1377,11 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 	}
 
 	names = devm_kcalloc(dev, npins, sizeof(char *), GFP_KERNEL);
+	if (!names) {
+		err = -ENOMEM;
+		goto err_clk;
+	}
+
 	for (i = 0; i < npins; i++) {
 		stm32_pin = stm32_pctrl_get_desc_pin_from_gpio(pctl, bank, i);
 		if (stm32_pin && stm32_pin->pin.name)
-- 
2.39.5



