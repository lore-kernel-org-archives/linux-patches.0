Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F45347BDB
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 02:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773369931; cv=none; b=spbeKvjbTjau/ER5u81BKRvVkDM8XAEN/PVp3rLtg1DaA1pNd7/Hln64ovPLDExGU4GrBK+bXU7AdX611LQh01cSgPNejCc6eVT113jtXMh7E0ef7tbECg4oFyUW8j7VAwuf2AlZGZ8yNNeykUd7TJrkCz4DY1RoBejLZfiXF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773369931; c=relaxed/simple;
	bh=giTsXWYiMmee3pERN9Kh7gFTOn98G4rPfrj6r3VgU6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nR4W8O/Yorr5D3YKXIgJiedUAkePJo7e5zHle0A9QKfLi7Hu2dqZRB5xS8iX8HN3C9HgA4aDM6f6ycElz6V1lAir1jY8sqWQ/SF10siAu+1DyP+aP73LheCia+frIRNhPBampOFhkvrfXwUN0G+sWkCnwYasEXrCRnk2xCYeyXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jcn2G8ZY; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jcn2G8ZY"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd830404c2so173911385a.2
        for <patches@lists.linux.dev>; Thu, 12 Mar 2026 19:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773369929; x=1773974729; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U8NQTwBNhkmEHjj+/QCO0V8kqmBWWveRFnSlOxGSXyc=;
        b=Jcn2G8ZY3Z3NhUZSDVexqQgehpVqdLz0M+Dms11/TdIIk/0Q1DRooqyGskO12v4y4r
         /Rsfp7JFflImy6A4n/rTn25OD7G1ABZ3JemwP+5csSvnURZbjaOocspIYuMFdnbvSJw8
         X1NzrA0setfIN8vJx3k61VrmVYxjH0oMFT/C0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773369929; x=1773974729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8NQTwBNhkmEHjj+/QCO0V8kqmBWWveRFnSlOxGSXyc=;
        b=DWy/0LLKEauQ5B3AlUDhFbV1Xr62VORcPExj6W5oIFiXv3vPn7gU7C/1xCXpei9uEp
         Xo/mbh5iekPlwpYivQ92Um8YNkUa3KetiX8GzniKWWs8hyKlUPvBlZu9t8CJ3Z6kpM0U
         YEWli1PUZczP6G8QmAXsr+buXhm+8kCyCcrl7Dgj6EHbnhTuo6iwJInVnjBOb9WMgdHc
         4hsF/OI18KcdaLQltmwMHgd17WPPD6cTDVmEDyr62sJsLa01BY2zflSWoHw2DlWvlnCc
         hSzrLFxGbdf+9cKGQepsyPL7tnL3KNzxueuDXG4S4QGNabtUYSTbv7Tc/zGJgj3TMFQg
         6Eiw==
X-Gm-Message-State: AOJu0YwQAPDQNjKQf8wUqeCI4jObGyOBivYTG6WmrCGgPZEOB/D6OoxT
	DD+v/dXgruOIrzpeU+rwd76oG3jX/c/xYsrgYI7cOrSdgzMRlQc4pBssD/6o92A1Zkw=
X-Gm-Gg: ATEYQzxqgOReFP8GPh3yiCUn0SmacM6Tqc3kEO8mvTbyqAU+ZIkL824U5raWtHO3dkp
	B6DIYRXeTGxsrYhAuUkWLKRNQlT0v/rUXUd7h0E1f39jb8J6t0ONo1wnALG0bzIH3OVbhOoPPzP
	FXGUZ2y0NhQiSc5IlWLLlqVsRXtQuC7sSDWLm5f/FnxGokeGdz6P4oO4PbwZ75K6nOX/WBuk26c
	ldWcOEEM8j/4HT/r3DUGe25I8ex+TnjL0DcuGjyp/V8jHGDE+K2rJv83xqyyfueFcS1WGJ+CyXs
	C4tqN1WAvNQtZGIfiENrBjryZv36xPTdMfuuZyFytJ490fb7+C/PSKgPg7/+WFWCyAglE6g/mnE
	JWfy6DKN6f4F2VH30lN/RoEUy2CQ/3nWQUrJvywwb4r7q5b7HBfq8Ps2Lad4NaXt+9SBYzy+4WE
	z5c/hwAJkKB6wBHP/VHPrCA8ycAG99n+8AySc=
X-Received: by 2002:a05:620a:318d:b0:8ca:123e:819c with SMTP id af79cd13be357-8cdb5a9e994mr293434085a.35.1773369928677;
        Thu, 12 Mar 2026 19:45:28 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda211036bsm494717385a.23.2026.03.12.19.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 19:45:28 -0700 (PDT)
Message-ID: <1c15fa4f-9017-4c03-8c1b-35b8ffb37524@linuxfoundation.org>
Date: Thu, 12 Mar 2026 20:45:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 14:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.8 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
