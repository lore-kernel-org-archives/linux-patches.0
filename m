Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792795453;
	b=QM6zcUhD1CgQyBbjecjnpGxTU3uo5XvpcBC0W9uM4hxRmRG7vPSP4RISOzgrrD1Rgu7G
	 +cS1h5DdQGr39p/NOTARdSd3xETTDf791vZ0uFgaDEMeVDz9/vu2HrclICnWS6ngCmb3G
	 Rj5iTe+r5mmLk9I3BvTV5v5e7Vi1jYSNGEZSiwZImBnDQXRDym4pkpldGuF9eDUP6rLjI
	 XViirxRV0H7FmhZQ8GeuyJiPKMwTt5l1vWQDAzSCdif1JO3gDJmoOuL+lirCLDolE606k
	 wK15v2Iv1YdOk6sryjzyZU5LAz9AxOAJ9wSTxjeRGekziEc7u6iXf3thSWTkFQQ6Erg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792795453;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pJIrxg0Pdx42vikVs5ulMinCyovF6k2xYxAEXJBeRzg=;
	b=XV3h6xa9ERtcRhetZ2a4J4UzvHE8Bi9w62gN3ZLaSjsvr9BqdI0eb1wuXhE8l/skKw5z
	 IC4zx2Lbo35hmVwhW82eaWFk1z1HjRC/yadHxHKVqwg0zh/smRhWIsYgfoGRVSWi8nFht
	 qWfYnTFg2f9PiF6qLb0aD45InFj74Pbf9IaQAYOuRd7zCr7lJ/COpUqi3SVy2SB3M+MYQ
	 tITKmsNluf2q0iioreG8q4OL9/Zpni/UvGo1rF+PthCNCTQjyK6F++4Sgbspf6zpKJX9F
	 km0/q2JqPyOhwPPKIpRHz4nIWjo1Uc62WJ8PhkqBKDcVVMaDrjaMY0WUJ+xuVPEwhGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EBtI6o5w;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFAB606A31B
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 22:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FFAB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EBtI6o5w
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91c2fc03880so20332696d6.1
        for <patches@lists.linux.dev>; Fri, 23 Oct 2026 15:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792795452; x=1793400252; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pJIrxg0Pdx42vikVs5ulMinCyovF6k2xYxAEXJBeRzg=;
        b=EBtI6o5wV+Mihn95gs7xfZWjdJsbToPwRRbUrx0laNY+e0/TJqew2q4Ne4gqrSjpdE
         aJVQFids9gmR9/sloQSzxUsGwQZT3ukUJBHG1FXwF1a5NfdENUjGLxmuuVKeFavV+GwO
         /nJ6OLGULQvtYSGuu1SCZl/ry7SY+EqSaeeFzEvvg+VYXp9Ppmh6EaSn1z54PDFprRF/
         VCxT2PgCJhItZlvR4ScpRpadt1mmv3Qsux6aBtbufu0yCruWdQkOqks1AEAxyKh/KG0d
         QjtwKLIT+fhso77N15Dg7+RGZkLEuixk00Nf6RT6AK3fo7xCkDDquXvoHFX5ot6SdjGN
         /JaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792795452; x=1793400252;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJIrxg0Pdx42vikVs5ulMinCyovF6k2xYxAEXJBeRzg=;
        b=AoDTSLsIFlOKF2VxgDKFzLrJekXzEHGirzdGJcdAGhS01te9GEKzMOQHf8lHUeihCX
         Y/3mNqYUhJXv8UGqCEbkU0WcnVBdr4y0UEtsUqDG+0ROCg+rwqemg8vLj4FVGV6F8tdK
         wXSDd7n+V2c0Lz7e9/IPX+sP/Kqvqby33Sd4pb9r54Q+iUKvtSo2WPVM7RhNVHDInkT5
         QeBUn6lj2kQuV/d4VmPGi+7su0pw7kQumEEK94DBNQ5xBJfZnlyueh7EJZPqGb/G31Ed
         ew+b1uMa9ruIWXh8jVzuRZXFdPKVdk7TLVoiEKqcfNelUPuEYX+BeAaIJtPtVQfOfzMx
         lLyQ==
X-Gm-Message-State: AFq9FYL+q46xJzEoDVSnj+YxyZgQIyrkeCPZbBovlcocuF86y0fvDcqx
	qStOk7rMsSyL1g7f80TI+FXXnjTvCF8C3Dw6oj/6Jj3PlNuWM0QkZKVX
