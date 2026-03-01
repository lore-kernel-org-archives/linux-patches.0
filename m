Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7723615539A
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 08:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772355003; cv=none; b=lVcJE2vFYRhbfk9lPYt72H6yfSCIG6cJ7CMgLk0Lgl6kpuphxoRKNTLngPHpQq6XX8MsShxqj9Z/G5Pt8vr1MK5dWIIz00SA/+8rwf8GSnjA3JoXfpQJXbKh83oHww8nENTcjcmj68arbr22zKGu+ISM7qf4H8iwYC7bN+nHdC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772355003; c=relaxed/simple;
	bh=HsnFsvBs12076pK0qxpdvIP5xBh491o3kaV9IioQUQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qHjuOCYE5FmabGllG9fj/zrOn/ndJSYboR5sCLnuJRYdE/MuaJoISU4cAi6aYT9jZ9ZExRoSo/i10iHDSdejf/FZg3HJPcekpEu7Ng3v/l7V4766Fv4uPZDmSg99tZp+XA+kgE7guD3tSGMWBBzDRlEHIRqomFPHnpijPVbBNt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=YfGMAHZR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fy7hWOPf; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="YfGMAHZR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fy7hWOPf"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 135137A015D;
	Sun,  1 Mar 2026 03:50:00 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Sun, 01 Mar 2026 03:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772354999;
	 x=1772441399; bh=ThONbf2YvMCzTHzmAfdVxkvA+DfWRkjecyYIwWwJ3Yw=; b=
	YfGMAHZR/eijWNP2gOLDcOdBFKEF9ryiGpdwx632ymANyu3Wjn5EosMNwvCraaHB
	B4YVxAueyeUKENxiruwqshEcTcnIIY9JioeoChjTUOdo0hHPwgjltgKQwWlLlaQj
	dqjSjcF5yKFgC33TV/qTpSeUB9AZev/NU+nNw/h+/1nK6+qbQqsu5NWNLPp80cuV
	uZrL+Bmkrw26GrZ+dOy15mbyrqEhX4O/pF1FASs948EZ7uJxICYdlgKya2n93BJi
	9kSjeKlv4C11gpuRpnFi87rbwp+Vl4IXuERMUZSeP6uuel/dAPJkqTi7mWM08m1o
	sLNSMO505TzjU5DPM6TwEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772354999; x=
	1772441399; bh=ThONbf2YvMCzTHzmAfdVxkvA+DfWRkjecyYIwWwJ3Yw=; b=f
	y7hWOPfLjw2Sl+X9x4J7aYT50ZeNTZNsV0AnxPFk6gNXOcydkS0W7/ifdrKZq+LQ
	9lkKeWNTUcvxDpYGsTjEennUmKNurXJgH+/ZlR4Oa4rp/KkZGRcNgyrmkjlVAn+z
	HJKJ0hDZwYKbRfiDPCtMtASEzvrJ8KjewRltwSlY4K2ptc8u9p+VDm8j8j+snVxR
	nAPqvX9chpqnG2rMnTuvsAyWesQg/peYeRlzVDpvj+p6R4h9bU+ArHFG+W0kKQ2d
	L6VUZlK0Rk7V+cMKWPB9oiepvadVZp77WY1uSP4hM0h3wPYs0jTMA0USEJYAcsUU
	6dLVS23EPEU4OOSWNCXNA==
X-ME-Sender: <xms:t_2jaT556HoBM6I3oBYPaOFyLL2gpgrVzkaRfkwKSTF_11bUO0WqWw>
    <xme:t_2jaZQHIIVUN4Q5TmQFIb3oVioAgsQOvmUyLNYmwx6NuwvnF-TeFc6ESPSbqVpzH
    4GQplmpOQR4XnTrQ9CKjuU0YvFAm0aX_6DYZhso6TywHHIbM_OtGgo>
X-ME-Received: <xmr:t_2jabk_nEgAKof4Y-F4yawfrX_ZRyx2gGG1pFqb5ULrdyI7ZHTm8VZYgLKfDVIyVZsvxVjYO2j4Z2wzdxfFeOsQD_w1Zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheegfeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleet
    gefgfefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgt
    ohhmpdhnsggprhgtphhtthhopedvuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epshgrshhhrghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehprghttghhvghssehlihhsthhsrd
    hlihhnuhigrdguvghvpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovggtkhdquhhsrdhnvght
    pdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:t_2jaQIJJRatPxlvfb7k8RgZUPLyGsFmh1SbFAy6KIruTYr00D-7ww>
    <xmx:t_2jaWSm41h_PNu_xpmm5Z5cltgxQGL13u9EnZWgLV3ZnKAgLAaJyA>
    <xmx:t_2jaWRYVyctMLOSSJ7eZKmTEYRNZweZduWMUD9xginFhW84oI0yvw>
    <xmx:t_2jaQwY8LNCp1yyN1CO3fW6GT_Oow4DUt2014UhQ_VkEbwd6B6Mng>
    <xmx:t_2jafz7HpKkNSaEPcTfBRKgU0QTXSAfjmguPGTjyRnHCMIgfZLVfnX1>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 Mar 2026 03:49:57 -0500 (EST)
Message-ID: <9623f4e6-41b4-4dc8-a6ff-cf0de3604dfb@pobox.com>
Date: Sun, 1 Mar 2026 00:49:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/26 09:18, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Unfortunately, 6.19.6-rc1 won't even build for me:

Warning: drivers/gpu/drm/i915/intel_wakeref.h:156 expecting prototype for __intel_wakeref_put(). Prototype was for INTEL_WAKEREF_PUT_ASYNC() instead
1 warnings as errors
make[9]: *** [drivers/gpu/drm/i915/Makefile:449: drivers/gpu/drm/i915/intel_wakeref.hdrtest] Error 3
make[8]: *** [scripts/Makefile.build:546: drivers/gpu/drm/i915] Error 2
make[8]: *** Waiting for unfinished jobs....

This only happens with 6.19.6-rc1, not any of this weekend's other
stable rc's. (I'm still testing 6.12.75-rc1 and 6.18.16-rc1, but
they're doing well so far. I have successfully built 5.15.202-rc1
and 6.1.165-rc1 but I won't have a chance to do any further testing
of them before they're released.)

As soon as I can (in the next hour or two) I'll minimize my config
a little to shorten the compile time, then I'll start bisecting.
-- 
-Barry K. Nathan  <barryn@pobox.com>
