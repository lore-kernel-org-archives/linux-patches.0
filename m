Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1228A72F
	for <patches@lists.linux.dev>; Thu,  8 May 2025 20:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746736669; cv=none; b=O7c7pvwr0Czh9FYOHLBK+x7geMkkEVkOBpB4bvn6F0imuPb7nMjZfOjVck5Dk1YfnsyDiW+LWBgEjuSn+S5Sjb1GWZeszYFI5JF+/tm5zQjM0VT22k3ReWCcIWSeg+O/FNh4SRoCd4c1nl0S+E7zgjakhYSa7IMkT+TOz0LA1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746736669; c=relaxed/simple;
	bh=IlZ2JgLQeZR//pkXonNxC8ho6MNB8ZvszUYZZkkxipQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jljn6jD741J+HSuupkq/Pr/lBU+440uSGAidmcBYZOehvFELRzG3XaI3WlWYVN+I5HmPeXfqquKVBIQFlMsdSnJo/WtXjU88I8XtPGG3fQWXsgrE+l038JWlChW3HGvKeuXHiwPpQKUrjt+Vnxzu7SkTnb7clxi5ufxGErUFUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=An+MKo4u; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="An+MKo4u"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7411f65811cso1016347b3a.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 13:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746736667; x=1747341467; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ysNlZssSzwU7Kko7fU5Y5VNdzVq6jh3lbTMABCRGORU=;
        b=An+MKo4uc5hCftPgnluEZHkHYD8/4EZeq7sttwVu3yv6Rxa5Mrdu17ObTObXklZG2J
         6/fktpU7xdjFxCepu5eqFYkdkvfHWSCevzfanXw16XtntnOfRmQFJQQWEagKWLRNNk1A
         wo6492QGSy5wGlyDhYFXnUqHP6OYg+FPVmVWmwSkknC4uM7zKtfCy9qCjXi5hMQbg4B0
         OxBTGtT7RTtlykXVnb22bh+SYfHV9AKe2byaUqYP/isKj99Eh5XaFV5VbVapeRbI7WBT
         9vkklI0vfvONEHFoBX+aMTWZfV9mG/I+oIIjNWBT6jAGpmLYo4DKqiofbdglMsLtTdHP
         htCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746736667; x=1747341467;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysNlZssSzwU7Kko7fU5Y5VNdzVq6jh3lbTMABCRGORU=;
        b=sjL/KWTLHlhQWi7HJkFJhIYEAWji4CSzJYQHXILYmkhScy5XfsZj+1wK/5bK5r9azN
         UOb+INfd/MhOIIbqje6wVxPdUzmFSTYUsiQFhY3ZDQjXmwwnCUK61HTkxXxU7wPz9Ufk
         fvWkdLtvb/rstdtPJS6/CqrencOtcRmMI4ncfefNG29PEnIGPSXBBB4z+bKm5YtJvA0e
         bpoehjBPqvxSI+pC1EtrDc45ZgA+2LGEx6iw05m3nbnf4CYBHou/GEyTV0Qp50JL27eY
         Az1G403ETELZXzPvtNjgbiWBYIdDQWPPxW+KHlxQExApmRr4Frn3DOSGGu9Xksc8Qrcu
         e2oQ==
X-Gm-Message-State: AOJu0Yx+n9Htb1M0INkj0SocUsIEe+vJTLs35OPapJQdCQLe8NZBirVG
	T6j8V3Fg8fGnEtciyoATWNBH5KZrY6UIIxeVUXnHpivZFVRGAZJh
X-Gm-Gg: ASbGnct14AqFr3eX9plVUeXAk1z4unCWdQwJOqeNv1iBuD8aMBRiNpuWcah04h5LaeZ
	DuvYBHU+MmiJhDM2jwb7Gd3bV5a5uxbGwmYEk08oFl2+Wpr9qmTd/h2tpE0qkr1JCNe7EvLUsQt
	0YpsdDYQwx6w7vGN3/klQOZw3GHBTvIY7RW/Pa6FgYSNe8aawKNVNCyqOokeQKpasswQvyO3vbI
	9DwqwS9Ioh87QfViR5c6+PkBaHizQgzEEC9HJC/pqThSXbeLXP4h1nTFxuwVn/xVqcE2dOyFLsu
	aHVHkLGqh8LD3tLdhg5oteFqq9D/EnfIRzguRnt1YvpBULNj30TZXNR71LdsoUWUP3+9FlWM08G
	Mt6k3
X-Google-Smtp-Source: AGHT+IE8J/x/3mlye21FbKe7QiKbsMD8WVJ2s7U14Sbz6Lrw05tImS1mJS2Dp9ZcKsHMnpb/yzmtrA==
X-Received: by 2002:a05:6a00:a10:b0:736:6ecd:8e34 with SMTP id d2e1a72fcca58-7423c04129cmr967854b3a.18.1746736667316;
        Thu, 08 May 2025 13:37:47 -0700 (PDT)
Received: from [192.168.1.177] (46.37.67.37.rev.sfr.net. [37.67.37.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a8f520sm454541b3a.172.2025.05.08.13.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 13:37:46 -0700 (PDT)
Message-ID: <3e25aec6-6726-4dfc-9ff1-21a3dc62446e@gmail.com>
Date: Thu, 8 May 2025 22:37:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250507183824.682671926@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/2025 8:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

