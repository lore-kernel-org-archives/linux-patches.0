Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44278428841
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 10:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210683; cv=none; b=h14MVu6gMzRl/ztzD1JjitTw5jKma/jZYnobN+mZS+r/aJ4AbuUTmK1KRAMfnj6rS3Nf52XN54ED/HmUBq7iHgYtne8oxpKZHl43hhMocNKWodkhyV07jv5YaMF1VnKlzjqG2YPOIo6W5fDdNgEze8Um46z0PpRnFIjl9Ctyoag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210683; c=relaxed/simple;
	bh=hVXAeeXWKdYkspctwqo9kbFTabQPqrYaGxCN45CSpyQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=BlqYFtGUrNk0u6s7iZY73OKCj/Haa5BvMw5vz8VTv/3aPXMg+u6zCwonVEvXB3/Oi0sZnMitWF60eerYpcDKQmbGgwfp/NyZUKCFTcZYn4mGdRWmnZ8zXawXjH3NVR40GfPAE0GK/BZseZ1wWxcFTmQl8SazCtIVvOZ2cCpB0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=YYCC865q; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Vuna+zG+; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="YYCC865q";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Vuna+zG+"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id DC469EC0101;
	Sat, 12 Sep 2026 06:58:00 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 06:58:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789210680;
	 x=1789297080; bh=KijIXLGdUqOF6cyNT3nNqDfzqJ+JjAIePBMYLLtZ+2o=; b=
	YYCC865qsLVP+/m61o4pWLeP2H5UrNmj1bncuJgff73T0Fl54k/a2d2/bkBC1cWQ
	XnNl6QDYVDlMr5xZoN4RPPA7CWmkA0vMP3nrBHev4MR+F/9wgIfsPQXSG0mkjRHl
	EJSM2dq72IDnR9zqlaWVWho3AneYxiQL01sBGfxd/TYUSuxbC3l2L/UEiU9wgzEa
	HuATIP+Ki6hoo24DWVWDDFEWEKsWFIvJHpzi6kkSxSOO2W4swNLYCS+WjTTb3QW9
	Qi838tGq3mPXYQeojGcCEo3NqEDROLMEh6yyOK7oghI+affiwkKXs/WhM1KwYNcz
	lm//ydccbH8cKYsqM63UwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789210680; x=
	1789297080; bh=KijIXLGdUqOF6cyNT3nNqDfzqJ+JjAIePBMYLLtZ+2o=; b=V
	una+zG+JQ7DBDeKvh1qSD1KtaSpCQihDTSM0kwniaf5g+ErEJ1TxVrO7+3VMfbZl
	VQqrdg3k6OcKoX4EIFdqHVuzTu/7KT879mpPpAbRAzRiC5PvPZF9SCE5M9RzQxg/
	NiRXLVlu6oI57Wb3DzOrlOiSLzCqkXD6pz/ERpfY0DqR4ErioiMrHYzDzrIYSm4F
	hbLOjkOYJ23YOorcRfcgSufAvr+8Cnuko5TPvPn8JlvoyAH2CX5cUKq4sjuD4YKa
	aZuuZnJMb4UopB3siirlCm69sUtzjXNEpboc6iX5XcLE0fB5SraKvlq/RGoP231f
	YoLKU3F//o5hwDoj+GKRQ==
X-ME-Sender: <xms:NTClauQn6uB0sOQI4f6S9M1rFYFt1tnLn1PEDLAKDz2-jUuCvOkziA>
    <xme:NTClaumnSH3uwDAOeBmqucH698Uw8FGecVwc6vIGT1T3qZEZDHTXAX9ln9dSsw4sw
    y4Z31rqwtPSiZCQrZFpUNiPBIy3Y6tXdHalnt3ZSK5tLd7QNejGHzI>
X-ME-Proxy-Cause: dmFkZTEIXI2wlk1tCvJNEjna4Opps0JwkN+WEecBjWkn3oKN7bDcV+WVEZurN/3CWvnm2K
    0ME+2T5Eue2UdOVwDcbZjnFms292Ufyv6Ua3dEltuc5ELkptt+7reX+3HaqJK7UMrwA5zq
    cRUSkBPWuFHITdpjTnGg7gPAi3L2zl+y7dqmCTft/p2mpYEmWbI+lVV6lG+vrlaNVwO9yk
    TzkX8FaMXNI5AhadQUHuAMn5fBYpg/jAn3x2fj1QGBHm9+aXXrms+/EAYa5k4hhNasfZ3X
    IbuQagcqRD15dw+N5sE+unpc7T8pZ8VpSKrcd2BAvhNiZ+GgkjbiBWlDN8ByAw3xBbTwYR
    FTJRJz4r7hld8oAmz3dS6bcH2eoko1jrUvFQLCkFLyximb4cW7X5n6x4Wx2sNfK1ehB83y
    WKejjMiRg9zvZu1NbIw+phBASa8LD0is6NB/7RVY/ubKmfnT1bYoT9KwR3y2OMK9VdiBbI
    2HYSEbNMAIYfDO8q+vO1O1eEkTRUeMIrMDLF/5cvg12jubIg5KcXSjMNE2Rcjnzt8I0Hlv
    WG5T3BstcCCdC6I1MN42BmDJPbrNlfM7Ze+gDHq1ui6c5WPSCY4y/0Jtx5FPU+qLNclc5N
    UdP3FCrQYrdQnlCKz2n1jzdnth6JFUsIaSj8p0QFhkwoLGxItI7kVYy+WUdg
X-ME-Proxy: <xmx:NjClauGVenfGtPWiYn8C1EnF1-LaTduEBb154T7I_kCg0I7jXn2qDw>
    <xmx:NjClajA4t0Laz7YJtcbbwJEhGzkz0sFH0hrDnDmIFV0RP8hz4-N1Mg>
    <xmx:NjClah9ngbmsIX9rTUk89QdJlOxiXp56p2fel1LxdMWEGWwFoGprWA>
    <xmx:NjClavAxQBXkgWbRXk4RRB2eCL2A9pqbw1CIFBYZAMiC4TZtbvRAog>
    <xmx:ODClaiUpVVURynsCABtLFBGxcCagxnmPXQQ75EMBMU3uIez-wobEZDZq>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7D72532A0082; Sat, 12 Sep 2026 06:57:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AggdL0O517qg
Date: Sat, 12 Sep 2026 12:57:36 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>,
 "Sasha Levin" <sashal@kernel.org>
Message-Id: <d6c294c1-4e40-4646-b5f1-065a3a9b16a4@app.fastmail.com>
In-Reply-To: <20260912065644.647595753@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065644.647595753@linuxfoundation.org>
Subject: Re: [PATCH 6.18 0937/1518] gpiolib: move legacy interface into
 linux/gpio/legacy.h
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 12, 2026, at 08:51, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Link: https://patch.msgid.link/20260428154522.2861492-1-arnd@kernel.org
> Signed-off-by: Bartosz Golaszewski 
> <bartosz.golaszewski@oss.qualcomm.com>
> Stable-dep-of: 942901eeda93 ("leds: gpio: Clear error pointers for 
> skipped LEDs")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/gpio.h        | 162 +--------------------------------
>  include/linux/gpio/legacy.h | 173 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 177 insertions(+), 158 deletions(-)
>  create mode 100644 include/linux/gpio/legacy.h

I don't see how this would related to 942901eeda93, this only moves code
around that is not touched by that patch.

     Arnd
