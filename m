Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C08145347
	for <patches@lists.linux.dev>; Thu, 16 May 2024 10:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715856978; cv=none; b=uhPLTk61BH9ozSjQ0J8lubKqOoSwwdowk9bTPu8PLS0o/eltSTdvqGZ53TZmjye+UQoVp8ibnAUp1jAurwQqDqpYBwTTJXA4X8mRDR4ZBGNI+6/UJEa2iGNMGFbTTM6DxJJKRY52Oasw4aEcmUCGSTZ8U77whg5HjteGBq1KFiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715856978; c=relaxed/simple;
	bh=aCXY487Vxu2tav49EYVB23ecLd3zrF9qRUTgLAbSiNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4R1CgLGBDyG8tWR875KbXba5qWJ9Akp3nF6rzOf4rcUmheO23yX2owxIA8KIOvnxZlS98KbBtVCTKPpd9JoP4haG8i/BI1CQHngtR1BK7KaDWZhaFGFAAgnFJyjyyOtIrOEb6JRBaqyH/FiV1VQpsd1nJDl4n9flKbg4gkc1is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vemdlWtS; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vemdlWtS"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4df4016b3c9so2778722e0c.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 03:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715856975; x=1716461775; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8hvYdyfxE3IpE/vm58h7LJU7ngmgeqBpo8sHkqV4Ox4=;
        b=vemdlWtSxUaUiVIY7LMrOg2P6uTeb+Yfo1MnrCVH4PWhMJtyYJHFtveGkb4tH1n7VV
         9h/0BQ++QvV2U/Q64ydYmebdxEP2A3yhlq2O+TtU7JzhsQWCAFfHTKpsYn4ygNytfabV
         0SbdiE3/NTlSS6IVrFhL61sE7l355BcG3BAUL+LXUpltEe/MZV8KDa5JZxfDSTcEzvJD
         +ojRvBBFyIL2tklS0UKJYnJr8mYaOPMn3rHaEJjT8C64Wu9MDVlEX64zWcmuI+dMn3m5
         Dl7gZtUNviMfpYd/DAm1ORoaAPC+rFliCN/X4JN1upGCZFxHN0lX76HYR8WrrBwRdMRw
         y6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715856975; x=1716461775;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hvYdyfxE3IpE/vm58h7LJU7ngmgeqBpo8sHkqV4Ox4=;
        b=lxmRv6ioMqCq1f21f3VXgutWQ2e3TejdKsHGeM+bNmryA/P7V9S+gcIZ28+/fD2cbN
         c3gxWUrS8xAqkd/w9p6XMjNXmXOnSg96a9J85OC3vuPtNZJFT2dkGuDbuDiq3fBIvcME
         7Xsz3VfjJ9Nfjcs2qbZt+tfRo9C+1ePupIspPhkGHsEvkre17Y3JmqNZ6eW+qES54AMJ
         GoMbslvNF3qy7h0KcXOyM/vuo7CzFUXAhNFjN8aA9reaUwt40qsFXo6JtoZXN/4FQlJK
         BR3HQgBK7tWyknqbUsMSx4rV6fF+YbbTCxvEE7hTGPid3u9Kyv7jH2Hvt98FX+zHWTNY
         A31g==
X-Forwarded-Encrypted: i=1; AJvYcCVUUaWln8fzRgKH+QKSBbATb2fRy1Kna9plSDxvK1ym1au1sDdb1WuDbjyU7J6dy77RDetl8x3xTxV1JhgNkjdTjvwlhCz0zQ==
X-Gm-Message-State: AOJu0Yy1Oel+cZIkrELggIHRwwnrEXu8zA4jhHngZL4AzjS6YoCSU3FF
	ZK0J87sbJ2cuX1VBnKcOApjxVetQ53SQRNDc1vwKwvClZgMpBV+iCjoc/SVc6j5340+3rjjqPpO
	1X3a1i2346yBombrNbSDQW/syyOG4deNnRu5REA==
X-Google-Smtp-Source: AGHT+IHLfOcjHOyNax1qpFAJlUavmIK8GXsB4d5nnt42V8lPqyLhP6Ngp7Ge930ihPYf+AX/U/jPZnq78529h9Sa7uE=
X-Received: by 2002:a05:6122:4698:b0:4df:315a:adab with SMTP id
 71dfb90a1353d-4df882c2956mr17221080e0c.5.1715856975523; Thu, 16 May 2024
 03:56:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082517.910544858@linuxfoundation.org>
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 May 2024 12:56:04 +0200
Message-ID: <CA+G9fYsZ7iTr8UGyaN-FB1R8=zLWnciB_10mzk8QCRhUMLSfFQ@mail.gmail.com>
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

On Wed, 15 May 2024 at 10:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As Mark Brown reported and bisected.
LKFT also noticed this test regression on 6.8 and 6.6 branches.

kselftest-ftrace test case,
ftrace_ftracetest-ktap_Test_file_and_directory_owership_changes_for_eventfs
failed on all the boards.

Looks we need to add this patch,
  d57cf30c4c07837799edec949102b0adf58bae79
  eventfs: Have "events" directory get permissions from its parent

Let me try this patch and get back to you.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
---
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.9-341-gcfe824b75b3d/testrun/23938179/suite/kselftest-ftrace/test/ftrace_ftracetest-ktap_Test_file_and_directory_owership_changes_for_eventfs/history/

- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.9-341-gcfe824b75b3d/testrun/23929234/suite/kselftest-ftrace/test/ftrace_ftracetest-ktap_Test_file_and_directory_owership_changes_for_eventfs/details/

## Build
* kernel: 6.8.10-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: cfe824b75b3d9d13a891ad1c4a2d6fe0eceed1e9
* git describe: v6.8.9-341-gcfe824b75b3d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.9-341-gcfe824b75b3d

--
Linaro LKFT
https://lkft.linaro.org
