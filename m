Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26CC3A3E9C
	for <patches@lists.linux.dev>; Wed, 20 May 2026 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298978; cv=none; b=hSwxMyTqt8yw1oW53n8NztcZZL1TqIE+MFfEJ8GnLka2nx6QW9padI+1qVn0aRoahqroTM+vft1kvmHVmTmmTlFcp1UWISj15xK3mDvIrOhcnosbobB7VcI+xWej5w/UrGNAuGa5c/F3ZpCYMtkGcK5t6R1n0K1FXK4Qvgq8IIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298978; c=relaxed/simple;
	bh=5LhrUVjkTVqEBIpSGIvDaNsaVk5wW6tsrMk1Hi9fI2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lYnxpgrjXdJjzrD6QuKtx2ev6DJZ4PxIhl9/SQo9Rg72DXXEQhIz9e4iLVlEZSo8uM9S0pphyO/sXln4AKpptJRNkMyp4ufYRtrh/Tj+9VTIsMcsRyxGPdHp632lvoL42x+G2D5SGXYfpnVbrfsqfUGY8CDDiKCDIGcBI7he9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbGkQ9m9; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbGkQ9m9"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-135e88b8e55so4115689c88.0
        for <patches@lists.linux.dev>; Wed, 20 May 2026 10:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779298976; x=1779903776; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OW/DtWdlDcypcrOJke35ovA01mlOr73W7ESIIJo93wk=;
        b=HbGkQ9m99+qNqKhtSXavLgyKVmNe50AdqCNKl1hJfjXVWIAbz5HIz74t7P3ymFcPIe
         pLJfqNLeBQ93eYlL4oog+hrWSeEjmkZ4OklfSFKfKOC2PGg7Nu1stuJEHNkPbKTdviof
         JROnyQkXC+DcH7JzlFx3bAjA7J75ZxLv1P6SIUVHd0fHq4K1hTcvhQ1SAgDDxLeNGlBr
         n66hJNJ5SSmddqUXtAoF9WmLW2BWY65v8HWSSvh2gXR1hiGchVx/+6ckCZOvtLk0LSLr
         DzL48+WHf/a43hfnYfuxho7TV78mkBTD+sPY0nGhSZfWalUkW5UMfPcYGYho1vY14ZcK
         PWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779298976; x=1779903776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OW/DtWdlDcypcrOJke35ovA01mlOr73W7ESIIJo93wk=;
        b=b7UELFFFq6ATMeKZWQhtAfzbr4lytE5vDpLo3ZEFZPKNVxu6lTjGtnskJzh/Ke+KT2
         06JRwm3MAftmwRrr3hHp3XT9h6KuPvKLJOkgCYDcXYIPlgTutXztzOmPzrmAzE3yG6FH
         0YkgjF4SrwOIkphHxH1zZqkF54Po9fw4c2FXe3A6W5DB3imOJrKE7PZSRt8QS7Pf8JTx
         QG5BOvmIoEXwqcZR8SIuxPnID13niZcEtxCqznHLBwmuEvV4CSUQpAGWcsozqiYfcFuG
         vK0myM6wQU0CzAP5rFF+8Pafj/3Ekbpvf7BvwNFgQQMN7rEl85Z1h5sMSKzqEHL455dy
         Wavg==
X-Gm-Message-State: AOJu0YykCK9S2zy9eJV+gweZYboitZFAdehfti4xtcQaXqswJiem9rJg
	qUx8N4ezoFctMPLUOefG/OiKDukBLQa8rhbzJpo8RaUA2Ua93OEpLTC4
X-Gm-Gg: Acq92OFaYzYSN5oGJtowXQkjcLzeJIWmj5owjqc2PTHxXSZt47kO/xe3GhKBtjYOSMv
	QgCWfDkTNF23PoUgd/RE+sHSFed+r8VXPsAVfavoMNwczm2hlyeE6XPH6Ot9NVO1sf1LHMDifMV
	tie7mozI7JSwbjcb8IH8yAwyy+538qEuH08U7+Ei9s3hRbU7ArNKjKsXXcbtVnvVd77VsnxMTQR
	b9TqwQNvGRXKgoDsk6X2uszEmgr1sPiwQAALTnV7D2tRUzi5nL17BKR0Bn7pKJEpfz6wryCL2/I
	XtOMs60yR15dO416vbdNxa51gdd/x3Y4iztnrOt+qW2BedzIV/lVj8qsTfeXoPzYGz4OvzT4fM9
	0df8beKbSCNPOLSN9LHgfhPWkHJYY2g3BtGaagH5KJo66/Y4BcnBXZMGpmipCHAWekH4qIPvtR0
	69U+DJ+vio0EFLShrxSQMpeIMHYlQFcLjKKiBOCR+XxNNQQwjO9g==
X-Received: by 2002:a05:7022:6b9a:b0:12d:de3e:86aa with SMTP id a92af1059eb24-13505642857mr11363047c88.40.1779298975818;
        Wed, 20 May 2026 10:42:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb9ed3sm27488430c88.1.2026.05.20.10.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 10:42:55 -0700 (PDT)
Message-ID: <cc909bc6-42a3-4d35-8c97-fb31ff3840f1@gmail.com>
Date: Wed, 20 May 2026 10:42:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260520162134.554764788@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/26 09:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 957 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
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
