Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B794C346E71
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 03:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773372191; cv=none; b=JWE6FWXtHJFNoZ8jbU3mdgC6ZUoeFjJM3vBQqDYn+gR5hxJUBVP9nHSuONBldVOMqRpC+qCAesqN2O1NFGwbWzGQHv9fXamhHCnGbzdWP/6p5DypByebzcJBEcq2YLg5IoUAdQ8YXB5HX8LWZe42L9ojCH9Z3reK4ukY9Zx648c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773372191; c=relaxed/simple;
	bh=iNtx4cifbRl2Sc8ccWVKiU5qNr4l0WUDIo1XKZDWgNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jURz+ajceIijQiJdknqP2sguCy1CosSDyR19MYv8ZZdDO8vi/rtoH/9cSyVy6lSEi+TKoawtMIUDHQpLcxo+LNhyWMXME9oWlp/RFNlcg2mfv6KqFHXmQ/WNOw6nyrtAqgxCXPgzEo+hXdtVfwJi6A71L+NmufMFWdIc4ZJFrpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wymzkmxp; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wymzkmxp"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5091d71aa11so21899141cf.1
        for <patches@lists.linux.dev>; Thu, 12 Mar 2026 20:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1773372189; x=1773976989; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LIZxj34/6tLtqQGtdBOTqFM3e8/L5Xb8WQCotKqLWvI=;
        b=WymzkmxpENBC+X+X0MMM5xWku4EWiznkzzhhmwm3CqCWcIGy6UaU2cC7FYZCS/3l51
         axMutApUgnbolmA8vSt6kjCaUBol2P6njjlk30XQamAvCJplO2T9J+EyMdKWCnjrpQQv
         wapgfhP73lFr3OMQxSXEIOHDduLt7Mr/cS+3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773372189; x=1773976989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LIZxj34/6tLtqQGtdBOTqFM3e8/L5Xb8WQCotKqLWvI=;
        b=IVgnykx04SXsWXN9DWp4CqtB6my0ZL501QZhjdBc5TCvfKnK5TbYEHNjur3UCwV2jF
         /7dZsi5ELGZAHcA/MmlkN8MeKW7+hfzRH1CHnvzDj+RgKnFwT4cwC8a56R9vDQ+BoBkg
         UIP/rdlPUlTr4SWnw8uOMXr7B0AmQpYvJc9wwPpgbn2VCbDQr8iLt8dK0qruOu12zuNa
         5vHYT2yZ6oeYQeAnNWVeoGELhaHy3yDacJvB/0tmqc0HeUAmquCXa0ZYNK1Z/Wg74+EQ
         RpttEaWHxtP0d0npc2da5IAtuKjm/AVKc+dXrYSRUY7ewGrfjvEWW8r7dDo2wzTin6Rl
         oaKw==
X-Gm-Message-State: AOJu0YyjS47uMDmjK4Ycn4ua1qFthA8jwOmqkl/oGvLJXH86xfvTPK0y
	2py/aHnD52MvNHwXSl0mFytNgipdbmSuzYm9u6Y4bA1Cz8ZFp4E7/sUaVK8Ng7Qq62A=
X-Gm-Gg: ATEYQzxvZDrGzro4BBM9k+L4+U6TLTCOqtRPgtNzw8xsnjkYs2a1cywxGhEePW71Whv
	ee81MipimnxZm214xSITslA06JouEDaxlptJr2x+LmjFAJlQ3QKPEclBVjoYaSMaAXo7jdK5XL2
	itIrGp4CS4Mj+s4I2Gy42fXnaxiGNynvvsgp6lE9JF0o5nLBvjbfvxax2zrcFz2zcvW3LvIqVON
	QvnXZH3YcUbKfwZq+edW2kBXf/8GiyqsZXNfwr6ecjGTSWSlpA28yI35+LiFxIgEo/Gfvuvbqru
	1DjeWTICsxL1kGhvwaSNMKgL07YuL37lnQb/R6rZrdwUoBUHf6BRzj8WKheaiBie7BVVT8I+Nmg
	1okKCrd3smkCi3rd0I4W8RHshpN3VqWw0nMpcuiYXXCe5rBOBJ1RG+ymlL2F9yWc3w7xSEQWryU
	wbLokomG2HBJzRt87n3aJNvquR9C0nnAR5y2I=
X-Received: by 2002:a05:622a:5d3:b0:509:3fc5:a840 with SMTP id d75a77b69052e-5095717e1bfmr27668161cf.10.1773372188701;
        Thu, 12 Mar 2026 20:23:08 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a14791dsm46384471cf.31.2026.03.12.20.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:23:08 -0700 (PDT)
Message-ID: <90590550-cc47-4eef-aea5-64e0df96f8cb@linuxfoundation.org>
Date: Thu, 12 Mar 2026 21:23:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/13] 6.18.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 14:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.18 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
