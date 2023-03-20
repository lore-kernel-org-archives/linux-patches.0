Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530BA4C6A
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 18:42:53 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id c10so4199234vsh.12
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 11:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679337772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6qDlxgrvXVQRNB9kUbn6eufRRtTHPLdDgSZt+65vJI=;
        b=f4tYwGPHEiPX9T9NSQEefkwCMwavF0Hfvbj8MPt8OzL6EDMfSsCfBfOjHcWUPINIYO
         9ZL/1zFGenH3AzWv9GV0KXiADSzo+VifNzGX+xdaveJasZVWPs86w8AHE3037eSicsTt
         W43IW3n/QcpZBLnGR3WvNGApR8libNVl60RcIJrrrziM44R40p2A9CINpYv2KRzKMDoJ
         OkCQRcPkeAYra3fLCg2RE27/RiocXxzaspEN4Ngo+hL/I7Vxzk0GJDyy86SyNuimXbYj
         ++tKvusG3Ooqy+780AhinPAkinpjJ8vsgoBuqnLayzMZ7eLNDKSNOj4oabisOMENf/lU
         p2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6qDlxgrvXVQRNB9kUbn6eufRRtTHPLdDgSZt+65vJI=;
        b=zqQDgYlcSSnfUtASVHEi6REqRDibAkMK1H5rjeigWBRs8V0Z5Sui97TdFAkP5s2nHH
         yJc85ZgsFxTDsNC4HUebqtu8MqCfJQZw8KicenfKt+6AGZCl8AFcWLGMluKIsK2bLVNO
         iTzPTJkaV9jWAWQwUn+jh8Dua86epj6rQId5gvHhD5hd2RNFuN2R/5wZnPHZFKns2F6h
         dOvh7MvrC4s7XRUgo3J7foLHOJgKNdXox5FnUt4J34gepx0hP58fuhOc0GzmkaIkt/jJ
         Tz4j4Osus6chqloPnKmHZuiP2Hhjh32O+7KPNF0mtxnReIAviwcKK5RqrFzrHfaOryUU
         yd5w==
X-Gm-Message-State: AAQBX9cUgOJUvYfksgXgntqeELChB4yaRhO3CLXcrT+4AM/UIjFoyq4H
	5neOuQvilmUpZrpwDNgPtiiaiM45fyG33ro45mQ5mA==
X-Google-Smtp-Source: AK7set/vVlTyUh2BRkhjfN5Eql28JK/M5ok9ZONQir0aJp4DhxnNQlA6ExlGsyH5oMhXl2OBLvkb746J5x0qgMXmI+w=
X-Received: by 2002:a67:c01c:0:b0:402:9b84:1be4 with SMTP id
 v28-20020a67c01c000000b004029b841be4mr4451vsi.6.1679337771950; Mon, 20 Mar
 2023 11:42:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145507.420176832@linuxfoundation.org>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 00:12:40 +0530
Message-ID: <CA+G9fYtCtfSqrje=1wkw1ODpnJorDMFkB1bSVexpyc4gi3X0ZQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, llvm@lists.linux.dev, 
	Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on PowerPC build failures.

> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/64: Set default CPU in Kconfig
>

We see PowerPC build failures with Clang 16 and nightly on the
following configurations:
* cell_defconfig
* ppc64e_defconfig
* tqm8xx_defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Error messages respectively:
-----8<-----
error: unknown target CPU 'cell'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
----->8-----

-----8<-----
error: unknown target CPU 'e500mc64'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
----->8-----

-----8<-----
error: unknown target CPU '860'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
----->8-----

The bisection pointed to this commit,
  45f7091aac35 ("powerpc/64: Set default CPU in Kconfig")


Follow up fix patch is here as per Christophe Leroy comments,
 powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG


--
Linaro LKFT
https://lkft.linaro.org
