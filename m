Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDA03BBCE;
	Wed, 17 Jul 2024 09:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721208906; cv=none; b=YK/gYibn+qn+v2ARjB1wzt+ru7/CKB6GQozF1rpm5rM3P531cp2knXaxClZhqZiJKBdWQr6WJpdeLX1wS6BOPmOModMhdcjgHhmCFi5WA3tEHzAlpFvZBqf4GfOT+rU0Gq47X3pElwqTEtKcp9nfa3gyQ4KJ3QMnOwm/eozp6yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721208906; c=relaxed/simple;
	bh=CZnUbOaUwzx/0gXeJAh/4PVi/RA9aD0FMDoYABbCM4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NpnI287AW8LsX2X+3yG9dBRU6o5hBjGfK3nd60sxjkE8Hl6Q8InD3hvObgll25MmKypAEfvRlCSfZFn0TfeMNBwm04SjBNof1rDsUri5+k5qeheV0Rnx14KftiXy1SDkcB7MonEEvshdUUpL6XoEAzc6uaTuYmU0kwJwei0oLCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=kfKmGF5p; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="kfKmGF5p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1721208874; x=1721813674; i=frank.scheiner@web.de;
	bh=s2sSpNCYmt/O5DHa9VM0FTL/ofl6LuG2kphIafi/fTY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kfKmGF5p4OjoDv9+o9bUafd9UxnZQ6k9rHEV/GU0l9yhyAnazJuvHuPcQAnOwsMA
	 kXLniqMxBv+CmdI3BedFy77LvmfBIG9iEAUJIObCcr5t+ZaYNteg2jJlIWhYbNzwH
	 G4r/pvLe7PYsBYJnmlSPvVPs68F3CkFqxy5Gmcow9RQYRMLPwZsdPvaqgksakC21v
	 F5I1CCRqe5Ywod06cTCM1JlQ4YDcyP5jl1jQggdy/wlouxN24HLswX/O63acExFtG
	 sX/BgAjJhQq0cu67p+oJ4E7ADUaRU2NRgs0F1ff5aQhL5zD1xT1GiNrmlAueGpypc
	 mZT1XIMVbLO0Dylphg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([84.152.252.217]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MdwNW-1rt2PU1lv4-00fm6q; Wed, 17
 Jul 2024 11:34:34 +0200
Message-ID: <8bc5fd5c-e3ae-436a-94f9-8806841e34ad@web.de>
Date: Wed, 17 Jul 2024 11:34:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
 linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org, =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?=
 <tglozar@gmail.com>
References: <20240716152738.161055634@linuxfoundation.org>
 <01082e96-8c2e-4ebe-8030-6e308a03f9e5@web.de>
 <2024071700-precision-basin-0e6e@gregkh>
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <2024071700-precision-basin-0e6e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1D2GXMk7jklKJ7WG5adFz5K2pz1HPTWYHhYK3LCMzkGauDkkQK5
 ZOLaUOy8Y4Xu7uvVzJj/OonTQHYbWYFta98l5fh/GY70uB0eVORXEnsM0333Nv7ZaRxxRul
 zer6sV565/D7BoZl52E5izehSMrFIEG1r20ujZOOeKjmCA9od8zJAsFErd8outqiZ/EJfz5
 IrtPeO5/hbpGP2lxWcHQQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aA0xWoaPFAk=;vsRpJdfaWhch3xROWbcLlD1hZXH
 EmurSd0qfHQlx9hZuqQ9xv0QAWvTpWzdEbEyEVpFgBBd9h13W4ma4nAKYbLReRR8TFxrA0nA6
 MAwEmDyIXlT1cDoKUruXuz4rgU80RK2ALt+PVvV+k9Onh8X9r9wkeKZDqIxVdSh+xXc79YoR0
 OPIweFlqwbtlk/aXzoyd866tK7arGv7SVqXnt3k63KlKpBXW2Be7KsO65FZ9YRcSkNzT8VN/k
 6JbRksOJxrsfAjtZz0Pm98pVpZWvNHF8EO1wEFKpm3d0eNSIfm7mE2unP3imzTquOkkY+pNar
 7sg8VlyOZbn8Y7rZfb0kgOXdFUbomJlmvtTOs1pDv50/pFeclFEwj9+ErluEC4bDGM+U1JnbQ
 KE545oKQhF5qpM0VaoMf1yEyEhPcThRryXbBiWF6Tj+5Z6DLLx45e1b0oUNz1cnwpw/RAV3+5
 HwNQ9EQM2xVtM8xgxV/Pg+ZmQc8tnl7cpbOEqLn9EMjh0MgfV9CMm/YHZMJYfdHL6lzcQzVna
 uCorB7Df4NsjUH69mul+Illlu0RWqOXHym3BXmAE5jhgSHXdohvfoVMA/rAmW63ppLn+rYFtU
 NR+fhXC8gKvFzRHaAOUXM503ePyqopwbLjUiXEAv/py7Trv/NUyJFlMzEwjv4AP4xBpUntGfv
 vwgEMxiosSC1d4rynZhpfp0lboJCKiqoT/lBEE+I/NebMeZtvNKgXZVmgdDJ4vmUt9b3V97ZS
 H1vSh0rXue82Fmwcuiziq6gO5KaEs1XLty3Ye2R3X/duCVK1C1Nqtk6iOPf09KbWDLTPUxTCh
 6riMpHWJHtjoxLsYbkiU4vk2DwZR2pDu/wyq5jVt6Wfx8=

On 17.07.24 11:30, Greg KH wrote:
> On Wed, Jul 17, 2024 at 10:54:40AM +0200, Frank Scheiner wrote:
>> fb3739759474d150a9927b920a80ea2afb4c2a51 (from mainline) should be
>> included in linux-4.19.y, if a589979f345720aca32ff43a2ccaa16a70871b9e
>> stays in.
>
> I do not know what commit a589979f345720aca32ff43a2ccaa16a70871b9e is,
> sorry.  If you rea referring to commits in the -rc tree, please don't as
> that tree is rebased and regenerated all the time.  In fact, my scripts
> don't even save a local copy when they are generated so I have no idea
> how to find this :(

I see. Makes sense.

> Please refer to the commit id in Linus's tree so I have a hint as to
> what is happening here.

Ok, will do in the future.

>> ****
>>
>> ## Long version ##
>>
>> It looks like:
>>
>> ```
>> hpet: Support 32-bit userspace
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/commit/?h=3Dlinux-4.19.y&id=3Da589979f345720aca32ff43a2ccaa16a70871b9e
>> ```
>
> Ah, you mean commit 4e60131d0d36 ("hpet: Support 32-bit userspace"),
> right?

Exactly.

> [...]
>> So fb3739759474d150a9927b920a80ea2afb4c2a51 should be included in
>> linux-4.19.y, too, if a589979f345720aca32ff43a2ccaa16a70871b9e stays in=
.
>
> Ok, I'll queue this one up as well, hopefully nothing else breaks...

+1

Cheers,
Frank
