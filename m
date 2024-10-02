Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356C11D1735;
	Wed,  2 Oct 2024 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878714; cv=none; b=BAmFQ976yAbvzPoY1qkzQKC1KO4jOY8D4EqxO6DajUjSIyasGOU6RoaIW7ghyv8pKZMrzNdWMhlua1yJDOSLvr7zMXElk2rquA8zHRqRSI7eVgaqIhmmLHEMR3SaGHxPPbBx+iKywdZ+st+4jd2uPVvcl6H8/ohv9QT/xFjMN2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878714; c=relaxed/simple;
	bh=F5+yKkBNJbLl6SMCDQMlu2uNacDDe2Marmn20AgBMmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNradsc1zB4Lf1usi1pvjw8Epz0ZI/7NUbI26aaN78KUdAqy93WVMYNZx8zkMdk0ivvqwtRaJokRT3dchc/aaJUJRG/sT7IyFfxlUdn16G0fuXrYu1i7oSQNsdYAkPQ01sIeUXV7NeJfBi2FIn9houFDbSwhS5ZEX8DZp12lo3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mFBaXy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mFBaXy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A936C4CEC5;
	Wed,  2 Oct 2024 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878713;
	bh=F5+yKkBNJbLl6SMCDQMlu2uNacDDe2Marmn20AgBMmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mFBaXy9oK1BFzxUAel8jot0FIAPV6juexJUpnTA8qR/CgOREZ5Ky1LH6wHWn3P2U
	 qhIMy74ArO1L5KU84cJyPf3Ms9/Lq+vTO3rcSbWYJRb4hmflmUvLd26du+EI8nheWV
	 NFJT2sDfm1V9Ok5ZpF8UxZGVOv3NAaTBV8OEZT3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.10 477/634] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Wed,  2 Oct 2024 14:59:37 +0200
Message-ID: <20241002125829.934276620@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 


