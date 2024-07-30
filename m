Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF11AA3E6
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 23:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722380619; cv=none; b=LyzlmiGzJfUROZ+Uu9xm2pLw0vRoGwN3z8zz3JSmZX0TC8vKO9XZYGoOCwdLspdWx6rimeXfBQbYs367C29e1QBxjkUvdOimbRybzW9QQ++dgjrwX2+KSxZDvILn+pM02iGK1KWDUDQAiFqHNjXwrskEsvuDajcSxm6kr+Kmh+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722380619; c=relaxed/simple;
	bh=QEcnJYIGmyutkjt9sGE5RN3RMI3LLHOKxXqTrRav/R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXFA30lzysAi3W8qquCz3gkBnZWkJzgH6Yy6ijYMZD7Zkm1rgtfa7nFvmoMJ5LjK3+ZFChYwn71+pgGQCA/dLsUNuv1DYkxysOC3zAhAPdm5CgFYyz7hkL7BrmOOco7ik9tzGJeBvMi4QjuDqt8TwYqmfXa+6D/oNDcsc56gytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eoaQPEUo; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoaQPEUo"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7a1e2ac1ee5so327373585a.2
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 16:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722380616; x=1722985416; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VcM0knhLOz1m9ZbRQY0EYzIe6XjeFf2X8aUPfEnckTQ=;
        b=eoaQPEUo81+Z/inQbahqzuRss+Ghj6oxeY5Ob9VskWdPuAPdbgL39Vl+Jl/PwRVmFW
         CA848bVBy2ftC/rcdjLqRSR/bhU0d+AYrhLjt+hUzCchi1sdSDSUYTNSM2OsrRhjfJhz
         YBuz1MvzP1ZJebf0IeS8twjg3M8u7Iyycdriraxi2JLzlh7O0+Ui3faytcYtSGvU/SHn
         GOf6XGQKoHaJt0lDqgLpYLK483TAeL7NFFyUitV5avlVvWsqBtw3N+lnYusVF/ikzahT
         GJqMlXlVmvWkg2Ff/OBlgD7Eh+Djuj9EaBF/Y/J6KjMZLBvzmQ7O0A9pr2DPaziWnoLu
         q3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722380616; x=1722985416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VcM0knhLOz1m9ZbRQY0EYzIe6XjeFf2X8aUPfEnckTQ=;
        b=I7Gfj4z8+ykNWhpBgYh7yOmRNN9hkWNK4Uh8GPOFxsLgt105gNhDnXQ0fKCKM1jSVY
         MQaLtK8Yb2sih3tP0p1NKdkx4Awui9iZCGY6yUOMdIufv0QwR+l5ppXWYOlGU/Fsy+Ae
         6xDAh3c9toa15N0ozpZMADkjNnBu/4v5psLbuQdngGRT/Glejn2gMvqsKzXAxPuVezaV
         h0l47NeYR63jGvjYrUyYmtNW38TlKDHvxURzy7S/fXj/dMnkPMTubw2fOASAsF3omdDL
         0hwhteTwjtKgJXBFiVNzjSQtXnJEjksFjpoNtiLb5xt1IjPVc5uDJSTXLn7gbCmtIyEX
         S87w==
X-Gm-Message-State: AOJu0YyVXqmlXEXDEdn/p/y7grhKQBZjyZS1jH2+vfJ3r9leWPZZhHA/
	/efXUuNf8zu4kr7cwbeBM17Ty+109Lz2nHZq+E1OaeMknY4Cwx4O
X-Google-Smtp-Source: AGHT+IGf+zgdI5tE488+z1wEmMsZ9oh3Tvc8N59XvRejpiLCz1NQQVLyjlm/+xBjXVrP6J+LjVjGeg==
X-Received: by 2002:a05:620a:430a:b0:79f:d0f:2b19 with SMTP id af79cd13be357-7a1e52f20a7mr1422831585a.68.1722380616193;
        Tue, 30 Jul 2024 16:03:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7a1dcc43dacsm599684285a.126.2024.07.30.16.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 16:03:35 -0700 (PDT)
Message-ID: <86c0c9ee-f1f3-414a-bde3-c171bbce85c1@gmail.com>
Date: Tue, 30 Jul 2024 16:03:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240730151724.637682316@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 08:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf failed to build with the following error:

In file included from tests/pmu.c:7:
tests/pmu.c: In function 'test__name_len':
tests/pmu.c:400:25: error: too few arguments to function 
'pmu_name_len_no_suffix'
   TEST_ASSERT_VAL("cpu", pmu_name_len_no_suffix("cpu") == strlen("cpu"));
                          ^~~~~~~~~~~~~~~~~~~~~~
tests/tests.h:15:8: note: in definition of macro 'TEST_ASSERT_VAL'
   if (!(cond)) {        \
         ^~~~
In file included from util/evsel.h:13,
                  from util/evlist.h:14,
                  from tests/pmu.c:2:
util/pmus.h:8:5: note: declared here
  int pmu_name_len_no_suffix(const char *str, unsigned long *num);
      ^~~~~~~~~~~~~~~~~~~~~~
In file included from tests/pmu.c:7:

this is caused by 958e16410f96ee72efc7a93e5d1774e8a236f2f5 ("perf tests: 
Add some pmu core functionality tests")
-- 
Florian

