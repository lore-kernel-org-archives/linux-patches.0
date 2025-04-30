Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2668235348
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028593; cv=none; b=DdW1e1x8eJY4oy+nrkqtny126u/5n8eDyBCbqrK005cqOkstZOwIBc//wKHBOAR0Osz9dLSz/D1BlsYa/72BdfXc4ACudzxqC+gSjfZQGB3b4emDdh4kdJ2Ne7BjWSYi7Dtn5FE6PGVEy7GRIgwmV58FpUdbKVFEanGZTvfbUYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028593; c=relaxed/simple;
	bh=pA7CR67AeI1bkOqd63U+4Afv5eGza7jJuigYQSok1LA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ac9J+mhuxU5WHiuROtiuexrswMyAAOhficyoQwm68thtC5IzcaFBSf9iApZ952B74c3bc0i9KQWEGyveAqT+UzOwx6fZyjcg+Q4xSPpabNijtBWyNwGnh5e17XbJ42T8pX+MPw4PRAcnkmwpS1KyF/wmlNgPOK62O1/mqzHeHeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOQV+J7y; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOQV+J7y"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d9030c2b73so34345ab.0
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746028591; x=1746633391; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O3812M1CMfafLY/AjSDZ4rQrf9LGvmm52EF3l0G3ANU=;
        b=bOQV+J7yRqzw1uSAS3bL45l4mvJisCi+AUZCL22scHe+cnnlhX8JKAsR+o4tmGzqqg
         aavOjxKReDh0YPdbqjqrB2JiGqPghuEUVKUrm9kii+Ila6XkKrne2eJxAoESax1paKRi
         2U+V9Ui3t4mhGlnM02HA2o4JP3rH1hPdvH/8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028591; x=1746633391;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O3812M1CMfafLY/AjSDZ4rQrf9LGvmm52EF3l0G3ANU=;
        b=bTfugccboelXQ73tJK6NW0wvstOnih4zyioiaCB1Bwnpn4gdmTFsSso10RX5mWHO8j
         8mhysE8w1uUj1kL+wL+7qtD1ks2bWmVj0aiMwCN9GHaqXNxIAdjWGcCpurp0N2wwtdv+
         eSNW1xYbIntXZgjLZk/9SpI6rleBi21FXi6x+OlPKVH7lATqAYGEUz936+Y8g/wa+4ty
         R9RCnC64DAqWJCDpTeNrQFlsBDe4XshxMkOjwlF7JG8uXMQv62wfuVPxJC9bRr5ug1Vh
         Qp8ZfMk89kJ8Y3Aqz8p4zOckKZ8RrMooOrXNbDwY1L0LBat0gqM8QLrPIzndNiNVH3mk
         +qzA==
X-Gm-Message-State: AOJu0Yx3Zc2oIVToT0ZC+IRE6ZAv96AVhRxmPiyyahUyQVBQxFXZsTEY
	L5l7qgL1M5jEt4FFlTtJF1j7uBkwKcqcomxpVJiQ3drRsYQw8o1VNzZHUFkQNco=
X-Gm-Gg: ASbGncuH/ZLt0aPi39/FzgzRHP0O1yK0wL3X18X6lk+HaeiTS+wYxXGwEOpCDzReJ5n
	FUah9/DY2zHueK0kjvuQRUQgkrUkQmlUp10sLsgE06O586ogIrv0/gN9yu2Ov/c7Fricb6VQm21
	vDxB/K8p9MPJc+3NDRLxfqSMn8fs7Bxv79MZ0yzhfjyspKpNvbNMXXFTxXo432bXzlXR1iLF/k2
	OA8+vCL7sTLTLmo5408lXDRip9LTUUITduAUGsNAydCdU8DMFiCgc8gI47FW1HK7ieD8j7E+omN
	9N+BG8cHd7BGoXCsidnxZFv51tXgLW74rRdGmjZuUJnyr050MwJ2Xnrll4Q+EQ==
X-Google-Smtp-Source: AGHT+IHMjiMeFah9B5OAFcO3f5dp76g+Jm+Si6IcQcOXU2QHU5UbtHuX2e+Jro56r9zfGV6MceYJdQ==
X-Received: by 2002:a92:c24e:0:b0:3d8:1f87:9433 with SMTP id e9e14a558f8ab-3d9676d0ce3mr35554665ab.11.1746028591040;
        Wed, 30 Apr 2025 08:56:31 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d95f2b34c5sm8803235ab.21.2025.04.30.08.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 08:56:30 -0700 (PDT)
Message-ID: <49a90b7e-05ae-420c-8976-7fd1e43459dc@linuxfoundation.org>
Date: Wed, 30 Apr 2025 09:56:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/373] 5.15.181-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 10:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 373 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc1.gz
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
