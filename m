Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1C1D2E9
	for <patches@lists.linux.dev>; Mon, 30 Oct 2023 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="q4VbbNYs";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="dSna4Zaw"
ARC-Seal: i=1; a=rsa-sha256; t=1698665789; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=b4fOF/V8BCG4ZHLsO3LVYfFqY33xA3/aEpQMAQTjUjc9URgwQ7ZOixfFqks5X9wc0j
    igfRbec3kbfAJzASn53YONd62BD1mcoNOWeAx2Q0EGU/BMya/OEpQAyagLGzQHtCAuhM
    2Wxt1FFTMyYFDuGpigBT1t6vD9vq7RpLWFgI3NtYF7AJ+BxCl0Rya7IlGztjjQyUOnLf
    BHhbW+gE6hiuwW6SP/X8722ogu/o3UV9Pkl6dZ6pCImDsXjxKvVuiZ4ojzpuGavNvhRF
    hrqCS74p+Top9OHmiln4ikjjJkixb+ei3EMsCdXhKAZO102dETxPw1WH7q3G11fw4cry
    sn3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698665789;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dvAMxS1s9xzlzdndQjZ4tD7LC8vju2tU5Fs8EiEQpwo=;
    b=LN4JFEbstgt/JUgYf2AgWlIWAU5cmSbVJmIh0ia1Kcfrae7bH3deMSq2cv58z6zccS
    4vNBe8GUyLb29jzap6b+cAyOX87JDv/P8iThtMVpvg85F+zNInYATyfn99N9RhWJ34vP
    QzZOdUedtkTDBgmfECXHCggJ9mNXzpfMZ1L2Ry2xO5nLrpFHhvwB347QNxC63NVnlU+E
    7u7Vzja0xyZMReF38rlZL2qLgjQ6XKSnWF3lrSgdRUvw18xdeCwcZEC+1dcKPRGfHC0n
    kdlQYB2Mw3JH9zP+jRE6f3CO5gltqR3tALBVMnaIkBJ+D35TnJg/WiJPnqMvu6pPzTtW
    iPlA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698665789;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dvAMxS1s9xzlzdndQjZ4tD7LC8vju2tU5Fs8EiEQpwo=;
    b=q4VbbNYsxjvUhr2a5Tb6FPuZp5nalwDKoXmQQvPtHH98BhZXCO/Z0MpmDMwpNcjir8
    qYmMObHfjva0B/lMNSDIOmnfJzdnB3sbSLYlaSVCq2fSte+pSWjeiB7sDyPTNU57tOJO
    GoQjJ30wRJE6EAIcbVikLzH+bTQHIHP3IlSVtVvqp/fd/a7A3cOi/Z3JWk+fm1jEbnbU
    /PwDgGKq8J4BHiwxkgsqXMAxWlVi0+IbI4a+qcUOK6QeFJSPxHYf09cHsyxumPz+uX/I
    VCUQvM+p/ydKvHdAdNRggjzdmogeGhOncjOdfcZZkyxZ84K8ppZ2Yxdkmurv9ReoXY0k
    wjZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698665789;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dvAMxS1s9xzlzdndQjZ4tD7LC8vju2tU5Fs8EiEQpwo=;
    b=dSna4ZawCcU0ycQCl1w4dSj450k/MZbHM5jHT+4MZsaIWbn8F+xdFNR9fGazc0L/ka
    SSxzskDU+IeyVBF57/CA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVJiOM9vpw=="
Received: from [192.168.60.115]
    by smtp.strato.de (RZmta 49.9.1 DYNA|AUTH)
    with ESMTPSA id Kda39bz9UBaSDKw
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 30 Oct 2023 12:36:28 +0100 (CET)
Message-ID: <a1ae9eee-9da6-4ceb-8873-dc5ddb1e8e88@hartkopp.net>
Date: Mon, 30 Oct 2023 12:36:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 043/131] can: isotp: isotp_sendmsg(): fix TX state
 detection and wait behavior
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lukas Magel <lukas.magel@posteo.net>, patches@lists.linux.dev,
 Maxime Jayat <maxime.jayat@mobile-devices.fr>,
 Marc Kleine-Budde <mkl@pengutronix.de>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org, Michal Sojka <michal.sojka@cvut.cz>
References: <20231016084000.050926073@linuxfoundation.org>
 <20231016084001.142952122@linuxfoundation.org>
 <b4a1bdc2-54f8-428a-a82a-0308a4bc7f92@hartkopp.net>
 <2023102721-voltage-thyself-e881@gregkh>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <2023102721-voltage-thyself-e881@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Greg,

On 27.10.23 14:16, Greg Kroah-Hartman wrote:
> On Tue, Oct 24, 2023 at 08:34:30PM +0200, Oliver Hartkopp wrote:

>> @Greg: I double checked the changes and fixes from the latest 6.6 kernel
>> compared to the 5.10 when isotp.c was introduced in the mainline kernel.
>> Would it be ok, to "backport" the latest 6.6 code to the 5.x LTS trees?
>> It really is the same isotp code but only some kernel API functions and
>> names have been changed.
> 
> Sure, if you think it is ok, please send the backported and tested patch
> series and we will be glad to review them.

I posted to patches to upgrade the 5.10.y and 5.15.y kernels to the 
latest 6.6 mainline code base.

https://lore.kernel.org/linux-can/20231030113027.3387-1-socketcan@hartkopp.net/T/#u

https://lore.kernel.org/linux-can/20231030113110.3404-1-socketcan@hartkopp.net/T/#u

The patch description contains the list of patches that have been 
reverted to meet the older kernel APIs and a list of improvements.

Thanks for the review and the consideration to upgrade the LTS code base.

Best regards,
Oliver

