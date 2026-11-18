Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035762;
	b=Cc0nvn5tbx9y0VW1zCpBpxCPs9OSjIkx9xB52ahM6uWeH6XCB2+wsHRzn5yeVLEH7GYE
	 sdxq7MBrkLVl5fUHrnkR1Taq+ZaVIhYS3UxNmipy0ZodBaVsu/0esQMEI+EP7QrSF5Ilu
	 New2KjoprNIgj11pg/oqhW+h9mtXq2AILSAjN5RVByW7JbBp1OPZV0RuV/kdd8HUdoJms
	 z/53+ZKGwwHTJ98WxDyYjQbF8tKagg7ftIQfTw3y44uH9YRPmuBUTAD9Se+wWmjAS/Gl9
	 aSP4Y9MXA0i7iRr2QW41/TulH1NB4LxSoIlH2SAiJJ4cr1hBKhtCx6h88AqbLhxDIxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xnR40TJSXmHNXPVHxDDQGiuwlR9UBgzEwRWroAnhXU=;
	b=CsGzN3jeoAxCq8FvjXQZ5GFVjeqHTDKPeho4UoDks2jGhha3UBtEd2jb7J49UuzoiYuw
	 Z3vLTPy+g2e5eZPyeJIvL0zKSXsX2kReMGBP3AKynsnPJmFHgddwVYG88pCZfZpDQLEcQ
	 ITStf175eOig+ulZ7SOBBM2m1PFKrcVY1zmk5x+1aarBurjV50cWOOXLadYV89Bsk8l2R
	 105NQAFgd3ZOukI/6enavu4qW1tLlDAbowHe7RLVB0gojqWDcUK9aZopnd8SItXeJ6cLj
	 9BHEIwWIanC9G9ogN4Xb3XhsOB0EAtKTKMymKpUOJifSungyBuCqhyLlIAs/8PtCVWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AIq/cr9a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3E606A325;
	Wed, 18 Nov 2026 21:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AIq/cr9a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35861F000C4;
	Wed, 18 Nov 2026 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035762;
	bh=+xnR40TJSXmHNXPVHxDDQGiuwlR9UBgzEwRWroAnhXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIq/cr9aSxgbIaR1YScFZ1jhYUU4Y8D81+vVUWC8fUL7HW5JKVote/1P9zu6WUQO+
	 2ktOr0j6FPZKhxdlUcdxKIXwjR0j5pvZrmzgOq0ghdILUspTXbQUjZopMWVJw4XGop
	 0gzeQNbZWQDNr3990tUVHmOodTx0q+F2wDYdVrk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0817/3318] clk: mstar: msc313-mpll: fix off-by-one in clock array allocation
Date: Wed, 18 Nov 2026 15:23:59 +0100
Message-ID: <20261118150343.546407873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hanzhijian <hanzhijian1991@gmail.com>

[ Upstream commit 712b75152c00a8ab0c56dbfe34caf88e3870ddde ]

The hws array of mpll->clk_data is allocated with struct_size() using
ARRAY_SIZE(output_dividers) as the element count, giving it 7 elements.
But the probe function stores the MPLL clock at hws[0] and one
fixed-factor clock for each output divider at hws[i + 1] for i in
[0, ARRAY_SIZE(output_dividers)), writing 8 elements in total.  The
final write to hws[7] is past the end of the allocation.

clk_data->num is also set to NUMOUTPUTS (8), so the clock framework
reads hws[0..7], again accessing hws[7] out of bounds.

Use NUMOUTPUTS as the element count so the allocation matches the
number of clocks actually stored and exposed.

Found by smatch:
  drivers/clk/mstar/clk-msc313-mpll.c:134 msc313_mpll_probe()
  error: buffer overflow 'mpll->clk_data->hws' 7 <= 7

Fixes: bef7a78da716 ("clk: mstar: MStar/SigmaStar MPLL driver")
Cc: stable@vger.kernel.org
Signed-off-by: hanzhijian <hanzhijian1991@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mstar/clk-msc313-mpll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mstar/clk-msc313-mpll.c b/drivers/clk/mstar/clk-msc313-mpll.c
index 61beb4e875250..bd45aa0aec011 100644
--- a/drivers/clk/mstar/clk-msc313-mpll.c
+++ b/drivers/clk/mstar/clk-msc313-mpll.c
@@ -105,7 +105,7 @@ static int msc313_mpll_probe(struct platform_device *pdev)
 		return PTR_ERR(mpll->loop_div_second);
 
 	mpll->clk_data = devm_kzalloc(dev, struct_size(mpll->clk_data, hws,
-			ARRAY_SIZE(output_dividers)), GFP_KERNEL);
+				NUMOUTPUTS), GFP_KERNEL);
 	if (!mpll->clk_data)
 		return -ENOMEM;
 
-- 
2.53.0



