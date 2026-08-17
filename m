Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5983AFB07
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786992851; cv=none; b=Txp9ILoFjPHrOaIrd06/Dd/Z38yWRARhjHkridR+3JtFbb1njGbyXNL2SQK8S9KO35gz14c0Ax7WoNdW35N9jFFH1HAzR77C9Ih5KCpWhSI1uu5mQNro9MU5yLyX6HQ9SUXUidqVmBSj6oihXFpkV7guyBVq7QXmeGHqvWWZM+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786992851; c=relaxed/simple;
	bh=L0Nr1deRYZWpi8xXHW3KEPTuBWUM3hQ+5z9+zteFQH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CmeEHYukwczUgNhfOGlXFyYQVCpfNz/Z6vYnmL8DsiTeWb6pshVB/rLGanaMzejpPoZJwMPgJO+Tuf/xr81OaWuFCNHl2Xhjk78eRAew+zTt1EodhGrKiIPgwb5aUQq/sHPHlolf4jKWS09XLWmqqUJ3aeMr61/bCvDgpeHOu6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iCjP7vUN; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCjP7vUN"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5218927884fso37543901cf.3
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 11:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786992848; x=1787597648; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E9ShVqtKyC4K+v2kyZVTQgSatBC2/+xjxc8q3bLKXFI=;
        b=iCjP7vUNppMtJw3Zh5rV7EJjLKIa7XbiY9qw4ZiGNw3QUmnCRgT9iQ7Au36SvXuIdZ
         aK423qNVSCoqy0O11OhU31bli4Wv4K/+mURIP0lRy6/ev565Etm3hROe+vR/gXI9lDOU
         2xeXVYDRQ5g8cM9RE6aRunzFXKK+6G5BHX7Bjg4WnYOg8VrSRXHtceRy2ltAVMI/shXl
         1+wDCpmZbeLdjpCyXepoPLzI7KeVAGkGINtiVKRUQMWdmDxkDoXP98QxO5TpV4nj06T4
         3LSFHyz8BXeE2DbmyvMvTsomLSTO024K6bNdfxWtMpjfedGCc9Gh1KvDXewUvxpklw1Y
         b1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786992848; x=1787597648;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E9ShVqtKyC4K+v2kyZVTQgSatBC2/+xjxc8q3bLKXFI=;
        b=GdVPQQ80yXyYsT/ZJCEBX+W7CPV/l9cGqxoQV/DIi+LuLilwg+C6wsVoVjqIFsS/4X
         R0BzP5/aZLwarLAVaP3pT390JvCrg3Pa9hEhAyFq1kO5T/fKFdkrMgo7f2rcnBClChPb
         L6sULIuFEdBGmtweMSiSfyu/5okHkxRrGD5M0I0qhDDP8lIhvreE7aQtlAS5lOxNayPd
         yhgyUt7t4dNicnCik2PRa7+jMq5a/EW9gppjyZHUfoffkouZDH92ufmbapYS3hF9cEDc
         Li4Zt2C7x8eEfdKDe/Xkj1VeYlLXkykY9I4k44+3mtwVTdLdk8G4dcXVlw5GkJM5G2BX
         tU0A==
X-Gm-Message-State: AOJu0Yws2eY8S4GxO0CPFOi7cnmDLGViXIv+1mVrxdwMX2rNlhoQN8A2
	RsRV9HErydQvgAsvbTjzGGY9Xt0voWKtnMtZUoO7iScRMTb6rb9ahKNa
X-Gm-Gg: AR+sD10DH5SY9zgVqyuE54+y+sAdc8j0nRx2Su9OMW/IBnviw7pdCvLwhr/J6ggfg7Y
	jI5JsJdCfGa2ErE75B8PjqWjPpkM96IGzvGTlOZKNXeoGJYfrXORgCfWtfNouj0JAG7N0vVt4jC
	ihLsvajNcgk/cq5dODWxKNyehk2Bju/ubBCRbQpfZQMTX+lBdveeVdL+pOEUau1Uqg4TGPMYb+J
	fWRy9Utj1CXrqvcIVjYkMdrB9S7Ojs6xpzSlIJu6Vui3M3+4dIh60iJwMb8dD51VXPcZxMHK1Zh
	LDH1/srowvPhwD6imePdUxmLKiPyniungL8pCUtM/sHEjjIzfli1cTYMbF0It+iAmpW9F2nAHOw
	Ge+nw2C6+NpDPkQUs1mcpfimRYLiFuSdtvY71WLIrRYPBEoHlZEZ5TU4TjZg76YPvjs1e9Gx7ia
	Stru5cnaFwL34V6N4WpKD4MIR77Ae094Ra0HXStKzZxiQYFXf4WD1ugUrrDn3EcJtmE9FPyMUlb
	q/yNxsmLCS8H0c=
X-Received: by 2002:a05:622a:c9:b0:52c:dde9:5cd5 with SMTP id d75a77b69052e-52d8542c8c3mr287850681cf.21.1786992848515;
        Mon, 17 Aug 2026 11:54:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db6216c51sm20553811cf.14.2026.08.17.11.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 11:54:07 -0700 (PDT)
Message-ID: <13de6032-0c51-440e-9b09-fc999b753880@gmail.com>
Date: Mon, 17 Aug 2026 11:54:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/389] 5.10.265-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132538.796021292@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.265 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
