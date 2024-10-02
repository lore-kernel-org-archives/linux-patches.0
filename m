Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC61D042F;
	Wed,  2 Oct 2024 13:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876759; cv=none; b=nIKgvakh6QfotFi9cTonUpmMdKyIokGWkw5YyjQKBjVje1xG6vTocNESin0Gd+kB045Ev//2FJ1fGqKtxv5yyysuO6tEfeIIEz3DnncBimsF2Ua3nfb/TL9LFI1N+akmhnnSErd2KOaGfwUxVrnNjYb+wsJvjorcHtkXYJkkovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876759; c=relaxed/simple;
	bh=1OoiIls1CqmSwAhkomeL39L5mzu6G1KEhxYwrGSPgzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edumh53WalLKC5vAoHiGKTmZBxAYVU8XC5LSpK/CID1Z5dJ4JwjFloXtHdCe8x4lhmTT6iBOGI2zjxQUNgg40En8YeKLgqh4JaQmIO2Pv1WzBD/vwTb6nfXqcc77gZ3RV/L9q65AxyXvWNAkqtN3zJyqxK/BM0IiF3cTdQvZN78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpQExj3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpQExj3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EA5C4CEC5;
	Wed,  2 Oct 2024 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876759;
	bh=1OoiIls1CqmSwAhkomeL39L5mzu6G1KEhxYwrGSPgzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpQExj3Gri8/Yx0ZE2o3d98bwxaz3OyJAmv2wIopS5Slf7DCR1/bvytyfqSYsjwZx
	 7syYGi3+srokPVb+VkqpyyDr/J/jkuK0tU4bUFUnUacifOR/wj2gr3pXIXfPd+su/U
	 MkwLBbVdMd2rHpvgoeKvIfsSSl4gJYhstSShg4NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 526/695] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Wed,  2 Oct 2024 14:58:44 +0200
Message-ID: <20241002125843.483747115@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 874c5b601856adbfda10846b9770a6c66c41e229 upstream.

Driver is leaking OF node reference obtained from
of_find_matching_node().

Fixes: f956a785a282 ("soc: move SoC driver for the ARM Integrator")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-1-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/versatile/soc-integrator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/versatile/soc-integrator.c
+++ b/drivers/soc/versatile/soc-integrator.c
@@ -113,6 +113,7 @@ static int __init integrator_soc_init(vo
 		return -ENODEV;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 


