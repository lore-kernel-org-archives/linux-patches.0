Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058591;
	b=lzk4HHGEsEIURARgw1qIjbeLPuQLgsFyYsvhKTXICvosjTuK4DxIC5ocZDoTXgfvbnlq
	 2Aq/3HcitC2rhCJEvsZD7OCXr+YRjiAXthUi6DUbzLbkp0vYtgW8Wu2ghNRjOm8AVexiv
	 cPotqsHknuZbMoSg/IQIvALfV8nlr19ssJQ3ahG9xXhNDYiIsmR/qRGFPGD7gocYKyqgr
	 24OVa4FTEq5w4tuNlg8a4SXVFwUuP0fe8fYEOKzG+L3fSEWADabzt3f/TJ+GYSHMFVRAx
	 KuzTAN3g8tCbERBEZpetU+TEljDTDO/RbOtEc9s80e0LgXJgNBOjzWdWNPoAXKvygig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058591;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Mime-Version:Content-Transfer-Encoding:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:References:
	 In-Reply-To;
	bh=1gCemJ+OoIUXvLmdwnpvyyQkDg9ytHfxR6YyKzs9Mfc=;
	b=meTH/qZMRVN5wnXGqA1ayWkeO+R48qdE5kzft9vJFt6Lr2KheSsDcUmHFvxrdwrTrOgR
	 7CZtOruJEYlmdq5epZLtwQ2CpK/MXK4yhkAlzM7K7nbHK8oo2qjZxW921G8stFM0dQnXg
	 rkXsODCl2herkVB6/jc9orQBHwtMBRFuZi8YX9yfmWNIsI52phGGKrs+LIVLPQl8Gkcq6
	 hvdkhkvRcWdnzj6d6Oml/VHH3GNZmT+oOAObhvjfQQ5Umm/VFTlJCIzRWUP9/rclFhbiI
	 RfWU/uStiXBvB+WC80dR0wN1c068uTHWqnzuVwV1FPTTklmWdz3a60UWt5/R5I08GYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCA2606A32F
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCCA2606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0F9643F4C1
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795058589;
	bh=1gCemJ+OoIUXvLmdwnpvyyQkDg9ytHfxR6YyKzs9Mfc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To;
	b=FkNpLKTVaJZoNZ0vDRmBq00qsolc2tWt0NLFMupCdKA60Qt/ovgX7bHF3DYm+h/ZX
	 Z32Xt8QM033eJybDBEfUp2KIgZDy+LJhbH8l40mymF6O3lzMy5cDtdQJl0zlwJRFjD
	 ledP4PVS2avu8B4jLBHKbGt4ymP1jg2fSl3627wDEJXgAMPN7U9yX/be+PAs/t1OWK
	 dVb0itKpHfdwif6hAbzADWNo/FexnvtmSAH8xgUyA3+RUFn/2/EffnLYBOQNunejR5
	 sQdXN/IXl5HHsvxSf+O6nJbjikEd1UQiEBcWlZuh2kx3b2S0ENMo9EuHn2LcYo+Bvs
	 JxPvvb9pi3iQuHMamZshzlxIfQFk4IabgwoKi8y1iiYD0EYD0R3HMwrZVwHgUIV1YJ
	 4p7BchvdUgaHKOyUIu7JmbM+CuLwsH16wD6h1iyoNg6HfpApXRzAJD7hAofZmDplOh
	 0Bl/yGod4YKUc6mM7zVJlhQqlqMQnaco7cLZxIc79uX5R3FlIXUL4MzRCrdxB+rMLj
	 2sGpnkT8EgqfY4qLGB3qlsSiZzNUcWHht9/dB8ICo1s5hfOziMR5j8Zg/LFFlbqrZy
	 sSFTxj4XXm/kO9WrWh17CHgTBknVgIo8cjZd0YleHBrnOwyZxwtHOYb+QI6EEHhYop
	 WeRVA/a2SsoVx+VA4Ab8I3i0=
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9212335e257so13988296d6.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:23:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795058588; x=1795663388;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1gCemJ+OoIUXvLmdwnpvyyQkDg9ytHfxR6YyKzs9Mfc=;
        b=FS6PwTSlVMRfg1FADd9Jx2zGn5UeYWG+3YD9kXrK9rGDg+OZNLQKBnUNydxJcHxUDZ
         dlzzCRh2wz0KA6wVqOb/9oGywSUQkzby6R+veHPLBMRIqQn/JMQbNEpiSoYzAW8vXSr8
         4xshk0gET9tW47GECRtxJOvotueMHBOS8k/O+QcPKJcL9uoA/pDrOJqYFC5R8CKA+ARr
         6jXYzTIAefHUoIfd4Y0Y0+KY19e9oz+mLycfVspEWk/rtAUOmDapw9tVn2A+DPGdHKKm
         pf0jvYha920mVvuZFp08BTVqXWXco5g/S+iiob+S88iF/m/MniP6IddBdNcdG2z/QajO
         LEvw==
