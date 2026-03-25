Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC7430EF64
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 08:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774426802; cv=none; b=vDOozGYqh3obyb8sGSGU3sYXV/eBXFPfV8hASnUrzoFWkBxfYS3hgg9iMojI3wZSj2cDdwBao3hcM83pLJdlQ6y2T5lKBRG0YP4/iFtmYZ1+/PCoOESPTT+PgEQ+7KwQVFVNeBYbURUD3NZMECDsy60RvkhF6vSDp/o7UKR6Y4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774426802; c=relaxed/simple;
	bh=SA25mtJVoLzKWES4VucYW5UUsgCZqcbvhC8PB6mPu9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j1QJNi6TtpleAL8W20fo6rnz+4uStEHq5yCz+TLoxjfRY+RYtTF7DY0ah5OlQKast41EUp/JGopekTWkUMhZbFvQg51hcvCdJLqnd1I79ZwVfmh+aSN8pl5gqKP2M87pIEnL8VKxPIzp9Z5WHTpQsid2cyWAfXouVsyU4SDqrBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=YYxRuHlj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DSO57/r8; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="YYxRuHlj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DSO57/r8"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 5C069EC0246;
	Wed, 25 Mar 2026 04:20:00 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Wed, 25 Mar 2026 04:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774426800;
	 x=1774513200; bh=ntGmE5ZVwVOEZi5U+STXROqR+zy1YiWtq7ywZ2ZVmwU=; b=
	YYxRuHljF66tftwWj7gOTDl2n+Pn++9WxDrW/k0pNEXsbYxFKgPq2KA18Czta2B0
	zZuO4BR0gYKXRoze5Ln4hc+hXnz+A6PRvj8Dn7QsLbbsgoZpGP3mL20h9vCvYXLa
	O8f/E6RQ0JHuC8JR4XQDGw2D5Xplk0z8c7LLDWFu826l/ML8YtzyadlJEt56+oer
	cl0+bglot6YJqpTElfbBz9naR3BVdqWWH8C/aEpSRiFHW9IJhgaUMCM42sRlPDcR
	i4qjghmiLSyqDjv6g43UDL2OJ39hjbFYRzuWJknQ1ULEUUz3cqpXdG84ysqE+Tqe
	Z/yN5ReqsB5TFgZFx9e+Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774426800; x=
	1774513200; bh=ntGmE5ZVwVOEZi5U+STXROqR+zy1YiWtq7ywZ2ZVmwU=; b=D
	SO57/r8oeCVn3KNWNenFfZe+Pp3NWTmOlVyZnsmHWXADH+oTR7e8L/8NO6kLeerh
	bC8ioYKIZa0rI3aZ5oId51EY155fCEWXVoyHnLp2b8Y7EfIXw3whlmW/wTsfb5dQ
	SqLvED5gMFQMUYgyn1l4FQ7D9YUd9KD981NTPXTs3z9gNG/cCc+MsuI/mU6uitu1
	VuNFK0BcDXFbfb2Lhv7U3HpP8iGvxP4HYtIKlElIu1KgIILdp/gr/3YoH9yOWvkg
	+BJywEBcqecWwJNFSl6WpExwvbfWbNGHv83ew2yFq76NrppvDpdMCo9eBmliR2ex
	Iato9tNRhbCbZ26eLB8ZA==
X-ME-Sender: <xms:r5rDaY0w8Nht8EQDk5e_Pw3j-1jX8atgOYhFQqe9MEC_eXF31p_Xhw>
    <xme:r5rDae-o4g1eVPSd4AsZZu84hB2n6eG0bgO593Bi-HP2xyqq_VQmldZMT286xEANU
    2AhJwqjmrWi2dvl3zRRGYOGzKSH5aoDgN74ds-NyE9k6Lag6MAqvg>
X-ME-Received: <xmr:r5rDacaOsJQtA0_mJdral20tYAG2oEZv0T_2OFlOdXrcw9gEs7KneR-yk4udnes_X-pmD8gYK_ZfdxEj64lkPa5OsoQcJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdefleeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:r5rDaVyYbZV7vijUrI8Oo4SrJAM_aQBGqNJQsCcYfHfR4YCKvDhO0Q>
    <xmx:r5rDaS9AyM6nIi35Hpopr4zbce-Cukh1kwzqSBN772sTZU9LVYkkeA>
    <xmx:r5rDaZwknaIJawZB8IBcSQZzilcqkRkGOby1etxHJdUlwvlfmfIC5g>
    <xmx:r5rDafvfZn2wqJ7eu_QvVyiofT7rZcIg9MUMumwZcKe3BsVGdjL1Jg>
    <xmx:sJrDaVI6WxnFLqKIqzEeNpaAQ6J31He0oXtKOKfjQq22nQS_RP5aEGmy>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Mar 2026 04:19:57 -0400 (EDT)
Message-ID: <44a5ff3c-ad2a-4d43-8d73-2bef4e74c025@pobox.com>
Date: Wed, 25 Mar 2026 01:19:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134526.647552166@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on two amd64 laptops (a Lenovo ThinkPad T14 Gen 1 and an Apple
MacBook Air 2017). Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
