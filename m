Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255BAD49
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:20:20 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-68c576d35feso744644b3a.2
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 05:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695298820; x=1695903620; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=bRKrkoX546m0rrXqj9LX34in6kCX9Nm6R0nAMVnYoZ8=;
        b=Fvtz8xNd7GkiV/3+mt7j4QbU7fsPAe0ee/lcaCaggycqHF1YTjzNb6IrNKttvj0tMm
         p3HSffg27B4TtWpY4NZm15ho3HjC2nh8rbAuD3GBIXq90QDNIJhYA2XmDUlAc74FLCmH
         YyYcv6a9nurxEf6/HUARtUPCEDUqDjdwnKgZ3nfakHl0I9knL9vrx+6MYo+ZelPMEaz/
         OBYyoE6U241ed3XRccU3+E96dNK6TnLbZHli1qhS3KyFNSwbopjCsBYKv7cCfR7ypdJU
         82m8zyXIHT3vMZ4KQeRd08Fh2kKVNUguSv/tzQFPL3EX3iNpB+8LC/xjb7dLnWdLGaT5
         P13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695298820; x=1695903620;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bRKrkoX546m0rrXqj9LX34in6kCX9Nm6R0nAMVnYoZ8=;
        b=QU0FXiYtFSVTXxnTGX2XbyzctIyVkH1PAI/F1B2F+R9uG0Pcn6MnwtgnEER6PRC6kz
         Xeiy036rMi2y6ecErNwT9sfY/AH+Iy687ZsM6YrPxSsVxicEWr8TzbwsNbd8ef/4bnoF
         ysYxrT5daaz0uDfZxiwlWERsLuo281rQ37LPG/Uf60h2LKSuGo30QHZ7DOKOy0eTsK5z
         J2LpT/2l+9FtvgsVzR0YvcPIW8fAMbzdPFtarj3PKo0ZvvWDhiV2ji/upM5Sad+q6Xqp
         XxCOgX1AMWFOeC9Wmj8WpsBRvrfAsDNQsFnGpPQiGoZfTPJhzneiov0TVJtk/u/2GwtI
         ia9A==
X-Gm-Message-State: AOJu0YzOhCYfnuNq7OBEpmVEXJwkI4/rE1Z/+QiQ6SFWkwa0YAvxHlsh
	edmoD/wopB1ptma8NxevgL8=
X-Google-Smtp-Source: AGHT+IFXkcZZ+FrJWIgtoDVWXF5W0k54s49OSuzsR2iFUk3hqay0ZRvvpO/yos/ac4Y/QrCf4RUZng==
X-Received: by 2002:a05:6a00:3697:b0:691:2d4:23b5 with SMTP id dw23-20020a056a00369700b0069102d423b5mr1600110pfb.31.1695298820050;
        Thu, 21 Sep 2023 05:20:20 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v3-20020a655c43000000b005782ad723casm1067235pgr.27.2023.09.21.05.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:20:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <1885150a-6caa-8d92-f893-02bdb5ee508d@roeck-us.net>
Date: Thu, 21 Sep 2023 05:20:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.4 000/367] 5.4.257-rc1 review
Content-Language: en-US
To: Florian Fainelli <f.fainelli@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230920112858.471730572@linuxfoundation.org>
 <166b5b43-adab-7d00-e3f6-c9a1dfd29f52@gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <166b5b43-adab-7d00-e3f6-c9a1dfd29f52@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/20/23 10:21, Florian Fainelli wrote:
> On 9/20/23 04:26, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.257 release.
>> There are 367 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.257-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> perf does not build with:
> 
> libbpf.c: In function 'bpf_object__close':
> libbpf.c:4205:15: error: 'struct bpf_object' has no member named 'btf_vmlinux'
>    btf__free(obj->btf_vmlinux);
>                 ^~
> 
> due to 34d66b750e83d49c7d3d33d59e6a1b49e0d5db15 ("libbpf: Free btf_vmlinux when closing bpf_object")
> 
> the btf_vmlinux member was introduced with a6ed02cac690b635dbb938690e795812ce1e14ca ("libbpf: Load btf_vmlinux only once per object.") which is only in >= 5.6.
> 
> Suggset we drop that commit.


This problem affects 5.4, 5.10, and 5.15.

Guenter

