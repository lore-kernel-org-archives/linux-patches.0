Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952FE5C613
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 01:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776735557; cv=none; b=PxUojPl+zMvTkbBRPGYmIdOCzph9lXamJr88eQaN+2hize037BiyVzq17FR7iflXa2y/R1Vaw6QsTUEBxMrF2kBv4AZs0bvsm651As+Jv9ZkkNxlSfrHyB4+w9hLflmH42iq/6lCpXOubi/HUs0PKY5+/QObKFCJ00ND0sV73Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776735557; c=relaxed/simple;
	bh=u9xQ+bpNIHcevNXiT7b7wjsEEmiaBfxWTIwHp2CAxiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AVSPTmt1K4vQQg8TpVrhw3R5KBjyupuV/323urpBU6Gl39fi7Yl1rqaqVySGHSiyvo013LIXuAPc71o7ifPqGIKnV91Ry7G7NFRXGiDXAmtCGboITp7LpwAzT6V6zScC/t3h3ib7vQQ39jRL65w/sjgWv3nMRy9K1G1nKTurZkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=oTZ0Tzag; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GQQCOd4a; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="oTZ0Tzag";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GQQCOd4a"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D394E1400151;
	Mon, 20 Apr 2026 21:39:13 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Mon, 20 Apr 2026 21:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776735553;
	 x=1776821953; bh=4EPMUerUOgXaVf1LZV4LV4cb+nNOHeQUpzdQ6HHApOk=; b=
	oTZ0TzagyjAc3UVcqaKjqb65ZgI8wOCUuS+ShF0qYFvR3X01j8zz3zJoKuLrPjda
	1UZaYDcty0QL/tRaurZdB8osOG5Qe2jWTZqgo0o7ZWGSndNHNzasT2HcdWspMTWm
	LAOcoWvq+AuLEpMZCMxXJLzb0BloSm6yR4yuKFdI7bVUp1telOIOkR7d0pjllzvV
	lj3d/Rf+GgN7HjM0p6IjpBaEekQ+joZvqxkWo9nicw9Jmd7ZNGRv2SF++gUIB4Dr
	kE8JKJr9NZcusfdDwL4DjPpu81vBVtrpb+72P24PD3joLG2cfinnHQ8ADoswYX8I
	x9P4zyY3/H0s/sMW9URkrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776735553; x=
	1776821953; bh=4EPMUerUOgXaVf1LZV4LV4cb+nNOHeQUpzdQ6HHApOk=; b=G
	QQCOd4a8INO1iA5Ocw9jRYf8qFFwc0ZbtPEM46tcGrh5jrXJnY4Zytd/1ga2o7nH
	Dlo87wugzkcBINzof1HJIdapQfN0oxisSfPctCKidBBnfwoWzOIh5BwoCxNQv//a
	cKwXVokehJpX3icYs36JKw78Btd7KnI5Al1pIUOO9e1REDBJXzyuPBVWQYQ/n90e
	3jwXcZBmQUDOcuqHZ6Xz/ISQxiihwW51JVJDZKo/DHsDOEYAwjjwsmB7PVMItlR0
	+vO81vPLVVWFwMashEaKMRMBUlLImUMvJNqo7CxoLzrKIitMt5xopSYeHzBybCsC
	xkh3EKLrfgqbTsj5WqxMg==
X-ME-Sender: <xms:QNXmaQX_Ihnlwln5RUxm1l619q160t1yewwTgHYtsngt-ErbGtiq7A>
    <xme:QNXmaQdipG87ti4obO6iE5eU87q0eR-z9W-oSJjaeBbOI4iwoSPQE3z2w2HEXhT33
    WfzsBzeWJ5bG0dKr-lK5GiO0diviavYGmD44qbijmes_4kbe5jUmw>
X-ME-Received: <xmr:QNXmaf7tl7JOaDI99ccOv0kCuswcjSkQ0QtFU7BaRpjYamoj7Bbx6rLI78r4xLI5j2JC7mBVI5lWQJu9BzeGJkSf5lZ0DhbM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeitddutdcutefuodetggdotefrod
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
X-ME-Proxy: <xmx:QNXmaTRzHYhET9YgqiesMmG1HjcdPTWWtXj89ZkgtHO4npruyklG6A>
    <xmx:QNXmaSd-ZjH8_FifijKSsFndndqAKLzr9OW3e_T_nD2WA3msUl5WeA>
    <xmx:QNXmaTRXSvy-OmjasoibPfvzaRMdMFkqJy5iCzp5F9eXpBOpVpFZCQ>
    <xmx:QNXmabP6ubsbpjqA6he7MYiclknzmzlFT5GKvTlPn1fsnkpZywdpxA>
    <xmx:QdXmaUr8k4yIdHyLfvbSHS28CJfXtRTD6NgWOQs8skPC0VGYc8QBzZLI>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Apr 2026 21:39:10 -0400 (EDT)
Message-ID: <e12f2b89-753f-466d-8157-587f1e0b83be@pobox.com>
Date: Mon, 20 Apr 2026 18:39:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153927.006696811@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 6.12.83-rc1 with clockevents-prevent-timer-interrupt-starvation.patch
reverted (since it has been reverted in the stable-queue) on an amd64
laptop (Lenovo ThinkPad T14 Gen 1). Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>
-- 
-Barry K. Nathan  <barryn@pobox.com>
