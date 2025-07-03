Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514092BD5AD
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 22:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751580870; cv=none; b=uIEY+EX5PILVWHQNg00XmVTHYDUQA0TYvA1CTAfRfruLuj22yS/HMhfd2rfd849OlajCWGIFAmJT0iG6g5WaOEEuAZ0yVleQej/WLVLcwBvoBSkwrNeLqBgIY8favyXsNGTVv6vt+NN4eBPQ0cxiPDwId3yfvF+YQD5uBiG3l3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751580870; c=relaxed/simple;
	bh=Q0g2Zhkq4WLWccNiTfJX8qbXkS51qMJT0rZHNTxXi1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b72bnJr+EhSZEUvF/3lg0unWvLXQRoJDCHlLPznH8B9y3eEm3vaAEprekAKG/z+XiKvytkastVe5h2KTn0txI40rQKiHlp+hGPFcdeuttfJ6FT70xOVBOPkyIu2BhMNjgc1OpTgacA1cQ/GsYr7aBTV+DeLxwMEoCNYKiHYOYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFJbliWA; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFJbliWA"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e058c64a76so2388825ab.0
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 15:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1751580867; x=1752185667; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EMHiazTRC4iQAueFQNRIE7L4iJerZdQRrKQ3VEF49ZU=;
        b=LFJbliWAIVGvpcW/g/fT+WCkvAH76quQ1vVThUk49yMRx+8MRBPLsNG2qkLmIdOyvl
         IPs/dz6OIkSdpCWNMieI9DkWBU6yj5QAykK4FxYkYZfgCxkhmzqIRQur9sLym1bsK6uY
         pHMMYe46khpFJHWH7epEsYrGS+mVAOHvERVTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751580867; x=1752185667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMHiazTRC4iQAueFQNRIE7L4iJerZdQRrKQ3VEF49ZU=;
        b=QhSb7Dc6gV3kHHEZvIlqsFl1f85mZopBoYatFJB761XENKdokx5GpBZ0Z+aj4pH5It
         OksfbfhfNItp4zYMkJAdyV3pfX/d1amB80ye13+Jh3r0We18HEhXIWQ3YkOHG2hXAbew
         sd70q+EwL6MmSEfaqUwuS7soM4PEULMS6kXeezr/ElbfKkan2Bg1WFATU3bCWzetried
         fQLFxMlhB3ZsBDInXAc/b3m30NitfRT8FOtBQ73b9cqr+wCwUMEc6K85gqvew+TiEmsU
         ZPMZpM4PS8rDahkVmL5wpmzzbO0wVRG9cbsTbQaT8tgRlFdL5bPvFHFUtoS8DAd1tN5T
         z5dw==
X-Gm-Message-State: AOJu0Yx23UVL0vaAligwWvXQjowWj9FqNlngzb9mnxgHVbOu/+Ay1eqw
	E92P+/le3uU633egi/DeEKwtVGuMC/MefATjb440MB1iYmDYXyU/QCqPRUhqFAQ83NE=
X-Gm-Gg: ASbGncuUuAepq7BaVqoGtul86VbDixZ/JYZchTi74f2uBrvQBmusoOyu82sDO86RpVV
	BaLrRAJnjqjLRZI87/pA/V/P2xTkTgxEUrLUn3ikz4SbpQcPSyjXaKsiu1qFmScjW8zquxHBsTV
	or/OeGV/xaNGcSdxH5qWldQ6Tee5TN3mE/TetOosxuvBfswdIdYp7XvNBZT1lkfH9ou2E0u1+x5
	ApdWSim4nqzyIXhuIU0FgLnbQvtfysCSvUtsbmMR625w16eEwDMr4i1Yi5W0OttMR8Ry8VBQsS9
	eFRu/aknlqGPvHvvF1pKD0tdT+oCn+caW5LSc2NSCdOyfI6RJr6DS2r1lqS4OOtNDU09olgyKA=
	=
X-Google-Smtp-Source: AGHT+IGKLsYwNxaeU1iL2zR7dYli0csm1SLeIM5zBOhqUdaib/shcWJHmANH9UBvLtxtMQRqBqR0DA==
X-Received: by 2002:a92:c248:0:b0:3df:49b4:8cd6 with SMTP id e9e14a558f8ab-3e1354fff90mr2023985ab.7.1751580867397;
        Thu, 03 Jul 2025 15:14:27 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e1004ceafesm2134355ab.61.2025.07.03.15.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 15:14:27 -0700 (PDT)
Message-ID: <b6644009-7494-44d9-8480-5042bca1b952@linuxfoundation.org>
Date: Thu, 3 Jul 2025 16:14:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
