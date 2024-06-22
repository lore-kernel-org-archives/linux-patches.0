Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE31A25632;
	Sat, 22 Jun 2024 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719071404; cv=none; b=oTufNrARiFTmZDRVYd3sPk2kl6FKcNqGKvTANZ7wk9by/5qPb4TGRTxYkjZ1Dx+o5PGT0nocIkp2JSeJJQHW76IfVZziqll164LSJgT52sUUZsMa0EcpIz0Qvu6dd03VBFXxBYtVFOg6Vaj6RHdmfWYjHblYOwreBFtt3ze70LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719071404; c=relaxed/simple;
	bh=PiaqyW9zCw3IuWMgFtwudi7RiWa4VrwoYcA8W8NA8PI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Agd3+u5vkSl2jnAsOqEfG0+X3s4PZmtZii/u92rcqleFe3Lyp7JPGjnnGw7f049Op/L7tAwqM5Mlc7rXfm+yROeQnyEueyT+Jrtx4avVTXMm+PnI5NUDPhXNnXrNwa1KEsgEH7sYSQV1u8aLhtgvPR2SYFFFmgLp0YNXD9TQPng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=ScS+b4sg; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="ScS+b4sg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1719071371; x=1719676171; i=deller@gmx.de;
	bh=PiaqyW9zCw3IuWMgFtwudi7RiWa4VrwoYcA8W8NA8PI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ScS+b4sgDitUUwPKQJB6OoObzABhAsdgQ2ksC7sJrTCDlL/DTtfUHSQRvzs99HUU
	 ZkatpHJSiXGdXUa/pVjGFFQRx6uGS2wDMMirqEDA9LF3PTyj+2jIcN/hU0oU2rEHW
	 Pn3YkRoKrZZxhIcDTtE4hdaJRc5IgMzeFOYKv1QLWpfZ5oyZ3/UTeZ0kK4XGHXgp+
	 UQufWXtTtFYOvU8yEGy0srU3JNe+02/KUSD8Bam7veB8b9UbBezoGyP7XwGqKExwB
	 Tsk7CJ/8sJFkZBa+jOUjmAH1/kDthBWYrswcqSFOPqDV9tIUeLl/ePe0jklh3+C4z
	 r8JCQbs/+DpJ1gBGMg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([109.250.63.133]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFbVu-1s8MDs3XJu-000CVO; Sat, 22
 Jun 2024 17:49:30 +0200
Message-ID: <48aa5db8-2605-42e3-a1e3-1bf3428380ee@gmx.de>
Date: Sat, 22 Jun 2024 17:49:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review [parisc64/C3700 boot
 failures]
To: Guenter Roeck <linux@roeck-us.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org, Oleg Nesterov <oleg@redhat.com>,
 linux-parisc@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240619125556.491243678@linuxfoundation.org>
 <614d86a1-72c4-489b-94f9-fbe553c25f28@roeck-us.net>
 <21d5c00f-a373-4173-84e5-33dbd6305b57@gmx.de>
 <2760c168-974b-41da-9f1c-171a07bb60fb@roeck-us.net>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <2760c168-974b-41da-9f1c-171a07bb60fb@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GZB47vhf+aJuVWZIF2Jh/JUss/bD2HbyXNGPXz83C8JY3LEIwhl
 H3g4r3jA7XIptdoErvDc/sNBZcK713sU3eLmWKyQoUtyG8XKyHgIdhJl7LVHFU7Onl7vOGK
 fhBH+SV291fB/r0pYB1yCWONOy+ZEJg4VtKk8to4PDFaq8CTwz/AgOlDAwCzpnGeXR4Gw0K
 i1qGzPT3wpkWWctkT2J7Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JDngWE3DQ9c=;P6I8LsHGqZ0+2tBFw1gcoOaA9IW
 halOAq1f7Cd1rXrTYgH9LcJpEP0nSjZw5qVXK9sF1I3tB+NaayUEY6TPgdD4Q1IbagSwm7DYk
 DrjzhpkHjeyxk+2fHleMFY6KR5csOOxlqLLKORB61WcaHpokM574mxOCCcLyEA4AQ0rj9larT
 wn7AA02pJIfdMltsE6NJJITuT7zqKxoVjoWB7hFxBlxOktrX/cJn+jOQnanjFL1Xx0wwj12uK
 ZaOqj5fkJURnGjtkJ59uLgJl5IDvcyvSNiP3wLFmhdiK7elRJtMW+sxwnpXsfLhTYl/XWEUSa
 f7qUAd7cbR2cJ1nmU5HvXR6zo4MAItEBTO5mkBgI3TPxFgs12P3ij5eB+GXDeLjbyu4HGH6ii
 qrSw4NkD1WDmf01LhHwS76Y5K38KuoFItteO3jF5RuuNpS0I7NbN3X+mku2GEOeXNz/urEKPX
 hvEIwLx4QgzdM5xn2qqAoSgCXoFUpoH5LxtBMe/el7xkOKLhDXUYd0rcVmjW7qVAkRyaov0pL
 NCphSfoUHh2WILzUOU7InWoWM0TH9U0tawEdXB5L9jvQOxbmPX55cq6EdGzelzbbv77rxJwCp
 2o2RQZ7NFCYdj7TgFnETvz2xfyHPqLqP8iqIKuReHt5weakOrsPfDjCRaDylMxayqqo/eLr7z
 q6V9iNDGI5ObtGlUPS9lboEyP87I1eIA13Kceb9bqGqNf+pSz9eunYYyty79fukasK4cXvjqo
 1+U/ArUyZsQ4DmF5C9NG5ecEYeYgQX8OnpsZzEqKwwiJGj7ymE/vSNN26JvGhVUVNL4MoqtBI
 1OEyH6PfB+/9+rTvAEi4MGx19YGKzzivl6q3rYRKgBS0w=

On 6/22/24 17:34, Guenter Roeck wrote:
> On 6/22/24 08:13, Helge Deller wrote:
>> On 6/22/24 16:58, Guenter Roeck wrote:
>>> [ Copying parisc maintainers - maybe they can test on real hardware ]
>>>
>>> On 6/19/24 05:54, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.1.95 release.
>>>> There are 217 patches in this series, all will be posted as a respons=
e
>>>> to this one.=C2=A0 If anyone has any issues with these being applied,=
 please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>> ...
>>>> Oleg Nesterov <oleg@redhat.com>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 zap_pid_ns_processes: clear TIF_NOTIFY_SIGNA=
L along with TIF_SIGPENDING
>>>>
>>>
>>> I can not explain it, but this patch causes all my parisc64 (C3700)
>>> boot tests to crash. There are lots of memory corruption BUGs such as
>>>
>>> [=C2=A0=C2=A0=C2=A0 0.000000] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> [=C2=A0=C2=A0=C2=A0 0.000000] BUG kmalloc-96 (Not tainted): Padding ov=
erwritten. 0x0000000043411dd0-0x0000000043411f5f @offset=3D3536
>>>
>>> ultimately followed by
>>>
>>> [=C2=A0=C2=A0=C2=A0 0.462562] Unaligned handler failed, ret =3D -14
>>> ...
>>> [=C2=A0=C2=A0=C2=A0 0.469160]=C2=A0 IAOQ[0]: idr_alloc_cyclic+0x48/0x1=
18
>>> [=C2=A0=C2=A0=C2=A0 0.469372]=C2=A0 IAOQ[1]: idr_alloc_cyclic+0x54/0x1=
18
>>> [=C2=A0=C2=A0=C2=A0 0.469548]=C2=A0 RP(r2): __kernfs_new_node.constpro=
p.0+0x160/0x420
>>> [=C2=A0=C2=A0=C2=A0 0.469782] Backtrace:
>>> [=C2=A0=C2=A0=C2=A0 0.469928]=C2=A0 [<00000000404af108>] __kernfs_new_=
node.constprop.0+0x160/0x420
>>> [=C2=A0=C2=A0=C2=A0 0.470285]=C2=A0 [<00000000404b0cac>] kernfs_new_no=
de+0xbc/0x118
>>> [=C2=A0=C2=A0=C2=A0 0.470523]=C2=A0 [<00000000404b158c>] kernfs_create=
_empty_dir+0x54/0xf0
>>> [=C2=A0=C2=A0=C2=A0 0.470756]=C2=A0 [<00000000404b665c>] sysfs_create_=
mount_point+0x4c/0xb0
>>> [=C2=A0=C2=A0=C2=A0 0.470996]=C2=A0 [<00000000401181cc>] cgroup_init+0=
x5b4/0x738
>>> [=C2=A0=C2=A0=C2=A0 0.471213]=C2=A0 [<0000000040102220>] start_kernel+=
0x1238/0x1308
>>> [=C2=A0=C2=A0=C2=A0 0.471429]=C2=A0 [<0000000040107c90>] start_parisc+=
0x188/0x1d0
>>> ...
>>> [=C2=A0=C2=A0=C2=A0 0.474956] Kernel panic - not syncing: Attempted to=
 kill the idle task!
>>> SeaBIOS wants SYSTEM RESET.
>>>
>>> This is with qemu v9.0.1.
>>
>> Just to be sure, did you tested the same kernel on physical hardware as=
 well?
>>
>
> No, I don't have hardware. I only have qemu. That is why I copied you an=
d
> the parisc mailing list.

Yes, sorry, I saw your top line in the mail after I already sent my reply.=
...

> I would hope that someone can either confirm that
> this is a real problem or that it is qemu related. If it is qemu related=
,
> I'll just stop testing c3700 64-bit support with qemu on v6.1.y and othe=
r
> branches if/when the problem shows up there as well.

I just booted 6.1.95 successfully in qemu and on my physical C3700 machine=
.
I assume the problem can be reproduced with your .config ?
Please send it to me off-list, then I can try again.

I know there are still some issues with the 64-bit hppa emulation in qemu,
which are quite hard for me to trigger and to find the cause.
So, maybe you now found one easier-to-trigger reproducer? :-)

Helge

>> Please note, that 64-bit hppa (C3700) support in qemu was just recently=
 added
>> and is still considered experimental.
>> So, maybe it's not a bug in the source, but in qemu...?!?
>>
>
> Sure, that is possible, though it is a bit unusual that it is only seen
> in 6.1.95 and not in any other branches or releases.
>
> In summary, please see this report as "This is a problem seen in qemu.
> It may or may not be seen on real hardware". Maybe I should add this as =
a
> common disclaimer to all my reports to avoid misunderstandings.
>
> Thanks,
> Guenter
>

