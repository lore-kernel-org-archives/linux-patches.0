Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CDD19AD8C
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970778; cv=none; b=gWzLTfD/G2pptANcp6wNooSyxcT/Q0GX77znQh7gZBahSW+Wy/Om1lXcK5iFop6SebsozghJWbk0gU5llRLvoiOlr7jt9BXTwU3n8Mhnw2MuOrVDSZ816EnMwIMmNJNLkKxIVvbTeYMbOfs3GF6HEZ8DRZNpCIscdg1VBx31UhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970778; c=relaxed/simple;
	bh=SI1mAy6K4lm5YNnUqqJj/WtqEcaaqnPOHPfCDszHvUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AIDpGvBNwpGkyJbqx9MXsbBYuRyCCXNiwnU6hgskvFEsM7tcg3Bx+L9qRkoUO54N5Q+3lsqqGLJj/SiCp0GPB/VGuhHeHKcelmJvMV/kAHber5FkXJj/vN+qrPu9SceUt2f/5lfl4AOPBeqK9Er3ehLrrVNmF3VPkeXrFma3t6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZXqQPYi; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZXqQPYi"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso17542035ab.3
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970776; x=1749575576; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oxipSsAkichQGT02oXY7CtjNAbrB7m+GC/cvW2mwdPc=;
        b=JZXqQPYijWvkO4HqE55kWxjd2uwhWP7fets/0aVCRpTTe3IiGHLIAB/Q0VSiKorWp8
         7gJqT4yr+JU3Sp1vxBuxw+yHh1AT5FQpyTP8ibrHA2sRXhLBGv8C/mKXR7I1Ao/TMOPN
         s5evvoZ74VYyPiUfXmuOJA1vz9nRTwyyUCuIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970776; x=1749575576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxipSsAkichQGT02oXY7CtjNAbrB7m+GC/cvW2mwdPc=;
        b=SC+IVtoUfD+xIt+VfgCul1xyVpCgEeEhloDbJDCZVIP7a5lDXh8ll5M+QIKK9hGXyt
         asyCnuOxzxytxsEumqTBwvXvbYtc5xpxIrc7PpTsE0L8jCTsqZAyuzOIyFP2cixpVxUW
         gSD8+XHxXYIel4sjuB632f4/Vtgdp9lmwqbOt/k/Mztr3Jhy1pwlIf8XZXqubSzyjf6m
         REjeGb1eCh6hOC+SbIONr4P5/sjAd7DKW1LC+w8yP+VG+QPwGuirSgBYGEcV8/sfDP6k
         N0JfETfQngfebrGT5gd4zqjcHazoYywaFSSqbJUkThWG+WXgA0W2TFaZNksTUmuOu1N5
         S0Ow==
X-Gm-Message-State: AOJu0YylIFs7sTWYmP+y1cTNta/RDQ5uy+bw06NOUU50X0HcKX2dweuG
	h55cLi1p0QWIUFUNnOuAwZ0bPxDXA+aN65xJkzaQQ8Y1fTqoIYuUs62t/QVv+BBhs3c=
X-Gm-Gg: ASbGncu38QN4R3I42uxnkHL3oOwvKw0omjOlwOudz4bwffr70cjwwyHgE6d1g4vCfOe
	rSY0hF9eddoLJQDUcUtGDMjws8vYfrqMsRQu1kte4ChefZlDo3uwPFFqZfmPCP00lEhMpsssQMJ
	oCQMRbi8GLI1Igw/2ldLo2uV/szL9XDjO7DmsPfQ2wTicW4AzMuzPdc0I6I/irtT+FBHhI3qjh5
	ifvSalqk1FJ9MtObDaz4ZW6PbCLAX16AZFZWD9kWWwySKVsriUc1al8dm597ra6riUJseYD735R
	0U26tlsF87IFSTR7huZN4SD7oqVpHSJeyXzkRc2zcEZ3jaoZ0AFnJsi5tPa/CA3vCGZgtmUf
X-Google-Smtp-Source: AGHT+IESXIfXyJ7aYiQmXE3EiJ7rnApNSIGacwWXavrUtkBPmHYuCguUJ/DRscPqaTB80ts933EkpA==
X-Received: by 2002:a05:6e02:2704:b0:3dd:8663:d19e with SMTP id e9e14a558f8ab-3dda3370d40mr111673775ab.10.1748970775694;
        Tue, 03 Jun 2025 10:12:55 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7f22536sm2408814173.134.2025.06.03.10.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:12:55 -0700 (PDT)
Message-ID: <4517feb0-04a7-4413-ada4-582602abbbdd@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:12:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.185 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
