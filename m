Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3DB499F23
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788200475; cv=none; b=kI+lwD55GBXzlAQRQUqg9cXUhFRs3WtNWxohbn4GrAlSx4yBI1/lh2yd+B8aT5M06BIkM+RAGOfB9NJNcV8vib+FGFLWEnWN7P2M9liI25CX74cjwRdRvgBO/5UVUBULPNuth7LPBlV/AWQPeka+3IJO9C/Wmk7+d0yX8WEBbYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788200475; c=relaxed/simple;
	bh=CTe7x0uus5Jyh61aGiyKsb0esjA18qPPL2GDz+sMqHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PDwGAi0KTQAzhnNFE6JvdwQzvIOSxbdc13UtI4M9F9RiYRyxlUfhjehKqJOeGNCzQqWnNlWgqMKaC7P360F/hYUfJ4nGsO5Ymj9O4u/GUtjTmxFiswsaujea+jUzGZJO0DOn4+porYnOj2AwCeqkyFPbKfag74eb15TyquCL1A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELj+wVVZ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELj+wVVZ"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-396750cfee6so3060728a91.2
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 11:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788200473; x=1788805273; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2C8d9Mw5d8wycdXLHEiB7Z81VhrXXtSb8zZr7GQsQHI=;
        b=ELj+wVVZKSDN+f0dbMp8K31aTjy14R3yWrTrnJfUroZc6yQMEBip8JpW+DtRzatwDh
         FJ+SOTenf1+4EmmO8OqnUvhFZcszKGgXq99U4kh4Me9I5puldg/Ml0rxk/7L4Rx77Tyg
         pK1ZWEoiR8uvHOhBIkW31zLWiB9mW2+VlEJ+v6NxAshGnFiwWAXoGZLKLVZwV86tjcun
         zxC8X7qC1XbzMwYn5nDfnhEevA9eDs5jemHfHhrtj3r1RDgJv3epQhtAvwz0EuE61oQA
         M2LNDHr0Zwgrne5NgY22hMlpFNvqt8NI78gidEl1xlHXxEkxQDCCGQxG2k5Fx9gb+1jp
         ctrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788200473; x=1788805273;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2C8d9Mw5d8wycdXLHEiB7Z81VhrXXtSb8zZr7GQsQHI=;
        b=sxRBhPs1Xzr6o+D3p+hrt2AcRZbOmYuPFVQ4TE1md4SBB409ZOPqAMb+xDr13C2fsg
         TUWvwmVYnPxmnXFsG2Ghdm+Qt8hTvDwLz+GTKWBRjaD1fjtGLSkHU43WfI2EiWmXGf85
         AKPwdZWZ2pI+oSAvD+cn7N8QiWBOq6NJ1h//IG5f/QXWRFD/j9Ffj0d87B80wBA7XKyn
         uZZ8q7Pu6KqvyZCi1eVaYRSyjPH6t+qmQw/EDiF5XjDsCSG+PG1geRvo5vJXJFZ7ilFE
         0yhxKeerxgvtN08woPFdPqSIn0Ei7OnFW23p9Iom82GoT3N3RDg4FWYySBC42KUIWWY+
         vnhg==
X-Gm-Message-State: AFuF++lFuVIVFgWpKPJxLhQK52dIe4NAjgs48+ITnFvTVTZTzZHlMgIn
	ZA0lo0HJ7xhrW06P34P4Rtg9gpFxlx0ncNfbJZuweqt65WJebm2mxsFF
X-Gm-Gg: AYBFou2NHKDnWZpwvjqS6oaZ63bQB2blNW/9cxwZrLL8A2f2wqnvDDW8DmnaTRfrvEt
	nzHFHbzSRoTLPc2HVkATLv2d3fVgIAJOxLM6VqxPhIsklyHT0sZRShC4NlFwAZF07dOQDD6VwCR
	DogRzn/UBGGMj4nh2FLn7LfvCZXNfh6KqTOzni+PEJsQf5RW/A71FXNMQBWn5B4B3uhbQ9FALve
	HmqllV7tIQx0IPCDr5PpEcFaAnBC5dM2c/1Cj4A+4XuGRAwkC1hmslsyA0WzOmqWN4FW+dHF3bk
	7PPMlNhDfHURDqWd2X8raS16WiEn0vH8zYqXnvAMOpv+iX5/53xrSEMdTuxsqJFkgMGlwozLeLB
	yqOQVHJDFDnVJ9UhkYPpIYev3Z2g8YyHtJ/PvPYlfuf26/M2A8McEbb9cZEbYF0Uu/+5PQPdmT8
	tL1FS7BY3EYEKD8adiY5gcIFuXU8uJVkBlRDOUNvgA6ES1BKEmDR62NyHQeW3nMUamHm3LRwD66
	6PLjrfAQJU35u9s/7pRMvnzY2muzg==
X-Received: by 2002:a17:90b:5890:b0:392:e5b1:d833 with SMTP id 98e67ed59e1d1-396d0f1a83fmr43783255a91.13.1788200473351;
        Mon, 31 Aug 2026 11:21:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0de4d92sm27298588c88.13.2026.08.31.11.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 11:21:12 -0700 (PDT)
Message-ID: <e741bab6-782e-4e82-a7fb-7bcf526a93ec@gmail.com>
Date: Mon, 31 Aug 2026 11:21:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/91] 6.6.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.468089036@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.156 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

