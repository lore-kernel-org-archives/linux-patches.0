Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7DB2AB37
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtF1WUZb"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-775751c35d4so145179485a.0
        for <patches@lists.linux.dev>; Fri, 06 Oct 2023 10:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696612991; x=1697217791; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=91W3G0cEbqqRmxPXwGQ1t1R3vCvJsYOaB9Imo0LgEtU=;
        b=WtF1WUZbPiVOj8roL6ViV7/lBg1geg7exjfdfYdX6aYX7PhCzs1uCD2q7fg2Z/0I8a
         XZpCk/VJGBQu/r6kmbP1LQg/BNWdFUmYfSVGOFkbkZw9T8NUgxsBYTnruq9uVuEl+1Kx
         7EXFf1B/ZWof+T9BzTPu1wiEdb6Wdc9F2GVcs3dAK2RG69Yvq65Ne8mFulE3yfLRHLQk
         VjkpJHtXh4Qf6ZE5ZRJIohDvEZqyxWIi5D7vLaCwbq49GayWv8JCgx70qSxVdJ2j4u/6
         kHjXyPqxloHHDXrM9wyu600NHqJAIZJZy3uSATexLOlIEOHe9wSQM/HTlBtuKZpf/6ao
         4leA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696612991; x=1697217791;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91W3G0cEbqqRmxPXwGQ1t1R3vCvJsYOaB9Imo0LgEtU=;
        b=acF/TyhcjKaZ5lwQh5FzlQuqpvuAqV5ZAA7zZGwmWb/P8fjl+jKFQRNYDSrMLwzwUh
         Sl9EH5/acRTdHQ6TDaoEFJcxUWL/WkWtJ8sY41TUEGdUDxrhb92lbUy81f97MAVFNDEo
         zExeVibabpzBvgmVmlLTbaqcgwlIK2q/5JalZf5RJqAUrT1MWe+PNq6dnrrZxi8SyIEP
         NgMz6MY0WiC2vkZRdRU6bT5qB64v8lNZId2uXf69++dLK4qsCMe1I+FyDIkk7U7OvxCE
         VsvB559PqR7USG1uaAccJ2l0IZ72rkZ/H5GvEKOMdNgjsAOwXwdE29djCfvGt7Zt2v8k
         6qvw==
X-Gm-Message-State: AOJu0YxMkAhxkcJn6BanR9H9komleEtCz+t3agM0HJ3PMufEpS5nQWEh
	KI8Q/dsitkAC5AcvTxJ2SdI=
X-Google-Smtp-Source: AGHT+IFCGO1cTN5edw+2V4mOATys+PyAqaL62Y5qWGvXMNzZWrVIpId2KCZRfaxMCWapM1Nv26wZHg==
X-Received: by 2002:a05:620a:25ce:b0:76e:f3a3:4ac6 with SMTP id y14-20020a05620a25ce00b0076ef3a34ac6mr8463665qko.35.1696612991507;
        Fri, 06 Oct 2023 10:23:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p4-20020a05620a112400b007684220a08csm1433521qkk.70.2023.10.06.10.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 10:23:10 -0700 (PDT)
Message-ID: <4dd84bac-fcde-4bd6-be9c-dc2107cc2e89@gmail.com>
Date: Fri, 6 Oct 2023 10:23:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
Content-Language: en-US
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
 Darren Kenny <darren.kenny@oracle.com>
References: <20231004175203.943277832@linuxfoundation.org>
 <ec06c2fb-6737-489f-8439-307e0d84687b@gmail.com>
 <2023100601-ending-prevalent-c8d4@gregkh>
 <9fec75ba-a319-027c-6cf2-b65e703d3ce7@oracle.com>
 <2023100610-purge-pupil-b754@gregkh> <ZR_6Wl_pNbdF9M-k@sashalap>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <ZR_6Wl_pNbdF9M-k@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/6/23 05:15, Sasha Levin wrote:
> On Fri, Oct 06, 2023 at 01:03:30PM +0200, Greg Kroah-Hartman wrote:
>> On Fri, Oct 06, 2023 at 04:07:14PM +0530, Harshit Mogalapalli wrote:
>>>
>>>
>>> On 06/10/23 3:55 pm, Greg Kroah-Hartman wrote:
>>> > On Wed, Oct 04, 2023 at 11:43:46AM -0700, Florian Fainelli wrote:
>>> > > On 10/4/23 10:53, Greg Kroah-Hartman wrote:
>>> > > > This is the start of the stable review cycle for the 5.15.134 
>>> release.
>>> > > > There are 183 patches in this series, all will be posted as a 
>>> response
>>> > > > to this one.  If anyone has any issues with these being 
>>> applied, please
>>> > > > let me know.
>>> > > >
>>> > > > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
>>> > > > Anything received after that time might be too late.
>>> > > >
>>> > > > The whole patch series can be found in one patch at:
>>> > > >     
>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.134-rc1.gz
>>> > > > or in the git tree and branch at:
>>> > > >     
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> > > > and the diffstat can be found below.
>>> > > >
>>> > > > thanks,
>>> > > >
>>> > > > greg k-h
>>> > >
>>> > > perf fails to build with:
>>> > >
>>> > >    CC 
>>> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/metricgroup.o
>>> > > util/metricgroup.c: In function 'metricgroup__parse_groups':
>>> > > util/metricgroup.c:1261:7: error: 'table' undeclared (first use 
>>> in this
>>> > > function)
>>> > >    if (!table)
>>> > >         ^~~~~
>>> > > util/metricgroup.c:1261:7: note: each undeclared identifier is 
>>> reported only
>>> > > once for each function it appears in
>>> > > make[6]: *** 
>>> [/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/metricgroup.o]
>>> > > Error 1
>>> > >
>>> > > caused by c1ef510a0f2a879bf29ddebae766ec9f0790eb8f ("perf metric: 
>>> Return
>>> > > early if no CPU PMU table exists"). Dropping this commit allows 
>>> the build to
>>> > > continue.
>>> > >
>>> > > I had reported in the previous cycle that 00facc760903be66 ("perf 
>>> jevents:
>>> > > Switch build to use jevents.py") was causing build failures:
>>> > >
>>> > > 
>>> https://lore.kernel.org/all/6a577578-8adb-aa70-1bf8-b1a4573152cf@gmail.com/
>>> > >
>>> > > do we still want these commits to be included?
>>> >
>>> > No, I'll go drop them now, thanks for the report.
>>>
>>> Thought:
>>> It's not the first time we see build failures in tools/perf -- would 
>>> it make
>>> sense to add this to your own build tests to reduce the round trip 
>>> time for
>>> these errors ?
>>
>> Last time I tried to build perf, I couldn't do it at all so I just gave
>> up trying to test for it :)
> 
> Same... I've also removed perf from AUTOSEL for that reason.

I suppose that is fair, if there is a critical bug in perf, we could 
submit it "manually" to ensure it reaches the stable trees. Probably 
better managed that way. Thanks!
-- 
Florian

