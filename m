Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2D734DB7F
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770794994; cv=none; b=V7EJvnnv23S/FJgbDgscxnZVXDXweDa7wz88hXEFc1fmp1HBDgzYOJPxOsMfFb/Rd3Atbu4c/qI9Og8Lyd8HBIgr/cWc7yFpc4GrPlSWpQse/JVYb/g8jbIQxL3xb9AWIyjorsX5BCCMLqlUfRmCQohXPao9MKtOa+sHWdlSSQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770794994; c=relaxed/simple;
	bh=jUNNokpcT+UkeAlTWFJ0dNzvTBteBx3/nlPKRNqPSUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQOvhs8AQHyiZWkGZI8W0QezRbaCLDnV05531g4DM1kBsd3r9taqcRbi4i435iMdFpJAEzmuVOe3dsq/qycbXQejFDfGCGzievs73wX42frp3VWE3PxPMFj/ycxMpDY6SSRC2VyXi2tmd6MZel4JjS0vFvU75cfrlA1mhBJFQug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=UPtHvZCJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qwOV4j7f; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="UPtHvZCJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qwOV4j7f"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 30A717A01E2;
	Wed, 11 Feb 2026 02:29:51 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Wed, 11 Feb 2026 02:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770794991;
	 x=1770881391; bh=AjS6i/iKckaNsiERbh9MJsIjS+TQOnKvJzoFDAF2eb4=; b=
	UPtHvZCJM253jxShRVt/31v5p3wQk5psVn2APZ3nsCKyghLqQlCOJl3Q5RA88YPW
	zCDzxq+VV6czbCgl4RabJZfbNpqQNRGEBX3PSfmBrQhpauYtPYhpKgIAvf0i5Obi
	o/Dh+AEWOXlduLnhwpSL50dMNvbjNWhRUu7Y/hP4q+HqxP8bQ4IOIP587leBwNlj
	kyEtRqVYxJJIEtD3s3ZZIoJFXnVZDek6nJPUQncZBYxUievdNl/kPUAsa6QFJ2Fj
	VJqn4rReTe85QKWWqgdwcej8GkDdqBjJSdjzk5fq7vk1cEKPIAP5hVV/w1DbDvhp
	2xem3nGEhJf4+ne2kLd7GA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770794991; x=
	1770881391; bh=AjS6i/iKckaNsiERbh9MJsIjS+TQOnKvJzoFDAF2eb4=; b=q
	wOV4j7fyCA0UA9ddDynwFLwDohRgnYtpN5AuNaSDDQDGPSkl7GymVO3Y5EDfyAdP
	2ihjlDgqBYGnUinDtNbPuVoU08M3/c19WsszXLibJ9mj1EfhQYRzBtKbRL7uLRT1
	jibjSgF3gic7NzUTy4bvc0dwlWwJmNNta/2LJtUBqQTgQWjLsLQMdRrmfg558g3R
	2yrNfA3yaz/TgEXLqy5S7jDV/4pHr1UZ6oPCGQdYc5QBgshzw+7XUTiM8SVkZq2R
	BfbGYk2xZEmN6szVPUerr2YAeEOFySwfZ5S6JJTHh53q3tQ23J9fVX3u5WsvjbmO
	L2/IAWlv5l9nva+KCFk+Q==
X-ME-Sender: <xms:7i-MaYoKUwPv3PVH5rR64zn0kT9D829Y59ZAXZJ32oYAvpQzOafpoQ>
    <xme:7i-MaajHDkVoFMu2neNL_Q2CSbgydKOBszR9Krf2rGeBbboO_CK7P-pkmQqD5dsZq
    ZZfn2oo45RbDRxsYShDF3SRG8KQVK8al0WXO2e5xiqPvLCWiwmTsxAt>
X-ME-Received: <xmr:7i-MaYvZn3aH85QBms9e0AliJ9V3Zb3wy4nnoeCUfRF16WAA4U33m9Op8IupG7WGKa-nztDHRpKOY6OWUk-vTVrLdAe3iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdduleehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:7i-MaT1sGYkb8amLuddPeD-pEZ_r9fPZzMBjnTQM2kwOBmjgNXHBzw>
    <xmx:7i-MafycuWBiNtuA0Dm3D_D3MxrIfRtxjBO5pQGZqKRWenB5a01mdA>
    <xmx:7i-MaeXVvfIw6hR7uQ4gwMikIHts0tKkfODrPAIMDVLkXAFe0Lv_tA>
    <xmx:7i-MaRDy5bdNu6m-y3F854KuVSeLD5XIMCqIHKvnthk3z_7070lolQ>
    <xmx:7y-MaZ_ASN6A3p6gd4a9ND3SNI8l5eKfIioFR0ZHw3OusXGYeEJ7YF0G>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 02:29:48 -0500 (EST)
Message-ID: <a5cf1b62-b10f-496a-9f95-41c389f2a661@pobox.com>
Date: Tue, 10 Feb 2026 23:29:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142256.797267956@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.250 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.250-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well, no 
regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

(I forgot the Tested-by line in my previous email, sorry.)
-- 
-Barry K. Nathan  <barryn@pobox.com>
