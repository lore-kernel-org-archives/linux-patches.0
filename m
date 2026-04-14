Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9032222CC
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 21:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776201101; cv=none; b=Z8xDcNYky5s57JDFP/wnElvZtKVbePVGjbgFnTM+9WC8Or7gf8+R1MqJ6SzzzEAOWl868AgytMifXfn6vkdB9xL3m9qNPEaLSF+84WkfPzBWaCvs+Q1fzl8nUREXgAdgiU28g3CGS8uGqzr+b2IxjQ0VRN5kmiKdYPCRpspu0AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776201101; c=relaxed/simple;
	bh=xORBasnnuA1H3U0377J5I1oLYPQvtXv8PgWTLgHHm2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QzQk0K/Ut8Zpj55YxSigt8DO++NayMJdveLLLG9W+ZKmLWYg+GEhOhMGzH+Vn+Smuz/w6ixQKi2tMSTuL8EqxARxggg9/+peDuTk76NwUPyxYGN9jScapkNojqmZoUOKgWsBj86eS96AjQwEMP81ujSnEK37G3Jsm0Ip1Byc8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=tGg/Daed; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d98EifWU; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="tGg/Daed";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d98EifWU"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 776777A01EF;
	Tue, 14 Apr 2026 17:11:37 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Tue, 14 Apr 2026 17:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776201097;
	 x=1776287497; bh=LiwgadAiHeZxWcFRtlz5/YVlxTnCSEj1HBd4BPcZ3sY=; b=
	tGg/DaedcfkWZcbB5s6KZznqtd8ob6ZVtmfM//vrQi8e30Q7IemR7r+xpQmyEz/U
	s0hPG107B861ya8on4ajnoGuOEHMEvzTIclR8rXbnOMEtMqECcPgkUw5p5nD0c+m
	FPzKLFA7w/jPwPKVtlAxMTilqLm8/1zH49XBp9fUMpTiCefrLx25YVA5VZva+El2
	rxwsTsbxSzx3x1+nZthf5D96wkqOTArD3CkqQzfKfzi4956whk1hSPd/f8hUX3RH
	z9VkKZokntIGRyurRaiS8OgHTdv/DDe5sUK8UVRsMrqK554apGpX6RUbg5LQiUx+
	KwVQ2AyPj/SlLEdhQtcHFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776201097; x=
	1776287497; bh=LiwgadAiHeZxWcFRtlz5/YVlxTnCSEj1HBd4BPcZ3sY=; b=d
	98EifWUfFhb0PGpkVYXhWingDhN5rkBTStKhNnKmNESupAP7nQLFUVWuEBF4ywAt
	Wl4AiAk6X1I7c1LVHWeEcLQJk2DpLO4uNm9oKKXoNCvFXhftGI89YE62Qvx+mGz8
	AWdsS+8VyhiOZXQJJHsPEW7wJkEX8u68sXR/debLfky90lGZq76RjwDtfcBqstw1
	c0qbuKl+lBvbK0O51SWdQ0LR+VpiAPB8YnOSadDnNTnqRAiyvVhahNtqwuIn1ROY
	c0JCosG9wmVKmGYdebyXYEcd1Rbe3G72bIe39JRi6iABiZZkUm9uEMwFbwaJaVn2
	Xn96dZmO+5N34gmF0bW4A==
X-ME-Sender: <xms:iK3eaS2Fwf8dE44_yJEQLybBXQ2_3Swrj0SPxXRA4UA8DKjcspNXkg>
    <xme:iK3eaQ9xi2ofemUNIFoqX9oy9becLdv_9_2R1Y9Nqbbyv26cxFN-KM1p8PGqQxEot
    1Z6v-OrDYkw4Q9cGrbaO2yIesNZL1NJOIu-DWLbsGuDSBpIU9PCzNw>
X-ME-Received: <xmr:iK3eaWaE2umoOZ3luYFtnqGwzGAppzxGOe98QKtLKKpc6GXEfpa4To2_7_E1u4Atj4Fsfzn5CxySNlX_Y-5u_Ny0sKeE8BLt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegvddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepfeelheekheelkeejlefffefhvdeljeetheeltdeiudffveetffelteeg
    gfefhfejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsrghrrhihnhesphhosghogidrtgho
    mhdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehs
    thgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvg
    hssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhorhhvrghlughsse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovg
    gtkhdquhhsrdhnvghtpdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepphgrthgthhgvsheskhgvrhhnvghltghirdhorhhg
X-ME-Proxy: <xmx:iK3eaXzteLrL8Y9MAUmGXvYXAeZU92GJy1FrAS15z_1MAraZg5OHpw>
    <xmx:iK3eac8-lvzOvI6UvzqbmSFhiOL5SebLuu9JqokxYkX5QtHWwg19NQ>
    <xmx:iK3eabxOlrEXl8cN7hXKZDXcCdaDRw40oPQEhd9rS3nkV9IFF1ORqA>
    <xmx:iK3eaZuP1k7ATeu3dxZsYo1yFxPh5mTT5ZYOdepEj1-dmnLuas4hug>
    <xmx:ia3eafLoi-v0jcPUplzKwVQT91cFzSk0otl4gigv3z_2Gi9Sk0AhHTml>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 17:11:33 -0400 (EDT)
Message-ID: <4553b9d8-9829-4b7e-8bb2-36747d4f5632@pobox.com>
Date: Tue, 14 Apr 2026 14:11:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155731.019638460@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 systems (1 amd64, 1 arm64). Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
