Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8052D1854
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 00:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709137; cv=none; b=SLC6tveYodZrk5iSt3jlg1uYe7et9wpdghzG1PjQFBjnOneivfW41JF2VVf/MVFEuoUo/eNgaJ7xRn7sr5Z9DsPJE7cLPVu2LGkpxEvYmDnargHl0ouyOOPKH2w7F+uB+KFa+sQ1ajtu954FtQw0dC+yDo2qAAPPRyT8rz+TDJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709137; c=relaxed/simple;
	bh=1Exgi+JLL+QO+d2hti+19dm0FiYFViJaiPvbpGc8XJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cl3oxDjTIqp/1fmy76YXM5k6htOlalIsTDQ8WIQYAGTKEPA4BQ9Zt3GWMTEztxICY0s4bjqXwhMntRS6LPi6TxKH9UOOoc5Ni/19swV4fM7FSdf7JkrdjgldOPe/zy7EarMn0M/dYxqCX0NEAJomURVfx/t6FemV8oATKnWRtmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT35pP9u; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT35pP9u"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d0772bb5ffso142431639f.0
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 17:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712709134; x=1713313934; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fH2gqC5dLvzkZJc67eDj37ebZ1ZnAJYQHjhTciwIjkU=;
        b=fT35pP9uETsSpP8fXQS1kYb8hW4xWceERFdL9fwJsT2ZI1wO1XqD95JmXAV7e++uE2
         nfebblxNOivkWzQarrfZON047Sf4Z6xdmzgAShvzjlfzdmAXpQEYllPkM3tmBcAHG1uG
         4OdSakpWbBN8GNsEo9bAsCT3iGbm/DN3A4RHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712709134; x=1713313934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fH2gqC5dLvzkZJc67eDj37ebZ1ZnAJYQHjhTciwIjkU=;
        b=PgADqYNCpGVe0b6Xxo+eYUMzfGgQ4FWB3dn7FmE27eBU2V6ouF7S8NWm0qoHkfW1Wu
         0Xk9iBUFe3OAst745/TMFOQrOUu5S7+ZyGosj1JH2pRPo+OFcLxA2Y/Ai+qzDq2u8LRs
         PTl7cELruX+d6W/GDnRIAYGsgfZLO8LJzDsjbV1/3PeMVUSyPbyrt2YCRiPp0+Dpem3j
         Bs9H/MxOVNguCRGjbZOlmZuJRctnhY6S+m5cruA5OL3EndVDexirpKEh+NHL7PUxWTJe
         hSd4lmcR+usLpgjZq9wK73Ir8K6lW3lblsWniRfpT4IDYqOeBAa5sFYR8gzfmj8vyiPR
         Ntmg==
X-Gm-Message-State: AOJu0YxxY+Ojtf4aWZhGNm3Tz13K1rSVl2eH1zon9dZKAzdOBtZSFhsP
	FnIBdHrOvo7YvL7VEHHg5iQSmz8f8yn3ULP9AbJRq8wBNatyil3E0u49nLof0Z0=
X-Google-Smtp-Source: AGHT+IH7BSYmyscHz7vHJtvD9eJkudLF4tWaNfGG1dnEvB6mShpdylQuwZUbV8Oy3sTctHyrzW6kVg==
X-Received: by 2002:a05:6e02:1d99:b0:36a:38bf:5fb2 with SMTP id h25-20020a056e021d9900b0036a38bf5fb2mr1612736ila.2.1712709134686;
        Tue, 09 Apr 2024 17:32:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id p5-20020a92da45000000b003686160b165sm2843156ilq.75.2024.04.09.17.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 17:32:14 -0700 (PDT)
Message-ID: <99cc80f1-9ea6-4acc-a320-2cac6f7035df@linuxfoundation.org>
Date: Tue, 9 Apr 2024 18:32:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/690] 5.15.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/24 06:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.154 release.
> There are 690 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
