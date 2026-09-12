Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326F34752E
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 10:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210510; cv=none; b=SoL5wgJ5SgiTGCM49qw/WwWC/6j44yVOp41za9wx6tXss0US+c8OiHcI3tC8uK31kIe6tpOEVrPVuXWaYufqDtYobKwhIHxgk0iUtGcya/suqEaPwwKfaQNySojYc5fH54OgXTqggrClLFsAr7U+6YXy3gZAY0cHkvRNCc52Ab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210510; c=relaxed/simple;
	bh=EPgh8AU12yvr+cP7SDlIpLV9WIfQKWX+aKNaS3zz1jA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=YiNr0gVwM3nV3KtMj+rYT+sK1L1f6R9t70bTr1zzVXdQ6OOuk02hoVY36p+5jxXHXjv6AsEeWKrrRi08iGAXJtF777pF1RKm9rsNg+l0YBPTHgeyIUIgbgnh2YCnnTy9nZWY4hcWfrWWGk7XVNTXi3yf5RMjswcEKwBzp11oOOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Vjzfwkl8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=c/qLq3yb; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Vjzfwkl8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="c/qLq3yb"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E011A140008B;
	Sat, 12 Sep 2026 06:55:07 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 06:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789210507;
	 x=1789296907; bh=eql4k/kzL+rGSlS5qlqRs/RL0LYU0hw0ItAm0yul3vI=; b=
	Vjzfwkl8ktxUGQMhMAbTMwDPTWxn3wyBGMYWLx77ixFtQgB1G+b20VLZmZDVcMOh
	5MHEipnUmVtw/z1ruonN1alFPdXSbemS0+bLq5vxFIYSy7e96q7GuCMk5kO/t+Ml
	RbOGLAIFGrlVldlMhruDSaI7MTq/oEbtDRAAZ/I4DWqvHAK19lkwZfaVww1t0xWt
	AuJXDNOvO5AcjDpEZnsG2+yM0Gs9wgAmMWoJ7yP5U+izp0EK7eGwUoYLYbOWJmGQ
	agBlqaXPvq2DKo/DR9QrSKvQIAr5hzR22RO8k9VaTAXH2+YcO5D2tA1pcce7t4Ym
	Yg+gWanzOF8K9mj5+8txSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789210507; x=
	1789296907; bh=eql4k/kzL+rGSlS5qlqRs/RL0LYU0hw0ItAm0yul3vI=; b=c
	/qLq3yb3sRth2tuz0/4xsmqLI3bVmSKgdbWONu27FSf3ESLdehK6Nr+vgg+9BBMN
	Vmc8A5KOC8q362AQY3c/Jbt1kEUqDqkk7ppMIxKHiSka9x20KpLztc/HQEJ7FCRW
	28YiHiY/wHWiVNJ9p0vh3VP0TgnnhrL4I8bHBn7PRnJZQ7fS2MnGZ5KGnEFFrN+l
	AsEuaj0hHuWHecOX8PfzCwbroc0GpjYO6OGdtvBESt7zSt1W33v2xS04P/rfibmv
	3U4xIEZlngY0ur5Huj9p0axFUnxG6eHRTZ2lfq9yjgt+em1jjxV1nQ0Y985/PjVB
	3cfgrCZe/ed0XwIsDZpsA==
X-ME-Sender: <xms:hy-lai1XJUe7Bv4mnH3bR6zavPKFt9tiyKB1VnTNkrjmcBlK6BPhAw>
    <xme:hy-lav5fQxaEi4FE4CBL0Kqu8x-QpDTxAalSRDKOD8Nl3Ymm3mbtJLADDhApnzSpx
    8cj5fiRn_NbPKrbtA6nr8eytHDliPNF1N8TVDmdyONHi5vYTBiRSJE>
X-ME-Proxy-Cause: dmFkZTFuQcyXQu9OQdJU0YWM8G+HDDu76wAuADlFX6g2yjjWfC7TCLgihs2Nx/A+yqljx7
    zT9YzTwcsSKAzFzB7LQKbcaZh4YAoA9bJdkXZiFocqPMhxEUAyu/WJaWSrqQbFFXhZIzNd
    s0CBgfRzvalNrneH250b0k4OEC5iDi1dAb53UlUA4IyMo+0ikjozxEyU0Ep7FSxCsccfM/
    IUfbhcNFhM73H3aNcg7d09QUisoXLQNQ/XT4bIHGvxMNa878/iLtOKvQASTnSCWhsZaHQR
    PYeMAeGrhdOcDzWciZ5m3s3zsA7j4Z8Blka8bN1Et9El9DGQyJjHYwRKDkcJjtZ3lhrhsB
    TfJTSK6y6v8zFMiHAX5G0Vt9tomq1rNKBMU3JnAhUtuDoh+96QbiHwiqs4ebrRgt+nuBnW
    EiIbuB11xIMnWW9Mkn9NVpsATXLc1F8qGM2eqV23/xQGIc4JXsy+7uTIC5hcteDT87VXnp
    lopc0MEgU5u9McSgiugk/QI2FeKyU+Fu3xaZ1vMotid3Uhk+6F27UEQ5Ih6EDN5nneghAO
    Hg9m9ngNZgNoBVpvOkF/qBBcg79gBYK62EueccdY/rM5VtaYrxjeF9NjZX7zN7w2asUIo+
    IoBVBGGAXvr41BDPiJQrWZhBCzIFyGJQPD1bhXQ6VXFoWrzxSSv408ljkY1Q
X-ME-Proxy: <xmx:iS-lauXvckGPEaWsxz0PjKZ-FeCLt9QqOxxptXfYVSGCBzAvHRvw8Q>
    <xmx:iS-latrjCA-1bU_93sqjZ0Qv-EIYNWk2l7SkQP3m-dL-wOHqSii8Jg>
    <xmx:iS-latC3lNhOVkSgSoFqDd0o2x-JEbDDSx1u2dPn1E7QDyIOtChW4w>
    <xmx:iS-lahibOYFw5gYI5agak8bcsiUUIZ-CHhO8B4qAMYCi4HR0YyKDdg>
    <xmx:iy-lau-1bVSdsIHrYuSlTWmrSCVVnk5d9CGxM4SD3tekZkLLbLhgAFTo>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 01EFA32A007E; Sat, 12 Sep 2026 06:55:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AKbMHr2swbI3
Date: Sat, 12 Sep 2026 12:54:42 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Linus Walleij" <linusw@kernel.org>,
 "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>,
 "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
 "Lee Jones" <lee@kernel.org>, "Sasha Levin" <sashal@kernel.org>,
 "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Message-Id: <21533d54-3b31-4030-9dd4-9f9b1714bc5d@app.fastmail.com>
In-Reply-To: <20260912065716.196499692@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
 <20260912065716.196499692@linuxfoundation.org>
Subject: Re: [PATCH 7.2 1158/1815] leds: gpio: Make legacy gpiolib interface optional
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 12, 2026, at 08:48, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> [ Upstream commit 98c5c7b0d4269ecabfc86b8b49ffcfa47979e99d ]
>
> There are still a handful of ancient mips/armv5/sh boards that use the
> gpio_led:gpio member to pass an old-style gpio number, but all modern
> users have been converted to gpio descriptors.

I think it's a bit too risky to backport the GPIOLIB_LEGACY cleanup
to stable kernels. What is this one needed for?

     Arnd
