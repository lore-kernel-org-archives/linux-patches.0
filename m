Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A03175A9A
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772433290; cv=none; b=njHykHr/e1+GCtQjp95rcbg7H6iD0aSrYjAxi30DIA+6t7uDmFWDUUE9n/k4hcIHV0byQHR5TLpjwA4Gg/CwjFSAmCYsW5St0fJagfS5yg0DH/Wr9EACNe461S9OSBhg05hGc847OugvDz2IjXROPBn+cyMLVwgB5Ga03m01TcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772433290; c=relaxed/simple;
	bh=vRO+oHmk5YGGkTB88G6/eykYcRBEka1Mo09t9KaR6AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTIVbJvISasHhKJgOSzitKLZHtptpQPgL1lZh6rk1+6c9RCo9LaBq096Jo7KKPyxr2abMm6CWRXrGQ7UwpiEEz2fZaX7RuPSJ9o9MPXkpau3y00jdocpEo2ihAx44SY+hn9PKJqbv0K+e1DglYyP+hLVGmh64CXGeHGduSrbo5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=jnIW/xdx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ofEGStyC; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="jnIW/xdx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ofEGStyC"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id C552E1D001A8;
	Mon,  2 Mar 2026 01:34:45 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-08.internal (MEProxy); Mon, 02 Mar 2026 01:34:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772433285;
	 x=1772519685; bh=Yizj12luU/DOkZYFAXinlxaAGnXOovaAVzGZmDXvoeQ=; b=
	jnIW/xdxK+ClcP4hzDuC5vkpAkEKNF2sw5/LST39h3iRvTJZlvsjZDrX6zfPkG+o
	RpuhVtUpSiRIKlMtjjJkpNl53ZW9iD0EzzZWj2KfjHCxBc+vTL8fipMhkmuyopM8
	kQn7fNC6x3TJN1ZR1jlgFQ2uh7wC2uTrwn6pWOmsDeP46bM7waG4K9uniUIiiDPk
	cGjaq5EVl1BsLR6GvZVEYcEDrEJ1XZQnfshKBXr1fDBl4oHYWwbZ3TzURqyn4w9n
	NT953Yl2zqjtyyT0RVcPQjoVutANVG7wm2NUeXUU0KxIvCgUfepB20AY3nPIZZnZ
	/wilXJcZtXRPSS6qJD4TUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772433285; x=
	1772519685; bh=Yizj12luU/DOkZYFAXinlxaAGnXOovaAVzGZmDXvoeQ=; b=o
	fEGStyC8hzKqAOFpGQNPFnf1l2/tOirsc5b0csE8ZK0ERBDeFVrcPTOd3ncQzVaG
	1Fr7VwNPiHkx6zcUDHg2R9fns1yWXkBXuJfaM3Td5bgIkkDadqaGPKepaqq4rqaR
	H0jMJNZoUGCnR4I+EdnDqWFXUoqeXwldCKLZQw/pNmfoJJghl1oK8rN/9oYLESdq
	wVbb4EUX1a2ZintW7P9zcYUHeMY+28mIyVycsUu4KV7wu3Hla/c0q+h3nKrQBUxF
	ah3V6z1LTrO5/+5PAI9TZWM2lUjV8dKj8V5eU6c5L1vWWYMl0bdI8QJMJ4fS3wU8
	VMh9We7xK5crihbMEZHhw==
X-ME-Sender: <xms:hS-lab_BJ3Lafy_SBbq4w6Ow5P4GCWiIStjND7Dee3nSGeXA6SJAPg>
    <xme:hS-laYHMIVuPIzjrqZLdVXrfzjGjf6-gQllFBki9-W0zyC1AlGRux-iFLWhy9Exlb
    D7bUnv4s57VzQJy12LXBUDpJsEqYgjf7dubZkAs3Y0I949q7iH9OFE>
X-ME-Received: <xmr:hS-laaIGxg6289RFhwz2AIRTji2pJqmPSKt5kcJHeGEOZZpj2_164sbU6VV_-ul95Sx866HLTSc5uvXd3T8SU0qZfneayQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheeileeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeduvddtleefjeffkefgkeefkefgkeevleelheekueehteeutddvveeg
    feeijeetkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegsrghrrhihnhesphhosghogidrtghomhdpnhgspghrtghpthhtohepvddupdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehsrghshhgrlheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthht
    ohepphgrthgthhgvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehtoh
    hrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlih
    hnuhigsehrohgvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgv
    lhdrohhrgh
