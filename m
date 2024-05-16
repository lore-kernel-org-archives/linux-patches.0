Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5D3145A0B
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715860978; cv=none; b=BR2l2fGFVfbu++VaecsvRJXJDdUVZgKuZ+JRHsgNqG+SaeVVzsJcTkmmsuebF3/6XUIQ5GTe3V9jp7kSRht2EYEjwxspPmDLBUI3GUirEjj8pLg5LPdPHZwevAQ6r1zRWo6SZiBl8QYWfU5aBQwX8D5rpHU96EJ0sPengyL7pnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715860978; c=relaxed/simple;
	bh=oBotsPJil6PVHxrA1q35uvvz/IlhYD9SDt5YNtfq1+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S7Ej7OwKkOAy0IUqglIBs4qlhEqFFThZR5JZ1DUStXm8gcLKu88xmXCgNJ13vElHICwW4b6Nsn49rebz/BM9DTU6+Ax9CIQw0e6F49jH4PHPSdUBa+iFjauy2bkx3MVzInJJN2wTTQ1oXlC5/yUxZDEVdBdimKZcgNCoLxQqrlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TByjlPR+; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TByjlPR+"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-574bf7ab218so3570052a12.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 05:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715860975; x=1716465775; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/hFujEQkRTTIC4sPXxzKx3nVfvJZhdLcxUjBaYrvXwk=;
        b=TByjlPR+xRiA1mS6xFj/j6BclJ7Js1JY5drlFOY+rqwGSilJoZ9LT2N2Ey73v3n8qW
         H7O/CCExJXY+fnZj73wZ37xNMxpOeWXIwKEPtRq8BCPL8oEOgwKOYsT+g5CxlLjmMACO
         U85K3xbc5tMcoOwS+UvE0fxAnc+0MhcVVm04C8kqBZn/nR3Uj5ml+HPM9ngRCX7qw1ye
         EGXqn14c1JCpdLIz+D/9DTl8sLWmETwwLvRMPaBevBxHyVrpGN1N9wXZ6CidksnsaaBb
         T9PKyp/DjSdXzkHcr33t61CX1qTc9T6CTvin7tJQT+EgtCFC92wyHz4m5JWCW2yrax54
         NpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715860975; x=1716465775;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/hFujEQkRTTIC4sPXxzKx3nVfvJZhdLcxUjBaYrvXwk=;
        b=CndXnH84je5Pfrq9MmUxlDhh1JUf53aQ274sptLPbA0QEQaX9q61NJRqlzJWnFNPLv
         ajvkzDwh+ZEA8Ic4euYjwZkXpL25iJPzujUc0+bGah8bYOFWvqZ4vCBHHbhHGoP0R1pR
         0/KGXBvoSkWmMKvFlGU6Hhxv5+RQb8x9ezos9SKnHDxWuoC/RRs+y/DggtgPEPmkwLAQ
         8Hn+YU4jqouF8roDHmVKMSYgjRy68JTXeEudqACzjCjmmIq5LX5YkkVfQx+5ekT1Xdh5
         RqDYId67GzCzCLKeTZehvn45QjYetQVCZPbeIWQ1jxTDyJLO4Xhg9YF/BqDXQ4U/hAfB
         lIFA==
X-Forwarded-Encrypted: i=1; AJvYcCUau4+xlm/fEyhnU45x35dtALjuLUxKGQ/yRFQ422pnEOflcL9xsNho4SCfbAd3b53p9HfWhCHoS9yZAUkVyQM7BfswDsT2Sw==
X-Gm-Message-State: AOJu0Yw7n68wsB04rFgLVCWNc0MtHJMAQMxsZaF2ZiZsO10XvNYZQzB8
	fRQgO/WKmUbwljqHQQSxhHp9z03ovx3YecPM6Efs3JIztOtxktpyM9nliNu5DqTkDEWZrAYfokH
	wHQZktuqHXa10F9eRTn/HYut2dqLEGSG3BFxAvg==
X-Google-Smtp-Source: AGHT+IF24n7Bb7yiv2hPX9QR7OjJaCrjTnhCo68mBDN/2UoOuuobCTIpqqrpv2tOfjJAXfPmF2dX3HP6bJEPacOIT0U=
X-Received: by 2002:a50:a6dc:0:b0:574:ebfb:6d90 with SMTP id
 4fb4d7f45d1cf-574ebfb6e1amr4125608a12.4.1715860974768; Thu, 16 May 2024
 05:02:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082517.910544858@linuxfoundation.org> <CA+G9fYsZ7iTr8UGyaN-FB1R8=zLWnciB_10mzk8QCRhUMLSfFQ@mail.gmail.com>
In-Reply-To: <CA+G9fYsZ7iTr8UGyaN-FB1R8=zLWnciB_10mzk8QCRhUMLSfFQ@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 May 2024 14:02:42 +0200
Message-ID: <CA+G9fYuexPg8yh61Bx58QN_y836rb-cfP4DS3ceesTmgohV-5Q@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 16 May 2024 at 12:56, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Wed, 15 May 2024 at 10:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.8.10 release.
> > There are 340 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> As Mark Brown reported and bisected.
> LKFT also noticed this test regression on 6.8 and 6.6 branches.
>
> kselftest-ftrace test case,
> ftrace_ftracetest-ktap_Test_file_and_directory_owership_changes_for_eventfs
> failed on all the boards.
>
> Looks we need to add this patch,
>   d57cf30c4c07837799edec949102b0adf58bae79
>   eventfs: Have "events" directory get permissions from its parent
>
> Let me try this patch and get back to you.

The cherry-pick failed.

- Naresh
