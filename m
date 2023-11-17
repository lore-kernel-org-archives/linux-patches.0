Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D245AF4E8
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 07:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qx5tRvbS"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-45d9689b65dso669311137.0
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 23:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700206885; x=1700811685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCDUD/ayWCyYX+V5eg8ErxP1HhH1oV9OubP3STgdWNA=;
        b=Qx5tRvbSLWHghsCU3N6d6mMb0i0TqUUh6qvaqqhq2eSFGc0EvVa9hPMCeDyGjE47V5
         N59f+e5kmqPqnZEe4WNyUiVWRpaCJ7jBt+N8MmuzKT15b/XIy4jmpmEQVRhRbiz/oI6V
         53JLjAQmqiVMrXc6leY3FBeaNvyKZFN5DAq0077tzxao0YVkhulDqAcdtek4F1yI5naf
         wwpWiSC74rVJmWx8jumaD+EmugY/k5PSdLzunHyAuQoEwyJW3I+3gEILfE+37GMDF6Bf
         TNiDu8pf58Ft3QacTXK9E51uNKMGmgCT/ZJ5cCXWqQueVx7ZcVLCwNw/ZGN9ZeK+NLLX
         Lbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700206885; x=1700811685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCDUD/ayWCyYX+V5eg8ErxP1HhH1oV9OubP3STgdWNA=;
        b=wGTBD081uq/57yhg3LOrcNk5uPBsJe66VtF8GK7Nv/Xb9aZQjBeWMT7SiUsjUiWYSn
         g/ZQhmM52a6amW551qWkW5H3M/8oA9OdYsVYmrxaPQDIOgq3xjyphBVpKHzKwi2fsB7t
         My1/n6XTsLti+WgMXud4iUIlMSKrm8dsjMh5pIOdiUI5eMz4P4DJc3eT81asLVQfi2fw
         W4iIrqY3DUk94/VJn2GVVJ9hkoJbdnHQdCYqJAG+hsNdyfVK5WO4zF4F6+jZp3yr5+jZ
         MSRGy+zJ2Y/UDVtfsPA3ddOezl/8zohZnxgCwrhmMOPzMTK/1CyMIKSJexWbs1SJMQXv
         GUxA==
X-Gm-Message-State: AOJu0Yyp+otHa9dptTDOz6pKmextGqGVgg1ZxKowS9/xQxK6rTb280Yc
	crSWvjxmkQ1B7uvQLMeMFfEuE5uI+dSsNEjgaxO26A==
X-Google-Smtp-Source: AGHT+IFy4OUn5tiw3ME+e8seX8aG0i3Hz+uDvT0kxb9K92hvelXNsjLz3NHqivsCcZchdAAm0jaDeHfmaroVHuF2uc8=
X-Received: by 2002:a67:b70b:0:b0:462:7c41:d00b with SMTP id
 h11-20020a67b70b000000b004627c41d00bmr2581850vsf.4.1700206885545; Thu, 16 Nov
 2023 23:41:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115204644.490636297@linuxfoundation.org> <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
In-Reply-To: <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 Nov 2023 13:11:14 +0530
Message-ID: <CA+G9fYtOMKserwz7w_gpe4bZnEwrd_-zSyndSepFP_jO9X-o1w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Nov 2023 at 06:43, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 11/15/23 12:44, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.201 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
> > Anything received after that time might be too late.
> >
>
> Build results:
>         total: 159 pass: 155 fail: 4
> Failed builds:
>         arm:allmodconfig
>         arm64:allmodconfig
>         i386:tools/perf
>         x86_64:tools/perf
> Qemu test results:
>         total: 495 pass: 495 fail: 0
>
> with:
>
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: No su=
ch file or directory
>
> There is no linux/args.h in v5.10.y.
>
> Caused by "interconnect: qcom: osm-l3: Replace custom implementation of C=
OUNT_ARGS()".
>
> Also:
>
> Building i386:tools/perf ... failed
>
> util/evlist.c: In function =E2=80=98evlist__add_aux_dummy=E2=80=99:
> util/evlist.c:269:24: error: implicit declaration of function =E2=80=98ev=
list__dummy_event=E2=80=99; did you mean =E2=80=98evsel__is_dummy_event=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
>     269 |  struct evsel *evsel =3D evlist__dummy_event(evlist);
>         |                        ^~~~~~~~~~~~~~~~~~~
>         |                        evsel__is_dummy_event
> util/evlist.c:269:24: error: initialization of =E2=80=98struct evsel *=E2=
=80=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast
>
> There is indeed no 'evlist__dummy_event' function in v5.10.y.
>
> This is with v5.10.200-192-g550b7e1fee20. I am a bit puzzled why others
> don't seem to see those problems.

Thanks for reporting allmodconfig build failures.

My apologies.
The LKFT found allmodconfig failure lately due to infra issues / timeouts,
the builds have been re-triggered manually.

        arm:allmodconfig - FAILED
        arm64:allmodconfig - FAILED

LKFT have stopped building perf on 5.x and 4.x branches, because we
reported several perf build issues and were not solved in the past.

However, building perf tests from recent stable branches and testing
that on older
stable-rc branches.

- Naresh
