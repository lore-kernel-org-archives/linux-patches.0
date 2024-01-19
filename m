Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DAB645
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 00:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705625015; cv=none; b=dWrEsd7Z84vFzZRIYyfFpBpwaIE03IRFWtv1eLs2L1PCYDUJrOoMWCm6WnhIUXcx7cOp396DNfL8/MxauwJlJ3Bw/qRLF8z9Sfs8IpZdcHBqembLYFbdu0x4d4BwyBdrZlkS2XBgAR1guDfolFD80BP85NXhayGUTl3hVDxLTMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705625015; c=relaxed/simple;
	bh=We9kek1QvfzEG/FHp8foZ8D3EJ3QMcjcRoKlbrKIHMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mG+lKMuzXlKaC6gtcagWSc5edDOtC25JsBnWzMlmNijT/XnoRvzB2dE+1ycVrOXk3LwNimvKh3HF8ablMj8BoXzbXx5WAbuemRfg7FH5EukN5zW0WikLFI6ZxBgAwIxBZlbuYqJ5D5TqxXL762SmqK9iIq+kpXhtiQ0SgfRPljQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkQZ98+Z; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkQZ98+Z"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bee9f626caso3549739f.0
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 16:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1705625012; x=1706229812; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xBnv0RUX3TFCqj0nPUuecW/H+DxKfFYP4y4/hu5UPJQ=;
        b=WkQZ98+ZuD4jcdnl2r914DCKnb/LUvU/ZqbMsUEb8BgLQarxYxWUltaXi0l3i+p4Kt
         X6eHtXlMtauEVF1ypErpgx/gnt6+6/ixq0VdlNRR0Vb9qa0x3iFs4z3w7wDOu8o1FoCR
         J2RRJdysrblhR3aIukQmVVjORAPaZqLPjjMWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705625012; x=1706229812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xBnv0RUX3TFCqj0nPUuecW/H+DxKfFYP4y4/hu5UPJQ=;
        b=gYjT0tSu8ynqhTo7Exb4y5XdQ5qZDaXgA/zggQ+zz5VHJQieGtb1xhG1ZlgQ79DQYW
         0OeL0ejJbhPXHnoQ7rsAPpD6MPLWaWWy8ecyVFymOve171CdZG7lRCdp4KKzc5rQKofi
         VtyoYLPJdPqC1A60cbiklerEDs2bnDPezir/QMTmKHsTPrKNfO6ni5sEPZayQpXvKJm+
         FIRC9xdXa607qK1kYi4ZJZFFWon9xSL/ibY6TSuvo7OcAZ26VteqBFFT6mDLQvpVUFxA
         UQCnaDCCOEDpTaVIT5QnVcWfEmPx6gSAC3rQRpATyJCs2u4s6CXhIjwgwHFW5/cG43ep
         DlNw==
X-Gm-Message-State: AOJu0YwxCZsAqX2B1/WXE4nGLlPJq9Cu4v1g0GVtCu9LY9ilHg7r5DP/
	0K4cWD5Gu31EOIO3kO6AKqQ5F/HZe7IsteUFiKdW0PNBJdcKzyMbqbXcREtzwXQ=
X-Google-Smtp-Source: AGHT+IG8zgueDzfS9LD6Z4yYM7R29y4jllvVjdL4m76mwgub+kiIq1WXMB2z8d6G4+aySIfGkX8nxA==
X-Received: by 2002:a05:6602:1233:b0:7bc:207d:5178 with SMTP id z19-20020a056602123300b007bc207d5178mr3402541iot.2.1705625012057;
        Thu, 18 Jan 2024 16:43:32 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id l10-20020a056638144a00b0046d18e358b3sm1323950jad.63.2024.01.18.16.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 16:43:31 -0800 (PST)
Message-ID: <459b489a-d9b2-40bc-b1f2-7a3650fa71ee@linuxfoundation.org>
Date: Thu, 18 Jan 2024 17:43:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/24 03:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
