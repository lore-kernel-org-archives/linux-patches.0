Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103214;
	b=4pRz/LLFSfHcD75zI5yUVLxeX2doaLbMilLuvEJ/InGAoXEpEsZT7v9hhoVmaOcB+YCk
	 j/dbCQy1JNWf/qTS31H9p4YszW1bYFfHKua8mOKKvW4Qin/mJav2Raj0FuKG6Ib6ZK4Qy
	 m1NvIu+qccammBWX9BRcBmMryNAuG6JvhaJiEkf4iCs2yfB9LGz/bnBAukEreR5fxpx7j
	 lKlsMwHbgWRr3nQcQGb9kVM5yBj+r0zNNg+hD4ateUvSkMULPhLDBESJ+S0hNEYyTZUwg
	 ZkMjHEePV3uQsyKgpAORym8rIVJ6CuIDwd8vncjqHLIZ700tLqZt8x43eblw4xpD4+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=EI6AD+cTGv9AwoAU/9fE+a06GaJxs25LC5gaQkSzbV0=;
	b=tfZ0hZLEOC79B9AZy+zFjZ+8afwQ58/f2Q6efJRyt3plhb9HMVfdSaqWnpabTzxlwl4v
	 rHHcmPBCDF4o71uEd1V20xaHOOQfyEzX2sJf6jmp/dHU8PPsuB+FR1JfQxUqCBqdMoZt8
	 3NXJp4AWneFtZeSVZVYDat/0YOM5T8+Q+7Rf8yF4sY9CzI4o/Xvdqr0/T45LS5D5AH6Oe
	 4lHAg/sSUkSSCrLkUksThaD/eCuFw8KO7KWS63W73KCFwv+K88/0+OTgkDZOpTHtA5lsB
	 hNU9J4W07QdNObD29ndxLTCmI+RjbRtnBMgw+s3Ieezch4xw/NYXfaRH5qYV/CZdI0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=HuOE9RCL;
	arc=none smtp.remote-ip=209.85.210.48
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E9606A320
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 15:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 347E9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=HuOE9RCL
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-862aca1ed4dso1000973a34.0
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795103212; x=1795708012; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EI6AD+cTGv9AwoAU/9fE+a06GaJxs25LC5gaQkSzbV0=;
        b=HuOE9RCLlChwv73e4rfBGrRewBcAOuDW6noHXCRoOXEWJsLBRjFa8iKSEMbnoO+0IO
         D8AATcbWOg38pnWJZcqsH0zQ9wsuxS4vd39Z9H2uUGndh4FPTlwLV0geCjFoqHQrDNTM
         QeIuxAtEMCBdA4fI6OhtEoFz6XAHd6YriwGMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795103212; x=1795708012;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EI6AD+cTGv9AwoAU/9fE+a06GaJxs25LC5gaQkSzbV0=;
        b=ju0ExT652vzobYeQ0zEIgnEJTtYAhB2Px3FBdH0MpH5bH8cmMHUFak2oJBX1tiY2Pb
         H35dIDMydOXUHDPZwD/fN3TBLm9v++UGUohXC6mn1HG8tSXca+cP9jJYkYWq3q3b+wfg
         DiTUHdAKEYMkL9uP6U+OAeKPTBPEM9BdwlQ6EwM2ADz/uNdfT/wGlwo/tUjtw0Uhz/sg
         oosqeT2q8Az8KiywX8oan+8TLrJk5S3YtGzfCpXglAwU5i1tKWOw2SW/YkJpqhSWfCYe
         WA3MFclgmlK0kPdW9PJplJVNq6UxOLv4fD6Vh0bKRGPBxVS0x/TuPtBcnuGgP1ygMDb4
         yCEQ==
X-Gm-Message-State: APuU4Z9Wfi5xvHNS5eVyU5zl2ZyCEcD1UFQso76osu8FTA0ejXJ7JQJE
	gDCM69kszxwo4dFbLFF/xfxKQWX/cvurf2MC/5OJSbky8ydvWvGJ7ZCepi6/fty8lu8=
X-Gm-Gg: AYBFou0UNQBBvfDUBJk3L7ONvz1i+LVF9atuf/27eOAtIVp+jKiun7FkPLA9oWHOhUm
	ZKR+KtWp0/4Ni88nxw2Fqo0T8xhbs+uEQrKxvVXsw8UrFVLR7Tf9S4NJpC310RZYOaKrVU0J7le
	RS4UNTbMMgIJSQX+EtoNoiDuM8JZdoFA16JWlNgdIuyKSitDdF6oYf13NUTvM18WGPwETLl/YRb
	OATJpd5AUE5Umw3UCweK+oejFB0PMfH+8lu7KBd7zLqD7rRPTXXe34BESCbBIVCDalxHE26V0Qd
	3TRMqxfx4fxMqAdD1K9Ws3MYWMnZek8PCg5RPPGYBGLEJZg1BAL0+YSGU69j+icvEhOuCxFMiWp
	m9PcIxKnzza8Y0nCYDq4CyPFdBxxDYD/1zIT5SKRnUfiRlsd3gTHbbg14MztkdVejtbG7OvHjA3
	o5KYHHat9php5Jyz9rWh8m95G30ZBJsczKGhqWjCni8Rgr50QnisgwP3KCL6baA1DP7gNcVivKE
	81EWoF6rRBOhjl3uVtx4jdRW9w0zvW6c2nre3ZFxIFco+ZKCuC+rPt13mV4O7X0i8EOtDhv1KqG
	b2Nnav7rj5vDQQg9u7s2BG/pijM4q5DRTSOw/Q==
X-Received: by 2002:a05:6830:448d:b0:85f:1601:d3 with SMTP id 46e09a7af769-863157af868mr264649a34.23.1795103211993;
        Thu, 19 Nov 2026 07:46:51 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f023760asm5047157a34.19.2026.11.19.07.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 07:46:51 -0800 (PST)
Message-ID: <9f67da18-8dcd-4f2e-8599-c41779b5eaf0@linuxfoundation.org>
Date: Thu, 19 Nov 2026 08:46:45 -0700
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
Subject: Re: [PATCH 6.6 0000/3318] 6.6.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 07:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.163-rc1.gz
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
