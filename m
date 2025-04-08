Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF8920A5EE
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744150674; cv=none; b=pGbQTpvR9qqn6nPzle48OQqloWs/NZklL4+ql8QfiDUAcwmdD63yJ8ec8k7ScWcflimlq0+Rm/ClSt2tujMWe3imGSD6+6fUalzWV9yOp7O894p+twTHmVEQq8zlFxSXJ0jQlJaiHTjnJPmszY+hGkGFijYi9zyYajVd7X2jkVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744150674; c=relaxed/simple;
	bh=Nwjf3Ev35BkoU+AzDwIZ0WwCQBVCuBSmXYeBwJpr8Ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XOuZKRdHjPUX4gmeK1G9HIl+NCq1kmDoYt13CrVxYJVNrOlgbBupPu3U9yKWw5iRchIK68zwp5lnQdE+hp6K0sBG4LLju4mAlL2UFDwpITAq6ZCjcQAGxyIPnhgiWZvHAUOLVAipatGwnLwLgG19/U6eGUs6q1bO/Vhk4p1yXfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djAWU5EW; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djAWU5EW"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-72c14138668so1468457a34.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 15:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744150672; x=1744755472; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nrJxgcRdNJNP/+MuT/tR4TERrIQfumnETWNEPiiQMHo=;
        b=djAWU5EWM5fh2DG+8OGqQ8zGUMOy4hYN3JkJ938aY4RAEYY1nQ5xeQwk2kpHHITkts
         lVsgro3iwmIDC3yLBEvbQqv3NOD308p9EkZ4CYP9L1YUC9+0kEhD0QSWJ06R4EhdhWfY
         /ChbQVuV4PxC9E4RB5SPVta640wc8zn0XRiMhcrLWhGRfPvccxl30W4ISpyI435bGEze
         xIeEfWWhh5uPryC9lR6EsF4/9jjOjdXElNUeQXL1Mgx/1ACLDEF43HC0BA/i0BLPk6Sj
         XRNVIt5qCygPqM2mjj01m4I7z22XqiDUlIIpczq7GL1M94HwxkF5uIph22ZmHhYoYQ1H
         yBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744150672; x=1744755472;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrJxgcRdNJNP/+MuT/tR4TERrIQfumnETWNEPiiQMHo=;
        b=RKW2WtAatXqf1mkthpwfJVx0+4P5pNpsZ2+aQqHS4Uh8L/njk2Mxqbc2oE5Dbgq4bj
         Tt0aewOzR7wYf9BnN7M8/rQPcThEDsHA4FaXht37njVi0nFgHNhIedYBmHYpOAXdboea
         j1wMx7JI/gzFXaVe/WBSRLsRk9gsakD7Lkt1dtw5t1dbcc5b9QKZlxMTa0k9EO/2VtAx
         vhESGBgNTydKYIT46YlY3+UFpJFg63Xpcy8IU/uiX9+fUIA3AeAnYZR2eRLfGyCIVmRh
         SvIcVjDMdenX3rjwRVh3lGay5MWHcLwMJFdzWxcN/jkjWZElt5Z9r9U4mehG+PE0FDYq
         rJRA==
X-Gm-Message-State: AOJu0YyGHZsoHDJl9DbowimssNNInebQUzRXj94aDIrrCTdQJMtiAR9F
	7SqiJdxVaAVyZ0ZMq0o+KQahLoEFidkvk1Qul6aal9+slEWqS44H
X-Gm-Gg: ASbGnctOHoefmzg9EOSnmISS5yT2bbQf7EP81UexASnWzn0C+3ssbN9bugPfdsAZqiJ
	+QeGjzNGYZO+u2yxLlmwozubvsEMlsmhwyKf03t7Oi3/VFHa9LY6PR/ta8V23sfmgaeTA/RgYMT
	vDgV4SiTtDn+0EGtCCoCLLI3ZV3JzBN2rZCLlk5QdN0sxsytIhzI14VmPKlH2X0pfOEO21LIi3b
	wXRATylMtpY1IGCN1EVwxQ2aw36HPAN6Zs2wsIxfL0EfdgXegW8ky3HQUFTn3ltw3eCWkWutB06
	CBWYYCCEMkyvCQVzAmgFh9DD6Vv6Xp+79g2RK01ThscNVvWFrJjKLy2UNY4zHOKgzI1kFjxg
X-Google-Smtp-Source: AGHT+IEG4A0Abyx5pR9YcuoHJpVVNCOI3DLsM+x3b/91o/c0Ejpuune4Kav4/IPb5oC1yCuocKQEJw==
X-Received: by 2002:a05:6830:6119:b0:72b:a61c:cbb2 with SMTP id 46e09a7af769-72e71ad3826mr181773a34.10.1744150671853;
        Tue, 08 Apr 2025 15:17:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72e6515bfc2sm615047a34.12.2025.04.08.15.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 15:17:51 -0700 (PDT)
Message-ID: <763c56b4-68f8-406f-8222-e00051dbe41a@gmail.com>
Date: Tue, 8 Apr 2025 15:17:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104828.499967190@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 03:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.87-rc1.gz
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
