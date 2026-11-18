Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044275;
	b=xeB4oPCEsd85Nf5iXTx++F4eHoAIzIVSFDjb1xZELsj3q4Zdi31732SipL2aCXkjxqRf
	 sBe+Lu+t4cNaE46FhDeIblWQX1Qmiavlz6zBcvBjsdIsABq5xnT3B5Usw4BEbkN1boOI7
	 pbbnaZFFkhOIZUaudJvOwHvqAyE65iPn9Ckp+SN8YXT3J7uDb9iusLlm7x2YeasELn5Bc
	 resMrINL5rv65OKNEYG4J8SLxwqGOYc+5qPb7s5RT0uFtYQMp0hmD+3Lc4ZjgrEn6dHJ3
	 JBnqHqf/1BNKvA5tqxLFOkV+DheZU9/Ff3hkqrBAUkLXZO0/YyoZtKm6vL+GboIrWvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFdczkdbu3tLSp1EbZRUuwnr8ed+EHbKxbXsncD8OvE=;
	b=s4/CFDApDgkF9G0EeoVyYs1ZaLLyCGK/PiRoDNDDHZbcvhW4J+j/IBKfBEuoOUbk7UIY
	 peQzESbWD0QW/Hz3aIhJXtIKBTXwsbIpZH4bStJgcgmubVAw2jcF7bC2A35T6n90TlENm
	 FGIgis4iRnJ2QgsBiTlX01g6UXEQqXJ1LWXgSASsYx3iWiEEmlEiF1hZZwfqv488UGXqd
	 toWO0BeMXxztLD7sCHjGykVdp4RETtqKDh3qVg2rs5HDp1yD2x0yaEU+Ll+f9Y3E3YGGb
	 2kRZyNMfZzgqLD0Ppm+qzZGe2xC3if1Ibaqj6K8LITxdwmzAMQFazY1mCupERuHsxag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKl7hjN3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1641060A2614;
	Wed, 18 Nov 2026 23:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKl7hjN3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9A91F000C5;
	Wed, 18 Nov 2026 23:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044274;
	bh=VFdczkdbu3tLSp1EbZRUuwnr8ed+EHbKxbXsncD8OvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKl7hjN3AZwu6+x+zzpEJn9NAVIWUyVL/LSUATZg16CB1VEcjpL4h3RSLW6peV2AT
	 kpj79yQQRYtM+aQfmYbWljdJpicoz/yPbngZ/7T6/lGy1Xy8kmICl3oQvJdQh5QoHt
	 Hy+GW6rdF4KAvEKOFcFoz2HqQVhAjO+yweo6OAKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 0507/2857] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Wed, 18 Nov 2026 15:25:41 +0100
Message-ID: <20261118150219.716884688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

commit 1dbd46d4b2fb416a8202b1a8e4ef9d0cadbe075f upstream.

wled_probe() doesn't set the driver data for the platform device.
As a result, platform_get_drvdata() in wled_remove() will return NULL,
and the first dereference of it crashes on unbind.

Set the platform device driver data in wled_probe().

Cc: stable@vger.kernel.org
Fixes: feeab87b3072 ("backlight: qcom-wled: Add support for short circuit handling")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-1-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1681,6 +1681,7 @@ static int wled_probe(struct platform_de
 
 	wled->regmap = regmap;
 	wled->dev = &pdev->dev;
+	platform_set_drvdata(pdev, wled);
 
 	wled->version = (uintptr_t)of_device_get_match_data(&pdev->dev);
 	if (!wled->version) {


