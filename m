Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C9A2C9E
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 16:37:43 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id f1so12262248qvx.13
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 08:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PK3I727zzaQ8oJhwBvZZe+bdq34vFA8KkZVT4eU54A4=;
        b=N/OcUDSZrw2hKTDAppnELEEShDNZbuVL/9XrJBldl/IaGqGAFH8Vw6yw59w+pwqAzR
         3yj/vwxS35SC3qtpmaY5s9ifi8Q10PCb2BxebCfwGfueviI1uIkhrCzcnb0bSqqwm/aA
         N4FCa5FikS5OYLsEH6qjy0YJfsI5gBX97n1ngq/+4hxf1T0XKW0q1E2Ym8BlMpry801a
         UHaqX+kq0xGwrgZEDrCcxo0wAbsVa2LbkpasmlbqmTuSDPBIjgr2kAZf9K2dP+8jCOmI
         ejytGNJuEW5h2sskasqLTAHOqSaNAkH7oPYxDQFKI/eZS4iH6kH2kqxf5yAdnIS6KP08
         Ohbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PK3I727zzaQ8oJhwBvZZe+bdq34vFA8KkZVT4eU54A4=;
        b=H0PwBs079sfVqYbOilVaz75gAlqQ5gJ4wR4s0I/KTSV/XwVEzPID/cJD7umf8RUcMt
         rHNUlsxXIArhgeLPPkJIYG8FYEZhXWwact+vKvkWw9vSUbABHYNXgM9Ym5mWNMyNyC18
         /JomZhZc/RzunPxOvd52IU8Zkz1YihEDGHcHTS5UUEuQqHP96fStzxu5fRHm6NND08yV
         4QuHP7oYRXNXlrsgNINfcg6dMWZmspLMYF3pWlV8m8ivBh1i/W8EjMxS90weZW0lQo2j
         CFUnHzMa+yzEKqIiYESjWO/2q0l5YJ1VIFQsGRSfIqeJNpVi+PxD1vlqOSJP8A6L0q5j
         oBjQ==
X-Gm-Message-State: AO0yUKWx1rl9P4shZUfoYfiw23qCReDSZ0rKj495uBMeEZccmC+2lJ1K
	+ZpZ3uYYmS46qFVXipnSaR0=
X-Google-Smtp-Source: AK7set8awspWCvk1R/MdOkgOMDPcx7oJsaZKo5FAewRYWHDzLKbq3PHirXykbdolKgSfgxdF0nZJUg==
X-Received: by 2002:a05:6214:f6c:b0:56b:f28e:628a with SMTP id iy12-20020a0562140f6c00b0056bf28e628amr26999370qvb.6.1677170262157;
        Thu, 23 Feb 2023 08:37:42 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 3-20020a05620a048300b007290be5557bsm6883589qkr.38.2023.02.23.08.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 08:37:41 -0800 (PST)
Message-ID: <b53ad4fc-978a-b883-0d09-2a9306615a66@gmail.com>
Date: Thu, 23 Feb 2023 08:37:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y/eVSi4ZTcOmPBTv@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 08:33, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2023 at 07:36:39AM -0800, Guenter Roeck wrote:
>> On 2/23/23 06:16, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.96 release.
>>> There are 37 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>>
>> $ git describe
>> v5.15.95-38-gd6f4f9746d40
>> groeck@server:~/src/linux-stable$ !ls
>> ls -l scripts/pahole-version.sh
>> -rw-rw-r-- 1 groeck groeck 269 Feb 23 07:33 scripts/pahole-version.sh
>>
>> This results in:
>>
>> make[1]: Entering directory '/tmp/buildbot-builddir'
>> scripts/pahole-flags.sh: 10: /opt/buildbot/slave/stable-queue-5.15/build/scripts/pahole-version.sh: Permission denied
>> scripts/pahole-flags.sh: 12: [: Illegal number:
>> scripts/pahole-flags.sh: 16: [: Illegal number:
>> scripts/pahole-flags.sh: 20: [: Illegal number:
>>
>> and all builds fail for me.
> 
> This is a fun thing, the patch shows it being set to 0755, so `git am`
> should be doing the right thing here.  Let me dig to see if I can change
> something in my scripts to resolve this...

We have had this happen, last time you explained that quilt did not 
handle the file mode:

https://lore.kernel.org/all/d1a46ccc-cb07-fa51-f722-c48d6c84bf9d@gmail.com/

Anything we can do about this?
-- 
Florian

