Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB2BA53
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 21:56:44 +0000 (UTC)
Received: by mail-qv1-f44.google.com with SMTP id h10so24357618qvq.7
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 13:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uiMizveEgyDAGlc0W47uncAUcG6L03VuImc0GvuoYxE=;
        b=p5o31y9OsfjdpSiAXjzA+5r3R6ImKBKWr6A445Wii0OKqT8FI8/3S9RS83PfqF/OJ3
         Gb03T74TU3VScnWn2RbvEiUKGUWUcGMRlVfSPgVQzPF4AJuwP4FNpPzqQ4WnLwh89iM0
         5mP8EDBDZsGvzmdVl1znYSmNzyBLGcBJ2ahHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uiMizveEgyDAGlc0W47uncAUcG6L03VuImc0GvuoYxE=;
        b=Euy/l2KQh5rhaWtd+Hk45FvdCVD/jYXVuF1UeIVsl/Xh2Nwkudd2HXPBE9o28WXWW6
         VOb48GyhpchZ7p5J6L3PrxLZC802qooaNDShkIiNGHC+PMOBBvUIwfveEuqUeegsTs9A
         Xxt9roKwBEwOmAkW1i9nnpY6B+gutzLg/uz9bpWSx8XQ6GLb555pvFAn8YoXJvyp5kHK
         KWpAVAwVtEEoIJ13LkE7eE4wLaiErRQJHK/s+g4qjGkRaERn0tw8oMjCQIJaPn9C6Qeq
         KlfYxyPaSrOa8/11mTxGAqXKTA9+qn3ZYFxQbvnMSMsaNofyw6WQPjwylk8PFjT84hJM
         lnQQ==
X-Gm-Message-State: AFqh2koIeCsgh8uymm7mwtvxV7Ig7SDtoXNvBKQ+K7p7WKYxoOcTVRlc
	2H17U9WzznX4+7w059uMrEyqTg==
X-Google-Smtp-Source: AMrXdXs79DFhcOSo+x56due1wHHvPGqJzQtSjupgBYYgCdttjXsSb8ARar1FCsCF27OcTCqQ1ind4g==
X-Received: by 2002:a05:6214:4386:b0:4c7:47f:5511 with SMTP id oh6-20020a056214438600b004c7047f5511mr73638855qvb.48.1672869403574;
        Wed, 04 Jan 2023 13:56:43 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id bn35-20020a05620a2ae300b00702311aea78sm24196850qkb.82.2023.01.04.13.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 13:56:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Joel Fernandes <joel@joelfernandes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Date: Wed, 4 Jan 2023 16:56:31 -0500
Message-Id: <7BA3F66A-097C-44F2-AAC8-35ADBEAE7E12@joelfernandes.org>
References: <Y7UOtInxdmaIP9nH@kroah.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <Y7UOtInxdmaIP9nH@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (20B101)



> On Jan 4, 2023, at 12:29 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.or=
g> wrote:
>=20
> =EF=BB=BFOn Tue, Jan 03, 2023 at 04:16:07PM +0000, Joel Fernandes wrote:
>>> On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.162 release.
>>> There are 63 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>=20
>>> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
>>> Anything received after that time might be too late.
>>>=20
>>> The whole patch series can be found in one patch at:
>>>    https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10=
.162-rc1.gz
>>> or in the git tree and branch at:
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git linux-5.10.y
>>> and the diffstat can be found below.
>>>=20
>>> thanks,
>>=20
>> Testing fails. Could you please pick these 2 up?
>> https://lore.kernel.org/r/20221230153215.1333921-1-joel@joelfernandes.org=

>> https://lore.kernel.org/all/20221230153215.1333921-2-joel@joelfernandes.o=
rg/
>=20
> That is not a regression from 5.10.161, right?

Yes it is not.

>  This release is only for
> the io_uring stuff to make sure that backport was done correctly.
>=20
> The current "to apply" queue for the stable trees is very large right
> now due to everyone waiting to get tiny things into -rc1 instead of
> before then, so the above two are still not yet queued up, sorry.

Sure not a problem, I can resend again later if it is still not queued.

Thanks,

 - Joel


>=20
> thanks,
>=20
> greg k-h
