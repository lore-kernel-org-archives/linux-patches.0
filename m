Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249093DD51C
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 10:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039209; cv=none; b=bi2d+gIP+mLkz1uZWleXMxhrRfiZYS8tWTg74ooH9uyEEHe6HxV7pbVGd5QfLJ49pkJ8G1+k1tN6zZsY6D+06woiO2V1UXnbHoqrOrAnNaoBjI+rsd3SB5xuT7xb59Gs0by2M6VUMiu2IXdOCP9JdTWx+F78bQ28ihPC53CJhvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039209; c=relaxed/simple;
	bh=qYg4omQgzuOE+gP4e8SM1mCN0nyRYHc/epEwQhb1AuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=anQLiwa+erlhD/SusjSJxGxPM4XPJqPlOTwuSbyotpX9le6lP5zG7FCABk264l5zN63ZLe55BsmkyZK/57L7Is0boQWxSLe6hz/kVm7zcPZjKHwBii5TIKfnngr/DzMoVpIZ5FmjN1/Lbx/JyO3L+/+BpeP+OWMjXyYQm7oZNvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=fay0d0wG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RglUUkiz; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="fay0d0wG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RglUUkiz"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4D21914002B0;
	Wed,  1 Apr 2026 06:26:46 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-12.internal (MEProxy); Wed, 01 Apr 2026 06:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1775039206;
	 x=1775125606; bh=nly3ocXdIbCzHD2R31qh8gEREIXQ/Mx8+1BwzEH7Hik=; b=
	fay0d0wGatjvOsalwsgQb+EbrHSU8HEaWFKMcFMgPu9VivjqQze7ARP2NBiVOqsd
	t5Xjke0rnAJMrvmTc74QmmJmAYUMscOh7NWk1dAZkefkN4jr+MzSODDT8iUsiAmd
	O4w1HOndhnw5AZZIgbKgELIiIZyN0bMMI5FMDq8gXqX18eDkwkk3VRnEtwKxHe9G
	wS4VbmAEgPDze6Bc4sP//Ha3hzdt87drwKuJq73dTJo60xRUUSySR+Tj+DNOfGej
	Es9GaHsTcUcZP1TrNnZLkKdoSP7PDBTePVHSWlPusc+ho1lGPzcH+sBhfqEUwttq
	n6HBLiLtcsMylptmGLAv7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775039206; x=
	1775125606; bh=nly3ocXdIbCzHD2R31qh8gEREIXQ/Mx8+1BwzEH7Hik=; b=R
	glUUkizWoXjioO6ofeObeG5u7ORwBhhYy5uH+cca2xg2h4zBymNmebDxXcmDqYIf
	fZoq9Vs/rIvFP8Y1JGm9joWP5k7JER/SqznChSd0rYC4j4JAwC3dYMqDclWjlCSG
	mYjaq9caslbYGVPF3M0Ij0u0KMJmzT9UIUv42Nxgzoqp42cYD17f6cllR4hw5itE
	Driv15SYOXqb/HEdJReutDReeDx6X0+Kophq3lLIx2GtsKpUHnGHE/Hvbfb83MFH
	WEpP+9mZdbFIV1XBk1TIVwLBSPcWGEvfZvs8IbeJV9GahCAx+ujKerfgVRv7Wil5
	+5W/MPMmQ9FhKfQZYudLA==
X-ME-Sender: <xms:5fLMabUr9r8ys3woqCv4fQq7Zv7Cai6j68QoxYznQrwxM8ybt3xBdQ>
    <xme:5fLMafeI9APPLN3nL-SGwTmvnWwJL8vSMi4GwfLXo2VpNf9REzBn5ECz0KJM98jcQ
    09FjV2ToilMAGPygZW78RtOII2ym5W-Xwv4G6RRc8KlGk6EqakQlA>
X-ME-Received: <xmr:5fLMaS4i9OCWotOkrfdJzAcu1yE3WZK0yLjj4Rx32xJPjftLXKoxG2UGg-hXLGC8Fh36f3A7AynDJySN8jLYEeoXGE3w0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhrhicu
    mfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtffrrg
    htthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleetgefg
    fefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgtohhm
    pdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepgh
    hrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepshht
    rggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthhgvsh
    eslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgv
    lhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgusheslh
    hinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhn
    uhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehrohgvtg
    hkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:5fLMaaTLgtglcFGXuMxp5NUrUR0ShT3Rb5kcZt-YTBNE59ZWn7Tv8g>
    <xmx:5fLMadfFQSFqfpSG9MIhSsUCBIzEARg08dxvbdDVxp511yCIziBBKA>
    <xmx:5fLMaST9T9WFf4WNnSn4pGrSowUuMjaIUBnPr_TOcBEecoq8m21uUQ>
    <xmx:5fLMaeNBd0_eVR_5f6wmlEmu1Gc1g3ZvLZ8AqKz-_9gXrC5HQoZx4w>
    <xmx:5vLMafpryu5JNjmyQtFbAeVKWaWjGvXsilwvOkY2jsgZ28Pl5PGVtMg2>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Apr 2026 06:26:43 -0400 (EDT)
Message-ID: <33fa2d26-3309-42c0-8253-111d78753690@pobox.com>
Date: Wed, 1 Apr 2026 03:26:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161729.779738837@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well, no
regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