X-ME-Proxy: <xmx:hS-laTcQcGvBM9EyhQR6jOiJRGDmQnnZdLqzc9NUBsj-flZw4-0SJg>
    <xmx:hS-lafVVK634R554Ehsslyg4KVXxKH90AGfxUQ62ag4b4TEdImteKA>
    <xmx:hS-laSFfRQl-XAW18X3XiZDRU0ab-boLb1yyFMIkFUfzo9Dsc9sUfQ>
    <xmx:hS-laYXEktz-5AMOfG5QYdgNi_qCTCfZcP51G8l5z9zGqcRw_ALUEg>
    <xmx:hS-laTk0h6V7kwzhA36cD9Ur_hlh0yqC9jMKI3nFC21-49E5PviH2dx8>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Mar 2026 01:34:42 -0500 (EST)
Message-ID: <761b2e6e-6e49-496d-8fe7-39d4f628405b@pobox.com>
Date: Sun, 1 Mar 2026 22:34:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
 <9623f4e6-41b4-4dc8-a6ff-cf0de3604dfb@pobox.com>
 <bf650251-9254-4d42-9224-0b8db08042c7@pobox.com> <aaTef1CyYVhpE4k2@laps>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <aaTef1CyYVhpE4k2@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/26 16:49, Sasha Levin wrote:
> On Sun, Mar 01, 2026 at 08:43:43AM -0800, Barry K. Nathan wrote:
>> On 3/1/26 00:49, Barry K. Nathan wrote:
>>> Unfortunately, 6.19.6-rc1 won't even build for me:
>>>
>>> Warning: drivers/gpu/drm/i915/intel_wakeref.h:156 expecting prototype for __intel_wakeref_put(). Prototype was for INTEL_WAKEREF_PUT_ASYNC() instead
>>> 1 warnings as errors
>>> make[9]: *** [drivers/gpu/drm/i915/Makefile:449: drivers/gpu/drm/i915/intel_wakeref.hdrtest] Error 3
>>> make[8]: *** [scripts/Makefile.build:546: drivers/gpu/drm/i915] Error 2
>>> make[8]: *** Waiting for unfinished jobs....
>>>
>>> This only happens with 6.19.6-rc1, not any of this weekend's other
>>> stable rc's. (I'm still testing 6.12.75-rc1 and 6.18.16-rc1, but
>>> they're doing well so far. I have successfully built 5.15.202-rc1
>>> and 6.1.165-rc1 but I won't have a chance to do any further testing
>>> of them before they're released.)
>>>
>>> As soon as I can (in the next hour or two) I'll minimize my config
>>> a little to shorten the compile time, then I'll start bisecting.
>>
>> Result of bisecting:
>> first bad commit: [0ef5d235ab57bc90831ddf38eb1742ff68f345e1]
>> docs: kdoc: fix logic to handle unissued warnings
>>
>> This commit breaks the i915 DRM build if (and only if)
>> CONFIG_DRM_I915_WERROR=y, whether CONFIG_WERROR is enabled or
>> disabled. However, the "bad" commit is definitely fixing a real
>> bug, and this build failure doesn't happen on current mainline
>> as of this writing (commit eb71ab2bf722), so I don't think
>> dropping the patch is the correct way forward.
>>
>> Rather, adding commit 524696a19e34598c9173fdd5b32fb7e5d16a91d3
>>    drm/i915/wakeref: clean up INTEL_WAKEREF_PUT_* flag macros
>> (it applies cleanly) fixes the warning, thereby fixing the build.
>>
>> The resulting kernel works fine in my testing, too. I'm using
>> 6.19.6-rc1 + 524696a19e34598c9173fdd5b32fb7e5d16a91d3 to write
>> and send this email from my ThinkPad T14 Gen 1, which uses the
>> i915 DRM driver for its Intel integrated graphics. (I also
>> tested it on my 2017 MacBook Air, which also uses i915 DRM for
>> its Intel integrated graphics.)
> 
> I'll queue 524696a19e345 up, thanks for the report!

You're welcome.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
