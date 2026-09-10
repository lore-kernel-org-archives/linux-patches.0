Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D8755C1D8
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789061808; cv=none; b=cPT2qQBoJbdsbaeID64QVKnZwE7IZkLpJGGKHhOsX5xIN1fMgu+f1/VBRAuEhTNGfQA74dzBX+UDKn+Hp0aUtouYzUgba4J9mPBHcoTekz5z17PglYJPMWu+KvNgC7iTrU4xD+eyjGptF5CdyiD4PVFwl62nCcyKYQ2VZYReAf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789061808; c=relaxed/simple;
	bh=ImPxA/rUoNLvK9u39rTy303kECXS1yH3M28zrUZ8utA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C+kA81cEhwxWDyUvQuuHmAACOXQhLy3coi1cEkaDV3PR3U+8dpLbKdWju7vIG9nMz3MuMyvxChbNy1AjVr548v6NedY4fQvybBV4g1Le/Z5tN02nJvtJkep5rJyYUojJO5lpLs6qNhVjj7HlHIhQhUIIVCjLCOMjdALeSCpJtrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=RLNeHpRM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ir470VhC; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="RLNeHpRM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ir470VhC"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2716B1400112;
	Thu, 10 Sep 2026 13:36:41 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 13:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789061801;
	 x=1789148201; bh=I2VWxGFI3oVu4Dlc3BfD8bqOEW3Z80dsePsJeN2htVA=; b=
	RLNeHpRM4bRJirP7w9UOlNeCHDbE9sgLagWgzzhNniVdiLvuVlj2T/I7r6eWeUe7
	PmT/T8/x7lQNZcDykqMo6bTtfzkHxZRq9EEeE7oHPYjmOILUxvniH9Imz4Qn2jkM
	68jJ99XXMbYJHQCTRqEUB/xWLk8/sjPAfUgtUUBv6Igyd4w+DWDZUxykFvWzp9RS
	WEsDYR4HePQJxNDwJt5N+d+tdN98ZCmjluVWe4TxcTN+Cw2tDnoPt5NySyFlCBLG
	gm3FdU9qaWO7mVqvOuypSWIK8Tev/wgqujboVhljs1+O6SyBNhkq3qCrTy4CMOgf
	esrCHSyryCAGb5Y1yN9wGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789061801; x=
	1789148201; bh=I2VWxGFI3oVu4Dlc3BfD8bqOEW3Z80dsePsJeN2htVA=; b=I
	r470VhC0rzjjMS/y3iewzgYngA6ed4jwe0NwmfUXoiawpaJ+zwytGtVwy9Ds5/tA
	o9QY86A6SAHxftxyXNBCguxJENdmuAkXzrDyOxj13nwaSc1E39t9QniMbYj2buy1
	VLYK+XF3OjRQD+pMih+nkeXptCaRAN3rSJaNmhpp1TPgyOfh/kv/u+Cb33JETd4X
	4TdUYbh7odKM7iYrzVlhfRAp1zxYvmQ81+AyzVmdLwXGqDsRI4LhYSEiYzGxcFZ8
	43Ny+qanUb1t2NGehTYe4eWxRU/abNW5vN+UyensDi/kqrAnmQTNG9n8MSHhsCi9
	eLRCQDXfVZ4SReIXpD4nw==
X-ME-Sender: <xms:p-qialZtYoEk4u2ZYNSCRGQhdueUFlUECfV6Y7x8q2iIUanOItOITw>
    <xme:p-qiaoQgb8AE_ndy618BYN66yY9rJEHxlXxCagqH6ikhhjwFenwB-5nJYL9sk3iDp
    IJ94QwU_Tomx0V3VrDvQMxY6-uGtl4zebXZHflXqJxuwN2-j48vhfE>
X-ME-Received: <xmr:p-qiajdXS0EGQ_JzUbQDlPf7T48H0fQX31sLHGCiDYdm3xyh1WG_a5uHb6iGvyKoDntZeA3Pr6VwTfns4dS0iWB3FS9ySEnD>
X-ME-Proxy-Cause: dmFkZTFKn9g1I2UqXoXFN38HHdIeMGMwzykN5nqOMjQJtyqhUabGxmnhunTuO2dgOxIXn6
    N+4BFwUp+kFt187HxkIyFyWb8B2ZeLpiTXw2tEmM2ErssxlkTdvle5UDfWJ8MSXqEeinS/
    Kl+NG2RXj1PpMtthayPAGwk/1WsVKZh5M/uOL0f0UY3QuC8Oeros6cVyvVnNKK19QguBCd
    uj97DIhcyVmb5kA2n8+kE9H828MJPb61cI/tDm14jJhFmRkZefBaF0U/zS49akXgSBWARN
    ctI2tS7HRMWKFeanuN4Gd43H1uoo0wVygB4OHxpJW0khwQNWthlvLpcmoTvdjp/L3PzYIg
    KsvZnfTfW9TiB+FSG7yWKBfqFzblBS/jth5gfwsC6fZkSmgyU9znDkXtE64w4OrGd4h3av
    DBQ3YUmdNw6FLHOTTOEzPSpYzVufZy3zRQCI4cKz50pAgkLY68OvKhg4UUqLjfrDZwgj7r
    E/2FXEXQtHyRk96aLMP0il49XwAWg/ZwiTVCRG0/adF/hWvysMkr8FGAMGoGAODRhgSKSy
    HSvRlfGqiKSqSO43Rd9e2G5LIUsqFJbjO0itpwhAsPe8yK3zdIX/7lxOYdyGRuemI0LWi/
    XCXP/SokD40gBS/e2BfBfU1tFIipNjWLDYACdqynjdVexnrClaByZtwKNtag
X-ME-Proxy: <xmx:p-qianl2lumkicE4d-dPUNY6EjQSiST4K53YuoKwmUz8bUGf6igXsg>
    <xmx:p-qiaojgeESeAqtRfLd3FK5RYEXpmHCmQ_XKFZKrDKX15xtYHJ_wDw>
    <xmx:p-qiaoFg7W4Mst_FyH8h5p3w135ShpSRlPch09iPTUdZN2hpBMSXkQ>
    <xmx:p-qianwefF43WJuUaAj6ltEfwnIfKK1XPzWW_gSPjF48LmiM5v10bw>
    <xmx:qeqiajvbIMI1Wus3ajma4wHfRN9qgn-fYPJtWMkxS6-HKH5LramBE6f->
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 13:36:37 -0400 (EDT)
Message-ID: <fb192349-7a21-473e-a020-6dc6ffa6eda7@pobox.com>
Date: Thu, 10 Sep 2026 10:36:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260909134230.441546314@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 6:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems (my DIY home NAS, my Lenovo ThinkPad T14 Gen
1, and an Apple MacBook Air 13" 2017). Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
