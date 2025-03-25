Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F32A823DE
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742925044; cv=none; b=BRcmJbfwVcx+mV6OtSHAMl88kgeoVxupf3HVDzq61KI5UVaAzW4SbQm3quBLSHaCHIfizgdLOzWqGIPxFfjvxW1xfDFc2PdFDbXzJATr++ywXfX0JIKC/qVQSRMnfr4jzyGicxMhJuTTBmrm57oaVZaFH1bJgunwDh+j8rzI77A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742925044; c=relaxed/simple;
	bh=aWo66zMNZsltX267eS7ieYkDsrrujgp9Ss5dR7uh+3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ze96s0ILRyxT6XbbK+1a5XwFfXFi3JisEnDhuwcx4yYkHrBpcKRUlLxDw8BytASuP2f8J5EeOPEtyZikDJQeL05zI6hCnkVl7sjMenPf4ZCPoMx+gcDkuJygXFmlcdlI/NkPt8rTFKZVCsDqYH9mVsU9No1BDTnAJnkdnAUuzkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f5vL805c; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f5vL805c"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-227d6b530d8so47036955ad.3
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742925041; x=1743529841; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/9O5z5wpMAD/d6DKPdNpelq9DnCqpNf5QfA4sBqy9fo=;
        b=f5vL805cvKfypPSprVkYDunklpPcINDfm2KU86a4KnqyDy3w+VYwth0bZtRYbCF6xj
         DzAEynRSzAhN9Bi4XWcPCQAPqbW7oJQCuU5DnrQy/1t+/gcAFeXV15IoHyi4yzoBwv4G
         vA/6IoqJU1dfcWz9EWWKk53JpbYaf8A6thTKTuWLi8EOUOMGqhfi9lHf7fVidYVx+zYE
         FLTkf+Spd1loVVGQ6+Wg0Yc4eATKPzg+jekz0JX2xrGN0OeNMNkOwPBJ8uy6y9px+mRL
         YQMfv48J6Wa+c59TdsS6vSP4pWiDjC6yx5g7D//Al1mWI3wKZGu5KE1l+657I7NNIqFs
         lxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742925041; x=1743529841;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9O5z5wpMAD/d6DKPdNpelq9DnCqpNf5QfA4sBqy9fo=;
        b=T6Dws3Nn1yD3f38gk0vKGSvH/3rDNGrWAt+PZAjvFwcy5FH89TW0YkuuffT9cBMhAA
         Uh0jd6yDGd9XC5LKc7Iv/msTyXoKnhCjNlsxuqPkQmMsv7EfFUGQBOriBLVA+XTyGnOK
         HHLxYT+PNO8Jx9mzhtykTL2enEeGzmbT/yVWCtp7twgJzjLEQURVEnTVIZt3+E1otxrT
         8slkgvsoP7OOm1c2jNtbwwTxr3t4ZR45axE193O9rNyF4Dw4ZC0ahuB5LQQvG31z949B
         3fWl37wczTsesN+eedDllFq0lgbgoPhLvuITaDP3g7S2eP0XsJ9s0oIHquhux1va4FYu
         B/0Q==
X-Gm-Message-State: AOJu0YxZ8tvRUMy/RLm+mdo1WovEjFJgicCqzVm7r+UwOtV6sZmgtLMY
	0MXlZ98HTDyIMWQOLM+9TtDrHwq3dVZ066CDpb3rOF31Lts33mIC
X-Gm-Gg: ASbGncvAkJ9FmwsOZSWu0KS1QXg4eSgXd06Gppw8JLOG2Bbbbcm5EedB0MAXJN4KrXw
	7upvLjJKTHXKfjaEnBmF/FO4Rn74/AsYOUj7kc6Zu0ru/Lf3wlZHm9Y2OGakoHWxso8AaqriCvI
	DL9WmGjhUJY3wCjz1Gb53jnVl6QloMPIQXdymfOvPtYkgCnNlH8XDgXLNB4PZ35mk7Qn60p545g
	OcoYFMe72J+/aVASfThQxTmWwnfRdyZryOTJLl6xVGlcCwsqpLgWwQpCJ3TDFQ5fv+7CMKEHHTJ
	+2YQ6Aw1ukVVPrQEIJJqbq5LbiQm3nhSvCtyIq3NXSBP2M6dP0iilC00pfka/YdoULJkyCLA
X-Google-Smtp-Source: AGHT+IFNy/AoA3IgJdV0KhVTbA9UE/acBjBDx4/c1rrBsATih8TDS0W2KoovloZQLPALvZ0WeLCU1A==
X-Received: by 2002:a17:902:d4ca:b0:223:4537:65b1 with SMTP id d9443c01a7336-22780e10a22mr267093925ad.36.1742925041400;
        Tue, 25 Mar 2025 10:50:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f45857sm92940905ad.57.2025.03.25.10.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 10:50:40 -0700 (PDT)
Message-ID: <6f1865d9-fa0b-46bf-93e4-ef8d86820d4c@gmail.com>
Date: Tue, 25 Mar 2025 10:50:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250325122149.058346343@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/25 05:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
