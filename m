Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793920844;
	b=MNPOPw0Pe5VmhG5f0F0rhTyXP9VE4IPD49WLLeulH9IZvFkqNAQJo949aVt9+SHIIA7q
	 FL/Ys48nLVssRGC7zob1vZkW7xQCxPozos8a9enfen8XaEuFf3RifwCqkGGTBk6drckf+
	 fMsHD0o+dh5ddcqSG/MLPbG2vZYetg4oESVeUwenR0BNHLJVkEWOgr4nX2xynHZ1IOn/o
	 Fq/C324Zd8dALeCq7RcU0VOj2gEPdMbsDhBbsEtv5yRsAxuYUh+SUln3G9DtmqOQf6Vze
	 e1cgR3idL1OaGxC0hy53oj+dkBSC+1xcKxBGqTwCjKKCDL0YTn0CFuYMhZ5tZG2/GtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793920844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=7TboJa7vOyFx21F/S29MlnKjYaribdRj3iyzdvB38D4=;
	b=jFpsVLpwn1tV3swTTj0kUC/f/46qbisSyf+n6IFDGOFh+WoYHeL30lP2Xwn9Wt59Bm/6
	 O7Uck+SFeNWDFpml1zuoFYVsPtoHACK38Jcjvy2joJN9t5MM1CZ6+bmLaul/w7CJv0I9+
	 KE71Nuv6lzfuBPo0rO7uV1jlSo0rVFbmRyhXAwDTM6egUamaRjvGg60li9e65yyT/RxGM
	 i2R4s7RWbbi1mwRTeL41ovVrBFUHPrMMu7fidh1cVYn5MUzLnqDsBvNYi1Lw2qFZOiOin
	 3GU8VnnRnF1X1OeI2nR+P+NdSILoEpQbzaPahtSIyZDeZRJCUHHHgNUYu4hHSaXkhrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=gIYk4l6U;
	arc=none smtp.remote-ip=209.85.161.54
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7069D606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 23:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7069D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=gIYk4l6U
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-70b875f6f13so119710eaf.0
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 15:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793920842; x=1794525642; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7TboJa7vOyFx21F/S29MlnKjYaribdRj3iyzdvB38D4=;
        b=gIYk4l6U5l6iSaXJyomxB9ZAJ/sj1Hro3WYuaRtARoOcVJVDHwubc23ctOLSRMfhjn
         9xZt4jYpEmMN1UUiTjbd4g5XekoZtbrVT6TqZavxL2sq2Tw9APfVPz4p3cVcQ6AleqFJ
         EwHQMD5fuyOZA3xow17m8LvHuTAfEKkDQuPpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793920842; x=1794525642;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7TboJa7vOyFx21F/S29MlnKjYaribdRj3iyzdvB38D4=;
        b=e9nbAPJvWoO2IUPr+pEHP5ueUznGA2kAuBU7kYpjP1RHocFEPNiumNRitNfAjrs7Fx
         itkbrlweyC25yyuiVf53G5OQdkDSRL7vhsg+v4hHCfnB69HrgoUEZdBHynAtIqBAVf/t
         EPTdwISayrDXDprU3dYNOVZtW8RAUS/pCBjlwkCRBsX+LZi9Yk25HY/CR8XE/jBJ3aRW
         M6RiwGH96NetKU0h0BtD4/lnj4k3UvLaxIdBkHgJli61t/PPW2yhG26/Obm6hrd2ok43
         6qeDXeQ2zj+edKvbgrX3Wo9XLdfjlIxcVvTIO+li4riNdK7aDYfgZAtLLp3l6JYX2fys
         ydXA==
X-Gm-Message-State: APuU4Z+BK7/uxS38ZtS4fZIeGzZ6erRNW1NzoJJ0z65xBh3vsh7gX1RV
	8OL7DfYbRbAMaV2zKrgbEEUghbWw9wJ7W3Q1EqHFCoFQBRNxGwqvxAPXPkQlzr7VGNs=
X-Gm-Gg: AYBFou3M2l/zY3olIMlZe6rxc0UOzxT1GWmkfXD48JqWJ8F1QLXNFePDZe8oI8sIlX2
	Hx6TzD6IPxVCiSX70gKThzScS9v6Sr4KADcZRljQrW2COdmh5EDiBMbF2T9FFBuRBRnqr8P9FXe
	0nDHJuJJ+jnZtAMu0P4bpCugMDpg+UBDCdEB+qxKd3PVGosjXYOT4Y496J4WjSGbwZWcNKD0NvS
	Yfr9z5GU5BXRP8wcdj+9qxqdW3RzArNrbNncutGUGXOw45dM7TcF08D/v+L0kT6+a8TDE6vtF8+
	1ybdeqB+hCFNo7W0BwsHKdgCu2t25HimD/+g+835/aOhEM6x+kDiBr5/p/lmsQD07JBx1KyzkVy
	zbQ3Z89CxGIxkGl1+J1Brp56CGlACxceyuJb7miX6hSc6/xac4PefMhzovYjyVMg+4Fvq3JrFnJ
	T2QJlnMeAycZ43SpRl/0H3VIG/XQmckuEUZI6pknZhUuz7xoezNYAjbd5c7QTmSfJidNUMfLvb5
	n3cCeaP7WnuZvALO4GgKI4KCZBslTC/Dk5R8VvxzMmGu+QY2XPXEz5SuqH3ky2RX3hIdNg+mjLz
	EVOAOmXH6aeZAy8ZZeyxsgfYuPHHWs2UJv7Cgt08pw==
X-Received: by 2002:a05:6820:1346:b0:6fd:4277:16e7 with SMTP id 006d021491bc7-716e78e3963mr715043eaf.23.1793920842324;
        Thu, 05 Nov 2026 15:20:42 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-716ea18a791sm484293eaf.14.2026.11.05.15.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 15:20:41 -0800 (PST)
Message-ID: <76fbb257-cbe6-465d-97f4-f8ca51df01c1@linuxfoundation.org>
Date: Thu, 5 Nov 2026 16:20:39 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 13:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
