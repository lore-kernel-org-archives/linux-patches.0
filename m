Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041278;
	b=kdLlPt5IIqGqqibc6FgFhB8AqmDNPrTT8pUJ8QZCdtlGjMp0ImbrTW4hVMxnykT2Ubm/
	 kPexVMT22gJeUBHPrhGZzhgK1Y7zdYGBkNw9bh3OnalpjKwj+Tyafp9srJzMM+B9zZXIM
	 rMj1oUrhHRVFfcQm9wWbR4MIJn2WUVxr3GpSVDKr9AMEA507TCSJ2jJ5lCHLGmYUgtfrw
	 6K3vwiq7DVdZtjMgEI+OBHQMBWWBWFTKoQyWPpLpqJCSeo/G8QkpfUkNJOJcUbfhKZIjB
	 ZnzhuuuH9EYHbAHtHzAq5f6T1Zux6L/xAp8QNFTD3isSrc68I0PflAVLnt3bcMUIWdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iY9QKmzNF9XPeDvuJ95t8JvgAzwharYp+2sJyTO66LU=;
	b=BUt1WdFO1OZoUPi/qo/i/+7kZ3P8smgKZS13Zc7AGu835DvwA941VEIIJhUbxOM5IVg8
	 syedViUnXA6NVZ6P9Lf04j3h73SSi++M2VOCxxVvLMSdyejuWB/SW3FdBcM/ICqgXSkoL
	 UuF9+pbjmZ1wW0tasHyoB/RVULJcLbxRVSiGM6tCU+HxTYmA7g4LFobICTNHWSGUQVXnO
	 u1Kil0rtezvrWCuPW2kmkf4PiEU8164LrTqJSHh5nBZZmNtf4jTiaJPE15D26COiYXMUs
	 s54inldT/Ym6jnrNGkW5mv0LmjaIVNhoTFuhw5I6H5xM3cgpOaM6A1VjkOR2Cp01uvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="05/nCIqG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BC2606A320;
	Wed, 18 Nov 2026 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05/nCIqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B08E1F000C4;
	Wed, 18 Nov 2026 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041277;
	bh=iY9QKmzNF9XPeDvuJ95t8JvgAzwharYp+2sJyTO66LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05/nCIqGbzX4rvprRcS/x0n3OAZvzHv5e9KpDspZlo0DXzKJ7CUu4TnGVTjpSgzAR
	 MexO2/r+mkrBkUxxWqgKFz68SrHNNtyb90Asuc7np9iy9Q0nhKuqSShpoDBX7imKnT
	 YQnhwy7+T2TrqKNZtXGwdzIM6cSNdYV8LjW1Qf68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2754/3318] power: supply: generic-adc-battery: Propagate charged GPIO errors
Date: Wed, 18 Nov 2026 15:56:16 +0100
Message-ID: <20261118150443.368186866@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 36b0abe904ac9cbdce6161d9c7c0bcac963bb3fe ]

devm_gpiod_get_optional() may return an error pointer such as
-EPROBE_DEFER, but gab_probe() only checks for NULL. The error
pointer is then passed to gpiod_to_irq() and the original error,
including -EPROBE_DEFER, is lost.

Check the return value and propagate errors from the charged GPIO lookup.

Fixes: b0327ffb133f ("power: supply: generic-adc-battery: Use GPIO descriptors")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261009112429.33318-1-phucduc.bui@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 43b735d4d49c3..c7e5786dce59e 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -243,6 +243,9 @@ static int gab_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register delayed work\n");
 
 	adc_bat->charge_finished = devm_gpiod_get_optional(&pdev->dev, "charged", GPIOD_IN);
+	if (IS_ERR(adc_bat->charge_finished))
+		return dev_err_probe(&pdev->dev, PTR_ERR(adc_bat->charge_finished),
+				     "failed to get charged GPIO\n");
 	if (adc_bat->charge_finished) {
 		int irq;
 
-- 
2.53.0



