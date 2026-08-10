Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06B43BB9E1
	for <patches@lists.linux.dev>; Mon, 10 Aug 2026 23:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402820; cv=none; b=mIazzyQPFroQ98qtRfiJtViFI7gHQZLiU8dLPkzPDLxs7KuX5oquxW1gDyJt57RbJg/BfDx1oQEKfawFC2Rxel5CLeQ+EBWTOOoIAt/jp26uc7mQdzcY1I3WxJo0w/59Vzat9+nWPEXd5NSM2cemcFCNRUnwELCXSR/WawTg1e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402820; c=relaxed/simple;
	bh=AIffyatO2PMrnjuXzFz/fouBCJubWOhn2zUYeUzYE30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PsuNaOhAeTuM2V5FfNcrQKJnqDOprELg5yAmoZJaNuqtb2pqUbamv+yZZANLtSVWhDvcxEq1PhapTt8g388nrCckC/0hO9ZFmN6gF1al4cjpdH6Iw4ldJRs4y1PGlfOruDVF9y0vPp6MH0Xwn+8LAfX4mWgDemQSKu+ft7lcjgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIYweC6h; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIYweC6h"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52d37b65926so1202171cf.2
        for <patches@lists.linux.dev>; Mon, 10 Aug 2026 16:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786402817; x=1787007617; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=blLJ9/tIXxSZMI1TcmSIhA1UYbC8d5RJ38svlmIf2cc=;
        b=aIYweC6htMNAp12CXRME6uxxQKYZSEFssonfWtkqXz4jpGvHhtvtx0vRIT1W861g/v
         DSl7JtarnWXSeil2VwICIkHbA4Yipj0i2rtmfkGLSwaHDlVBSrLsscypM8yf+TfEYzCC
         k+nIf2pLR1yY8DlPJldBiVuDfV2qtluBkBhWiz1q6jg3SdLap80I9KbnXupZsjRrSVpD
         sb/+ahn0oGBCuiA7O2I70qJviQNBa8u3ufaAeZL675j+qxe+PdSS9gvWj5/kofv55Bsh
         ogQHxu4nNuBiqY3tjXMirWZvtK1UYY7OfxAFpWYLPAAvctXxJF0FgQ0n+0PUGYlBlSR2
         1xrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786402817; x=1787007617;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=blLJ9/tIXxSZMI1TcmSIhA1UYbC8d5RJ38svlmIf2cc=;
        b=lxincYXG+Ft/iJ+Anpy6UEwR69k8EDjAf/uuao22NFqdveH3njDyLl5BL/yOZv8Yco
         MxkjSYywOelgpqkl88iq/ibjAvsvycJmllt260RqcYPgkLiGdaGWg6Hftb8FctxUL+64
         l3HL74Z9rj11du6mq2x3X96lu9VqxifUnZroLyMoLY9kqM2Drnu5Oi7DlcthTNtgYSX8
         vtNVF6c6i5zsIigqtZhS2g51agPjV1XSBCJ0DkJPUTn8a/53gV0ZGllkIR0jjIZ12O6W
         lj7NXNiVbV8M3Qcn3/1VgmLA7iYDaexYWh2MmgCF0CGWBRZNo+Pltd4DFVBvjq/qEvFj
         8x5A==
X-Gm-Message-State: AOJu0YxzNv8Ez5wUZxZnlkluaJOlNAUKBQaBFVaUVWS3onLWjr8c5ULQ
	QKvlKbGjSYJIX0kg1BjhLcgghLcTGVxe/fiJJix534Su9N60qX2qUFEB
X-Gm-Gg: AR+sD10QoAokQCwNdy9X1SHVPxQs/t/5XvatjhJmU13hm+lKoHEXWv2Hu+Q+9kqcUic
	IWU6h9Dvqn86HP/NbyOjyXn8Q9MZ3dQbYxIjLCzXE5Iu9OIBTSECaA6WG6CBeeHRekoIqIdLvaR
	AgbWMTdSft1J8WsSrps0P26WQF4MqOohLlrM2xoOZfzHzQjnac07fD3M3Vm67Il4KGhbbJ6mOES
	Y34OLml4HrLXx4a/QJcFy+9dIi+G2bgY2LqMXoPZEPNsLWQdlvH3qns7E34yp6fKF/ima+WBm+8
	rfGVDsF1aCqVBCA9UXMkMrJQwvRy47uVKczATeWIbur5YtLJhabFIV/VIl88bw0+4TvZKL5gFht
	8DCLnPKBaZ1U3Qj6JHB7xmMJysnwqd8xeyXkiFtpWmYyzFMRtEdejqTHJ9hOy5AVSSBkGnuovoO
	3K2sSyOKpsTkrw2tpirwqaBAbbcqmPLhADATFpYW9uHM7wA8U9hI6NToYwGk/Vpi6Y3T1Br3fUK
	oj1bkEK2vq8718=
X-Received: by 2002:a05:622a:593:b0:51c:21d1:3852 with SMTP id d75a77b69052e-52ce5f63740mr483994001cf.5.1786402817492;
        Mon, 10 Aug 2026 16:00:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e22695bsm889897985a.25.2026.08.10.16.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 16:00:16 -0700 (PDT)
Message-ID: <90831f40-dc9a-4255-a611-7f59e5685f94@gmail.com>
Date: Mon, 10 Aug 2026 16:00:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260807143428.008222056@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
