Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761730B508
	for <patches@lists.linux.dev>; Thu, 21 May 2026 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376264; cv=pass; b=tAVt3jh42GEpktMPXyOrKs7AXHjA5X/uSjQnBs11F8TVRWJgkciC32wfZf75Tvykl10v5z0T18sN7VRfTRmZY85S5Fcwi/fo3UKWv1oVF9+qJONZ/s7fR3g5HcEudk/ZU5ITab2QSBEaynuCtFBLcBmk4gqbZiyaELWV8143ghU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376264; c=relaxed/simple;
	bh=ILfPKmm6WIP8+pTKfALGk8orSX2OR5gYrWIIqKa6xG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFdSUDmIKimxmYxoE3l36w+ywXxQdbGTc9pedKxqLvTtjkQL8WA5Z7X9cPuZedxO0zCfxSdxrKEpXN2IEiOrf9coVyFW2tNQmnQ0t02/R6m0hbM4x16cW5HTdq8XRcCKE7iq0unmzMliyIKAo1wptOQRiwrsZA/xIc6EPIXYor8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FYovcun1; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYovcun1"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2c156c4a9efso8820368eec.1
        for <patches@lists.linux.dev>; Thu, 21 May 2026 08:11:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779376262; cv=none;
        d=google.com; s=arc-20240605;
        b=YJQs+p3Ja6KjWpfgdUkco5NtR2kP8/9KfQDrBPkh5UfMEa1zlrJo8WLobRvV+NJLQj
         NITSt6m4epfUva4TlzI49wJk63z2/hHNLC92R9QX7vsgy8qTSM9VxVxA/m7sXyG9afZD
         ljDM2Wlt7Lro1GVFEFDecfF+PFzMYfAAVCKyjMkaIhf5OzpFaDu4Tjn5EWJNpKPqZc/z
         FC3kh7JbZDPMJwgvp1BKV5cwXh8vJ9q67Il8EIBMQ4XZ3bo6IpLsmvsowOLiXhbYlJgH
         RPWEzCuXvRnrubXviA+omXM4q/kEs8/puzCxQudQSmKMsBqiWQhpp/0uhKiIeVaGTwDV
         a3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/zKjoIM90nBhcCHwQGZzjnKjYO07HjblWjtUDxE6Lnw=;
        fh=KSYsSx/6A5CKt5XnO+xmwSh6NTFBKldgoMK9Pr13mUw=;
        b=eaHtkvHg/IqAQa4gYFF1/edDiJMmVTcYPgb0i0MI2tiN8PosrK22QDdAjOHyxjRF0l
         b79a/EunjkX0s+2+HXNEQ76R9GWu7RqSIYgrVjOtI+GKZUYnSRx2+iloOi/HAM4CLTjL
         5EsmP6GAE0LLFjIHkXwSCz7cXJiLAsNRGieoFYYB+2eAF+FV2zZsU25tRmMjq+4SzYov
         ae0e+Ygy8LpLQJQ4ahNTt0/RAWqSs36Ud5DMwVqGLWuYMoNb6gNsvT5s6iuhOu15hKfW
         GICp4VVyYqM2vjQ3i/mFW9mTKnOTi+7L6SqtUSvu/BQNX/cPQPPprpsVPhHVMwW8oebz
         vpDA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779376262; x=1779981062; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/zKjoIM90nBhcCHwQGZzjnKjYO07HjblWjtUDxE6Lnw=;
        b=FYovcun1Dp8Hltti2iWY1Mf5zSNfBHpVZQfFLzHy+7yncCGKDLYkrKkL+kad03Gakg
         GJOGXl9OdtiHoUMW0tCT+ol88BiiSsrz66Xu18eUHOdLFEIEj2XWM1B3quW4SBOe66JA
         ja+WOSPv40sTzc2VTQZz/PDngRfLIP9YS5ZX/pm/F+iKE/gFEuihjxlOvaJ8BxqxvEM5
         kJ4RouPc7b+X9gfb1RRqLanYXP4FhkxK/uyeMoH1AFLVUaLNTet85KRy0brMymE1r3qm
         DDtZyAxspeeMpiNEKJ/qNM5U+YQ2gGTpOOnlZtwNTP1dET/tPxEIQUSopVRMvQdzDhom
         FpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779376262; x=1779981062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zKjoIM90nBhcCHwQGZzjnKjYO07HjblWjtUDxE6Lnw=;
        b=Zd6PPFxIbjz9Ks1vkuyIjWP88POFoeoAVfYhk9LeOU24Qhe1EiEwNlRzEOTz113ecf
         eOWtnu0PmT0hNvid5CdF1YU+wRO+khwURv6n4Y01enBNjEP42Iw7VNbj8IeQe0kd/arN
         DkCg+AEjq/YXUvQAPP8Rzq0JPBVG6tjBQpnYuOuFRLSnG6Y+GPYnJQ0nfHq7nMJDhJxT
         Qw+9fjwpBizQgiBjrRnUlqWZpCZarueyXkfMM8YUWae9aoxf4aSuCWI+CFpIcBJ7Jeef
         M0FAXVsBTpZqOm99fGJWqWCuztqYrbUVycXinRVH4nxuzjtDFon09LP/lfNC3LKIT5g6
         M/mw==
