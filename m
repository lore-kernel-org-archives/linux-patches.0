Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0A2D6407
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762903709; cv=none; b=MnAZIYwXiFYtiLEN+lf29KAzVFcazUOBlqL/CLI1DsVcoGbE32or/N9P3lgcExz7GdNTNrTQWEGzbkbi/oTzKJK/L+syoxnsNr4Mj/y1EY143+wkqgpvyYWycQyUNIKzjU6GGZuaL8bBTrJKgxgg3r3YeVk6gsjMT9+T8b+W4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762903709; c=relaxed/simple;
	bh=SBZkH1SK4zEtlic0reoqSi8cs9YBp2mCAARzFUtLSMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fcwyznbyNBSFZpuLtUecVCqMVCb+j/YIkOl2OU7gvXGYiFLg+7DPFokuryKVkdDuWT5SikKMd0mcq+D038QBH7ufWnkUh0IJ7D1ducKirQfvgLJWa/iaPUC/vaHigRy7aUIDQ9Z7+ver7+TPdwhiNOoWP9M3XOwcCpHJNZx68qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIjwZ38t; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIjwZ38t"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7c6ddd07c5dso90019a34.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 15:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1762903707; x=1763508507; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wdmJPBDhXZMh/Cf/AbsXERBVSsuyRqEl9m3+Psa35qo=;
        b=IIjwZ38tz6hjTWzpsz/nKNu1RMX3PUzyUF6oupP0bpn1glpFygRoEPoSGbaSgQgH9F
         jgUYm7XDXG/UyOKWwalyGDwGfejifxi/bqB//GA7J8VTCNp9Us6JqkUcHUXVcoVdIGOd
         yBHhi9zvhOplWi5fTJPkRm5c8hZlvvAQzGD5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762903707; x=1763508507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wdmJPBDhXZMh/Cf/AbsXERBVSsuyRqEl9m3+Psa35qo=;
        b=gt2BN9og9peTd3xeUiTVFIvl9QKg4FHe4DaD1/gjZ6MVtFjZGsad5wfDV7JesudZo4
         sJr4bmRWb+2+3vOD3Z24kkbTOba0j7bNJqJuT81gTHR2GK8HH5Et3CNRo6wBXZzxvC7N
         JcKuTRIBQZyWi1p0NFr6IGHBRYjuOHVK4Pd/E7c407gwW1uZy4319FUPPMPoBTmoBa85
         D5InkIhTQMotjTTyvB4FP8a/v7jk0xw0U6ktE7I6gTLO1S5NPGyZ/3pV5pHmhot+uEI0
         dy7TyHF62YTIw7t02drjUo3BBhA3pKJlTR5R80VPHfvQ3EBfSa28eTMA88mwN3kVaWB1
         1Zjw==
X-Gm-Message-State: AOJu0YynSNVOuXZsXRdsMoKITLEDUDlRjWVbLwaydvCmO4rcZm3AV9Zz
	kF+1wpjSb2tc/MOVZZYjCY0X1Gu5ZWPZUJAvsUW5SK8SYR2drpx9eudOhCDiGHU2YX4=
X-Gm-Gg: ASbGncv+1tVp58LwlnLNhimquW0dVwlhgnj6haScMEbVLFnSQ8q+bTRMLXoSSywNGNG
	kGDo8BpK/FZD1M2GQGwDv30VzqW9UiediGvXEqkKMPeERCepevZCi1FVUUTu/lRXqPUMgaY0X2v
	rtYJdMymUqJ75VwZ2uPaGTxldRwXD24Ih47NpzFweFBWtNrJYETIYJB5InQmQ18If0W5bHyL/VV
	Als42AR3T74yMhWx4CW31U4k0zQqE9kdSM0yFqFSJtcp6MdT+XrzsoMhUaQXnYA5q9gq9S5MJTl
	ixt3T0+aj8OypCp5Qtj9X0a/0mOioIeu9p8CEprbAtoiGMeE3u388kmi9uVp8Ku3pzcDRo5UKnF
	T979M4CIHmPJ0In0kiz953doeS1mqoACTS7H911yiVBZ1yDseVUWKiVU9+K2FB5pjLEt0VF8mHc
	sO6aso4jSUXdAc
X-Google-Smtp-Source: AGHT+IG8L5zMLS2ATSKI/dMgNAQn9ETt4P219H5Z9iYMUxj68WRlOpHr2wSz4E3cI0EJtHnsOTWVvg==
X-Received: by 2002:a05:6830:6e98:b0:7c7:1e8a:c9e0 with SMTP id 46e09a7af769-7c72e3ce55fmr509116a34.23.1762903707177;
        Tue, 11 Nov 2025 15:28:27 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6f0fb491asm7617540a34.15.2025.11.11.15.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 15:28:26 -0800 (PST)
Message-ID: <81f3e0d7-2625-4183-8d42-46fc4deb70c8@linuxfoundation.org>
Date: Tue, 11 Nov 2025 16:28:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251111012348.571643096@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 18:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.58-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
