Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6943179A3
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 02:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730946438; cv=none; b=IxPU32pVrqPXFEgcj2rsXwWEGN+GMI/I71AN3jZHwwuRdP4J+3Vkta7XYZohkcmdtd+l+fhyiqBlx6MEXLCcI9ycwYtG6k+DMtVcSx7Cx6LZIUfiKqP7wYyoH23YUQ9ao7ByZZGGogrWkZxKZHpnW31ztu4kTFq/9YNHJDejkSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730946438; c=relaxed/simple;
	bh=66r6xIbtsr7gOmnkCVDORMzU1xLzP2MTzmFr5wrTId4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TE8dE+p8Jg0DcrcadJFphx7E3pUPJ0c5LAxWqq98cypMItn4torT+rwvkNpWKuaWkt9B+lVXtqYBvbGfLrh5w5wfYVBLJRItOdYlr52vKjZ5Ss7BzZSF4NGABQdsOdQOq946voAxZ6bX0ulixhQ8W91tEhw1IcRK5xcm/ZOyQhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2XlP6as; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2XlP6as"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a3f8543f5eso4921195ab.0
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 18:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730946435; x=1731551235; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4FH1qWWHPqfjxtFSCDAPzAW+vNNLwYck5jhkRuC++H4=;
        b=g2XlP6asxGvHt/ZkkoUiyFw1XV6o49SC3Pg6yRF0FZ7j11a4/eZpGoyL44RlkhK5ZD
         A5nJSg/50/KmQt9xIu3aFONe6wVHVEnN3lATTuTxumUpJoTQqXV58OxFtUMBXNuCXLjM
         s8oPZCcmPtQSVesZrSyMWJ1Y5gfAIqkrB7Mjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730946435; x=1731551235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FH1qWWHPqfjxtFSCDAPzAW+vNNLwYck5jhkRuC++H4=;
        b=ONh4q2CwZdfqmyDGG+bRS1O5Cn0BVWhMaYMuLXIcd1pYuMvL9O82OoVmzVi9pmnhE6
         CQY1LdRZaOU9zEWzTF0gXwI4MEM630OXRmwy4nN+x4vBaAkdmp7zBHI7qX+RYahLTXLp
         sFLPKihp0EY/vszvGkOG2BB4n8H549aWM1OLgBeMJyhrRjJXpXqXhEu8Bb5TkIBtofAE
         5dLItr7fDzmrRFsT6oypAxD5PLGIpQfLtzTp4WUIUOrthixy9zo+nTXmvFYjpDP1NyN0
         DpjZY/65MrYq99o9LDsU+VI8ZyCXHPrqd7pWWMA1RouqEQZrqWh3KwzEiMsgV0jJqcST
         XMMQ==
X-Gm-Message-State: AOJu0YyqaiSX7soqpJ+CkR0HOv0cRGRRqCVGmFZCig7S18K1u0K+eCKx
	WL6RyJUdz8txcDWQmRD389Le/REMlq3DSyCiD77jjjRnX4pxET24gBdBDDxGr1c=
X-Google-Smtp-Source: AGHT+IESzjzRALUubFg8iGwDGC3CrFswWkMFRdL0oHQ8Pifeb0Ths28JWJDs7h8xJNjRe6OJO4cxpg==
X-Received: by 2002:a05:6e02:1808:b0:3a1:a2b4:6665 with SMTP id e9e14a558f8ab-3a6e8964e55mr14571395ab.12.1730946434806;
        Wed, 06 Nov 2024 18:27:14 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6eacaa0f5sm736305ab.29.2024.11.06.18.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:27:14 -0800 (PST)
Message-ID: <0f9b8729-67d6-43ee-a484-4f58bd08ecc0@linuxfoundation.org>
Date: Wed, 6 Nov 2024 19:27:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
