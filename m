Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40276374E48
	for <patches@lists.linux.dev>; Wed, 20 May 2026 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779313613; cv=none; b=LYDV1EEAiMK0wuB0A5f0wsFNHb5Ok8YB4a7iyEefkHvYt1HzCI8m6Y0KxiSGDf5RBKfS9Id9SfZMe2dIomI8D3+yqdWp8hqZOkCWxeHYgZzHLadACI1myImSrCTvGWPJbhFouDjmMx7dvIWh8RrWvWndC5XrvD604qncxJVVHgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779313613; c=relaxed/simple;
	bh=UXjrHToxSQU9FpY3EynRDNHR+WYdXBKMEWN9piIrWws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hd6t4fLtL4A4LLObt62dEao+57kXAoPpDn1tt7BrYbC5+TxmJg5T/ZZlQZXRMUEUsziDVVbQ4UVGc9othYDaB+E6JfrkqMGTrDCajdefI7rEuQslbQM9poTAhOrQ6uJFsjP3LLYGPu8dR/9EjWjSeSzRa3Vj7+oIwCjSpeP+2Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJhPtivG; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJhPtivG"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-303f2fb7225so3653688eec.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 14:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779313611; x=1779918411; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=amUvCdBE0GwzwMhCPkPPp5DXmMOrBh3zemY8l9WgYno=;
        b=XJhPtivG/JFeiB4l1M2DlBMZWPI6PrfFOx1oVGqP2qnFjHS6LMNYpTwaJPwkzXkryM
         Pf/FKpzI49Lbi1aTClt8Z6KBck5TmuQVUfyn9ehWxcuqUy/meaAgoPMPhVmc4G+5EFAr
         jJfMYz2je/rskqIXV4l8aSZMf3ISYRX2ZUPGE1NhNJs9+QmJgZJI9CbTbUX/oYHb8qZv
         ALwT7w35+6qbieSyTxTYVecVUsrGA8uLjgWXXB5vQu12AkLnevrxyfjxdqjSX+uwHOt/
         OJdq2k1TQlwEnU3HztrNXDfxn0PZy74T/sGxAN/85q6YhiGvLZwDEADzilix5gZqpaXB
         /sqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779313611; x=1779918411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amUvCdBE0GwzwMhCPkPPp5DXmMOrBh3zemY8l9WgYno=;
        b=rMyGhrNCp2ykMfDFS5CuhXrNGHWj76kDYz+atx2CqcawWNhSHbn6k4M6sYhpQ6zHD8
         9q1qq380eazHA4yXdJIEtUlTX+0fB0egvkLrDwrs/9QNuFEVOD64obagTT0Ij0p7/ulf
         WULSJwNJV2qoAwZ/AI2gE97nwFJTAK6+idQICokSJ+Njxn2oQ3mPrVwpK9O0ESxtsCBc
         dl1E962GeVEBkIUSfM9ipjXF0yoU3iV37WQ1k5AFsLsFZ8muHb/vzhCKH8KEU2uv4CZk
         RSIMayT5KMFFCujjxnPvmLAHNKIHhs0ClvHkJinXMCvYp5fNPGwXir53s3tq0YlaAQzp
         mDHg==
X-Gm-Message-State: AOJu0Yyqgo/9e6UKods14LF5eSjujVDzwTQxmNwGj6JOIfC4lhXL1sD/
	8R4xTptDkUQsXkewXqLDbRCNaNuzSUNQac+zGD03ehw3ORr3iDMdHWI8
X-Gm-Gg: Acq92OG8GZzIMypOtFOu9RnwK7eSjbiteua5IRaybLP75LeqL6o/mpisqgGmoi/oykF
	gKN6gpWPDrhDsZc0RCBiKnoPMUZECn7vXbrOmqqvC6c0JHLb05s24l+Q33jjzQ4eV/bDd2wClZU
	miA+NyWWxgJSpNMeOEFB8PjFMWKDo58bay1ywmu6CpcFgnKBYPjku11J8V2EewiDrWZs86qnbp0
	IbWR4z2D/K/qgAQ1yXFLup3J9x5V3+Z47wCpNE6kgTxVp94AELrrUl87Yd/rq3QbbrGqp2OlQjt
	wL+Jnrv0SqeJOoYCNLLp370lkYBwPCqZ3doFvtYsk63SSPBqYAzv4gxOB4rIvAcHu7HmHq/kG83
	Ndcrrdu0D0Kh//CBoonszs0I4KtcDR9UJuD5PtHcOTvK+jexo+LT8aF64odJmGe+TlCc9rgDh7U
	ENJQUaYuJbPEvR1IUyRttr4Nbo5BYuYFyCjDY8UJcOt6HS732R0elj/aeG+6Ee
X-Received: by 2002:a05:7301:eaa:b0:2ff:c611:82c7 with SMTP id 5a478bee46e88-3042f595735mr294810eec.12.1779313611280;
        Wed, 20 May 2026 14:46:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2e686sm23595618eec.5.2026.05.20.14.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 14:46:50 -0700 (PDT)
Message-ID: <54f12da1-32e2-48dc-bf84-3bdaf8ef0f6a@gmail.com>
Date: Wed, 20 May 2026 14:46:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/666] 6.12.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260520162111.222830634@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/26 09:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.91 release.
> There are 666 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on ARM/ARM64/MIPS with:

In file included from libbpf.c:54:
libbpf.c: In function 'bpf_object__elf_init':
libbpf.c:1538:76: error: implicit declaration of function 'errstr'; did 
you mean 'strstr'? [-Werror=implicit-function-declaration]
  1538 |                         pr_warn("elf: failed to open %s: %s\n", 
obj->path, errstr(err));
       | 
            ^~~~~~
libbpf_internal.h:167:47: note: in definition of macro '__pr'
   167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
       |                                               ^~~~~~~~~~~

this is due to commit 2e81d08459c32c57d037ad160e755bcfe6d5003b
Author: Mykyta Yatsenko <yatsenko@meta.com>
Date:   Mon Nov 11 21:29:17 2024 +0000

     libbpf: Stringify errno in log messages in libbpf.c

     [ Upstream commit 271abf041cb354ce99df33ce1f99db79faf90477 ]


we would need to backport the below commit, but it does not apply 
cleanly to 6.12.y:

commit c68b6fdc3600466e3c265bad34d099eb8c5280f1
Author: Andrii Nakryiko <andrii@kernel.org>
Date:   Wed Oct 1 10:13:24 2025 -0700

     libbpf: move libbpf_errstr() into libbpf_utils.c
-- 
Florian
