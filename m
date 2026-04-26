Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5163554774
	for <patches@lists.linux.dev>; Sun, 26 Apr 2026 06:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777186703; cv=none; b=TmPWpNH5mj2gsdhHrGEk9gx7Dpo/AG2m+73Fjlk5dAs4nVQY2hHJvd3LYGQg1tbCgZokEtUZFYgbrjK8nDEucp7uOsjM7EOAVBOjLLEGN+n/pQnEGaTq4qw+4KczE2fI7kBt2gVOyuhKnn7AyDLbPGzLKsfSN8iDjaz1R2o5O7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777186703; c=relaxed/simple;
	bh=vtvpacLWRIolWzi2JnRuq+ZWvBm6vlrTMFtWpbBBZTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D08Ps/if/EYq834XSIb5KoH8qJv3T7mfMjbE0uOdaXby0tbLfhjemLO5vvm667E/QUFFyQtINeoRsoJPzvxBKYyNXF1yEpPU//mKEBoGym54oRBE1pxiUw1Vin9UoYgixm1Qf9v4B7IVuitjSB6nHvnJJ5hmB9ipI45XGpcYtZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=pA+ueIda; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=i8yycmUw; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="pA+ueIda";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="i8yycmUw"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 43C2C7A016F;
	Sun, 26 Apr 2026 02:58:20 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Sun, 26 Apr 2026 02:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777186700;
	 x=1777273100; bh=JTmCV/84KlY7KqQIimf5uT+95aDUkXnzBBskCuqZHh4=; b=
	pA+ueIda1UfG+olPWUqVU+X4d40sZbeFpjIrOtvI4IY5HP1P1A+Tzex0dOX7kUqC
	QUzMw7saZzI5l1UJK4lG1RhmMVIAkIGhf6QsaIJ8WouaZekbLzT3DSXoDPBpLBt0
	OZusYX3GH6r/XS2egfxOKWzc83lF3YUTtY8ZNZpMZpw9ARUkiOSNxq4V/bYJN4KT
	bPceFXHMO0Jkqu/3gJSmjgz2fWxWn2qLCzA6A2L0Nx7zTOTPv7WY8+W8orCGPxlA
	kGdVm/RHkHUFLIDyvNUWTjx6Iq0i/PIUxNlJZOpIKS3g/Vz2HTYt7EMA3Wp6Mlin
	J1N3Gdy2DwZha4MaYZkbPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777186700; x=
	1777273100; bh=JTmCV/84KlY7KqQIimf5uT+95aDUkXnzBBskCuqZHh4=; b=i
	8yycmUwxihtXnW6i+MIb2zhANtArptfl+gsdYMjDd2lAamt46wIWk8f/jmRg7jf1
	NVEOz0PjzeY60GRGPHHrr2i3Pyx85VVS/6wKQLeGFVCVGCkNpVoLCeBugyOSb+Bo
	rc06EXcXveMzu2iHv8r3pCx3pnnQGXI6fDwzo2a4DNJoinBjNGKr8nlCZVmDovbh
	Qr5wo939xwqU6duB1PgMkAm+6qOhYrkH2MNyPC7U+Zz51T1JQoneRj1mwaR0gJ4f
	TlWT0gA3THBFxdNGPMMwsxOyE1afUM7c02gD1By090egLoLXYoLku4PwuA6O9aKw
	ONKlUl/fZ9rjOrdQfsv/A==
X-ME-Sender: <xms:i7ftad4-mNYkTs_A8bfJ40IASeupW2hJPGIGW5Hwe-bIySzpOvUPUg>
    <xme:i7ftaWyH-XvZGneW6lUoni2FA7Ln69uf8dY3xNf2XhTW7QH58s2EWceSJzA_1c1Sw
    eHdmwgEUQkIatQCBcwC1nJ5d7ls7dViRvVeWmhioTm_732EzGjBKe8>
X-ME-Received: <xmr:i7ftaf-XjYFfkkFZpb-83lJK9TnRHsxv4X_qX7rgAJg2vvfAyt6oIjvavhX6Uj-0Ul0aUWT0LObjnlMBE-fsd5E7pePGoV_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejhedufecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:i7ftaaG7X_Tpmt-zxIO34e33QNLJLdh7zoEyHhFa0ovU8SdBoZxs3A>
    <xmx:i7ftaZBCLSF4MHDCAE9gY2tMPvRkc7cOq1irUS1f78hw8-Qtd_adiA>
    <xmx:i7ftaelNLseo3QObDAxBCx28GN-9KlBrjbiP-JM4JbbSWV-rJxDb8g>
    <xmx:i7ftacSjTFPIjGgPFBBBEtvjbyUIvpdYutyFtvShO_0JaeYCPQpilA>
    <xmx:jLftaTPcAYQ5SzzwmO9qerKPUJcW-M1dSbba08dh90Vxh-4TtaxhUa0y>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Apr 2026 02:58:17 -0400 (EDT)
Message-ID: <7856d947-72e0-4f91-8c9d-a642b59b158d@pobox.com>
Date: Sat, 25 Apr 2026 23:58:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132420.410310336@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 different amd64 systems. Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
