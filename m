Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C189D1E0DC4;
	Wed,  6 Nov 2024 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898150; cv=none; b=Es9A65W6l/YsKrmooSH2U98nssV0tCGP3v2Fu4hIaqXHdRy05y2FZeGmkZcvszYjSy+QRdYiNSsz8eRs/SJlwH9zhatgZuoXmmoblQSU22qEQlBVtr2NGtZXir+CroeqfcvL6IKivD+ElWcQ4RxLxaEintaf56w5Dpc9GRpT+b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898150; c=relaxed/simple;
	bh=yTtrNre9I75PYqdQKJla30w5y8aCyLLkcOC2g4uLEF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co6m0UM43DuLf0lw0xiOc+172QVZANzSvlJd8qbinMaFqxwO0Af2WBj7Wr2tAAMknLUirSgBgScm5JlSJDEqOC7XMNu042RuxbwXYgSZu5xSH9YlvZoeQS4CS+SbeHNu2ItiDt5TU2g2ZDw/cOkGi3fac/77GD17yMm96TgbShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCIvhxV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCIvhxV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C061C4CECD;
	Wed,  6 Nov 2024 13:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898150;
	bh=yTtrNre9I75PYqdQKJla30w5y8aCyLLkcOC2g4uLEF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCIvhxV159Z+ZmcaFO/t/M0YsYd6YG4JoVxwh2+C8lu63z2zrmxhPOD2pSGJwoAuP
	 ilyDRusA9z1HxjLb4XLXFrVdn/WcWS6cfZBWsgNiJC+HgEjX3FC0+mxKFO+no1Q0YG
	 IsR0ahHXRiX9SsIxgryzdoEmSgMFjVIcBqJ2I8S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 140/462] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Wed,  6 Nov 2024 13:00:33 +0100
Message-ID: <20241106120334.967306005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -111,6 +111,7 @@ static int __init integrator_soc_init(vo
 		return -ENODEV;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 


