Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319315ADA4
	for <patches@lists.linux.dev>; Wed, 15 May 2024 19:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715802891; cv=none; b=qFF69YckKVo/3fXW5aaN6ZACzQ6BzHgSZ1Wm78aH6amQ8vcDfHkvG8BMcfDMsrIAA48HeWD0Jd9c4qfmzRDMnoxk+z88jbXa9gPv3mAUoCLteeAVCHN/HQhzsD5ADZxd4c+UaIcsbxHI/XT8jsvPGeeixw6MtWp2u5Uk8pnN9Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715802891; c=relaxed/simple;
	bh=RpY1ZLIWGoaTSG2trt5v7gG4sxt/2eeLMWhzG0YEN0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDW/ko9K4gMGLISbJLIbSve65dJjlVk6PpHNxtG79TGRqVs5Ww43/BLILaSs1GlA+p1u8OCaHWg4kqcpytzdc8iuwV7IR7vSd6co4v/UPBlrXOTsSbqG/vH38rclGH+JE7VIZMHUQRf0YJVny8XgohC0GcYjFqsRLnph5JzUVJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4u9DShd; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4u9DShd"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7e1df3a3f38so31567139f.0
        for <patches@lists.linux.dev>; Wed, 15 May 2024 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715802888; x=1716407688; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bl2K9Oe3kWb4B4ZrUWnPsSq8OrI5PV1sUFttZ0QWN3U=;
        b=g4u9DShdZz1H4Bfx3+XS60cBBB2aO3X8zpXQ0TkOHluO/ZTCmduxi3FpJBKl/VoRoU
         W7Fyc5TqtrhTOR+ghmxZiU4rGL5zUh/mDsBGTFqcq5WQpbQAI3gs7SExzxs+2R9SKtZh
         f5ujhuROz4tQcvU7iO9ItQaNJSpCL4q+KwD9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715802888; x=1716407688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bl2K9Oe3kWb4B4ZrUWnPsSq8OrI5PV1sUFttZ0QWN3U=;
        b=dyrHda0az3/RhjvarokDb8pCE4X/4U4tmJYa3rlO1esv0D/Dh7zgJABNG+loLI8z5P
         ztIg/rKCCJo0lRxuPW7VtQ5h2U9EdWUjt0brDBzwzBmb7Xn7yWstxkN/NcsEL8U5g3Wd
         /qjfwfIzWdnXcqcgG+SNXtCeCsJg6uOsD7kCpv5VAxMeh3yyLQlt0oXNVoffP1QmnHOU
         KWCwDKO0MIR1NBclf2SI+UumgpBJnOTyAnFGq2hdTkfin1VMb1zA89Q9E9ywRCYCj1cx
         zT98SWoO+HnZ++mXvk84LWqkWJbzXkGm6Vwx50ExBfnXHHoOj5oW7+Excuixb0kqbW6O
         /K/A==
X-Gm-Message-State: AOJu0YwgtICCcuoqZNZnu/to+jm1AIBtfcClIv6TiNoLhGfSF9h/7Jm4
	jEJF9/RfzQnlAAogVc8mQpsk6QliiLhksDv5+Pp9btqnffh7JuxNttBnp4zShuw=
X-Google-Smtp-Source: AGHT+IEt+AFs1YP+RmbhIVtPtEK1Ie3e0g8AnrQnfralB4FlTv2dlK5IMdCEU/UsVRuCWZYJWFA6Ng==
X-Received: by 2002:a6b:d203:0:b0:7de:e04b:42c3 with SMTP id ca18e2360f4ac-7e1b5022577mr1766220139f.0.1715802888578;
        Wed, 15 May 2024 12:54:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4895841e9c9sm3311353173.4.2024.05.15.12.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 12:54:48 -0700 (PDT)
Message-ID: <ee899ee0-f3e9-4f61-b48f-ccd6efa28127@linuxfoundation.org>
Date: Wed, 15 May 2024 13:54:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 0/5] 6.9.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240515082345.213796290@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 02:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
