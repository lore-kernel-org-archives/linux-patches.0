Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634F68633F
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 22:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753913576; cv=none; b=AISiF0pRmzrOZn/r9dEQuBIO0+ZF+bk5e3LBVAsvyY0GJUw4gYTz/wN/lYdaU9dxv3JTOyGo8e+jk85kXeAbC0zjFnBQ9ZQksSVcd9AGWO1Xlukg4JmN1X6bh0J76oww7zPHHZanLo9USjELMFElEu2puEDFR2ticK5C3HwkMPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753913576; c=relaxed/simple;
	bh=qYO9XYMd9Ess2LLFsyadSHoQze0pFR9pSR+4q7JxSB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJ12X+nY7T9m7jo8p4uexV1fezUSXbzUan96LI/s9F83fkMJk6yhAVXplsNdqh0VPLwqOzRpS3B6IY7AF3jRxUshWm9h4e4DAXPaCfPQP+gn9LbIa8cAm0u7XxpQ7JTAWhWO6flGRWfrmK8Zc0lIwmTBXaChx74jn2gfcILsLAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xv34Pb3Q; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xv34Pb3Q"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-875dd57d63bso10114339f.0
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 15:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753913573; x=1754518373; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6nTYoBlbWe2hufH9UN/C4sSrgwEPP02z/hVZuVmtCWI=;
        b=Xv34Pb3QpFTYIFINwfS6KFmWuwQJnqI2j1xTQj4eB/np+AfhmkhCycxUVppUdUsFcl
         fFRbPPip/WhEC15bGmJeMxHV2yT6gA8ZM+7yK69OwfMfOSI4/KMjr31l5Y62cZz/gHs4
         8xqWbX6mtaG1hTo2OsONWzYrDtpMO1gtyhYoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753913573; x=1754518373;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nTYoBlbWe2hufH9UN/C4sSrgwEPP02z/hVZuVmtCWI=;
        b=eSe0sWcO2kM5b+Qo1fXlnBKtu6VioBbyP0SytR9I6Bdj/6WY2mJUwpXeWZ3S4zbOch
         DGfu8GlFFmXLK5g7o9wxqNIPCvW0QhHHVPHCGq99SsOGCCtDhLaqkKPg4CaD+V0FOCVX
         YFUc/JzjgudbEp0lvzBPTOzmQ10p1FCqtZbEt5qTa4/8S4dtw7F09LVN6DQJrHgBwkuU
         x3k+i6SZrrDl2h5iUgl8Rgmj2CGp55SHmFnkepZi5qGzPhffQrSD5OD7PRRl5xNowAnB
         AYmaTdH1nzdQaBsgBrtUeuAXX2I/6Utv7/w2ZTAXlq6XAYcxqjUB0Mge+AoY0xiX+hn2
         TX+w==
X-Gm-Message-State: AOJu0Yw73bqcUqfEFURK2HtuKMrCRh8esw2dh944CENIpGF73woeS0de
	FzMAlL/u25GsR2C+Rp+BYO5ZfB6aLiEhLJibHS695P5lfnIekYSZ9pfrmRunCdyOHtY=
X-Gm-Gg: ASbGncs0eFpEKFCSQhvh9wMIeBqqohfAazvwk8WKEGKlTRq9J+z+dxW4cQA1+f1Nm1U
	4B4nbsxJl7EgYqvDiMoes3OiJJBwmGpSapFFhxWizMC/0qEtpQX3RY0tZOLf84o/9V9Z6TvRMFn
	R5bh6USf0i7m0XUEVt/g7dyhbMlWPhmGEwsK/1GnFUMZZALjn97Y3LItDM1uHqKOfx4GkwBya+w
	2unoi3yQ7LLsck5GrAVtjw4JvPGKkp6tjOHem6lqTOM/FQk+K1xPQZq0WUF8r2XVCexUVGNPdij
	7t9yLY3whqTucZH6XCAX0bS90jV58NWMPbIMtmUAdCNwD/pmsfqjvmwC3swNDAEyKk9xR3BGYtR
	EjAyDhvNMtquBk8YyN4ZB2GL57Kh1LMAf7g==
X-Google-Smtp-Source: AGHT+IENXvtA8hkhU/P6BXgu/6rZ6F/aOk7oAL7Z3QHmfwQrFaEE1/aG4rLPZfTApHUL7oAUHR3i0w==
X-Received: by 2002:a05:6e02:ca2:b0:3d9:2992:671b with SMTP id e9e14a558f8ab-3e3e92ceab4mr94834675ab.4.1753913572713;
        Wed, 30 Jul 2025 15:12:52 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da3360sm91133173.83.2025.07.30.15.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 15:12:52 -0700 (PDT)
Message-ID: <b718868b-d805-4ff3-bcae-3ee8b540707f@linuxfoundation.org>
Date: Wed, 30 Jul 2025 16:12:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 03:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.101-rc1.gz
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
