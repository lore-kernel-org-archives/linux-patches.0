Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F52C198A1A;
	Wed,  2 Oct 2024 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880366; cv=none; b=tSj062koQ8S12jzkcswJycIBV4FVJI/ioOebvkmFZxOpjt71m/4PatvV8Yzv2AvAs7LZtZZgld0Cox75UVYLrBBApjfwBi79vE72TXdhUE6SR8i3SKUXBI3awSMV+eqCMDGJTzogMs/+ZNPld5THUCOPmuqTTz55Wf10z2uBmY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880366; c=relaxed/simple;
	bh=niZcw9usDgJ8ltLhvTvhFGEAUgbw5rFilsJJHKAcQBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiX4URIwtbXvcc1hM3TkTxsptD3p1oBkbLlU5/wlFLzrJZkwJ5PX1tklTkpw3OpI7CXMfvZCO4nIb4cl7YdG9wgk1DQrmEApNs74EOG/Sgj/ANuIUM9s4YQR+WDBoDJOS665PUjYiFte5JjoMd9faOEsH3YTahFlnUc0uJfgh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9W2sIi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9W2sIi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2471AC4CEC2;
	Wed,  2 Oct 2024 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880366;
	bh=niZcw9usDgJ8ltLhvTvhFGEAUgbw5rFilsJJHKAcQBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9W2sIi7Lq91wp9b7yfygpumQJdCGM7Qm6lXrL1GfxohWNLjk6PtMJU8JKteOwjlB
	 jbR2CJgNx7hFUdcT/N67wFljsYXWYjZ8g8QNgJ10prJHy6RPnMMXgZY7g9KwG36OEb
	 1IQepN+mzswUr+0x/lMfESyF1tYLSI4SoaZrJ8/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 403/538] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Wed,  2 Oct 2024 15:00:42 +0200
Message-ID: <20241002125808.345307191@linuxfoundation.org>
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
 


