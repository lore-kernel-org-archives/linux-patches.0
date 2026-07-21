Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95EF46EF72;
	Tue, 21 Jul 2026 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660536; cv=none; b=gESt2sGYhfb9et6AVSAAkmkxpzJCaAwttnf7Lc8ImK8qvWgUfMpfaAZ85KXLwdYK0tt6qElS8cZE5XHUXMhX+3krw8GmivXT672bo7KwUS95JMTe1dW0vxperFtVy58mJ4T1ml1IGIIYpr8oATjGkPCo9a5WbxYDMcibAySUCl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660536; c=relaxed/simple;
	bh=xu7PSnrW0fag1/NpjdKNKHGjKBCqkJr9iPmwxDF5BQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIUbjUb0GEo+5kf1w7zd9xO9VkmMNPHk/ETHS3rOyJhdTU4Up+poyEmJt+JV8Y12DqSwJkPmvG1KZ9nMrIKYAhHe5P9g5VfYrxeZ+Gfqb04Mlzt2N+HiwhzJ7tTzhlMmkmGnjdWvK19KSQqtrfCB3ECed/j9QeUSmFX+Lv89Zyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeinCTCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeinCTCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D761F000E9;
	Tue, 21 Jul 2026 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660534;
	bh=SQjC3JeuCJ5RYiM2cU72B9ddZ5t6dvHOT2faSIOOcEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeinCTCUFK2Fckm2dPi0h6aZETqBfOVgnpqzXDLGtF8Uh3eevlFl0WhAJzzS8Q6Ds
	 3YIf+MMnzOWUA1Pk01QjLrpAeywe8sR08l12oJgQUKeEsfmaxrz5PhsjijFVmSmRVU
	 /yfwXw6QuVCy8Zf0NvowtT94D2Qgvf7HPbX6IP1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0973/2077] pwm: rzg2l-gpt: Add missing newlines to dev_err_probe() messages
Date: Tue, 21 Jul 2026 17:10:46 +0200
Message-ID: <20260721152615.768949350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 898ab0f30e008e411ce93ddf81c4099abd9d4e46 ]

dev_err_probe() internally calls dev_err() which uses pr_fmt() and
printk(). Kernel log messages should end with a newline character
to ensure proper log formatting. Add missing '\n' at the end of
the error strings in rzg2l_gpt_probe().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260604095647.108654-5-biju.das.jz@bp.renesas.com
Fixes: 061f087f5d0b ("pwm: Add support for RZ/G2L GPT")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rzg2l-gpt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-rzg2l-gpt.c b/drivers/pwm/pwm-rzg2l-gpt.c
index 4856af080e8e9f..8534a2a9cf7505 100644
--- a/drivers/pwm/pwm-rzg2l-gpt.c
+++ b/drivers/pwm/pwm-rzg2l-gpt.c
@@ -408,14 +408,14 @@ static int rzg2l_gpt_probe(struct platform_device *pdev)
 
 	rate = clk_get_rate(clk);
 	if (!rate)
-		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is 0");
+		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is 0\n");
 
 	/*
 	 * Refuse clk rates > 1 GHz to prevent overflow later for computing
 	 * period and duty cycle.
 	 */
 	if (rate > NSEC_PER_SEC)
-		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is > 1GHz");
+		return dev_err_probe(dev, -EINVAL, "The gpt clk rate is > 1GHz\n");
 
 	/*
 	 * Rate is in MHz and is always integer for peripheral clk
@@ -424,7 +424,7 @@ static int rzg2l_gpt_probe(struct platform_device *pdev)
 	 */
 	rzg2l_gpt->rate_khz = rate / KILO;
 	if (rzg2l_gpt->rate_khz * KILO != rate)
-		return dev_err_probe(dev, -EINVAL, "Rate is not multiple of 1000");
+		return dev_err_probe(dev, -EINVAL, "Rate is not multiple of 1000\n");
 
 	mutex_init(&rzg2l_gpt->lock);
 
-- 
2.53.0



