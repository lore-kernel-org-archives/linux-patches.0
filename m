Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030401;
	b=FkhjozzELeAYTWUWPEL0wFFeRZPr3YWVpTFjD7FZ8AnG3Nfrd1ITRiDKbGwZDL3qaeI2
	 V4+Hl64stG/iadICuQkCMfCVfMJ73Q3hMLV9P4rEbG/JIdC5e0dB5klRMqqmXo6U5izQz
	 fZmQ/sW45hOcOBAAJXp+F5EYblKmhZ1sC7a5PyR8f0h5ELI9LGpdyPgpdFovfYkpW1tKE
	 clVE7LJbFGIvob/+t/YWQMHYS3X5mzQ+JjJW4/tHSb0bC2JnXjAGB9VrEjI5OToUVIB7a
	 AMeehhPrnqvsQSiK3wRKE/vY3UhATv1IfidJs83hy4mx7K9FEkLiuBr36m40XUhioIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8CnuhxgiGmQ2IBo2I6KPyoy/KS7YhmwUF6bvgUI8oG4=;
	b=To7prJMXzR+nWxLBKEclE0ALl5xGI6Xqi9FwQYHDEJWO32KHfQl9N3RXovGbQ5lARt20
	 qJnWWhipJRm7KFlNZnnYb5cOHmQvTVwS15Wl2LfO252uO9LoIZgy8CfjatmQHu4pv44ux
	 3jRAFg0tM37GD6jfdgGu2P4JacRfMG6YvumVDZNhF2rSU+OU9UarzArRwFO5TJC7KuTUJ
	 I+UQqtiVAyOniKJAynkoT+CZ1aHPkSIVzWRj7F9BifevwpwJhFkzJaLN+hcHJvqFfkgSC
	 xhHjEc+SgRCz1/PYAed9NYLvskUWUcnF2VBuAAt8US85wLLEhK/yuDe0KIUZcVqUwkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=glxnCykH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007EC606A336;
	Wed, 18 Nov 2026 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=glxnCykH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530941F000C5;
	Wed, 18 Nov 2026 19:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030400;
	bh=8CnuhxgiGmQ2IBo2I6KPyoy/KS7YhmwUF6bvgUI8oG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glxnCykHcVdJaTmO+vBjxmAbN5nwP2X8hDDYQqRrDJTzKg22DOKajrUWMHHuENScX
	 AychvZD3k17oJ58Y28jWS52I2zE1FPN7/18F7iUtps2GJeBRaUzUj79n5CErI0fy1+
	 HtgMWb+/ZFRfBZJl2CTZfq1740vFjz3aJ+WktqDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0650/1756] ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118150034.754252288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 14edf39daefbf7aa689ea2bb8811a85c498e0ff6 ]

Convert the explicit mutex_lock()/mutex_unlock() pair to guard(mutex)
to simplify the locking logic and automatically release the mutex on
all exit paths.

This changes the mutex release point from immediately before dev_warn()
to automatic cleanup at scope exit. However, the affected path only emits
a warning and immediately returns -EINVAL, without any further processing.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260610102021.83273-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 411be3902fa8 ("ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index de5e1deaa167d..b993ca2dbd7c8 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -208,7 +208,7 @@ static int mt8192_afe_gpio_adda_ch34_ul(struct device *dev, bool enable)
 int mt8192_afe_gpio_request(struct device *dev, bool enable,
 			    int dai, int uplink)
 {
-	mutex_lock(&gpio_request_mutex);
+	guard(mutex)(&gpio_request_mutex);
 	switch (dai) {
 	case MT8192_DAI_ADDA:
 		if (uplink)
@@ -296,11 +296,9 @@ int mt8192_afe_gpio_request(struct device *dev, bool enable,
 		}
 		break;
 	default:
-		mutex_unlock(&gpio_request_mutex);
 		dev_warn(dev, "%s(), invalid dai %d\n", __func__, dai);
 		return -EINVAL;
 	}
-	mutex_unlock(&gpio_request_mutex);
 
 	return 0;
 }
-- 
2.53.0



