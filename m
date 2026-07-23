Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA97442B3A
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784809342; cv=none; b=u/5vBS29OmDLoinLz/oBG0GpxVoFWM/DtHQyJhH8L+rtxyBc+fTROGZRzDUwKDd2P9AF73dHQpHKpXst07mJDTFd9FlNW8ssdJseq1qMrEmXSYv3V7fQJixgVKWAHY4PF3rC+AEv+jwvjHHKR6wB5UsotVyyWkPUIl94XODF3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784809342; c=relaxed/simple;
	bh=UUwSjKHsoJK9c7uPXAZBIrp8z0VQnIA1clza2wSu+i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ND/oyTgHrvAGKjy6mJw6va8DKmdRR3lKPP2B9u1Ai68L1cM3pbxtkbXa/fzJWQ935dGnNiuDPqz46zSipcXgr4/Mbkmn/FFPYxmt3j5DfUN1UGuk4MZa2Ucr2C6s3Yum+efIxpr1GaF+sSW2a4xOktMx0cpa4bkd2LqWBWoO4oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=RxnjUH+8; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="RxnjUH+8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1784809291; x=1785414091; i=frank.scheiner@web.de;
	bh=PRpEARvt7gvc2pJ3VXJ13KKsk9jzbVg8fsjkujvXhFY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RxnjUH+8XGFwUbUqGADSzgQX//gljPpfKvjEzR1DMcPtDCIbrEzn4pUO+ImS+Quc
	 vkNfUG/vwRnAwPCGwdqi7jua9GUomojyN+ewjZApDZUs/bZPDVPLddJR+Fge6PLa8
	 Azl1olqxXMepEKQiYzG9f0oUGbGQ2/ccYtBk9SrswMC/HyNzLFofE4AxPb1AxFwhg
	 Gd9t0agU1HzE08iSHgFLYYrE30CbGYjPvlkY2dcoLf+xiGNY+keFWCIiYDpVB6Zj8
	 d7+RO5Mj32Eijh8WM3Of8A+fBDTVhv6yw9xPxPomm6yw7iqHf+cIgR2PHSTdBTtLt
	 beRqRNy5ietgWLXyng==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N5CQT-1wxHqh3o97-00xyij; Thu, 23
 Jul 2026 14:21:31 +0200
Message-ID: <1e9a0b1d-cc4f-4ac7-ac53-478580181c99@web.de>
Date: Thu, 23 Jul 2026 14:21:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, cc@epic-linux.org
References: <20260722143258.264584003@linuxfoundation.org>
 <88255dcb-acac-4a74-a086-b686aaf15eca@web.de>
 <2026072333-creed-overbite-b2a9@gregkh>
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <2026072333-creed-overbite-b2a9@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZHIeogtpb/oNx6kxzP6y+ljCWASHVt01MhjKS5sj6muP+gaGFqx
 M4OCCqqOfH+2cCARLjEXWRSjUkCBbIeXM98uglo2NVcnwlyUUeoZ5vUpoyuMfc702fyC99C
 +gN9ZqWwY/rUgzHcrlxls8pTUbBKWRUM6YjTaYx0DTa/TSfSpQhLLT2l+scuL34fXZFT5Bg
 6Ragk8Q0ndysrNU+NRY0Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Or1xTBBkRtg=;b3pBDsxTY06uUvp0268jF0UbGNz
 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

On 23.07.26 09:46, Greg Kroah-Hartman wrote:
> On Wed, Jul 22, 2026 at 07:25:26PM +0200, Frank Scheiner wrote:
>> [...]
>> In our fork of Linux post v6.6 we carry a replay of b4b1ddc that makes
>> the corresponding changes also for ia64. This is available on [3] (and
>> also attached to this message) and fixes the build for me.
>>
>> [3]: https://github.com/linux-ia64/linux-ia64/commit/a4085ca68e49f49f96=
2ddff46a901ff3468574b8.patch
>>
>> Can this be included for linux-6.6.y, so it continues to build for
>> ia64 as is?
>=20
> Sure, I'll queue it up.

Thanks a lot. That should fix our builds.

> Does anyone still actually use ia64 anymore?  I
> thought those systems were long dead.

Dead, no, not at all, maybe left for dead before we took over in 2023.
But still there were always people taking care of it in the years before
- keeping it alive for us. Much obliged for that. And today things look
vastly different compared to 2023. Tomas already mentioned a few things,
but let me add a few more:

Today we have it all: distributions that support ia64 (T2, EPIC Slack,
Afterglow), hardware and simulator support restored, software support
restored (e.g. Ruby, compilers and more, other things maybe only a
session with an LLM away), Tomas doing all sorts of optimization work
that wasn't done in years, other devs bringing in patches for various
bits of the ecosystem. And just recently out of nowhere ia64 emulators
popped up, one of it being QEMU based ([1]), currently emulating an
Itanium 2 system, with MP support and already working well enough for
MP package builds. There is now even another emulator that tries to
recreate a Merced based system ([2]).

[1]: https://github.com/syunnPC/qemu-system-ia64/

[2]: https://github.com/hotlandsoftware/gemu/

Please excuse my optimism here, but emulators with MP support will
bring in a lot more people, the scarce hardware failed to bring in so
far.

Of course we are hobbyists, we're doing it for the fun of it. If you
want to learn more, please head over to:

https://epic-linux.org/

Cheers,
Frank


