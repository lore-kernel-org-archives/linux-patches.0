Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A48C27B352
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218874; cv=none; b=LiDMLi756F9x120lFXKc+azMS+vldFv0JU4oF0kqymBkmGG/i9hQ1pGsoNzzMN5tsQoy5BccPcFA2G7XIUltG5L3+o23ds5JauRnFzNSldaIKOOb7CyNUnVw57cZacoRWtcHSnWrIuSUPO21YuHVvneagkaLzvbByBkBDwg+pRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218874; c=relaxed/simple;
	bh=Ihox7KjQM6+mVvo9UNxDhOw4q7HzSGfp98T4jh9xaNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JkEAhAPmqz9VBl1riISER8diYLjzuhpcyEZ6hSKS4IlIJJCsSVABAUJ+kGpwEyoTJ/pL6OB5tX+GD2YPp087y1IIn+GuqnVAyfq2evVODwFEw4+8bYRSQjiXalLSrERithek5BwFRry8d1zyBNeimSvJt78EM0O6qV6kC91eR3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ8PMwk4; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ8PMwk4"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5488c409d1so939483a12.1
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 11:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758218872; x=1758823672; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KDyW9VZMla/yzNH/VDc7UN9+phUtlhbd8pbrMSV+Eec=;
        b=lQ8PMwk4ecnsJAdkh3zXBpoFqHNcNsWfTdwYHdIwIhorLbGTzaMJUK6DMw1u/XAmLL
         jp2pcsVJAa4Qdq1I0dHoaCJ01hCybceVO6+tVxJi19a5PkLVxrYF579pJbGa/jP/yHuY
         75YrO3pESyeZDR6zQv/Lr3eSOydt0P5NZUVwiLxhb02rBQxmi3am3+D1mIwFExpSesB1
         GSadqsVAOAIsKSBzbrPKWk1LLtNRP6FkBSOgbgD3ZehYsFMI9PPFin/6rYFurnFhyjGl
         7bhWwrUOOaBYmDKEYiLKwdBbN1pOrKtw+Z0l4CJ1NPAamD/yaYO/gj25rKxqteSKIZJo
         Ti/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758218872; x=1758823672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDyW9VZMla/yzNH/VDc7UN9+phUtlhbd8pbrMSV+Eec=;
        b=ds+Qvs2a2Tkt/N62hyVvp80kaVG+Uwo/U6bYffGjKbYv3SdlKbh0/SNxZpxkduPj6+
         YTnOvLkZy5MwYCPzYm9NfQiFH8GBKMpVZG63w/YEH28e1EAndaIQTY+01HKmXkSvqu85
         lAovXLQwOB/02utoycZh/2Vi7J+UknSd32HaNHcGpwIij8DrV2Zv5v8ZAaGuain+BgK0
         uQulxJ9W/N00lf0KCD5PyGVcKrE3rFtHAiFxIe9FvpvGQpbfPVDV6UlaCnBYILhfqSZJ
         B0Q57a4RsoyMxCTggbnAYgy8ig6ZggToiK6Yj3HIX5mpjP1I33dXNd0urpq/Jj05NPoe
         2Q4Q==
X-Gm-Message-State: AOJu0YyXedklY6YZUIjPwYM1OSiqM7lApWzCVOWQUuXyWQtkc3u9kHru
	VgJnXWgOjKYuRJz0f9vfV0SZOcozIChYRda9Y0mQ+Qt3f2hamfcXWuP7
X-Gm-Gg: ASbGnctFpzkm1d7XFj/FExbYs/uLa9J87o7tFdFPqEr8TGK6dst/6Xj2CFSOSOQbznO
	HdioVFgWt5doWLwEmsVsek74yXZFKJvddFIFjXERhbhQ/koIJ8M/a22h/evHgKA0YK6dHkbudu/
	A+WO0OrJsIBMpfaWWFzn2/xZHgRqbfXa8qO8bhQ5oqxntLPDsBrahVUZX+EPDqBUpcF5okjk9tb
	XSjdiOyvyig+ufiXb5MbWoD6fqfy/bm5LZV2ipE/wVsfu/gXe4Np70NCivDH6UBP/EhZMyo8MP1
	Mi0pkJfwKGlNp1AWKKXSsSA2wpNdIpbRjXny04gSkW24Ww7gXcOk3vqkvNmBsJ64+1WyOOAFgen
	zWFbaSqva0tGHAi/azoY46wfAJrTOMsvbabJ5IkcIVzMusoqc8bqIxjFPA9gR3qAVG6u+8SBydg
	U4ygR+RQQ=
X-Google-Smtp-Source: AGHT+IHnYW9s9Ywm+C6BymDJxSBWvQwRe1XoOyZiFCn75JFtSI+lA2DVnxrrNWW5YZylSz+6+G1gEw==
X-Received: by 2002:a17:903:384f:b0:267:e980:da59 with SMTP id d9443c01a7336-269ba441db0mr6879635ad.20.1758218872257;
        Thu, 18 Sep 2025 11:07:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5510fd4872sm1270927a12.32.2025.09.18.11.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 11:07:51 -0700 (PDT)
Message-ID: <10179c40-595f-4dd1-abc1-d6ccdd0ad7fc@gmail.com>
Date: Thu, 18 Sep 2025 11:07:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250917123344.315037637@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2025 5:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMST using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