X-Gm-Message-State: APuU4Z8CrFDX1271Uv6HmzxFQmpbwZFqcjsgjmdFbkRBu38qP0gkqZ1y
	MbETY0OXr4g2+2//oTQj6VbGXMNk3qORk2GpO94iMb3Qyk3E1gkKwlLdY2guU5SjhEQIkyN7O5a
	ioSYCnl8NGLZjCggp+pEdCPZg3xpbgwyGmrTDoXOhB0mefohFoUWnIlmemp65miZf4MA+Nnguzd
	A=
X-Gm-Gg: AZFdTZfXNsgJYg7bRg4/4ZkuL/oD/TFl85t7rM1LebE0WfuQ61Zz3U6Ml6aDf17AuSz
	GciEbyGvaWz/Yn3Exe/FFkd6VuH07zg7WP3/aMZN5BUjreAlr1JLNtoZ/dDN8DSHZAYQ4odI/uB
	G4a+1Fcc93yi3PuKFzHqiPNF4od9XjCqmhLZayjLXYTCPOtEN7WxWU3A0PVTyhh6trkbny2saB+
	Fu6rQFmpDGKun3kx6lpfK9XAadYTM4UXnTSiAgckU80aV+maDIARudRwhd7snsQ+VLtr+GuY+go
	8GxguW1TlwW8qeCv5qcKfC0O1zTMhuJ/mTUAAVo7pHXFdU1tefAFS9xLJ2S/h5e8L5imqOh6X61
	I0zgVLgyry0Ky/AbyO+jQCtDeVuo05BZNrSlLo3um++77f/E640UkephROOd2RA==
X-Received: by 2002:a05:6214:4886:b0:921:2b3f:95e5 with SMTP id 6a1803df08f44-9212b3f9742mr4788986d6.24.1795058587638;
        Wed, 18 Nov 2026 19:23:07 -0800 (PST)
X-Received: by 2002:a05:6214:4886:b0:921:2b3f:95e5 with SMTP id 6a1803df08f44-9212b3f9742mr4788556d6.24.1795058587036;
        Wed, 18 Nov 2026 19:23:07 -0800 (PST)
Received: from localhost ([107.159.93.232])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d28215sm38265326d6.16.2026.11.18.19.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 19:23:06 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Nov 2026 22:23:03 -0500
Message-Id: <DMYV5T0TLKEG.1RHCZH8L40LWY@canonical.com>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
 <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>,
 <sr@sladewatkins.com>, "Miguel Ojeda" <ojeda@kernel.org>, "RUST"
 <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
From: "Alice C. Munduruca" <alice.munduruca@canonical.com>
To: "Gary Guo" <gary@garyguo.net>, "Thorsten Leemhuis"
 <linux@leemhuis.info>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261118150247.972732815@linuxfoundation.org>
 <cb9ff126-7767-4c60-b735-1b7890a247fc@leemhuis.info>
 <DMYMKQ2PRN7X.WKDSQ4X8JIFB@garyguo.net>
