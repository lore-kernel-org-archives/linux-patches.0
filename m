Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027E2222590
	for <patches@lists.linux.dev>; Sun, 17 May 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779029196; cv=none; b=AhEkvmSLrP+3EjLf4iScy7rJA9KniNo0rHjqu5eOPCfim1AEXFRPlGsbvjjyYlLy5lTrrVysGFtcRROdTaeuRdnWNBmXTYRV8m+Vgp1G2q/F3COEiU1aCfUV5mWUxBcFS5LmaZFGhzdXcEibk/ci0mLzSzM57SJlJY16+zLvmnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779029196; c=relaxed/simple;
	bh=yV2o+LQxy0twDXt6ZXJi08/jDtOXS9SC2hNuenY4Hd8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NtRS5x4Si7KKEf+WpO9hVYjP62yxBt7G6rv/s/vCYdQ9WHdLp7xf8+4XEBySK6CrXvBLosj5r/sQtdRzlWLe4xGNbV6OnbkQ3caaNBDg3OwWvsBGSYsuP3r2ETGBshXJjw74i4Cus61+BMiunFmvlb6HJo/S09NxWOWTvFF4zBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=WYaMyG6p; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bUmgyeUv; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="WYaMyG6p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bUmgyeUv"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4821D7A009D;
	Sun, 17 May 2026 10:46:32 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Sun, 17 May 2026 10:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1779029192;
	 x=1779115592; bh=ZpwJxHaGeUzpDJMtobLHlHxO0AbKrTCoxDPJ7Sj9Z+g=; b=
	WYaMyG6ppjC9ymoKlUW66RfdpUQLe9EcFz3cT9i0tozeUPdR/nI6dRxds/8uZcQp
	UqABJJmozQiABMfHI1YDBegQI5atLLAr9WSVhSwmDCRZUTX86C8F1INGqfqtmX+S
	7rpK+RvedkRiRkDHzv+E2t6YPST95ejsiOFUzQPg8m49jk7FqXZG9T5ej+A3C/yE
	xidH0VHRmMw21g2X/SWLgjNDOniC7gMFOYnrStxTdbtjevEy+yKPiUgIzpQ0bAMZ
	RbMa1bmKtnHwdyl32NTwf962koH0gsvVt8OxcFfd6DZXDo+Xqs1jPYVLxU6q+d1h
	CGEF1nadRSrnVbFF+DUBKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779029192; x=
	1779115592; bh=ZpwJxHaGeUzpDJMtobLHlHxO0AbKrTCoxDPJ7Sj9Z+g=; b=b
	UmgyeUvdYGAPfZN6sZokOytR81f5rv4EH5EmUVfiKPEBW/RgnqUleIHz0MF1wkPp
	z+SorUmX5SbLdlA+HrdJXWPJ4JPaZJhEI+BrqRa5E/Z1kC59jW9rNTQ9gXRnUxTI
	GlwSsjSE+lGZgjK88SVRIMal4PikZMDmbfBCvEjXqyC0t+YA3R67KpxybvqFsBqS
	0FsvIQhNnzJu4OkyYrzpWz2XyHXVjSs7ZovR1GlXhnYL7im7QzLa6UROmz8XVvXB
	Vg/oe/CQ5J/MfmCYU79CP61QHY8EKKknwc2jfHouiqq3DU1FHuXetq+2F5F/Bzb3
	iY6Lq9gofFmE/TQvTVUiw==
X-ME-Sender: <xms:xtQJatwPqBSx5FIUvJutqmLoDB-_wu5b9VFuO-62orbSTbGblNINew>
    <xme:xtQJapK3oQxQeilEwLt6-LXoMDJ8jznemxhlmuUVKmNocrYnZM4r50SEceHSy1QwJ
    DllUvHTLHtVV_QS0z_niwUGL-wE2eV1lCh0AUj0q-tluGxaVNuhopw>
X-ME-Received: <xmr:xtQJai08dIvAaYOOrA9VLnMmuXaW5xXHKp3EY2TZfvL8zfPVUwoIpXKYHfLOFXTqIuzEOfO0Hhg7KM7_Tndb7Pb1uzUNKdy1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufeeivdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleet
    gefgfefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgt
    ohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    shhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthh
    gvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgush
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehroh
    gvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:xtQJajf3fKFslBQqT981NBlMExrV92XveSQQ_WEA_ZISiYlgmm7S-Q>
    <xmx:xtQJam5lcBx9YTjMyQGH7FogtNTwjALZ9Itg2PMGWoyZNDgMSZXMBQ>
    <xmx:xtQJam-av7w-nAdV-h3EEZA4t_o7hXNJ8Suhgy6FRici2sGI52Pv5w>
    <xmx:xtQJatKccix4smnWiCAC6bAEOwZzLHLnC-PulFcITI5m-7KHZjhkUw>
    <xmx:yNQJahHw35ixIWxSYEsnXRKl75ZanJqyyFdjDKFeGygy1NGJIWaDh3bE>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 17 May 2026 10:46:28 -0400 (EDT)
Message-ID: <eafcb24b-ce47-44f5-9425-8686125f349d@pobox.com>
Date: Sun, 17 May 2026 07:46:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154715.053014143@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 8:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
