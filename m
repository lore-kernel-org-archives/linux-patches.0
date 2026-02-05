Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717073033C5
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 20:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770322442; cv=none; b=uk+C4uwNqQ2aPKNhM/5zsfQavb9TmG06xd2sRcOFtKeJWpY3FI0zUpNHPDOXHdO8NnJSFqGmWb/Q6aWQjqYLvI5YTWhb311D3t0TutT5wLLcIKplPHs8Vb8aoQKg+4nvRwW7Z2mvf7pzJ9HBKu2b3VFlo01cGDrJtvCg8GoOGM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770322442; c=relaxed/simple;
	bh=FWbUfHssEGzLc1oKkOl2uoJr0BVLEJRAaSvRg1pf3fM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXR8aSqQEgXHDBWFIXkb7iP9QHMhz89yQpUDeRZgX8yGlLx5+NF6c+LbFetqikt5MfQqAdaUr5TW8wpp8kkC0VGLaxYesJjxF5c2eI0cGiGs15+RtE5KhGqNAEJG7a8GK8a15Fuju8BGKIjiGp4a7cb89sIwXNyJ3sMQQXeE4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUDH6Fyv; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUDH6Fyv"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45f171cb842so913188b6e.1
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 12:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770322441; x=1770927241; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WPq9mEICMjrQhzhTZyXu/GWAlidCLqLgVFjRAnOqLNk=;
        b=hUDH6FyvZ7z0lLCI65lb/rVSYlQZTlk/Z/hnCPKJiqhNqiS02hkw76XuHw5O6228zf
         uVg1e+tG6ug1dRf+AibKFmQqu+bgtYhdyvtYwMhuNZ3+DMprGEkOozA9nl+p24UpUyfS
         a8On0X2RnRrkcVpGr4nrQjW1Bq+N91o8o5RbxdfV9A/G95SULLl/AzMfsZDPKkfuAClj
         CATONPsL2fJvBTyx3Iczvpq0HJkfKPzrK0cipnSsAmFtR7gibUEZFITaLwQ5jWJrYiiV
         yAqZV+mE6F7/qSj9TK8eAPfU8dmhmgcCe9uD7M0m7ALSH6n0iSDfb5x/wOrkvoqzt7nG
         bM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770322441; x=1770927241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPq9mEICMjrQhzhTZyXu/GWAlidCLqLgVFjRAnOqLNk=;
        b=YbSjwr60Qr+O5U1li++NJBnW6GOTJiSbxPoANFPAoK12xeolezr9GMCNusOOkmp32G
         J2+ETSGUu0nQ9RyhR+C8Urjgb6dNItA7+vWxaXMYG0gpbl3+CLcjLD5an9PhREIFoLGk
         OZO7GuSw96B4/ulyhdcAIiVUL83ld32CFioJxY2akWZMe0JFi0lGsaFm0SjoIZQx+T6g
         fFeotIZ5YdK4JaKVEEcVfPkOA64kH3lHqKxbzFHMA9T4DkuZcBdc3qTl3TNQGYGAfTov
         etEl5qGjkPHYXBb15LeRClv9vex6mYoiULBqwwpme9PvzmnhauU1F4rxf6Mt4+SQfMcX
         7AKg==
X-Gm-Message-State: AOJu0YzRD9jp92AqIdKpnYb2txzhUdj9MKBK9Uui9GooUivD5ZT0PAHM
	tOtLvOkN8yd0g48BqEIAme6NdjxsK+EZjszlkyBmra3Ra/dkzaV0UMeI
X-Gm-Gg: AZuq6aImItJ1L3dfzgSMS5zpCkYAlZMc2XFgiGNV00A7EcHQiUw8yjjDuzvpLnq27pg
	KaB6M4ihJXQ+kJgR+BWuxsfm7Bb0aMV304+SFRP8JvrdUtJ56rF99+QzToF02a9UtJjUJdNhfS7
	EFhv8VU3IPYy1PGvaBvLC7qEtCTfrWydA/lPt30wkvlnHQQi9sRnud72gdAxKSIKEpSeJ9Ss9BH
	MwnoqeC5m6sJ1b1GmanPV7fC6gUslYRmQy3DsdEYnDNkjzMtlBD69deKXuQG57CqtCC38ArC+Og
	HMN6/LOsLV3IomFFZqyEJintODVLZCgPu/LlXHdsvejqhykOcIoNc81/yIgr/xwGP2S45NP9B4R
	7f7vLFEsNYu4bf2TBZjPJu3ZU17Sil8WJ8+txod/+kNRglIngABmsqFZ4WFHv06+uDr73cMiltd
	f4qSpVkHzU2wUJRRTF/ta39SgNVXYIayuPuUmkXQ==
X-Received: by 2002:a05:6808:4fd0:b0:45a:58af:fed6 with SMTP id 5614622812f47-462e9ca5ef0mr2115516b6e.17.1770322441416;
        Thu, 05 Feb 2026 12:14:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a9964b304sm133901fac.11.2026.02.05.12.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 12:14:00 -0800 (PST)
Message-ID: <203da0c7-8787-48e9-bf06-70c0b6e806f6@gmail.com>
Date: Thu, 5 Feb 2026 12:13:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/203] 5.15.199-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260205143441.536029503@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260205143441.536029503@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/26 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.199 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Feb 2026 14:34:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.199-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
