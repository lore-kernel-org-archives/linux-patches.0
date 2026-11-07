Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064564;
	b=y6v6mUavujjNP7OO7FW1PFqMLC/Y7dotyj93/p2KY5gNB0jbfHOiixcACeY0USbt7MbS
	 ol0sAyiQBLKwLjmv7qikwDY8X/6BfBwh7svqkLdRfrgzjxg1XyvVfH3Gk7Hrcnpx4tLeM
	 ukEnZS1ezsKgKKRZ5almx2eaeUaZZG6ZQ4VoHSftZxL9Y+rzLhDApEKanFwROkVQhgS2a
	 jpyE4aqf7ZnM1yyS502g+sVvwHclbc03NPTEB68QRz0oikpLT55NPy/8vXU1k3//IaI+8
	 YWPt+OivEecfOSQd+V+zZhr4YUkLJOINVF8/64O4+1yodteOA+qh84JhunzpUPBGFUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+HZ4MNKhs27lQorTyybWlfspTfX69sIOPvBOUIiUZo=;
	b=vAJr7w35XWCqwqPhm6hFUBG+WafCVHE/IwBZZsSAjgG1hWBQn8bM02UeWOz/A0JhEHWH
	 8/sgybEd38+FXg83rhoyol39D00Z0ez5BqajReqyuFeP3XGhts4sv5SajyYHMiTJ5kZht
	 k7mgnmLgEAJUzntNs61YCUYBJahHjseWYkgQ84SjU8OybDdaO5FEX7xW7l2qpQZ2y72el
	 2IwbLTybcOH6M3IIb/3ciZru5oqxL1dFoNz73oKVS+ri3rOObuaH0rkQ/B+Lsy3/zG6/d
	 rMVepzaA8dwkQu16M8C2hcj61h6pPRCA1PKMSNx97NzFciGQC62MFvDQtVxzmgMm6WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ot7aBwM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4218606A32D;
	Sat,  7 Nov 2026 15:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ot7aBwM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604171F0089F;
	Sat,  7 Nov 2026 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064563;
	bh=f+HZ4MNKhs27lQorTyybWlfspTfX69sIOPvBOUIiUZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ot7aBwM2tczsXklIJdEtHa7bXi0yIXxOjMSLk0d5EJ7Blc7xSwW8vywxxJj/Iku+E
	 5NLVvse+3jOycOjedtiGfl83M2n8+yUuVrT2/o7lXmd1bbf/MwpNK9cv2fb1ohTse1
	 nOx0lmYvqmRVIuTqM+NkPjW6B7UuMFuKUltUvIYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0547/1257] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Sat,  7 Nov 2026 08:47:23 -0500
Message-ID: <20261107134954.502720402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 277e5657237a92e279ee28da2f5c07902cc6aa0b ]

fttmr010_common_init() obtains the PCLK reference with
of_clk_get_by_name() but never calls clk_put(). If clk_prepare_enable()
fails the reference is leaked directly, and every error path that jumps
to out_disable_clock only calls clk_disable_unprepare(), which releases
the prepare/enable state but not the reference obtained from
of_clk_get_by_name().

Add clk_put() to the clk_prepare_enable() failure path and to the
out_disable_clock label so the clock reference is no longer leaked. The
success path keeps PCLK enabled for the lifetime of the timer and is
left untouched.

Fixes: dd98442e17a6 ("clocksource/drivers/fttmr010: Drop Gemini specifics")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260915045426.1726805-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-fttmr010.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-fttmr010.c b/drivers/clocksource/timer-fttmr010.c
index 308f94bfbaed2..c2553851e8d6f 100644
--- a/drivers/clocksource/timer-fttmr010.c
+++ b/drivers/clocksource/timer-fttmr010.c
@@ -292,6 +292,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		pr_err("failed to enable PCLK\n");
+		clk_put(clk);
 		return ret;
 	}
 
@@ -432,6 +433,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	kfree(fttmr010);
 out_disable_clock:
 	clk_disable_unprepare(clk);
+	clk_put(clk);
 
 	return ret;
 }
-- 
2.53.0



