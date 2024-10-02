Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B7B1C9B91
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727889598; cv=none; b=tMSjh+th0obA65nQkwYAY5pxTfoFWAmZCRTJjl4zd9y/BZ6+zO/ev9MeuYS1G87i+cFcYg55w8/rBHqfzce5o+Y1/CNsJixX9i/ifexbEbyaOpBKYoAJ5fVlGSCjkg03OR3aIgV0kaX05fY7CyS6WO6GopoBF1G3DhB/djrqskE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727889598; c=relaxed/simple;
	bh=Sbfqm/YoHaNm6XOt8vy7oCLPqoe4IEjj91/nQVdjcX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpZQcMZyM5Y5tqCarTcabiBE8tD39qtqXvNKvKLwloPnUQ5vvr5OXz+knsZR4GqpshKf9VqbXq3+5T4/ggXlqSeo6R8MkZ7pBdqcnkuPBq0drsSmWkynH8w+kmMQH0DQRHshcd+QkE/zra4C1ikUrV7hKh38lQ+tfosuEpAp/WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6dUktbh; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6dUktbh"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3e0465e6bd5so68263b6e.2
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727889595; x=1728494395; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tMrXenvfViWrqA5x5E3oVvAbgpaUSaEl3Bo6hLbb6IU=;
        b=N6dUktbhcyxauSCm5M1VfB6CMtVCaJfPtdZFM1R34IR5HR7zTq/QXidtCUpcmNdWtn
         8O73jg33RK5J8rmDf2aff4lfaOe1qS1mRxMmLwST8411hDr2wMzWTyr722ZF9mUTO+DW
         gcExp7YC6VGuczoLBHQwLrzCtRb8oruzdh9+XkaZu/Tyiv7Ngs3ULwmXwra/ly0L6x1/
         8RVt9aVZP+u29cD6yUbagmdlXADflSkHmDbEplGbKeyRFF7p7kBTLEuuanRbDjJjr3LP
         pcEhHPhj+h21RxUNXWKpQbRRzFNmmSyeQW/2sx5Nr0Ha7zerCGqgRFkZE5sY8GmyFv17
         xp0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727889595; x=1728494395;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMrXenvfViWrqA5x5E3oVvAbgpaUSaEl3Bo6hLbb6IU=;
        b=P0durmibjo8uFkStPy5iwqvZvYEvKM6pAWWuPqmLgVJ0iXlyvK5bx3OaCWeexGc8Sa
         dwIE5nDFo42fESQmUNLSaDs/Xguvv72cNXk6M95cCUF0cBLZXIh4eYW4VbPPDErVOGKu
         erOD7pDb3ywWfzxdvflfn8bjF3VdPnA0LNKGL9cBwBBm9iMhZpYLPBQhkXyusuwzCpkx
         Nyu2GX7baXh7x74ijhoQ9l/f3vftcjBPP9JWptI+CV1Sn5Caj76JRiLGtPXwdYMh0Q0q
         TrzRENbukAP3fQoMMmnch9bS2V7Mwg7sT4aBUgAiVO34AltvGcSVkbROD3EWR3w1TTwc
         3B7g==
X-Gm-Message-State: AOJu0Yz/f8FU08wI9IvHxVQ5CGvbqKu700Qj8OJGho23V2dAM4hlrH8d
	OGJftOipUc2GzyQah7TxBaOVC6uah72eJYpSR2PCwk5HHTygAu3n
X-Google-Smtp-Source: AGHT+IE8YwjUdIa5w0L3xpzUkffBpyRtcpNI2t0kxfiyVNQsyKrR1V9myARjr4tNiVAw86oEPHlwvQ==
X-Received: by 2002:a05:6808:2212:b0:3e0:3b81:6b26 with SMTP id 5614622812f47-3e3b40fba7amr3715568b6e.15.1727889595505;
        Wed, 02 Oct 2024 10:19:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6db292f3bsm10123133a12.10.2024.10.02.10.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 10:19:54 -0700 (PDT)
Message-ID: <fc54e825-17dd-4b6a-973e-00d2c3b1b4d0@gmail.com>
Date: Wed, 2 Oct 2024 10:19:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/538] 6.6.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241002125751.964700919@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 05:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 538 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Fails to build on arm, arm64 and mips with:

libbpf.c: In function 'bpf_object__create_map':
libbpf.c:5215:50: error: 'BPF_F_VTYPE_BTF_OBJ_FD' undeclared (first use 
in this function)
  5215 |                         create_attr.map_flags |= 
BPF_F_VTYPE_BTF_OBJ_FD;
       | 
^~~~~~~~~~~~~~~~~~~~~~
libbpf.c:5215:50: note: each undeclared identifier is reported only once 
for each function it appears in

Caused by "libbpf: Find correct module BTFs for struct_ops maps and progs.".
-- 
Florian
