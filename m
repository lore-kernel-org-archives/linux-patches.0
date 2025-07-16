Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A3293C7B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752692267; cv=none; b=Q8sRykugxbgcUFSlogAFg5VpyFbBtlkACZ2HDhwBR8SKomoop8hf8KbO6iCt89B2wMprcqhS+v/yQzWhkfw2WjXMqc2jSx0sKg9qZQvo7aV9DFIn+TwqpZYK6+rNnm2Iz/GLmDdsr/Nck8q8Jol39SEbMZD8xKnjeMuGgEk317w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752692267; c=relaxed/simple;
	bh=2VQaiE2f4fpyS1+Nvhu3ATDxCZ8+tmewullTfLLoYms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYbKLRfHElPb+EbBNt0TNB/3PqTlxo6k+lTV22jQuyrcnC5b3Ursb8h8ngCWtikM5IpYWVwywi1nyk36qPx0KiKUnFrdPpPV9cvawbguSt9VCLO34HtA8PLSBLaT4PTJB18ZcKevBI24QXRpSUbs8YCpWn/RrxATlsD+IkpqKGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UsFsMjlE; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsFsMjlE"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e2c1dc6567so11082485a.1
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 11:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752692264; x=1753297064; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Nlc8B6S4byi7qqYIr9GjvMiwX+XsyRJI63r/10AmDZs=;
        b=UsFsMjlEToBrCPuO5vzBn8o1UMC1dyEunnl946Z11uAYcu37b6wG7AANNyyidf9azm
         3Yj9D0istNV7SVUc+A5AgxMQxdC7VlQmOW9Hej11g90SimVLY5AGM52pHiiqlqtfHV3J
         UguuxR0WdPBy3JbyqESqw04IvBDHgImSszaYnQMSuuNQrq0IKnRQPB29fnDub3O3F1xQ
         ZwS9DTdq+TtNTMvv+HvPKo8VCUFJh2T9h5OIwjk6/InxNoTK01bsXoTw3B9HLcw21J1N
         +16BjpbI1yFuiiTa8scyG6rdpLaONkWRS6eR431WcwOegiVZzapKQwE5uifMO+Fz1QSn
         4gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752692264; x=1753297064;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nlc8B6S4byi7qqYIr9GjvMiwX+XsyRJI63r/10AmDZs=;
        b=oOU0BJDAa89+MujyzKr70axhK864z2fzX5d7gzRSS/Go+cYgxuPMcL9Xftxc0lJl3Q
         jTxxeGRh14sr7LGmtJm1wRyLDbhuSCuXPV3x558lDuGGcmsVo9V7Q0RIXdw6Cqn8eTmu
         v1QykCbb9Phf/nlQXEUkFCdZ3x77NOp3LHgeKn4SS1LXKkp/1tnF6tOcKKhHCg5W9yLr
         WepQqK5ldOnKN2IBir8WBkkaizAEmk1lYSokwZS+AhWDp4qB8I4fAgALN93LCxyuo/mz
         OOtJCw8CAAsCdu+kVim1sSVNQqBL5KIIbC62SLWmudC8hfI7iFuzKBrcqt5n5KXeaRtQ
         u7Eg==
X-Gm-Message-State: AOJu0Yz372YsARBUkbXLNhjKYWmyprsPKdQYxhWkmNGaSIVAGQgLBVza
	YOYbB6u513QwXAMVdK/02bRtnsYPflg2x0wtoFgFm1B7TUSXegMuOwen
X-Gm-Gg: ASbGncvgL0OcX3pCoZeCsu1z5HKHo36VjgeVcEPXsLucVPzkJ/Ah5v0G3vrfBmrtcLr
	SFn8UdPZc/cYxNk41uyFHj4rgwPTHFdwvNsar6DbVzneAtkC0Yy4/21whfpL3wcK2cYSi6b54++
	VhWN3IK89nJRYLEWVYRdqE7GMOkTdVZh8ZGT0jwrxphYESHHhj678sklzWMfm7Cfjh5ehwedh2+
	6C8KjVufvyUA77d035wmt7u1EHQN1AjeMvC7cvbkcrA96NGwC/iMltxK3ORD2iZPmqkREBYD7Ue
	jWFirxzqTM5gK+22MmMAwVoXtQY2CQvw8Rm0NjlLYbisYbNhgk/rEWXXK1hBfeW++zh+ejtAvE1
	YAu65w992GoiMTHelqc1TzxiHlkQOYOhnWOA46w8zUHsQLeRExw==
X-Google-Smtp-Source: AGHT+IF9GOyyapNBfoqgOuqiv1XZB3qmpXDUP+K9ucgAkq5QF8plhpNilPsAFDYUgoSKKIQonp0F/w==
X-Received: by 2002:a05:620a:1aa2:b0:7d3:e868:a684 with SMTP id af79cd13be357-7e343635982mr449863385a.51.1752692264133;
        Wed, 16 Jul 2025 11:57:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e32b48255esm374138085a.97.2025.07.16.11.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 11:57:43 -0700 (PDT)
Message-ID: <dada6ceb-bc96-4d8d-9137-4ca1763baf16@gmail.com>
Date: Wed, 16 Jul 2025 11:57:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163544.327647627@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.39-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
