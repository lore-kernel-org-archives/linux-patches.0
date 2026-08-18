Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BF5430CC0
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787074531; cv=none; b=Q8SQ0Hgvy1Yw0Ka5Ve6oT47XzItlV7mxajfWleyerwiEBSs1DBGmhcRXNg9F90V2GFo5LIezbaGwXRF4a10xXl9CgJ3Ya5qRobCwnpRw+qGlN+yHBRMH7vT43cbE63HnnJaCGWFrnwxAFsGRnOJx7jW5Ieqc49TLWQqggaMT0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787074531; c=relaxed/simple;
	bh=vRv4p8G1EikQLPTLt8iSs05htgmriR7ULX5yE/7TjEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cZpw4R72sONqNwQQBgQj0bQrVG0jfIypyzD78snPQn6Lj3Uha6zLKoSCb9Tks9i85KPj02uLHTtrsVjF0PfzRnYVbHxUhrBp0etDwe3ui6nGPKVZ9/fvZHlO0SRiFI2bQNpeZ/gkTjMr31e33axCjk0pQpNKa4rv44vTXHcxe0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY67fo5D; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY67fo5D"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e9eaf04bfaso46899a34.1
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787074527; x=1787679327; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YVBcDDnKF6a9m1my7xViaBbBdXKcVdgploI4y5YU0hY=;
        b=gY67fo5Da/vYdriJmr+1zqu3jN84hjfzpYDa0plww7GcmslAANG806enKNwlFXYr6Z
         qMD2PV5JJgL63QnFsGENpyDyps7aO+ynhI1fv2+t6ua10/0cz/0TkA9t1iCsX45XGArV
         0e8JJV1oL58z9D5qPbE6TO+1YHkKNW32542Sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787074527; x=1787679327;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YVBcDDnKF6a9m1my7xViaBbBdXKcVdgploI4y5YU0hY=;
        b=s5LZzpEaI5XgzF7Fw5h/+mL15ozKfdbLfdb5hZmkDfevTk5Ikaw+ucMN/9S/xDkOeW
         gvV+Tr7CJAJqdAmF6+3sDuQWqyZ1o2UiSQjXVSQSYYaeRJpgl2e4VLT+Muxcu4wqxlsS
         mIZ7dpThum3rKWZ7ENSOXhrjPt5h76BY4m8IWbwt2FnO6JvUnZX0CrYoc6Z88frIkxSe
         Wz5kiI8sBdXHV3VC9l/FqE0+WHVIyHem8ju0KXWGxtlVeXJ9g2MiUafPA+07XUeYBHML
         UjFgOeoRYnDYbGbxkI2oWrfJXaZ6PAmT2kcL/Dfu7/Ltl8EwByNvi/YyJySqVKOl4KAE
         lRyg==
X-Gm-Message-State: AOJu0YxKqt7CLm1K49xV8rO89SJofY7PvaLTD44/B/W7I2PBnofN8Lpy
	s902cJPDk+vIC0yY3UDfnjbkEQY3MmfgWOhF6L39urQ4KHC2cO5tWru1cagnoGkL9ns=
X-Gm-Gg: AR+sD10AF14CnNMz9T90zGmAhWT5bucxfP2z3RNIaL3LqzJxwX6hsK44R9LQYqy0Zz1
	QR8sZEEiqYBjVH23SLEjpspXKY+HJU2VSQ7A6clvCQn4k9FJr6cr/rxJ7n9qWy42+ppvVgbTTm3
	QH2l+2mEh/kM0/Ixb4rwEb21qma9WhjwpQVEjffnY3X8hw5V0PkqrN36MJrMZYchridvrB+c5pY
	AA7bvYM7dGJPV1gLKe1RWXwrcuLiloR2PjeUundf3xUtNsy4/Kt0by5v1IUmpjtCWXjVe6nFnzq
	rEF/2wm8HW6OBPNQH8+dOt4PEwXqTuLhxh8Ble3mhM5xucc0NKv3ffzfyFI/4lealexU3HS0g8F
	Lppqt7yCQfD2p3zaYVBrGeuk8hlH3F9UiGnNA0hHglXWtUHzlPz9dAaRzOOO/pCBSLFWLP3vmDA
	DEFqBwplU5rtgGUXKpKbtuhQfblr9ctjUYyYsoAmQgNZHJ8n81UPoKCD6cpR/hv2Y8tkXdQw==
X-Received: by 2002:a4a:ee17:0:b0:6ae:9efa:b47d with SMTP id 006d021491bc7-6b0d5fb5dd6mr29851708eaf.7.1787074527221;
        Tue, 18 Aug 2026 10:35:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1166fd581sm5225084eaf.15.2026.08.18.10.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:35:26 -0700 (PDT)
Message-ID: <cea88589-5e7f-43eb-8cb3-5f71dfaf62a0@linuxfoundation.org>
Date: Tue, 18 Aug 2026 11:35:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
