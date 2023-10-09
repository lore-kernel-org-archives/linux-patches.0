Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAEF28E6
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 23:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9DZnIaC"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-d8a000f6a51so5467782276.3
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 16:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696893841; x=1697498641; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ey8nM6Nn9aQGlr1wJTzUAbOZq2jE15XKD/B2tE+waEo=;
        b=N9DZnIaCCsUhp2Nh9/5OJrWC7spxwz/dmKZIH+/+ZW3fu8AT7+X67B+bwVlU/FSIwF
         A9vaOcjtGtU220xptmydauVdY9f3ymQ+DLJ8Z6q/HuEJKw4J/VqRpinsEF4Dise2pgAE
         5Muk0y3PLu9/bbR1PQckhWq1d81wiH/Dt2ecXGwS+13Agfp0queMjmBqO4Z7YDOi0iDu
         bmKqtNtQmSv1J+W92Wd/RwCFkdRvNQj9T5kebPro8Z6xM7/0lwmACSORflKx1MuEWJP7
         G3k7FvVXomSUuNTS5FW3W80UMTkftUyUN6CJVj0g2k82PW8SKAViH4wejr2YFrfJRG+i
         YKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696893841; x=1697498641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ey8nM6Nn9aQGlr1wJTzUAbOZq2jE15XKD/B2tE+waEo=;
        b=o7tkkA6d4HnzQdhyaO/HwZC2wx0GzzvDHFSq7zZhm7YwMZGOjxni0yC7+NdkHjn9Nd
         l4JLDb++KhhANc91Ewp8A5DdkmczgoTVLdJF13ZcHwXj8YIieE1qp7nRBJ4lOJyC10KG
         b2YmZhRwtThBOO+JHTm0527b40MpbT8hwMmgt7OwuJWVl5tljYEFUswyEdG0LtfbCykS
         zopuMYOTGz+ablKOLU0uT39AGq8sHS9Vk/ZiaVQy3f7zv2HTO2UplC7RNmmjQ0+duwZO
         7AZRoNAXuyWcM4D+ZLvQmF8sDBCjdsq+AhyaQCYTzOXXzWOrqLDcT2syF8V+FcjQ5Q+F
         +QxQ==
X-Gm-Message-State: AOJu0Yz3cs73xJ1/goiWzuQa+I+wCLYe6CFo4SdG8zHLuxNwhejlQv3z
	1yTb1zo0sMraFGzYgFVb5X4=
X-Google-Smtp-Source: AGHT+IFZ6NjcILlhoL/fa4Ls67nKjcWAeUKBMb3C0lm+DoOQsAvLGSpfkgK+SC2Y326aFuGZOlpW8g==
X-Received: by 2002:a25:b17:0:b0:d9a:5021:4f34 with SMTP id 23-20020a250b17000000b00d9a50214f34mr723745ybl.15.1696893841394;
        Mon, 09 Oct 2023 16:24:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e15-20020a0caa4f000000b0065afa589bbdsm4220141qvb.66.2023.10.09.16.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 16:24:00 -0700 (PDT)
Message-ID: <8ff4a55f-a4f2-48d6-af5c-3f39884a1730@gmail.com>
Date: Mon, 9 Oct 2023 16:23:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231009130124.021290599@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 05:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

