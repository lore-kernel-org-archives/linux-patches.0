Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BC317F7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 02:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="sQEm3V7h"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b9d07a8d84so47593231fa.3
        for <patches@lists.linux.dev>; Sun, 15 Oct 2023 19:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1697423152; x=1698027952; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0LfinplnzcaTdsRdXhDFzIQMiKq8VSmVBDANoGvJi8=;
        b=sQEm3V7hIWIbmh1s3IhplXSr/T1z9MUiuNXe9mv9Roo38GxEoq71AuAMWPiHqQFJUJ
         DamQA+EAouCwzCbUjaUcRC0743qo7qL49CbFmgnQKvLoOLixhLZ2d+OtFrluCQjbTWjX
         /TUvLl/t9BvtGQn+LXe2DwZ5Ts7iWjf4SCdQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697423152; x=1698027952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E0LfinplnzcaTdsRdXhDFzIQMiKq8VSmVBDANoGvJi8=;
        b=XUTzTJMSLFjFbLgro8I2BReLAHDzQy+jGegf5sOUC6zRap2SBBl/1v88vPWptkU4zz
         x+w+rXmYdKD1tPPV3NGRpUq8ok2VxIfF8+8U2y3/LgFqScQTzQqHb4M9QiphqsfQGmMY
         94DkiM54Hm7Xs2GMTstMuHmdyvlz0EF3gBLAYZ2t0/1v75H33VajTfEwQGW5Q6r2+sf+
         YTcbz3vjbDOBiJg70SfcCH//lhemISlsfFWr5GzJyDLMkpU+AyIUMmy7HJRICGNs8vfy
         yIM+ytgPyF9nB/6B8GFwaVBL0U/vsZYE8G6Bszw2KHt2xBly+jaW1rpS/Fr8WCArP2dM
         08Ng==
X-Gm-Message-State: AOJu0Yx8gQoU9b1IYX4/EHKxzCnfmlRySnUJ1/qijwgBii+tfrgxhtMe
	5KsL6ZHky19jG6rWlSjoZrzStB3wi5CIhLWy0Gm8WQ==
X-Google-Smtp-Source: AGHT+IH+QrM3pSw2s87D50J4FBEKwsOAzgXABrnT9ujQNdoYkm+yIVIj1/2F4MvqnrHtyPQ3DN/A1XFuRQGCEyjzLvw=
X-Received: by 2002:a2e:3219:0:b0:2c5:1ad3:7798 with SMTP id
 y25-20020a2e3219000000b002c51ad37798mr1822219ljy.52.1697423151283; Sun, 15
 Oct 2023 19:25:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175203.943277832@linuxfoundation.org> <CAEXW_YT6bH70M1TF2TttB-_kP=RUv_1nsy_sHYi6_0oCrX3mVQ@mail.gmail.com>
 <2023101110-resurface-nuclear-bfee@gregkh>
In-Reply-To: <2023101110-resurface-nuclear-bfee@gregkh>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Sun, 15 Oct 2023 22:25:40 -0400
Message-ID: <CAEXW_YRf0e6V6PcGJ-LWiS=ERgy4yxHoSG4d+DHLjXZ8Ah7kJA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2023 at 1:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 11, 2023 at 11:58:49AM -0400, Joel Fernandes wrote:
> > Hello Greg,
> >
> > On Sat, Oct 7, 2023 at 9:00=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.134 release=
.
> > > There are 183 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.15.134-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > [...]
> > > Liam R. Howlett <Liam.Howlett@oracle.com>
> > >     kernel/sched: Modify initial boot task idle setup
> > >
> >
> > Let us drop this patch because it caused new tasks-RCU warnings (both
> > normal and rude tasks RCU) in my stable test rig. We are discussing
> > the "right fix" and at that time a backport can be done.
> >
> > Hope Liam is also Ok with that. I am happy to do that future backport i=
f needed.
>
> This is already in a released kernel, a bunch of them:
>         5.15.134 6.1.56 6.5.6 6.6-rc3
> should it be reverted from all of the stable releases, or just for
> 5.15.y?

Just 5.15.y. The others don't have an issue with the patch per my tests.

Thanks,

 - Joel
