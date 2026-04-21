Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7977037756E
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776790065; cv=none; b=qwZjiAHeWhsqUC2O5rW5+7za9AtxWvA6nLJACzTNy0VJZ28455APV+UvbzmfQZeWeTNW0GVYEsng5WOTxvpzA8w42BdykoNapU1+/fWpxHJBslGXp59Gkf0Vb4MdvIkAbZZOoaiSt2bK0chDBzbk+eDxuC2w+nN7Mm/MNJbPLlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776790065; c=relaxed/simple;
	bh=rzyvId4uK05JEtp0z7aiwfMKxJW9XdrPBsxYlXrWwPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwikXcL4mlX9sI7N3wOMRT3LLl+O+TvpJQ+2AlWXWIOT7anpOwnDiSrNxuGqb4hsmSX0pnRKqTPJzPkUOMNnHi9wUG+ZAP0tYCBsGzvvoSpHIdt0GJSp3lckE4TOc8qrH4717CWtEXoNoct09MFloNm0O9WoGRqQPWaWb1zybYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5DYTqnV; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5DYTqnV"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4243bf9be36so2130783fac.3
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776790062; x=1777394862; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xz5WxDcfM8XI3iueWbqq2OAOWxZLAUEDV+X56vrw7WY=;
        b=T5DYTqnVylJSeUNxJLE8kMtFTNiJfpJ+bTnkWsmRWdE7p3Ese1fR+TxfZ3+/aQo5sT
         +okAxY0xtu42HDkw+U+MNTi3vIW2uGVBfasGztXOBeDtxLtqN/ztjrZPQgI0g2UA4R+C
         a3NzRzgUHpn5jALgIHOHU+5sMciEBBKRFOvA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776790062; x=1777394862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xz5WxDcfM8XI3iueWbqq2OAOWxZLAUEDV+X56vrw7WY=;
        b=F3dl6/tSF65I1VOZ0g89+3BSNRMwC+b6ZpylLN5TlEgZ4EulstpTyZnadCLRixNDvi
         PsDN20vIz4pDIl59+M456n83KM6ynnxBEUPqUDQtbxg4R0gDY72d+cdglZFaWfmTM+OI
         87E3OL0UoO0o05PjZUylidCL+uLq37BPIhGHzachoi6yA+E/KKxtM1gKGSPUdqBBtfcn
         eo80zvNrHn3ccPNfzmPYc82A+GDSSb6mQ70Gz7xcghES/CPHXZyv9Lb8fRifsM4+e7Bg
         8TUcb6o58U969WxMLwDAW2Taco9ZviVv58lwEAQ4oMlD9koLZ9gA9zBtG1/SjGemV7IW
         aLfg==
X-Gm-Message-State: AOJu0Yylpd/tUqZmnw+tUtbvuRwvgTYOcUJ20eaXtc8gGnLVTPp5R7Hh
	bjR6bbDSmaR9zJ5+1IIV53LWLy1YZ9zAnm2jrFGckN0OZ/Ck8HLh+zOsWhrzbALQmk0=
X-Gm-Gg: AeBDies5zYWRLl3tbMZmGcpZKJL+gjlacezsndWiQOAt6NBe6+n+n5Qd1C14Ioo56GL
	mRt+PKSXh8BokSizMHC9a5MRVPWnkT0JmWUI+w8VHmRwO1GlUv8J9k5rAYrG9jppdQupUPrrxDd
	NVNQbladVk8rYLwQkzlbp2mGgpUENE27sSqntpjq8BT63Oks3TEkvRfanvIt0YlqL8nclIw+8Lz
	PybLO972rvaMSlCbdOwlhURvVYOLzyXbaNPg9AtQGtx1dJPzoprK5L/pn8stHnpHH08OTYLMiRy
	Tmr3yaz/Pfi5lk8WPXWYDe1uToSTfx1+Yu0ugspS6ft597k1pinw0WkXZNdiH5/pNP3ulLERjJj
	fg5LgAYmpQvL5Pgc63vjr/cuXKvmAXKlLc7wOCQkVmviRkYzGXG69k3admvgeWRBuV+1xPuxMHB
	o7nRU6SGAGfXIAGbmp3LOemw0FYjLIaNRRS2s4yx0qmA==
X-Received: by 2002:a4a:ee87:0:b0:67d:e140:344a with SMTP id 006d021491bc7-69462f0ed74mr9175225eaf.40.1776790062364;
        Tue, 21 Apr 2026 09:47:42 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69464eeee56sm9071478eaf.8.2026.04.21.09.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:47:41 -0700 (PDT)
Message-ID: <937497be-3500-4ab4-81da-d05ed17f03ed@linuxfoundation.org>
Date: Tue, 21 Apr 2026 10:47:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 09:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
