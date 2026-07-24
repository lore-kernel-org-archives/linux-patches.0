Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1467741A933
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784885118; cv=none; b=TWkHheKAPk0i+4wi7rZ4jXQq6UaCaebl2ec4DVKAiQL6yBJb1SJO77rPIU8TEt1NIjgClhQcF2N6ruFGLxViJtlyX4Oqu9Njg6zYMHfXCb/R5PVnOkMlOkzBy4z035mHItPdC8sMk8IK0wbulnwHpSEHvpyiQ2HCaSEu0sEX8JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784885118; c=relaxed/simple;
	bh=n1CXGu6AR68rlNziURIsrmRR616pHWU1tV6eG0EtBVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YhOf7e/PRxURnomyTyC6B5D7HTq3UtQF/ABwpX9Lmduub85KtOW9A72MFAMPtT9mQs/sudAWjAGYDJILrCn2Ox/uCamBYoPoNgQarcWMiA3qyoMK3XUPuE4e9SA/DWyvXX/pyDYvZ0DwQ+5dxOs6khHrLXzu83SMOyEUY72SssA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=R72BkOW1; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="R72BkOW1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1784885107; x=1785489907; i=frank.scheiner@web.de;
	bh=M6ss/Fcipi2+JGl2WWyZG191S+MUkc6TAZfcory6DBc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=R72BkOW1RrcIdr6AYJJh9o1C/pxWiL0aIK4yUMDg0LqOwhA0CNq9N6xSrWp4PJ4q
	 7ycxqalLGCR0p8jGhHlxfZNhSN39dYjQ0lzXal55ZnpKnQzoE8jHur/TXnuJBfrGz
	 OrZxOx+Axk7X9geeMk7kLx0cR7rGojdPFRInRpT+pgBgCWbvazIWwep7ZH1yrEIqa
	 QjBudbUd/2uAF8xFU6QpsvA0+YM13l6s4Y6X6l3MjNrDw4x3U5ZmZ7o7kFRUhzVEZ
	 5JYDCCLW12IypYfy2mCbetfU4DspFxEluEbYgZgFk+VOzdUWEUIQGJFBGKucinxCn
	 uBNOysfJyQM/cohk+g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mae3q-1xOAbA3SkE-00ntOa; Fri, 24
 Jul 2026 11:25:06 +0200
Message-ID: <e4b59f50-f0b9-4e7f-b0a3-b4cf8cd4f1d3@web.de>
Date: Fri, 24 Jul 2026 11:25:04 +0200
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
 <1e9a0b1d-cc4f-4ac7-ac53-478580181c99@web.de>
 <2026072447-chloride-plug-638e@gregkh>
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <2026072447-chloride-plug-638e@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LNmmMr+nl/LmGbxJcfPxo/bFZaIeR4+7LHJYeNY73x9zlzmEuWi
 TpM2xjLJtgtUomwvd7nn9GYXwXNyCaS218CCxDpy/AtiqgYr8pUdbh9NnUka+a36Rj+5JhD
 MvH8VpFcGmxPIi52ylP/kv0zaeC+4FyfxqmA1v8p9b5vd/vtYfqfWjSTAWhsn3pVURr1gAZ
 01dUwedfdnjgP5sIM9RHQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:c3l3pyUqfJM=;TxoAF76Q5AXK4wiQ4+2lAD9BTde
 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

On 24.07.26 08:17, Greg Kroah-Hartman wrote:
> On Thu, Jul 23, 2026 at 02:21:28PM +0200, Frank Scheiner wrote:
>> [...]
>> Of course we are hobbyists, we're doing it for the fun of it. If you
>> want to learn more, please head over to:
>>
>> https://epic-linux.org/
>=20
> Cool, but what happens when these last kernels with support for the
> platform goes end-of-life?  While running things in emulators is fun,
> how will future userspace code that needs newer kernel features ever be
> possible?

Actually it is already possible:

Our autobuilder built and  builds all current stable kernel versions.
The post 6.6 ones with patches on top (see e.g. [1]), like for mainline.
The stable kernels are also run-tested with Ski, which only requires a
few extra patches post linux-4.19.y depending on version ([2]). Also we
follow glibc and make it "work" for us ([3]).

[1]: https://github.com/linux-ia64/linux-stable-rc/tree/__mirror/patches

[2]: https://github.com/linux-ia64/ski/tree/hp-sim-for-linux

[3]: https://github.com/linux-ia64/glibc-ia64/

I hope I can get qemu-system-ia64 working in GHA in the future, so we
can also run-test non-Ski kernels there.

Mainline is also tested weekly (most of the time) on real hardware
([4]). So stable kernels post 6.6 always start in a working state. I
believe I even tested the older ones at least once on real hardware,
too.

[4]: https://epic-linux.org/#!machines/

Cheers,
Frank