X-Gm-Gg: AYBFou3YzGG+dYIfOQJIQz359wjabuHhJXUhgOP1Di6rC6vkgNto3A2gazVe7mgDWhe
	ydaQKKDO/Wm5LsTFeJMMxAFuOT7Oetf0TmvF64dLKoLJob0jVABPzgdleKnYqX01F9qkzH7BQgI
	rnF0+eWr6WLXltU4tbvqzRR/EifLNmYJbOFUg4D6RuU/rt1q/xkdGxb1TQraltqKvJQVXV+6khI
	vQrFqgn8uTHJNPdfAdwFtDbXA3llx/fwcOzoNW/0wPmZKkQ6WSwMjuuzf0OuCiez6X336hCjwQI
	lVIfM3Nmc/uJiFFW3LCx4VdfvNqooBjZkuvCJB1M9qXH+mh/2QHVNbzro5dwhgCw+e7c/MN8X5b
	avNMjxKxrMzIuj1425balp+A9m3jLj4THJp6+kaX806yGEf+yy+wVW4KeN3FDxE9xNBekdHQQVq
	IiRngqqNhekENHPDERY22HJT+1A7LK5d4CrnI4YwEskWqh1O710Wkj2+jh8wv26PYw5zv6R60fV
	6H10vCcFFfiYI0DkVnViXlT51ScBihy5wTCQd/vOw1vi7Jj42HZ6Uicvsb4dqZyy77Zle8LO8Zx
	xh0k0N/+xcl0WRMxErEw1mjhcE8f
X-Received: by 2002:a05:6214:5193:b0:917:b8e0:6ca3 with SMTP id 6a1803df08f44-91c490092e0mr6953306d6.5.1792795452375;
        Fri, 23 Oct 2026 15:44:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm6300606d6.3.2026.10.23.15.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 15:44:11 -0700 (PDT)
Message-ID: <7540e723-054e-43a2-859d-616010fc7bea@gmail.com>
Date: Fri, 23 Oct 2026 15:44:07 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
To: Salvatore Bonaccorso <carnil@debian.org>,
 Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable # v4 . 9+" <stable@vger.kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261023163713.816071858@linuxfoundation.org>
 <atvHKoRHHjKV4l8A@duo.ucw.cz> <atvS68GhCvmAphrQ@eldamar.lan>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <atvS68GhCvmAphrQ@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/26 14:34, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Fri, Oct 23, 2026 at 10:44:26PM +0200, Pavel Machek wrote:
