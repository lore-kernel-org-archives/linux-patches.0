Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A869B48C8C1
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688816; cv=none; b=C/p26GsFEGWHXxGraVEX6kmGq2zLmWdho6Jvg1vYJLD95S6y/wfFrLsyJm6MgqRThTVpUqFwzEO04PvEw9fB0oNJ7Wji3aQkA82Yh4AX6zWUAuU6Opj0QLE+LNAxA3WHfslSiEvxDfI0fxOtKZSB6nfHMaPQvLWfpDfxDyXR/gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688816; c=relaxed/simple;
	bh=YhBS2gglZpgBUTd3EN3gtxxcVc9j5kl99TM1RKqNIT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FalXvgzVb54ttl3qFf4kTxl+K/LUZKesE9jl6rDm/jz1jv1r6epx0OPL1KBbHUj++Rf7M+aW+cLfinP+qK0JbyGoGQgS/vDE70E8po1a+WEOoZ4UU7nIqqStfulAfvtzbH+Ym9qPFstaKW2Wv7NDqwlMZ1U5BjH3dpqO5IIsg60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSYCNm5L; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSYCNm5L"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dca4debedaso6585747a34.2
        for <patches@lists.linux.dev>; Wed, 13 May 2026 09:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778688813; x=1779293613; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UbrAmocTy/GZasxYN3SuUtJFFgRGxP9XV3hZlSRDuZY=;
        b=FSYCNm5LBi7A7WZKphfYBTylyF/mNI7NnGGBR/USPPj9TlnR0PThgK9laxS6EiJZMt
         Te/PwRWCi8wPVTV/jdSveWUCPPSXCViISl2t6qoA3NMdzhigvkudAt9enSvHAPxIVX1U
         TgLOizOKB/WgHSyBsP+ik0zKr/2Jc2CCtZ3NY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778688813; x=1779293613;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbrAmocTy/GZasxYN3SuUtJFFgRGxP9XV3hZlSRDuZY=;
        b=MWp0E2v/F1xcYaMQBrTScOimhbQ0S/4g3uszfhD01XTUVZv910lLq79IGflmgbOD6y
         wpDqnzEdtdOD+kxObX8U2+jCGHEydFO4iKBbk6u10yxTnSGGIx3hZbnFaG/8hptixoD0
         seYBYfptjrPXh7KIuk4REjXtUOTwI0PMFiCWV+QvYr9SLAJWVOX6e0oXU+9PNj8ZH5p+
         fqQbwSRAAVDJuito5bheYmA6sxnbNuvjJ6jIrsxXzrmDfS3smrnJeLde1M+3padWn5pH
         +UfyCw2L+9TNParasDIsmbYT13H3RGHAdQxF/cE7R+6SwOcYabOiHWpUinpNXy9TRvIK
         wguQ==
X-Gm-Message-State: AOJu0YwBMx1O/Ys134HrZL63wC+leK6/DKlH/Q0a0XnrQx79QSYa7/ET
	k/digrb//PNB7QzikYpkSiO34LSWB87a6LDoJPfvQl8UayL4j1PCvj+luMTMY0J1m3Q=
X-Gm-Gg: Acq92OGCFA3FazntOI67rd6y1sLtZn4b7wSxLArO/l5OQ4i+OAzdYhRWEl8BIAtayxb
	5rYX+B+l4kw3XLAKE9wXST1O1wFQAFpDhHvAfL5CqJ1qw+9TWZWlHG7Do4+k9nI2TC7VuEws6a3
	4l3B6ggbESB/IbdTvED8zpC4bKkkpiweMH6V74Fl+fvsOE4yhrJ5OkCGbdh/v03uZTu52YDO29U
	e/WZVReTx+27i1vQMy2pb36T51T4qaGlRexcQ4oTnTCwY5xG5Kb4wa1HKeQF1CFN/lWmhBdePv1
	624CL6b+G3HydhyV7TYdR/N1oaxDFEKMA2vVYJARKv7e9gEWyhyu6La/DDaeMffiWIn/mPfLyXa
	QdG5KVUVQRHcMUwaEnnm8lIdcDR7LOCTEmSXTsd2uKdIeAfNcr/Jmq2iJZm4Ka2DPLVFLTNz6/5
	gF971jhWt34QbdvsaiUbsp9AIM0n768bE=
X-Received: by 2002:a05:6830:44ab:b0:7d7:f5d4:ef5b with SMTP id 46e09a7af769-7e3da0973fcmr2213993a34.7.1778688813613;
        Wed, 13 May 2026 09:13:33 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e367c04e00sm11251548a34.7.2026.05.13.09.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 09:13:32 -0700 (PDT)
Message-ID: <73cd1ca3-ee3f-43fd-97fc-b1fc3fb4cca5@linuxfoundation.org>
Date: Wed, 13 May 2026 10:13:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/26 11:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
