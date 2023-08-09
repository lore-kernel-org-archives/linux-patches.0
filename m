Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94DC24503
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 18:36:12 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b9ba3d6157so1785601fa.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 11:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1691606170; x=1692210970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6XaNRnADYL6BfmJLMU8ikF4TaveyP0VMAvN6HyDdfo=;
        b=GeRukGKRMYqxQYoav5mEmzDg+GExj0GSr+1C/1RoPEhsTSXLyseE7R2epxSK1/Y4zN
         E/sJBIyGDRyvFBjYKD/37CaZCASI1CtGIHVkBYgyOltBO9Na3JhLqMmbr1jyzNUocvjD
         ECK9HXlhJzvI6HfYlIW756LDYJKkKgg9i7eIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691606170; x=1692210970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6XaNRnADYL6BfmJLMU8ikF4TaveyP0VMAvN6HyDdfo=;
        b=LGHCE/xVhI6LDKv39aZXcLL/4p71XnO7CLY5ahPE/MO3NcpVWVnlSLRBvuNylxaNpF
         dlCFu3Qufzm1VAD216GPZ70ZH2+l8CfGvhm+L293vLP0ZhDcsHG6XBJ3bJGXrlR2Mt/t
         jD/tAw/qy5A+x/Kb2qRoFbdXeBgrbwTf3YqAGPBlYcBY7/rvHJBaWhKS4ZswV1nGB/qB
         B2pV7XCzpO2+lA4Bf2o+0v8UbxePI8nV55OmOU5xSEceaKC7ItfGBxVDzGLzmWBimrY6
         Lr1/Jj1n3gDxvzgEE2yXYfcxZsRHx/7zXvK+pQHKmU99MKROjLxJcrVPO7RmfWnRSe7y
         SEQA==
X-Gm-Message-State: AOJu0YyFzj0WAyuN0rkxh2sE6shuSXxdzf9EYG3EHzko8Y1gdxq2RfTu
	7kktOksWZ1j4aEc2MJdLLLpXzlgAmsOtVP0aKHHFag==
X-Google-Smtp-Source: AGHT+IGXygtLz02FQtSpXeyHUyBXzsYrmeSt8NX1zrHnO3+oXSuKYWIrjbSoiWc3YJoJ3FlTnX7RlCDbOcgTVrnmCf8=
X-Received: by 2002:a2e:804e:0:b0:2b9:ea17:5580 with SMTP id
 p14-20020a2e804e000000b002b9ea175580mr26304ljg.17.1691606170530; Wed, 09 Aug
 2023 11:36:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103633.485906560@linuxfoundation.org> <20230809135326.GE3031656@google.com>
 <f47340c6-3c41-1f91-d0f9-fe0b59a23aac@roeck-us.net>
In-Reply-To: <f47340c6-3c41-1f91-d0f9-fe0b59a23aac@roeck-us.net>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 9 Aug 2023 14:35:59 -0400
Message-ID: <CAEXW_YQ4GqPwvUF8=8CWmdj=cD56v_eEVK-EirsObQXyBDFVpg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 9, 2023 at 12:18=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
>
> On 8/9/23 06:53, Joel Fernandes wrote:
> > On Wed, Aug 09, 2023 at 12:40:36PM +0200, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.15.126 release.
> >> There are 92 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, pleas=
e
> >> let me know.
> >>
> >> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.126-rc1.gz
> >> or in the git tree and branch at:
> >>      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> >> and the diffstat can be found below.
> >
> > Not necesscarily new with 5.15 stable but 3 of the 19 rcutorture scenar=
ios
> > hang with this -rc: TREE04, TREE07, TASKS03.
> >
> > 5.15 has a known stop machine issue where it hangs after 1.5 hours with=
 cpu
> > hotplug rcutorture testing. Me and tglx are continuing to debug this. T=
he
> > issue does not show up on anything but 5.15 stable kernels and neither =
on
> > mainline.
> >
>
> Do you by any have a crash pattern that we could possibly use to find the=
 crash
> in ChromeOS crash logs ? No idea if that would help, but it could provide=
 some
> additional data points.

The pattern shows as a hard hang, the system is unresponsive and all CPUs
are stuck in stop_machine. Sometimes it recovers on its own from the
hang and then RCU immediately gives stall warnings. It takes 1.5 hour
to reproduce and sometimes never happens for several hours.

It appears related to CPU hotplug since gdb showed me most of the CPUs
are spinning in multi_cpu_stop() / stop machine after the hang.

thanks,

 - Joel
