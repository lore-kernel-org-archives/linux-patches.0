Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019739;
	b=yVfzCeIMwEbpoZ/IhQGfsmvchqdCqWLEH5C7Tf8EGg/tRec3AFi1AXvi7cIlRwaeo/Ln
	 pVWn/BJKUZdAFG/Ij6XJGJbRCEriXVx21sk1RrLVZ+cOUWtpKab9VdN54Jq/LjcIkP7+K
	 TWPAthe/ZSg+Z7+LDxtBWNp3e94YlIY7JV/uzpyTCh1nz0ANUqVt0mcAeRLfsOBMdZdNC
	 7SCXbxLUrtfbpFyalGPyBgKkFGItc64O/PUpekMd4Y0kb7GuNzpjCqpMfKf+LZmHmEAj7
	 MhuP8FbVPps3zuDDziVQcX3xyWguu6UCnhcVv674026N+3F/9nWOq5dSwo9a+JYEDqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ETmO/uKVHeDhWkTQF86k6/iSvW4bKn+fhqoXB2kAbHk=;
	b=lMr9ZAIS7JssjBdXEAFM7Dsy/siJdSyGfHSK80mKtxM4ps0pGddcBjOFiBTNspJgg/a9
	 AicvkXRcrlmzgyOOGWZMUzljRZXocuFbTPrrXtZAh9j4bDlmQni6Af/J7eETzlSRSzOte
	 VTa8kMoiKsdJYPy+P5WiQGLr+ChilxnRA84ywFKaMvxzcnPZDe+5QYQelvwIQ1U+c59EC
	 ZQ7KUXyUH1NQEkXaYzITeBdjlkAfuKA0yxB3dc16tKGZlrUWXmBPBmk6ydzQAhHlSCgiU
	 61/RnOxp9Py0V/pS7GglKaioieQKydOmyiNKQ4HpXWdEm5idtSUJWsiqPyhK6CofMKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PO2zr8Mw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F248B606A320;
	Wed, 18 Nov 2026 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PO2zr8Mw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024051F000C4;
	Wed, 18 Nov 2026 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019738;
	bh=ETmO/uKVHeDhWkTQF86k6/iSvW4bKn+fhqoXB2kAbHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PO2zr8MwwGDBtVxhNmnHeqXE5sZIESzcKzTi093XD8LYlyB6vXR+vcz0F0vP7x3Vs
	 g+ae8iOSBmMKV4B+URjTZqtbQu7i4+kV5N0rAspePGp1uP3ui6erudrB5q7MaFRxA3
	 IgbmCJtSrl8wHCgm6iH5hYk6Qdf9idsGzjZYJxyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1663/2651] power: supply: generic-adc-battery: Propagate charged GPIO errors
Date: Wed, 18 Nov 2026 15:48:23 +0100
Message-ID: <20261118150347.594741990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 937b84e04ba27..7a1f8188bd27c 100644
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



