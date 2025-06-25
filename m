Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626DD20459A
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750853730; cv=none; b=PHWjwRjQQ/7wDepM7rPT2kljr0kHqp2aE1L13s8LgW38l7eKvVBR1DxEerqYx2c/wFZ7JsOIqkJ/TKYjsiIfk1v0oOIc0yQjobaZIT7FQiwtkXbJiGfomjqwbQ+GBfgY93lY/6YPYnmo0QdVdLb/PTZancis7yv0KCyff0UqNPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750853730; c=relaxed/simple;
	bh=30nOtmBlh3aA5ZF6uHRSVaCLZpCJBiyzVQGIhuSz7e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjf+wRJP4KIsvEawmyKqA4mZq04jW2T3J51FsnJtUnJ/fkywx1f4ywMbafmhSyA5RjWoDo+OpF93Pbb0PZWI0QaraokRlv5IfaHl9ohMRekwE3g/2BCnIxLy+n/+0ciD7ADUlLp8UpYnROY1xPKKNLdAF/5apWG3HRdaprmfspM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=GmkFJZ45; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L4P/yTBb; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="GmkFJZ45";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L4P/yTBb"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 06D587A01A2;
	Wed, 25 Jun 2025 08:15:27 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Wed, 25 Jun 2025 08:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1750853726;
	 x=1750940126; bh=o3GBtX60wx4Vf1WejvmFEtSL/L3MgcftL3fqrvCo7rw=; b=
	GmkFJZ45ilwhO3E31M+777jvMNsjhf+Z4wa22BubFTySBV0OQYV/4IDuAHxQpTyd
	2ie34HZ7VKDMne5aumyLjYEwv2XtFPR+JAI3S1+TMQqFi144xAIQfcDonKqcXwSm
	1NEQhNu4q5fY8ayJdZGAQ/wFVXx+9vYAIDmguMGJe9V0mk1tCtMva1JY8SkPbhCf
	WTP8tTpETqu5xWXpvTgQ2WKfIYFNQVhYs7x8VlUI9IDp1WR7UFk26Yjk9jwp4uE8
	4f/IqASq5AejtXFSqjyEFKy2Q0KdZBNFFz9+CjA1dGB12NU7P5qcmzJHzq8lc9W4
	kr0eueGWSsTf7nzmBUQLIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1750853726; x=
	1750940126; bh=o3GBtX60wx4Vf1WejvmFEtSL/L3MgcftL3fqrvCo7rw=; b=L
	4P/yTBb3a6APugNmTVULxjOeQuD4g832230VEZDJY1LQJpRXmu9mIWlAEVmWbmvC
	wjR9kVzCCyHpvSyatkbU5ZgXriqpWpchN5167oecgnqOoykyPu0U6cq0oeGQsgK8
	zVzeSa0XcRcWOCTYbhkVo26Msh7eLmH0zc99/m7X0WFA+d2rn7EUjrqxV0qqfwQS
	9yAuc4fJyS66fWfhKRd9hILypsMgKwPagziwX30nD/t9fr0LW10i3Pr5evmBTiog
	GlN5NPJ1I9B8SPheL1DO+MjTLtPYm21kyjFlpj8ykUSRqNIiSnQa7w+jHH4MniHX
	8Wz+jJ8JAGNB3Z2LR1ODA==
X-ME-Sender: <xms:XehbaEQ2dZ2I6hE87lLvn0WZfQrT-i7Jcgt0QeBEHe0lAEh0HQkFUw>
    <xme:XehbaBxPT6BeaEixTM4EmIY6zFyJJDBIl0zLXdN03u3m892l_ogNiwUgO8UOCVam_
    tAjCr43sUqU74uaZfI>