>> Hi!
>>
>>> This is the start of the stable review cycle for the 7.2.13 release.
>>> There are 242 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> Either something went very wrong with our testing, or this fails on
>> all our targets. 6.18.59-rc1 does not seem to have those widespread
>> failures.
>>
>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2982452623
>>
>> Example failure is:
>>
>> I'll look some more to try to figure out what is going on there.
>>
>> Best regards,
>>
>> 								Pavel
>>
>>
>> [    1.238864] Yama: becoming mindful.
>> L426[    1.238864] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
>> L427[    1.238864] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
>> L428[    1.238864] VFS: Finished mounting rootfs on nullfs
>> L431[    1.238864] BUG: kernel NULL pointer dereference, address: 000000000000002c
>> L436[    1.238864] #PF: supervisor write access in kernel mode
>> L437[    1.238864] #PF: error_code(0x0002) - not-present page
>> L438[    1.238864] PGD 0 P4D 0
>> L441[    1.238864] Oops: Oops: 0002 [#1] SMP PTI
>> L446[    1.238864] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G S                  7.2.13-rc1+ #1 PREEMPT(lazy)
>> L447[    1.238864] Tainted: [S]=CPU_OUT_OF_SPEC
>> L448[    1.238864] Hardware name: SIEMENS AG SIMATIC IPC227E/A5E42630598, BIOS V20.01.11 03/15/2018
>> L449[    1.238864] RIP: 0010:rest_init+0x33/0xd0
>> L450[    1.238864] Code: 34 ff ba 00 02 00 00 31 f6 48 c7 c7 70 a2 e6 b2 e8 52 d3 28 ff 89 c3 e8 bb 2d 34 ff 89 df 48 c7 c6 80 db 85 b3 e8 9d d7 2b ff <81> 48 2c 00 00 00 04 65 8b 15 63 6e 45 01 48 89 c7 89 d0 c1 ea 06
>> L451[    1.238864] RSP: 0000:ffffffffb3803ee0 EFLAGS: 00010246
>> L452[    1.238864] RAX: 0000000000000000 RBX: 00000000ffffffea RCX: 0000000000000000
>> L453[    1.238864] RDX: 0000000000000000 RSI: ffffffffffffffea RDI: ffffffffffffffea
>> L454[    1.238864] RBP: ffff8cf23ffed080 R08: ffffffffb385db88 R09: ffffffffb385db80
>> L455[    1.238864] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8cf23ffed0ab
>> L456[    1.238864] R13: 0000000000000000 R14: ffffffffb380c040 R15: 00000000b43e8000
>> L457[    1.238864] FS:  0000000000000000(0000) GS:ffff8cf287953000(0000) knlGS:0000000000000000
>> L458[    1.238864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> L459[    1.238864] CR2: 000000000000002c CR3: 000000000d630000 CR4: 00000000001006f0
>> L460[    1.238864] Call Trace:
>> L461[    1.238864]  <TASK>
>> L462[    1.238864]  start_kernel+0x7a2/0x7b0
>> L463[    1.238864]  x86_64_start_reservations+0x24/0x30
>> L464[    1.238864]  x86_64_start_kernel+0xcd/0xd0
>> L465[    1.238864]  common_startup_64+0x13e/0x158
>> L466[    1.238864]  </TASK>
>> L467[    1.238864] Modules linked in:
>> L468[    1.238864] CR2: 000000000000002c
>> L469[    1.238864] ---[ end trace 0000000000000000 ]---
>> L470[    1.238864] RIP: 0010:rest_init+0x33/0xd0
> 
> Same here indepently, but not yet bisected.

Same here as well, bisected down to: a0c935bd1f76 ("fs: add umh argument 
to struct kernel_clone_args"), it looks like we need to cherry-pick 
14adbd5341aa ("fs: stop sharing fs_struct between init_task and pid 1"), 
with that I can boot a kernel.

[    0.050862] VFS: Finished mounting rootfs on nullfs
[    0.056357] Unable to handle kernel NULL pointer dereference at 
virtual address 000000000000002c
[    0.065711] Mem abort info:
[    0.068679]   ESR = 0x0000000096000004
[    0.072657]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.078323]   SET = 0, FnV = 0
[    0.081587]   EA = 0, S1PTW = 0
[    0.084930]   FSC = 0x04: level 0 translation fault
[    0.090117] Data abort info:
[    0.093189]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    0.099019]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.104380]   GCS = 0, Overlay = 0, DirtyBit = 0
[    0.109297] [000000000000002c] user address but active_mm is swapper
[    0.116061] Internal error: Oops: 0000000096000004 [#1]  SMP
[    0.122056] Modules linked in:
[    0.125308] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 
7.2.13-rc1-gd1c66ab3e3bd #2 PREEMPTLAZY
[    0.135124] Hardware name: BCM97268SV (DT)
[    0.139473] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[    0.146859] pc : rest_init+0x4c/0xf0
[    0.150659] lr : rest_init+0x4c/0xf0
[    0.154461] sp : ffff800083133e30
[    0.157982] x29: ffff800083133e30 x28: 0000000000000000 x27: 
0000000000000000
[    0.165565] x26: ffff00001a5e2e40 x25: 0000000000000000 x24: 
ffff800080fc0000
[    0.173157] x23: ffff800083137a00 x22: ffff800083140e40 x21: 
ffff00001a5d1700
[    0.180774] x20: 00000000ffffffea x19: ffff80008314f300 x18: 
0000000000000006
[    0.188374] x17: 0000000000001000 x16: 0000000000000000 x15: 
000000000000cfff
[    0.195966] x14: ffffffffffff8000 x13: 0000000000000000 x12: 
ffff8000832fed50
[    0.203548] x11: 0000000000000040 x10: ffff80008314f308 x9 : 
ffff80008314f300
[    0.211165] x8 : 0000000000000000 x7 : 000000004308a007 x6 : 
0000000000000000
[    0.218757] x5 : ffff800083276900 x4 : ffff800083133cb8 x3 : 
0000000000000000
[    0.226356] x2 : 0000000000000000 x1 : ffffffffffffffea x0 : 
0000000000000000
[    0.233914] Call trace:
[    0.236505]  rest_init+0x4c/0xf0 (P)
[    0.240302]  start_kernel+0x6dc/0x810
[    0.244204]  __primary_switched+0x88/0x98
[    0.248449] Code: 910c0273 aa1303e1 2a1403e0 97c30fa2 (b9402c04)
[    0.254926] ---[ end trace 0000000000000000 ]---
[    0.259849] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.266980] ---[ end Kernel panic - not syncing: Attempted to kill 
the idle task! ]---
-- 
Florian
