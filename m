Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28BA13D2B2
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098542; cv=none; b=skKeSkcvGq04j/b260qQBpI+DzzlYI/m8DfOF9R0tTCaWFZqPP7O2Z68EGCPGdWtRdpDAfmZNBSbHcTDhXms7m7rhG7uVym0NKL/ISR+txWYHXIZ0HqYipx14247mOVBDVwuNf0xM1wIHIa4ywI2fX+djGSnbjckEs0YMGck4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098542; c=relaxed/simple;
	bh=g+VRb4yRTwwhPbCi5o2N4nNzKovgla+sV32t4ygzyJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kbP/aUb352W0sGwSwAnhh2JiyiRjmzb2MhP9ANjDj5nntRnGfda0M4G3fN1UDiyX/BaqPRykDDP3NfaqqTfC7oL5wmqluVaiz0X0lUad5GCmQvvBZ0U+NGWywXjLYSOvg053xCCXjYwa1P68y4Qe60SBIXidWaTri70o5cilh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fioqI7Sg; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fioqI7Sg"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8760d31bd35so17174839f.2
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 15:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752098540; x=1752703340; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kM92HEH5zfsbI+DNlrhf/9uf+uKIrQAwzHfs3x6qnuk=;
        b=fioqI7SgeqmugpyZTCGReusug2M2/eFsW3DToMoBn2PA4TKxcy0WmHfm/oK737DrMe
         EDUApRrxxKIQIXuakfydgnmwVDpzItlM4ipk0Q3pipaoEN9cp1ImM3kAqgm2VxVIk7VE
         dlcnS/gMqb4JF3Z6Ffi3NnKa+tJqk59kMle/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098540; x=1752703340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kM92HEH5zfsbI+DNlrhf/9uf+uKIrQAwzHfs3x6qnuk=;
        b=c4azau58fR1ky9TQlnDygzWaGXaYswWxxJiNSZ7nrp39dJH35XZdwsRjot8jDWTiDC
         DEyigojNrPJFjpL8qVzlLkM+7NkgBqGtf16z5xlH6jSb9Ap3JCDHfWepLNdGIQrNB1p0
         1pnQ/9J7Kv0oT2MB8uzi1mwxQxaNd56ucEm1BoISY/4JjH79WdWYNyUBZIisDDe+2oa6
         yYG1pvCtN/Mx1TI/cKkkS9N+higCJbXfYgeqwr3HaAsH6PoZ7H0i01dpKNaHQW5fK5tc
         bSnxVUDD07Kf+JNhLBeQUWK3RY1xb+BZifUZkD863aVslchRQnlc31KN2ozEkwxg2Hzc
         Mocw==
X-Gm-Message-State: AOJu0YyIvacw9Wxl7XGUJqhajhIC8Yg1GkZBMY/U0rkamAG+YLoWgpEM
	pmxVCYaebjZ5lA/PTs845WWTYndyiOeZPyr/B/7Cwt0XjS3xxFe1dCI0Dxrea5Z9wk+mTEvkmH1
	pXL+f
X-Gm-Gg: ASbGncuo/y6hiHDXDEhY1u8Ivx4gdoRBeNVNECxhgfmnEBkboec00gOp8Y0UagdZrk/
	kspN9ytVcAG+z1PhFBnhAO1cMy1PlE1/DNco9OI7jDgNXY9hH9C0gScBlOtdKiWc8OqeCYoaOpV
	6m88i2f1meN8H7CkQvG1TtOLwtqdCZ06h1ql0zym0Kbo+SSPB1xVZE4GDUovLjVxYbDXJ7ZdQz6
	nARKUx6DOiZfnWJnolJc3U3wQ1+2afKAWjVLgUdtcSJG8S9ZFs0PnTkDpAmdJwJWig1j58YZeSV
	WhwMUY2/o5Fkr4gAcNoKuffKaC+LJKw8mE5pJLmK/g1xuC6bVkc41ByXa8coFfm+wjgf+HQ3FA=
	=
X-Google-Smtp-Source: AGHT+IF4t0+0q5H3KEgFPgq8481bxlPOMTECM1/CqaWW3At5iyB3YCAM6l6cXFj7NdHfrSCvWvJWfw==
X-Received: by 2002:a5e:a607:0:b0:861:6f49:626 with SMTP id ca18e2360f4ac-879662c069fmr167682139f.6.1752098539767;
        Wed, 09 Jul 2025 15:02:19 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556b0ec50sm35376173.119.2025.07.09.15.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 15:02:19 -0700 (PDT)
Message-ID: <3bd4df4b-24dc-4700-a7f5-4c32c486bb94@linuxfoundation.org>
Date: Wed, 9 Jul 2025 16:02:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/132] 6.6.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.97-rc1.gz
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
