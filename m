Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314D51FA7
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 08:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677830663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s8QnxRpYQPEiLn8XmuErYmk8O10pIsFngcfQcnQ90xY=;
	b=DnEYcrfsckYeNYos6O9aI0Ctp04dvaGWIYwWbIrQLj/zDKUFVbEEaDZHbNN/rnbDg4hxHe
	c4rL2cengYcr3n8vcq8skw2Acqz81mwz3lT+SljWDTEyi8VAJiRAS8Nceq/vUReUQvaSHK
	gu+azcXa7KhsKlWN59TRAnY2IQc05PU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-_7wtvzy7PreDj0iJriJc6A-1; Fri, 03 Mar 2023 03:04:20 -0500
X-MC-Unique: _7wtvzy7PreDj0iJriJc6A-1
Received: by mail-wm1-f72.google.com with SMTP id j32-20020a05600c1c2000b003e9bdf02c9fso2459544wms.6
        for <patches@lists.linux.dev>; Fri, 03 Mar 2023 00:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677830659;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s8QnxRpYQPEiLn8XmuErYmk8O10pIsFngcfQcnQ90xY=;
        b=Ak9OImFR9wVibocnttPDwbaxqfUhLrSpb1VIeFb7VXycXNXvbxBsihzlWHc+nulat5
         QXZMwcL2m4buGwx/gjfYrGiRQfUsMMPcklP68tAjvdasvBn/SYMvjXKjGgo4lcH1RcP9
         5uqkgIfR1BXRDR9qWjs7EobJEXum9KmpLrbyU73Rpx2S5QCMsVsr8yNJL8UuLt9v28FC
         MkCBigQpmfGIAE1X0QCwIeJ8/kfij/ITsCHJew0ipFinOMsbTC73ErRscr38njrimoCW
         aZxb1vrCZhXHFXTr5YKGziGGybqwAOG5Myytewdz0vb+iYu0v4TvBa+DNBOLVGZRQ4g1
         l0VA==
X-Gm-Message-State: AO0yUKUYikgNmDkF66fDZBeXpOfXVGdmkR95yo2/ycBW6l0gPmHlSw4k
	NCSkR4a9G6GBC0AsTSHZwheADIGMUcyOht7RbOyYr9e9HzcHglMjeTz/JdMp4XXlOexaAfY/vNG
	x1E0tHfy+UgJ4vp9OsA==
X-Received: by 2002:a05:600c:3ac8:b0:3db:2922:2b99 with SMTP id d8-20020a05600c3ac800b003db29222b99mr788297wms.4.1677830658950;
        Fri, 03 Mar 2023 00:04:18 -0800 (PST)
X-Google-Smtp-Source: AK7set/BXLT+lMpnyKVQLibkm04GCkyPcxM5MUEDfKB9hdx14azQTgROHFPeVko3IYxqiAwD1NbohQ==
X-Received: by 2002:a05:600c:3ac8:b0:3db:2922:2b99 with SMTP id d8-20020a05600c3ac800b003db29222b99mr788279wms.4.1677830658649;
        Fri, 03 Mar 2023 00:04:18 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c471000b003e9ded91c27sm5848475wmo.4.2023.03.03.00.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 00:04:18 -0800 (PST)
Message-ID: <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
From: Paolo Abeni <pabeni@redhat.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
 srw@sladewatkins.net, rwarsow@gmx.de, mptcp@lists.linux.dev, Florian
 Westphal <fw@strlen.de>, Mat Martineau
 <mathew.j.martineau@linux.intel.com>, Matthieu Baerts
 <matthieu.baerts@tessares.net>, Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 03 Mar 2023 09:04:15 +0100
In-Reply-To: <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
References: <20230301180657.003689969@linuxfoundation.org>
	 <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
	 <ZAB6pP3MNy152f+7@kroah.com>
	 <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
	 <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, 2023-03-03 at 01:32 +0530, Naresh Kamboju wrote:
> On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org> w=
rote:
> >=20
> > On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >=20
> > > On Thu, Mar 02, 2023 at 03:49:31PM +0530, Naresh Kamboju wrote:
> > > > On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >=20
> > > > > This is the start of the stable review cycle for the 6.1.15 relea=
se.
> > > > > There are 42 patches in this series, all will be posted as a resp=
onse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >=20
> > > > > Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> > > > > Anything received after that time might be too late.
> > > > >=20
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-revie=
w/patch-6.1.15-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git linux-6.1.y
> > > > > and the diffstat can be found below.
> > > > >=20
> > > > > thanks,
> > > > >=20
> > > > > greg k-h
> > > >=20
> > > > Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and =
i386.
> > > >=20
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >=20
> > > > ## Build
> > > > * kernel: 6.1.15-rc1
> > > > * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-r=
c
> > > > * git branch: linux-6.1.y
> > > > * git commit: b6150251d4ddf8a80510c185d839631e252e6317
> > > > * git describe: v6.1.14-43-gb6150251d4dd
> > > > * test details:
> > > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/buil=
d/v6.1.14-43-gb6150251d4dd
> > > >=20
> > > > Regression test cases,
> > > > i386:
> > > > x15:
> > > >   * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh
> > > >=20
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user =3D=3D sizeof(struct tcp_info)' failed.
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user =3D=3D sizeof(struct tcp_info)' failed.
> > > >=20
> > > > test log:
> > > > ----------
> > > >=20
> > > > # selftests: net/mptcp: mptcp_sockopt.sh
> >=20
> > ....
> >=20
> > > Nit, wrapping a log like this makes it hard to read, don't you think?
> >=20
> > Me either.
> > That is the reason I have shared "Assertion" above.
> >=20
> > >=20
> > > > # mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
> > > > Assertion `ti.d.size_user =3D=3D sizeof(struct tcp_info)' failed.
> > > > # server killed by signal 6
> > > > #
> > > > # FAIL: SOL_MPTCP getsockopt
> > > > # PASS: TCP_INQ cmsg/ioctl -t tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -6 -t tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -r tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -6 -r tcp
> > > > # PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
> > > > not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=3D1
> > >=20
> > > Any chance you can bisect?
> >=20
> > We are running our bisection scripts.
>=20
> We have tested with 6.1.14 kselftests source again and it passes.
> Now that we have upgraded to 6.2.1 kselftests source, we find that
> there is this problem reported. so, not a kernel regression.

I read the above as you are running self-tests from 6.2.1 on top of an
older (6.1) kernel. Is that correct? If so failures are expected;
please use the self-tests and kernel from the same release.

Otherwise, could you please re-phrase the above?

Thanks,

Paolo


