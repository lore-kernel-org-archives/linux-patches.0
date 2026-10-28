Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212638;
	b=ZU43rR5CGkemG14NTLojXlEVGVkok5e+rBMb9gZzfxKIIRD/Yjr6QbZRBc6UZzdIYHDp
	 eZM+2JbeYMhjMJ+lquGRS+1D8JCfsk6Tv5AnSkyYFDcOqAGNGQXjS9kB3caQ2rwxV6T8K
	 45wJsOQx+3xC8FJjLUwYMafd8zBc3fCvO1J3fl1BF4iuwa61Uati0jsWC9UeS/bgG7u4n
	 z12wGWIxMR/AjG0JIZM4fAqfIkyR661/gbHRNnX8sDpb3WZVmZ0PwmX93WiFFPDoVycGS
	 f7UvW2qtR1od4h4InItOqP1HhN+TNpu4qYKv0gylPoTLCJK6bzkl1JGAmmAtfoSzinw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJYBD773GRVZML2iD3Yl/mRsnuJY+kZPsVVpKgiN8JQ=;
	b=CDS/CfH37vt50bi6374VTpnlzTvvKM1Vb5A5mgf1r2lwRuqkQaJRDC3Jtqhxfy+exK5N
	 hI+gs0ow1SEXIT5ZsMYKucel0nqMkD+rgmOblyjmvAHuDECQPJzmj5cfvZmPQZUNf1Qnl
	 g5TShOGmP13u929E1EK37dP9te2p2KbewGPayYiIcAQQh4OR/3PV/Wvg6V2PeRWdtCq2+
	 MC2pdkhKLBZL19qZ4GmzKI/y0nP8DJqLeVJWwJiFoEyGCsswdqJUMz4r1lMuv00FL6xqt
	 R7I06H4H75O/8+OKZjIc1okd5q5BmvG8NRhHBzgLEtC1BuKGSqc6TaidrOCsYIZ++bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/mMbZUt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBF4606A31A;
	Wed, 28 Oct 2026 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/mMbZUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7AB1F01828;
	Wed, 28 Oct 2026 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212637;
	bh=dJYBD773GRVZML2iD3Yl/mRsnuJY+kZPsVVpKgiN8JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/mMbZUtbq7SSKaKwja62OJRzrOjuudDcTcalEvOqA2pWv8Zf8Ek7AZtrD8ZLH31M
	 aGzjXUhqQYl2wbq50UJjMUKA3jL82oiwj7TRLd8+E89dBN/qL9FAPGxqE1AOajnPMw
	 jRY1s/zrgBXfrpTYRjQ7PVD3pgsVwZ5XMmhpzJig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manush Prajwal <manushprajwal555@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0224/1887] rtc: mpfs: fix unchecked devm_clk_get() error pointer in probe()
Date: Wed, 28 Oct 2026 17:38:40 +0100
Message-ID: <20261028170504.330021098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manush Prajwal <manushprajwal555@gmail.com>

[ Upstream commit ac41b05d15db3134e839148290d67415ee0bdb58 ]

devm_clk_get(&pdev->dev, "rtcref")'s return value was passed straight
into clk_get_rate() without checking it for an error first, unlike the
"rtc" clock a few lines above which is correctly checked with
IS_ERR(). clk_get_rate() only guards against a NULL clk, not an error
pointer:

	if (!clk)
		return 0;
	...
	rate = clk_core_get_rate_recalc(clk->core);

so if devm_clk_get() ever returns an error pointer here (for example
ERR_PTR(-EPROBE_DEFER), which is the normal, expected outcome if the
clkcfg clock-provider this RTC depends on has not registered its
clocks yet by the time this driver probes), clk_get_rate() dereferences
that error pointer instead of returning 0, crashing instead of letting
probe defer.

Capture the clock in the existing 'clk' local and check it with
IS_ERR() before calling clk_get_rate(), matching the handling already
used for the "rtc" clock in this same function.

Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
Fixes: 0b31d703598d ("rtc: Add driver for Microchip PolarFire SoC")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/6a9d4b02.7d74b517.206c4c.75f8@mx.google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mpfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mpfs.c b/drivers/rtc/rtc-mpfs.c
index d329e0eb66c44..e530b7868f999 100644
--- a/drivers/rtc/rtc-mpfs.c
+++ b/drivers/rtc/rtc-mpfs.c
@@ -256,8 +256,12 @@ static int mpfs_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	clk = devm_clk_get(&pdev->dev, "rtcref");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	/* prescaler hardware adds 1 to reg value */
-	prescaler = clk_get_rate(devm_clk_get(&pdev->dev, "rtcref")) - 1;
+	prescaler = clk_get_rate(clk) - 1;
 	if (prescaler > MAX_PRESCALER_COUNT) {
 		dev_dbg(&pdev->dev, "invalid prescaler %lu\n", prescaler);
 		return -EINVAL;
-- 
2.53.0



