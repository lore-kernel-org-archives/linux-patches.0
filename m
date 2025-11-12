Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4B929ACD7
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762979253; cv=none; b=p6TGMdwr34iHLqsif/x2yARSSjq4jZ3ScOdADycSUyYpRhH+j7sM+WV+fUfZCF27m+mIL/lABnTiT3CTMF2VNaLzooH/BRUCHgSzL+jPoK4ghftnvpJczYJ71i3sdousZ+rVCtV57EsuOE0KmCfjc9oJ5Caet+LrvqU9q7pcF4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762979253; c=relaxed/simple;
	bh=7q1Akm6G1W0g/IxIpcjEst+vGH/xiknusbk3UIlJLfg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=KdMc/6bRnb4LAYFaKb2HaLjWQNqwN5OvhUqeJy4DlxSnnclpIXrWJd/Wu/P4fe/lUevo+xc+UUWeK0icW58PjigvBA9qaCN66G6BjmyUROqJAgguq6UlR2Hwt0pMggz+ZzlFbfoOiNIclZxpxHcAoETO8Qwk2F+tY+ATtRmQaG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCmwYDU2; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCmwYDU2"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so40183b3a.0
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 12:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762979251; x=1763584051; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oLIWcbWTGCm6uL0osnPTfQ+TcowsSwsqY0w+FwgzNBQ=;
        b=TCmwYDU28XMR8N2GXbqY2zCZ3qZ0RY3iC4Fg3ZSs/b6nIfEpQWs2GfGVK7Hsh+EIVc
         pOGuyVM38KYll0JHQ/wL0ZstFJmduZ3N5GFQsuW+thO19UIDmkzScEzsBxaa2WW4/olh
         ni16qHbMXLoEW++FZ61rF1Y0Jln0wk3YJI7U9dJDYWdnm+L/aMxEnONPMbI7j/UE7KiY
         2ikdMEsTr24cTPzWRMl294NyLH7PXjm+Yy2Oyjfo4LumV231jUTwI320xv/qkDVMRFod
         oWXyEcjjRqMX6E/X+pCRwA7h2oxEJsEJVVpGgL0l7+Zhis3WlXUMKgsgvYzZWoTRQW4D
         /YWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762979251; x=1763584051;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oLIWcbWTGCm6uL0osnPTfQ+TcowsSwsqY0w+FwgzNBQ=;
        b=LaJRio1H/YbAfUznV39NcBdOZpGG1wUGDlKcSu2Sb3NufUktHFvAQg8NDNvQYS35Os
         sGWb9kI7UG1mn8zOHuL/PkKmGeLqp+PoACH3YwzYGCQImDZFMgXVn38fP0kFQuoHwa5i
         sSN6Taf2s40nm2ba0wEYvD1/Mz1oe2GXp01d/XX5JISgBmVc5C0MeiHpuWBUsI+KbWNl
         IXoa9Nqo9DKi/xQ9uM1+2ME22D45H6emdO+PkDjZMS9FXvxteX96LPREy+VA519ykowz
         UONq6TT9KJ1VxqgxY3NtVEBEfEMFhlKkX92+ReVas2Puo7DzZfd6gVByssizmzLWP46K
         t8nw==
X-Gm-Message-State: AOJu0YyC7LMLKTFSMHOUKYfDfBNi9vGs9q30J86wMLYpD3p5AwxtNeCY
	A383BwJpQd+Ibg2UWPenK+DIZVeXnPJdWRNT+QDNpkaMWJzY7ODeM+qb
X-Gm-Gg: ASbGncvLBW7hTAXffrZfO1Aj83vShZrZOpiOZyx50u/riOsAA4XPlSeSoDoEX7tECKH
	0lC02KsqwO2Dv+pxjQLGClQBcxCEXzd5jE+R5jEJfslKXqSpEz9VEFloYckcb2MtZWGysgEuf+s
	xsmua+SWOr7I8ZR4uhmw+zviXhyjoZMPtzkC9h8vL71z5Zl8suSWAGByRo/yKrVPENW51URE94f
	Oxt4aGsGI6MEDKPdIiroo/LK4SjFVb9G4YE2/FpBWaMNKqMBJLpeLSaX/Cmsv6egBFeyMZV8mpU
	VLX7VtanjVMNg6R+pWsz8Vt8UytnB9C95o5hqXP6VVbrDmHBmBJevePmbtWbvPvuxy1zvW+MfGt
	OO82JSu/4TCtzwQ7Jm/FP9praDj24jGNNBV0tmWI/5zKsq/s1nuSpnRVonfbA6l+IDo0MqIclG5
	rmzvWZmgZMEkNi26vSogvTynMWR3M=
X-Google-Smtp-Source: AGHT+IEqazzqkIX3gYmP/DkKutcz0SRgO/dq+RYXdbMvGVvreBofbtZHJyjGdltxbX5JSPzLOyM0Pw==
X-Received: by 2002:a05:6a00:2e27:b0:7ac:78d6:5f00 with SMTP id d2e1a72fcca58-7b7a59979f8mr5096934b3a.31.1762979251264;
        Wed, 12 Nov 2025 12:27:31 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17a688sm19823767b3a.40.2025.11.12.12.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 12:27:30 -0800 (PST)
Message-ID: <c3b7ce6f-aa06-432a-bbf6-abe6e1bb552b@gmail.com>
Date: Wed, 12 Nov 2025 12:27:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251111012348.571643096@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2025 5:24 PM, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

