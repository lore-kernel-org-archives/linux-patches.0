Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A77843AB4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 23:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+gh3BLu"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7781bc3783fso8840885a.1
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 15:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700089783; x=1700694583; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GEhgXm3pCMAcrpujNss809I3BLCwCALa+FWiZj75FX4=;
        b=A+gh3BLuTcnWR2wa7CImX4gNf6qRY7Pax9QQHzsd3XxiS87nGKC9l7RW/RIR7bC/WK
         S/RHljQmzm3NgCVXjzbXo5wrqotEA1MTJN5Do49KXwhj7PKjRxVCTG1cRVOMTMEMU0cN
         +8oD85aqgI/By8X7nIy9LCCEC6wBMXh7f6r5ZIE8huzXnUyG3IYGadr2DQ9OQV+07avJ
         G0BVKaDLGik5/XqHeEeVRyig5Fj+y0rtRjXjGXw0zpXHhLIUwBTUmpOFp431PJ7tiTK7
         n1Qo2MLmnhldHACHwOGu4AvR7jVdywTk3YyF69qYtxLajQZiLYA8yENq/dfZPIyoJALO
         l1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700089783; x=1700694583;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GEhgXm3pCMAcrpujNss809I3BLCwCALa+FWiZj75FX4=;
        b=TOtsdINniqVNCGuF0JCu3Tcz/bsKNi7fQj9e3geuo38vPh5LNYq7nasjGIQhaWU1eI
         Kac/M/kuZtjNGym8xceG5YqVbThxEitS2ZCx7q7ukIpXMsOQO1Ph13xlv47Afn4qNjeR
         5QKmgbdW2L0SO1o9CQ7empTjpOE0BCdLC8Pj5vljYhug/DrrHR551/m027rE3mscCErz
         KVYDiAo0DEKISl4vbgxc4xM374MOUgvk6hdE3RFh3AozokM7I0TMCJjiWmCPNrayPQ3/
         UsUwIAbVsm6Len/MMUwZo+W7sGaxphNpN/jbBSDmNnDOag+IEV7F6vGWPTegOavt+b1T
         tgiA==
X-Gm-Message-State: AOJu0YxheX3IYOOXzr6YNQgkWw6toKzHq4PtkSj+zTE/ClQvmyF7IRLY
	DFjwVobmIcoOPpPGoeDYtwU=
X-Google-Smtp-Source: AGHT+IEAS1NnzwEEMb4x8DQfQwSn941Jb7gA8KqsaXlGZY+LFrKmU9zIgBl2NseseqQJYzDKboZm4A==
X-Received: by 2002:a05:620a:2941:b0:775:6785:3051 with SMTP id n1-20020a05620a294100b0077567853051mr8747477qkp.50.1700089782766;
        Wed, 15 Nov 2023 15:09:42 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id qd6-20020a05620a658600b007758b25ac3bsm3836011qkn.82.2023.11.15.15.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 15:09:42 -0800 (PST)
Message-ID: <96156352-0c64-4835-959e-1188c8fa5944@gmail.com>
Date: Wed, 15 Nov 2023 15:09:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 12:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.201 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

This was caught up in the previous -rc cycle:

/local/stbopt_p/toolchains_303/stbgcc-12.3-0.2/bin/../lib/gcc/arm-unknown-linux-musleabihf/12.3.0/../../../../arm-unknown-linux-musleabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `evlist__add_aux_dummy':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evlist.c:269: 
undefined reference to `evlist__dummy_event'
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:655: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1
make[3]: *** [Makefile.perf:229: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2

perf fails to build because of 8911e3d6564efbb253208ba031b42fa3e672b3b0 
("perf evlist: Add evlist__add_dummy_on_all_cpus()").
-- 
Florian

