Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CB51A256E
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970638; cv=none; b=hzFaa/fFUIRv2VSWcPkTnt8Wdwj0YDPG4r5xjFfNb+x2BN+1+bK/1gjxQOUH02TdB4gxp//GCPvRyWd6cs7KuJ49xLBoJYYOQBXrMb6li/SlsCDLPLrnVeRyJWkDlQZuTZK5g+Diz2xpTWMcBi1Shea17rzHr6z8MYEkH5Zy+tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970638; c=relaxed/simple;
	bh=Y45fMnHMCP8TQX3oVIJIMV8ISnwVRnVRll8M0o7pQf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QarKeJp3doukLYBfsnNrkWSQCuOayyxQqf5TP5oWuunrto6cYRT3Vq1+YbL9y75jafQG7pMZBXbu4dLEB5LDyayg1wVjJV8if2sW9RCpmGt676TPsF4BSGPiOyI7yD5uN6wdj8ilNI7/CTJH1g6niAVaNpPTBz3i7MmQO9XOT4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kckku8Jg; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kckku8Jg"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3dc75fe4e9bso309485ab.0
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970636; x=1749575436; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wJ2V51PhfTVTchVMF1vi5xy+6A1bllD/3ZSU6+R/gkA=;
        b=Kckku8Jg4NW4/WbFHgeN0KD3YKsBVDC1phcYzoYBW7zUj9d+jnvs4caBQxrP+JNabE
         iWbYHI5NlotOJ9c4cFFGQ+i3P4NlKSKlsRlOZ/KDr5eUAYcQMUe5bL65ykUB/1J1MhbC
         2HnQpT7q8TuYJ+FriaPhxXnKydwx4CrN5MrpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970636; x=1749575436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wJ2V51PhfTVTchVMF1vi5xy+6A1bllD/3ZSU6+R/gkA=;
        b=Jc8dynRywaHAuR+9BrMK5XOMPfd94im7Q1fO5I3evHpkvkRHz4RaPVgGcG1837kNdO
         isl06CfJEYERKJufg7M0sSSZKFsF1lDFJlJdEv0VT9n/nsFX9RwPAr+ryu8gGM8KRqDX
         Hd26qyS9LVLE/mDWMKwzJ8oe0SDx9O5jTIv7frbcR/vV1edqOKTDygkcn6lu1LaF6U8z
         e3piTnGSTmCHanQb94ZC6gmjhouGWgq+xHq2tGkoiW/RYXhSl9e9PyGwmNlMQFPzfpO7
         LDhImhBz97CjvCBFcVXhsYBxfCG1bYkFN57Ryus9sZnHumABeJKMiVXaOiKTBesKeNfR
         M4yg==
X-Gm-Message-State: AOJu0YzxOBt80cujats9VFuxySh1JUjJ9Wp5BFvuCLXWfjKr/ABYR5tW
	SDV3oELUUcrILxOS2o6Oi1xrpoPX7dB3r0INHcp4ZfaPGMxPiM8ge+Vq0bVjPOD2aw8=
X-Gm-Gg: ASbGncu8fUfmHMrbMVMCS1fuk8wArHFIC+NjqIc3fV8NcmjpV3V3OMyAbol0UuDdaD+
	0sVgNx6iExkwpwmh+ab8mr/KRdeIvnU6eM4DrbjknFuuJfJjiDjQFDJYnPE0xeuSvXIG8zdGLfw
	tYgPtL3wBWr9kn2t5IvmChHGaQkearhMES2hit3u7ElX00+SQQEUAhf6jdBtX5xwnyn0ZA9i6ir
	UoxWX+b4azz17tGIidTEuXsUzy5kcjgGbRyZmZWpGjkYRqoKRkCvqGTCvZpSxPZtiC2/hJeL3E2
	u8W3bmo/NbLF2pd2csJOZGa0Fyt/NKb0kO3ikX1VpGAFX7adcZyueOlVEZHaSg==
X-Google-Smtp-Source: AGHT+IHCZSnIzYj+uUj9RtM2lKYcL7O0GbB3CDdlfDJe6XzzQYpAbREB6rRXkkRITOQuY/SMAth45A==
X-Received: by 2002:a05:6e02:681:b0:3dc:9d32:6373 with SMTP id e9e14a558f8ab-3ddb7808fc6mr26858405ab.2.1748970636272;
        Tue, 03 Jun 2025 10:10:36 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd9353e3c0sm27240925ab.28.2025.06.03.10.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:10:35 -0700 (PDT)
Message-ID: <460dbb46-ee6d-48ff-9d9a-779254dfd23c@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:10:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 00/73] 6.14.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.10 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