X-Forwarded-Encrypted: i=1; AFNElJ8n5kVadUKUnslHuZGPwYjTaQ92MiAmDbH6y2L5k9Dme8Y6BBWeTNNamJMu2pAhbZGJsBp78cgs@lists.linux.dev
X-Gm-Message-State: AOJu0YxhvIo7CkDXOfliL6rHKUjQCQOKrrfFkw+e1J5PjTCGLI7x9DwL
	tzwMiHgmSPwjiDSV7hAw076Z73M0l0z4x1mv+lcQ1NCkb/k7gkqKnS2wWcpBq6bGp+NzhS1bJaU
	HIWoMBWDTbWzaSpQHdFnKXchRcQ29qFc=
X-Gm-Gg: Acq92OETt4DYHYss2qKgravCCEZ1HwJdC1uw8PMnB7rE0Vwf5vYmJYxtg1adpN3Ouys
	CqMEMJUhX2earuPjDfZeSOF9qxc1ZfDhJfWtKcZYzM/iq2ixR2+aW2PnbvZGZgcDHkTDnl1EC8p
	aJhehdVA0xelRKreWtjv+h+I0paQflEApLBnqfGFETXCpE+Ud6UpETTvF/2M2dxYuu3pSvoQByM
	3MLITKihDReufbTLRqKxx4yRa3dBtoXTrebkYU7087i3vEFe52JC7IvazdpN5pzxYiFiX/p8ZTV
	wr91qr1cZ8vOft2HGywBYFn58OvdhYkrjY4eCji9dIUbAPEsnGc1N5Gg+8wbcp9ha0UJC7Qg/08
	omzJVi0bOIT+a+CxTxRrd2hFiV3KTPli0p6AL0vHrfc1dV4RQP/yIE/KP3/0HDjbAXXagCHlWcm
	x3xCTbV8N4mXXHHc59VTbuT6XwSxdcVoRN+bIDyA==
X-Received: by 2002:a05:7301:e2a:b0:2c4:61be:1d33 with SMTP id
 5a478bee46e88-3042f48021fmr1929829eec.6.1779376261938; Thu, 21 May 2026
 08:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162148.390695140@linuxfoundation.org> <0d67203ea22a7e63018ec8faf64ed2926a35b217.camel@polito.it>
In-Reply-To: <0d67203ea22a7e63018ec8faf64ed2926a35b217.camel@polito.it>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 21 May 2026 17:10:48 +0200
X-Gm-Features: AVHnY4I0z_lnmAtyJSTYF4yO7FwKP_QbNXUE4-v__QJHCIyrlaCcdQay2R76stQ
Message-ID: <CADo9pHhq41HL66NxeFBoPZjhmowJuDPOn39zw4n=KLzuAwrwhA@mail.gmail.com>
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Enrico Bravi <enrico.bravi@polito.it>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "jonathanh@nvidia.com" <jonathanh@nvidia.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, 
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "pavel@nabladev.com" <pavel@nabladev.com>, 
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@kernelci.org" <patches@kernelci.org>, "conor@kernel.org" <conor@kernel.org>, 
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>, "sr@sladewatkins.com" <sr@sladewatkins.com>, 
	"linux@roeck-us.net" <linux@roeck-us.net>, "hargar@microsoft.com" <hargar@microsoft.com>, 
	"achill@achill.org" <achill@achill.org>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, 
	"rwarsow@gmx.de" <rwarsow@gmx.de>, "broonie@kernel.org" <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

Den tors 21 maj 2026 kl 15:52 skrev Enrico Bravi <enrico.bravi@polito.it>:
>
> Hi,
>
> On Wed, 2026-05-20 at 18:04 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 7.0.10 release.
> > There are 1146 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >
> > https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> > rc.git linux-7.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> kernel builds and boots with no regressions. Tested on x86_64 (13th Gen Intel(R)
> Core(TM) i9-13900H).
>
> Tested-by: Enrico Bravi <enrico.bravi@polito.it>
>
> Best regards,
>
> Enrico
