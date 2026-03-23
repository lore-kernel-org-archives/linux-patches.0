Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5796335AC17
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 19:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774294201; cv=none; b=OHzOZvkCDV+cm2oiMFTmO3xh5fOv0tku5UZfEuZCZz40tF88zUog8I/iVg2Yy2dnLUAO/z+eIh+tGmlxDNo8wIAt9rCI74854eV2CUNnKNqd/HCKaQweAEQ+0T0MAwW0erCRGjMdEDPteCqUCXP+CM/9JkrFaPYmSZfm+J+/ZXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774294201; c=relaxed/simple;
	bh=bh6nVtKx5UAPlvUFk8STPbZr2xUBTzQCe+ZYTkyL85c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAIwK3qrBbsxWUBsEp/TQZqMrnsNtp54W0sGCTpJ9A/L7tmK5cg/VMVcZdXN76TxRwQLpL2XzrJK6xv+lmTjTXMxCGcnPngPWbcA0QtIBgjfYDhMugBSxGJ/y4xKkGuLiWFd5bd5V0zY/sXolafiEecyWpCveZ1jYFwAYDJ1yx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ee4Uo6bS; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ee4Uo6bS"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a747448dso27685611cf.0
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 12:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774294198; x=1774898998; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C49F6R+pPz/MfSx3LZ66CVd5NvbFdip2CBdIxmcwAXo=;
        b=Ee4Uo6bS/awTI6ZzDOUlks7VCkZRlk1WT4nCJLo5e9xoYXtNVlT4emfP563dbjhdNM
         ED/NgbL0yxe1wlpwdDW5GczrU4naX9nSz0+YGunoyM/xFyD5NfL8Z8Y/XhNTHARKf92b
         UZj+DxGLDjTWdO8qzzavAwfPl2V8jicZcV6PM996thGbCbR9VNOR5Jbj0pzgoGL1R8nB
         2fSGyXSywahDouaxAcv/9VATDRKYgJ55cLPtBkHKXhS599QJ3XKCG17GO2BJ+qRl4mzS
         SDFPj4LYLoAdAFZ9KAxQKCjmP7zpL2s6EXNoYGkxce16PpGBlh0wJojTwQJEZfVEOQU2
         syHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774294198; x=1774898998;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C49F6R+pPz/MfSx3LZ66CVd5NvbFdip2CBdIxmcwAXo=;
        b=e+0CocYDTgkIJib9VCDDTRqSVt++3vLyBxt+VQEyS2+BnZdTwSk2EdmQPm5eIvJ9NE
         5Crti0YcXNfOocLkgjtQcsNm5AtpoYgdNQFAwmLkL514qUwdvajC1PeqMfz6qR0DM5BO
         53L9F3gm1tEFNB8aWUEFQR15vOekxd0EK21VZaOgra+bRAj5gV2LdzL73w72ezQo6oSM
         dEyX2RGHr7JLCBByW8TqDSQaIcU8bQpAM5eY5BrMO/Tg5TI7/6Xv8ytrlFf8Hg03vJWG
         Ci+oi6noH9MjhWH5F4mpiMIadX7fx+BytO84Xzs3XTStap0ChZZYf7I4j5jYbhgZkxUj
         qW9Q==
X-Gm-Message-State: AOJu0Yy33CHO7Sk18qky4oSHj8DgHKPVqp25aHozXByCS3LrMd70pyfz
	uU0iPaaqBEqeOKKzQ33FdF+q/Hf/uiXzWCCFCku2VPy54ba5guMzzTAw
X-Gm-Gg: ATEYQzwdrlDS2Xy9UwD7lW5jDm4xdhDvpulNYikH6Hov1ZvG3bH0m0beFoUrelVnQY2
	fA8/xteXxwxb//JP7GygAVMEZU5X+E6puhezVtwn1fFG2HPi44cLybl70LjFrKmGoljapuk8hZq
	/B7WAKeoj3zsTGRzLIMtTRzoK+9vebzZhwbZfxsFlqSoDAKg5dWN9HD8BiM767djqUe0el1usx6
	i6jvxrMsTKbnDAYlDSPatbp0arCkgxxqOJxc6PB0CGusDEcoMik+ISvXgZqRpKILw37buzl+esx
	BLP7YfJgBKmO1JNvmMzMiIKa6mOmHsViPEYK6TzFGh4vmWppWuABKmuQHQIm4pJj+WiqoZaqJIK
	ACTkI//hELDwCJynxnJDyluLdbTB9DKWl8CLQ/19jfLpfZ6WGuTT/qUtxxIN9Oazz7mJJCg4ARL
	25t6BgVpZ08KH4R+77okjsa8Wi9kpQEVoFBdb3D9OvpghVqwe09Kv3D08ZGu4N
X-Received: by 2002:a05:622a:248d:b0:50b:4f5a:b0fd with SMTP id d75a77b69052e-50b4f5abba4mr116611701cf.70.1774294198067;
        Mon, 23 Mar 2026 12:29:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36e9ea39sm88890421cf.28.2026.03.23.12.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 12:29:56 -0700 (PDT)
Message-ID: <be4b8ac7-68b8-4fdb-90bb-daa9e5f2cff8@gmail.com>
Date: Mon, 23 Mar 2026 12:29:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134533.749096647@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.130-rc1.gz
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
