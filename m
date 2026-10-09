Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD33318B9B
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791588186; cv=none; b=fG+WL3u85VTO35816vBKYJzAnmI7aQ/ZEDA6vsG96U6VBGUnnu5VhNF/QgmHXN19DxWicDHl5m4sH0JmqD9eeS2AI0iw3G4/kobAjDE+p0F5CazquaNiK3ByNh6rEVU1u6qAdqjWg7E1Yis9CwhVhNEuiRQp323NzbhaLlYy4jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791588186; c=relaxed/simple;
	bh=VBnbwFMLD3JSNrfnQDebdiG+E2lh/z2NfE/iMSTFfOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EcZhfKiuF9yE5vuXF/TqJR8W8Jocd3aFz7T0360KmYUM64+75TsYh0/zXDVeLjRBC8S2CWTUcI8AAfFQ53WB7O6cARuHUYVLgF28VYfpfyfhvGkSSlBKVC5fedy2rtzP9ZfiUZTcAYsk2dWDgXZib12wJUegVoBX2bdzVD8tS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIDh2ZxY; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIDh2ZxY"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3514b90bb89so284423eec.1
        for <patches@lists.linux.dev>; Fri, 09 Oct 2026 16:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791588183; x=1792192983; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NKTLYTxvw3UCc06aTLO4FFaTc08hP3j7X8BS9ATAWjs=;
        b=CIDh2ZxYSwSBgx/aazp3Ke21DxKzMRXs9JG1+JmHJW287tcNyxONCeNJnpjXJVGRLU
         YfLUk/DLYfXe5e7zrwP6N9XzazyJiC/rzKI6LAkLXonJ+4caCVZMGifYXwYpqvq5hYrf
         LcBOIpQYRxZsw3f38gtJtbhrdv3F3cjR35M2Q3QpL8LxBER2y/JU8jH9IakOBIv+YsFd
         QDNMxgk/qYTj/LpzaVKeANSmyXEC6Uxd30xsWwfgj2+8YrcjAsjOtD+je1Z99R8ACvrU
         u5kLcozwSfVzQLhiql2/37853mZA0L4gGPr2xtml+n2x7Q8HIA4E69HQmpweDH2l+r3a
         thCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791588183; x=1792192983;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NKTLYTxvw3UCc06aTLO4FFaTc08hP3j7X8BS9ATAWjs=;
        b=rVN2bEdXowTCsmBp8vSskWsfLbuqt0QsqNHg+TdAvvjwQ4QXdELrdlFaOLSfibfuhR
         24PmpSyVMljyxJ6vluQkHro592T37M34RyhoMw63Icu4wsZlk5IGvY5MyAZwBTnANh4D
         i4u5FqwPeOdIAkqLz25VN8rnJdm00Hvc7Q2dvC4DNua33JylJ9vX+2SGKEAb67+XT/yC
         fBxAJvgz2jiA7gRO2HrMzEtoR0w3Q6Ws2mldN2w+SyL8NQeUDq5kDPHtvMkfDgVoJhM9
         QsNOZ2dtmmlN7FZ4tCWwPVXs7EmwqU6U/au4Ksdrd2hz6t5SD4tvAJ7pniD09B6zeTGO
         95bg==
X-Gm-Message-State: AFq9FYJKOPUQ3gRJQSdJlyWDjmY/oaui80cXXqqrZpOYTdoC9lWfRAdz
	zyQJZ8pmdSVnibnyg9/Ur44KOcERA7zIIrNIokwpZr6Wq6Eup1uxZfZA
X-Gm-Gg: AYBFou0QI4H2CfwnwcCQ8JM1CfBs2c1PHA3hWZmJY8Wal9nXvs7m+YyDKXuW2rVbkxq
	EdwVmY4U8hQaj/A9+IBkx/ugMnpAbYTCRgsHRUnQL3Ihj4ykToMWjVqaZ5fZDEGZ5VaxW1Tbktv
	3nELrlAug+FEiFoZHmGhyWgUfZc1c+5UuORHRTIVSbp3H9/6+aQSauZHgkxvcXxfsml+JxRI11+
	zdQMBFq69NCe7Ob/8FvFyqdZ40dzZnNXJOsFYLm5HHY33mqlUVaG2XfYExTmQrdT9ZRP0bER3++
	x7DQQ4GBLws9llr4Kad1SI1rUhonKf1ZOgWbQGSpLs6oiV1kHho7iKAf5WmjLsuNqeCMm86B05Y
	kQtwkbjG+12ddvd/razc9KU2Gm8iaUxkINOAfYQ8yevKG7RJXzVmB34sCcy7BVWhEj1kETO0RWx
	ssQs/FJdR6x9jgOBVG0j6/Iy5T6ltpEr077TV84zKDO1TFPy+U8S222YUI7zD8u6Df2AGlEpzW6
	+bBr+/MDUwoVbIeSzpbGOp4
X-Received: by 2002:a05:693c:4090:b0:351:1230:e379 with SMTP id 5a478bee46e88-3537df59719mr5073363eec.6.1791588183110;
        Fri, 09 Oct 2026 16:23:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d202sm8736839eec.13.2026.10.09.16.23.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 16:23:02 -0700 (PDT)
Message-ID: <bc869fb3-404a-4c81-926c-545def70956e@gmail.com>
Date: Fri, 9 Oct 2026 16:23:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261009140952.119038291@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/26 07:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Oct 2026 14:08:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
