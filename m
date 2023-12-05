Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499405F1FC
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 18:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLZuYufX"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ce46470647so1905355b3a.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 10:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701801992; x=1702406792; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CjVRAabg54DYaUkQE0x+HQEZpRifdvwoWnanLEPmYbk=;
        b=HLZuYufXBUVewJG+sTpOl4D8JwFoUwHRY8nye4ggRwNyMC++q5r3v3Xo6lfNWVPuUm
         WR6K1wEtXHtWDRsid0AkUzsDlRzY5oMx7AASyy+e1AeqcxfLmfkyoBrVSqu6fcDSSASJ
         tlDEdrVDfZNiMbOpti55n3q5iJQU2QUIIbZxIpffOK/5Eigm016m31azxv/8byM5N5Bs
         L0687OUH1ayCwVoXt9zHU2IEnSXqt4eku+TKDlrhB5+FNQsfKE8ZzILhBGwKm10/9sTo
         N8MdeTzdMDSylw+Ky/zPvcKHzOGY3AHnhBXxN+9tSpFyUF3UNOMHWwS6riGsy5fCngG8
         xWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701801992; x=1702406792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CjVRAabg54DYaUkQE0x+HQEZpRifdvwoWnanLEPmYbk=;
        b=FteKjM7Fu8nLmVF+wBI4s1XrSBcYlJHLSNQ8JB/LenW5ZPIDbBndqQGJ9AwwVYU1Pn
         Rc7ruPNhHgLms3TSUVTT2h2zthxjIm3IC4CzrACgwQpT5xhoORM8OeBbJLsGiQUnETN1
         PhYjDffdfSq5dzj79cFyK+/SAow1Uk/4b0av0ORmBYr5kTHEMmQz+NBBwr40imkrCxqO
         ptDZPj6W/bku5vmuAMlZ+N1ODVjR1nGFavpV8t107iqKRry01JBxcWThKf3YN+VAr4ou
         WIFriQlUFcyzJr4l0hX1YN3UbJ6+UK2/GPcezZKYNoIDkAEUK59urnsy5vV1+ZIgKSrf
         heXg==
X-Gm-Message-State: AOJu0YwjkpwVVPLshbGnBNUcry/D5WVQv18Owk859m3S18vT/SlKmWoc
	7Kn2WSB3WOHk0Y6qGHKExsg=
X-Google-Smtp-Source: AGHT+IGXta1ulaAYdeZtZ+IcEKjBU6b6E/TwofV0oeYBhqo4fwe18xdryCv/mSKvnp3/Vf2a7f+D7g==
X-Received: by 2002:a05:6a20:da86:b0:18c:57a7:ea29 with SMTP id iy6-20020a056a20da8600b0018c57a7ea29mr4037407pzb.45.1701801992470;
        Tue, 05 Dec 2023 10:46:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z20-20020a637e14000000b005c68da96d7dsm2520922pgc.38.2023.12.05.10.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 10:46:31 -0800 (PST)
Message-ID: <b36d17a2-2e7c-455a-b815-2c97606bbf6e@gmail.com>
Date: Tue, 5 Dec 2023 10:46:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/134] 5.10.203-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205043610.004070706@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205043610.004070706@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 20:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.203 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 04:35:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same perf build issue as reported by Harshit already.
-- 
Florian