In-Reply-To: <DMYMKQ2PRN7X.WKDSQ4X8JIFB@garyguo.net>

On Wed Nov 18, 2026 at 3:39 PM EST, Gary Guo wrote:
> On Wed Nov 18, 2026 at 7:02 PM GMT, Thorsten Leemhuis wrote:
>> On 11/18/26 15:20, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 7.3.6 release.
>>> There are 2651 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>=20
>>> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
>>> Anything received after that time might be too late.
>>>=20
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6=
-rc1.gz
>>> [...]
>>
>> This failed to build for me due to a problem with rust during the "make
>> bzimage" stage:
>>
>> """> error[E0432]: unresolved import `crate::util`
>>>   --> rust/pin-init/internal/src/init.rs:17:5
>>>    |
>>> 17 |     util::*,
>>>    |     ^^^^ could not find `util` in the crate root
>>>=20
>>> error[E0599]: no method named `extract_cfg_attrs` found for struct `Vec=
<Attribute>` in the current scope
>>>    --> rust/pin-init/internal/src/init.rs:171:39
>>>     |
>>> 171 |                 let cfg =3D field.attrs.extract_cfg_attrs();
>>>     |                                       ^^^^^^^^^^^^^^^^^
>>>     |
>>> help: there is a method `extract_if` with a similar name, but with diff=
erent arguments
>>>    --> library/alloc/src/vec/mod.rs:4245:4
>>>=20
>>> error[E0599]: no method named `as_ident` found for reference `&Member` =
in the current scope
>>>    --> rust/pin-init/internal/src/init.rs:413:28
>>>     |
>>> 413 |         let ident =3D member.as_ident();
>>>     |                            ^^^^^^^^ method not found in `&Member`
>>>=20
>>> error: aborting due to 3 previous errors
>>>=20
>>> Some errors have detailed explanations: E0432, E0599.
>>> For more information about an error, try `rustc --explain E0432`.
>>> make[2]: *** [rust/Makefile:649: rust/libpin_init_internal.so] Error 1
>>> make[2]: *** Waiting for unfinished jobs....
>>> make[1]: *** [/builddir/build/BUILD/kernel-7.3.6-build/kernel-7.3.6-rc1=
/linux-7.3.6-0.rc1.400.vanilla.fc45.x86_64/Makefile:1440: prepare] Error 2
>
> It looks like there's missing dependency not picked for pin-init changes.
>
> Greg, can you drop
>
>     [PATCH 7.3 0580/2651] rust: pin-init: internal: init: emit `slot` usi=
ng mixed site hygiene
>     [PATCH 7.3 0579/2651] rust: pin-init: internal: init: support tuple s=
truct constructor syntax
>     [PATCH 7.3 0578/2651] rust: pin-init: internal: init: support tuple s=
tructs in `[pin_]init!`
>
> ? While patch 0580 is a fix, pin-init is not used in a way that manifeste=
d the
> issue in 7.3, so it's simpler to just drop it and the other two picked as=
 dep of
> it.
>
> Best,
> Gary
>

Hey all,

After dropping the above patches there remain a few compilation errors with=
 LLVM=3D1. They all seem to
relate to pointers in bindings being sent across threads. I am unable to di=
agnose the issue farther
than this, as I'm just starting to dabble in rust/ so hopefully someone mor=
e experienced can track
down the patch at issue.

I've uploaded the build log alongside the config used in the pastebin links=
 below.

>>> make: *** [Makefile:256: __sub-make] Error 2
>> """
>> Full log:
>> https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedor=
a-rc/fedora-45-x86_64/11350094-stablerc-fedorarc-releases/builder-live.log.=
gz
>>
>> Have to run, so not time to look at where this is coming from right now,
>> sorry.
>>
>> Ciao, Thorsten

Link: https://pastebin.com/WCpUdkaC
Link: https://pastebin.com/5BUM2Cys

Sorry and best of luck,
 - Alice C. Munduruca
