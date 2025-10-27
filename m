Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29497155C88
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761601867; cv=none; b=dTXdhfUIjhOmQbKPTsolKTh3Fhn9RL+IMWcAB1yVWzwHjCgzIiEzv0BwKu6zz58uIY2+NiDq/G0Vdk5xJdeSw5CiYD7YDCAmG06+CHJ5CXjWZI0DktJ5wNKyHPmbiLT8yNIiR4BCZyxC/yC+/yzygsKKU30gOFO1bK69pKMGDjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761601867; c=relaxed/simple;
	bh=c0b2t3qnr5HsGsKFjLxBwS4JC9oQ+YneowGykdOhJkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+q9HNnrA19m+FJ9UUATaqBdNYLdZsrELiOzOhYEBaVPU/mFp++rYjNbyKrD2P0lw8B3M1YYT62cXf0mIqTpVp8pgu7UBV3Pzmj12KfXft/yj7IhlM/LINmT6XrKoKqh0rfR0mGSBGJjO8UAgN88+OmC0n1b0vglQcCsNzWbQb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4PfNNL9; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4PfNNL9"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-79599d65f75so46555366d6.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 14:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761601864; x=1762206664; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OrREd7iHeiHOSpPNpoHh/ywRu6TBc92FEkyLuBrGSa8=;
        b=T4PfNNL9ubn+3/9jousJqRtC39LZuL+01vONU5W0S8fh6RVO+zWkEFqCN4JHz7ZYgf
         dyYgzI1qmcLudZXeQlJdA7bUmXl0jkBu1mJpY6DF6mibSDE2PHTFY543/hgp1v02PNZn
         ShzRD8cJSelfy5C9U4FlXn6BPt+XXjB9swEYOiS79ZjL43P84J3ZuWg/oYwCisgXp1XO
         ztw3kCe2Mt6JJZARoG322/hk3CsZIZYNd2EfcdrKQPN0gSWutynglck7MiTfevhjsViq
         9iyxymJPNtppvult5PIL3//O+NllccHzfAACYOEjXQn4Fn8lw+djF5HYors+xMFFtQJj
         04nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761601864; x=1762206664;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OrREd7iHeiHOSpPNpoHh/ywRu6TBc92FEkyLuBrGSa8=;
        b=L1Oyf/bg8Qjk7p24iVCdyTQrwWQICYWuHKZ5hD8j2BKRb6RKPZWqlzXOW4o7E3Kiil
         SNX2z6Xg4MBuD+Bevh+8G68ikHFHSAjNVyN59Q0cgIHraaN9FRUkUHhviyd37s57zcke
         pOV96I8x4QFg2KzhPbmLsApdZdfF9Y1sUg/2H6enqRHqXEKH8uTqIlN2S8+5AE81SCsf
         FzxQ07pa+K/83zYVVfGKWPacMDs45d3sDfokCxVjYCYV1YQTJYKlCxXSL+GOAYKDNuBu
         IZDdgCtVi3x3jsF07WAaicAfae3YnmMvnvikmlX6fgymxbUnnMVff+2AXCJfP7oPSJYu
         Nd/g==
X-Gm-Message-State: AOJu0YwYBSdw/gm9u1GX2RxDoGzUMvCcS2zEaAO4uggbPNk59TvboH5K
	CDRXB80DiSJdcUfSz8DIELCeksqc73i0ZW0Hz2e5QuDbnqKMh5TXrF6l
X-Gm-Gg: ASbGnctVV9HnE68VoiEeU3O2xk4J+RjLaSW0WGux65nO4ecnsvSP+4SVSZZC7lzoaYw
	P0PeQIboHECG/R3ylasqqX5lVKLz2oBnCip8CNZbEJjCkjDsLfvKkx0yZb5fsnnVfZ6naeEdyDK
	ZWn1ouVWx9KKvEGlhvGXGF/08BuaHWX24RY6Ap4daFqgsSYcVMR7BjVAMzr6nlFMDZSQwveYG6Q
	7hwIuS8D6WiY4c1aJtM0/nEVwWSE7Olqs+kusDYVNCNhIm9XzqlD+Cb6IrvUVbcyvRbOeBg6Na7
	rUJgvf22hIrINbYrI4H/hVQFeKRd7IFexi7cgoowmQSaAJbvjXubyI7jY0wCDCy8jtrvIGzFfXl
	4a//MGkvz0NFH6rTej3mqneUjZ1h0pPXEgbHKbCEe/2Be+p0Yv7fSW3y1MXbn27YoB7UQH7x95X
	g9MMlUb/kr8yfh03fBYZPB4amFL9j9J8T4WvLt7g==
X-Google-Smtp-Source: AGHT+IEwMMAsl472wJTKvmKmtOeEVAzkmf55c6RANBm4nkhvEStvP0PtCn8QQl45Mv31CE6MfxiCZg==
X-Received: by 2002:a05:6214:2122:b0:87a:aa4:4b47 with SMTP id 6a1803df08f44-87ffb119637mr15831806d6.53.1761601863876;
        Mon, 27 Oct 2025 14:51:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48f7323sm63559206d6.29.2025.10.27.14.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:51:03 -0700 (PDT)
Message-ID: <7cc00d0e-1cf6-4abb-a3f2-e96e30cd9128@gmail.com>
Date: Mon, 27 Oct 2025 14:50:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183438.817309828@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
