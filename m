Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771EB7260F
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 00:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758674015; cv=none; b=h+OvpR+xOLIzsusZyDybXFbbPI0u0OQPUd5Wq0YzUuC3UKU5A1dNUgWelhKP+5O/cLENg6jASIqKmS3M3yjMiU5xUSNMmPRUotRpdZE6Jgr6TN0r6CipJ4mFy9eAKZQwR1o6i6mu+vO9r/ye/9u7tepnEmIpTizUNe0tXIHUE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758674015; c=relaxed/simple;
	bh=C5xHHpQBIRnwOxQRsuVMnox28OdPSZKgsMEWMSVqR14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PeJErx4BfoyYDz7e4SfU+4SZUEFxZONJgOIGu7EFHQFpuwNy4zdjjBH2SDSMx0zOQnloTCeM/YfVPYVIUSW0iX8+z/KxvKqxUXxbvKWKT0eYcmCJgrexZeNdDlHpTMUVujsDSBY3nfV/KriKFWbfwNpcZ6R4+qV1gIFPCx3HjL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bued5TUS; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bued5TUS"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-4248a13fbe9so25318725ab.1
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 17:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1758674012; x=1759278812; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QeCpOzQKe2yNJ/96XeJlPPvMwoakp9LE73apKlL8nBs=;
        b=bued5TUSsqljI82s4BYU7xkfON/TmRkOFF8j++l/TV3JBAA+6ZScAY9iyLxeyMVJs8
         vIzxNrhOpjkUjCnbse/DvOKk3cTewlnFXh+CjKA1w0LK7+jASsM19MF04HbZ0jO9McT+
         X8bohf7fUxLwcJ7IqRasb/BjkqxnGodxfXJM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758674012; x=1759278812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QeCpOzQKe2yNJ/96XeJlPPvMwoakp9LE73apKlL8nBs=;
        b=OaVROXs7XUhpat+/moWG19My+g6U3e5AxQgQy2n4KgdGpn8S60G42msrqvGWtf597T
         L2qHLmAQhFN0IBD8hZFBn94dHt9uMcTDFPZ5cJtNcGXGB4cnGO3iYe3tj/f9N9/d6sU5
         hav+GggsKZncRIQ8BxQDh26NOU4Wtn4lDl39OxA01Ls/Mq971cagLA0Ii/Pc4XGrTEqK
         NMxqM5v8yOKnddRmFIa13PGjcyo5UmDNrwkbEE2TkAHSZ5wgfTudRQGAXCy6zp6uf5K2
         Z+LIPjiNATgHEqpDpG6GLASKps3uyX+O1xOIsSLNVxCGxgYQC9KgO44ZgGIl3Eth6uCC
         eXSg==
X-Gm-Message-State: AOJu0YwTQXCDHme8Odrco2vz+Sp6OQJQepH/gJrw8wD811cLfSb0NduN
	a9RAVXGHionaQsTva7h6BwPkW1GD2HMhANw9hoOzs1dywjnpm+MsGNyNi5mgGF6CUCc=
X-Gm-Gg: ASbGncuz1OQe2Ef986ZkvoD6+0ybhlziruY2sw1X/K2O9Xt2Gar2ZoNVhW1m2Hx9yaP
	/42oburt2UY3YtBGVF1bXvauag2UdgvrnMYm8k19QC5ESHVRutbaHiERkL2D4EwHric9hsRNxRk
	+pAkzzsagYBy7YEk9XVWq8cyqnnqUJ6mLfqGLuUYDAZeuYjg1oZCcHlPcK3pBQPJ2NUagXtTmtv
	oGr+2gaGqMxDZVgwyR/kqCQmMyEtu6phVIIGBGc4Yg1t3jgW4Lv0agrVv58ig5GqLNCE6+MAuMZ
	ychTYOa3VIROQjNi2b5wXoGPWdrvBwMdCsCwklL1d3u2825y8D8plEvy+iTSGqU75ZNYIvWhSVC
	DVWZtCfZy+qny6eqpFtyKHfc2Nh5wxp3E4Xtr0Nl74i8VgQ==
X-Google-Smtp-Source: AGHT+IGMzxAmPOIYUqjqDWkSj1Vv2Q3usl1ONJIUBuObLOZq0Lscrf1N9LalcNZh3CtVcwMy11Qc3Q==
X-Received: by 2002:a05:6e02:2181:b0:424:71e8:3a2e with SMTP id e9e14a558f8ab-42581e7a670mr60747925ab.16.1758674012501;
        Tue, 23 Sep 2025 17:33:32 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3e337433sm7570329173.27.2025.09.23.17.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 17:33:32 -0700 (PDT)
Message-ID: <69689eef-8323-4afe-bc29-bfb5954137f1@linuxfoundation.org>
Date: Tue, 23 Sep 2025 18:33:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 13:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
