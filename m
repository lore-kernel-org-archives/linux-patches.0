Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C042635DA46
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776104862; cv=none; b=jOL4+txaQW39Khnz+cXpyDQ+wq4u32H27NbVwlKrjayvQPFYgW9bAMqII87crcJqpny+6PbDY8qMfPMN5zDHkszyTOFH/mSjLdj4+bLg6h0CeuGg1Bnr2evEzg4VmMVQjqpfuouj2MrGI/8XqlLQRDXizIiOFm+107WNzmmQcOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776104862; c=relaxed/simple;
	bh=+oz8fIDtYkeSS8yY1/lCiaI5mVmEJUTqZCRjjASOMb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmYVddAMkdP088AOMtJdTulKMcRdG5aQi/WeHTHsDJoVzMdAMvYvLcCY+3t1MYdRw8LxuiEjgLxCR8FiHl9sjFomPSqNYdY5RLH8x3sX9yxNj5tQZcd/oDKDnZFp64YkAcgLUASzZE/QxVrGJE9I/zeGnBsSW6uYUOKod3jf3c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLeu9IGs; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLeu9IGs"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so9930447eec.1
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 11:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776104860; x=1776709660; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ewijMpByJIzA41dtCa8+aN+j1YdkA+hHaQFDF1cLATg=;
        b=fLeu9IGsWJSdygyOnmY8u0/gE1xlft5RNqGMcP8JhvgTmQS2/gnSNyK0NhsBy3FmET
         69Atufpjfv3MRuXAzjdQgUEwLQ8DNibDFSad/Vp8WKvL8sHb5Oue8lW0hFvApnkLEtLw
         W5bWhafsDdVIsRHnuffcYIXfHyfpX+BWyFhybrifGRj4J3ex94UzTLylPGYidE97AjeG
         p3l38IPOYhsDopxukFETZFap59ZEPb0tpM/ZPrPiR0KR0NsHdOtfFV21PJZysEGST20A
         Jo1pmcP9HDZw+7pOubg3CmKx4nu0nVB9RT1imF8G8v9Ucpm8K1PXVt7gBqL/krPADJtZ
         UwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776104860; x=1776709660;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ewijMpByJIzA41dtCa8+aN+j1YdkA+hHaQFDF1cLATg=;
        b=giz5NviFfi2YxdUbDY5XXKE8lX71Ftf7VjWSnqdw0VEmqRMUTMKoFIqAGF+A/3e7T8
         vEtqydRJsWPvqtE8Vft1/Fl+9w3WhgS9cbhvnqKTlrp44jrAtyq3cYGZCLzFWFh8IZav
         Vr4x/fXqtycj+H2BhCpCK/eVFCv/4DeMrhIXg20fAE8d1VYt8YVx4UJi1nooI8reNYOP
         byBaOb9U7lcxnimmih/LcD8V5JIxDXqXwGzGsubSyEIRKXBJILXDm2xHtj5jEepsu4CZ
         RYFSIqjeAMkVwpcBU9Syqp14QJ+dYedY2rDumtXa8DyIXvyN6yIqB5TABM6gV4hsp4fD
         eciA==
X-Gm-Message-State: AOJu0YxrDBz6nPCq9LemTeVVG+I66+tFgMeX5NIQSKOyh84NpoOaS/CU
	JdhLSC1mYbI8hYRzuSc3EuYSqBgRj0lEUALRiJEkS94qVnZVH4Gb2WLb
X-Gm-Gg: AeBDiev14FmGlBKEztWkGqIfLHB/8cNOYoz3Xdn/zeNuu/JYjqI6pcNZr2480m/dt+N
	TOHRW/G/YoJWq5UQNFMTnoltlI7oCPmBFadjiOc0Vgg1ERD2NjqZN3UHtMAtO1K8C75fFKcQpuA
	AyrdtyuhhipW1Lipu9FQ4pYqiJus1hCJtxvAYGRSGUUbb8zCT5Vj9RW56O6X6IYerTQsLOgkGWz
	OGr5h1y7u6Py1cOjAxg/F8wium1bjnVCKWWQ8zMj05nzCeLBz4pJ2NxNA+uEl0U8AsNbIe9ReQS
	z5LgOYeQl7kTMaTbIgifgz/wg1aspVR23Mv/6STv6DNKgXKBrzlkxfXO6VjEaBvPlP9uaNHDZH6
	7j961aGQJvhtA3snbp7JbSD9Il8AxKXVkmWB6g2ZrTew0nCgs/F2us8E3xXlHakfEtnGtTO8MBx
	6osQT3D+BWCxNbQb3doGpJLR02o5HtDRzy0sNVF1Iy1CjKJf3Zq1iW81l0SiUe
X-Received: by 2002:a05:7300:320a:b0:2c8:6361:ab2e with SMTP id 5a478bee46e88-2d5877a7b8fmr9654863eec.8.1776104859817;
        Mon, 13 Apr 2026 11:27:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa556esm20830186eec.8.2026.04.13.11.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 11:27:39 -0700 (PDT)
Message-ID: <4b5a9ec2-88b0-4b9e-b1cd-eb2d064af32e@gmail.com>
Date: Mon, 13 Apr 2026 11:27:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155830.386096114@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.203-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