X-ME-Received: <xmr:XehbaB0vCLDaHUY1WHdgNcLWJV1Y_aMsP1Gv3-C3gS02ot-2D3QGYlalqeTJxsyUG8KLWGzi1MA9BxDZ_II_kNk_j_TrnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddvgddvvdejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepuddvtdelfeejffekgfekfeekgfekveelleehkeeuheetuedtvdevgeef
    ieejteeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsggrrhhrhihnsehpohgsohigrdgtohhmpdhnsggprhgtphhtthhopedvuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohephhholhhgvghrsegrphhplhhivgguqdgrshihnh
    gthhhrohhnhidrtghomhdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghv
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdr
    ohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtoheplhhinhhugiesrhhovggtkhdquhhsrdhnvghtpdhrtghpthhtohep
    shhhuhgrhheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:XehbaICJbyfKQTyhySsX82c90BohFvUYP6gKw-0cnqfe7OHoHyHiTw>
    <xmx:XehbaNhPSv40PdJqhW-jmEkwiLmFk1Dvglew3qiuwK4UIXp76Zi0SQ>
    <xmx:XehbaEqrZnWnDZCKkO3ovsOtG5p4QD2AmGYMSb1uAsJ5prlbUSZliQ>
    <xmx:XehbaAj8cMHXCkd2oKxmq3bzHRUYhyU1IKhcdcehtc7hOVCA-RqHtA>
    <xmx:XuhbaBHwPQWVJ5xuPKAAx3kdAT_MJ5kDtugb5j90Gre3QUiukdlDoTAI>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Jun 2025 08:15:22 -0400 (EDT)
Message-ID: <6d3b0f28-98cb-46dd-b971-8a11e3b69d68@pobox.com>
Date: Wed, 25 Jun 2025 05:15:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org,
 Christian Brauner <brauner@kernel.org>
References: <20250624121449.136416081@linuxfoundation.org>
 <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>
 <2025062511-tutor-judiciary-e3f9@gregkh>
 <b875b110-277d-f427-412c-b2cb6512fccc@applied-asynchrony.com>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <b875b110-277d-f427-412c-b2cb6512fccc@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/25 02:08, Holger Hoffstätte wrote:
> On 2025-06-25 10:25, Greg Kroah-Hartman wrote:
>> On Wed, Jun 25, 2025 at 10:00:56AM +0200, Holger Hoffstätte wrote:
>>> (cc: Christian Brauner>
>>>
>>> Since 6.15.4-rc1 I noticed that some KDE apps (kded6, kate (the text 
>>> editor))
>>> started going into a tailspin with 100% per-process CPU.
>>>
>>> The symptom is 100% reproducible: open a new file with kate, save 
>>> empty file,
>>> make changes, save, watch CPU go 100%. perf top shows copy_to_user 
>>> running wild.
>>>
>>> First I tried to reproduce on 6.15.3 - no problem, everything works 
>>> fine.
>>>
>>> After checking the list of patches for 6.15.4 I reverted the 
>>> anon_inode series
>>> (all 3 for the first attempt) and the problem is gone.
>>>
>>> Will try to reduce further & can gladly try additional fixes, but for 
>>> now
>>> I'd say these patches are not yet suitable for stable.
>>
>> Does this same issue also happen for you on 6.16-rc3?
> 
> Curiously it does *not* happen on 6.16-rc3, so that's good.
> I edited/saved several files and everything works as it should.
> 
> In 6.15.4-rc the problem occurs (as suspected) with:
> anon_inode-use-a-proper-mode-internally.patch aka cfd86ef7e8e7 upstream.
> 
> thanks
> Holger

For what it's worth, I can confirm this reproduces easily and 
consistently on Debian trixie's KDE (6.3.5), with either Wayland or X11. 
It reproduces with kernel 6.15.4-rc2, and with 
6.15.3+anon_inode-use-a-proper-mode-internally.patch, but not with 
vanilla 6.15.3 or with 6.16-rc3.

By the way, my test VM has both GNOME and KDE installed. If I boot one 
of the affected kernels and log into a GNOME session, I don't get any 
GNOME processes chewing up CPU the way that some of the KDE processes 
do. However, if I then start kate within the GNOME session and follow 
the steps to reproduce (create a new file, save it immediately, type a 
few characters, save again), kate still starts using 100% CPU.
-- 
-Barry K. Nathan  <barryn@pobox.com>
