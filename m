Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44633F0A9C
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781781278; cv=none; b=G+DEEi/cee8c90DkzkXGX1SAhJpGyZLk8SRq9QeM34s4qFuDKW0X0dYtfNzNa9C/rV0p/9wG2YiZukYSD9BC4daFsxLOaWbmWAAOt+4qzuZJBbwAkMrge7JJy4lIZmMijKPLHk0mLFG7q0XQ3roBiam1T5hOtTHqhlqq1uJAPSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781781278; c=relaxed/simple;
	bh=0xisGoATiu0CNcq48G/i11ypGmwcHZBkKbRPSzbckeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SFV1H6si5opwysutFW7TFVGljET+cAnFAarMYFbeUUbTcbqV83PNd97DqxFqzFITmQUddbnMGIkVRXWAjXG61W1Yi5vmOSSMbB2DqH9NDoBaA54mT3lu5Q0AOVmm2xjuujd9Jc9miDZ+iGjKJScC8cKHaoJoglz4oR7Hrab3hqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TORr0bd2; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TORr0bd2"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-461edb387ddso918177f8f.3
        for <patches@lists.linux.dev>; Thu, 18 Jun 2026 04:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781781275; x=1782386075; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rXeyrG62+aF39kKcXSYXLiE3a7D4Ivb39fzeBzQrUlo=;
        b=TORr0bd2bYrB1c00URjn5p6uhUl2xIJz8TEi7WRPmTx04JJAnGEgJY8WVyOoi8kulI
         eueQqRucx8FjoT00fa1Bo2Dj+v/99EFg36IrJmreqnYtfeqvKo4iH9tP7YehgRWK+vlx
         Tu45zG9nqOO5PVTt/CMqE5yEcCgn0mMxFZlRN1pP65koYAQTUDDHLhAVoKhnDjX8QZrf
         5S6pY6OpizUzSQQM203wnqut43zOy/XdTj+0tXPAEX5v9egI1Wj3NnReXG8QQADb+WIg
         QHfVQ/pa+svCcOACsE+ImHTxX9cf3RZqXZFyejhjJ8PtTiR6X5Ua8YG0iZgQi+oKiH9e
         rqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781781275; x=1782386075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXeyrG62+aF39kKcXSYXLiE3a7D4Ivb39fzeBzQrUlo=;
        b=khF08YCBqnSJ+hNk70XNnf91WLF2bFRARYvB+xrKV6GHGZ2llGmsVMnPSDCs7HkVW0
         c13B9/L+Qp1iCqydqs05rVE49s0O6o3xeU3Z9rO8SnU/KS9AQxZcuRKQR3vGwt7vxexS
         JX4iv9bzxltiEKDiokSqN/OJY4f13OYgWDE7eKvL8Bv+Zx37qAdbCJwYlfA4zgJjaDYp
         eNa1awcVqjEG6rOTRSCqDeA2L+GKKA+rrRilWygdDnsiOzUOT4x/yNdmCKDb3bDhyQuQ
         Qd38JiRnKFeGteXgRyJQjrMTJo3zV6HlpDKf2mg5FeyIiDQCCmN6k5ywC6Go7aBssjID
         LWug==
X-Gm-Message-State: AOJu0YwLQHDIKNWPZAIlwgn5JPuGUHHQgw2xEmPQuiqeRt9MrzAkdji0
	nIdzMxAydigWrJa9l5Ta3mBE1RIj3Caos85zzuDnspSxc4m25l5RM4bm
X-Gm-Gg: AfdE7cmI6nzPwiZWcbx5m24YEOL6//d3rOHgxhRvfYKOsJA6uGWGS2YY/WCxblPVKwK
	w9GO+z7oHl3nv2WeWXKxF1tY0hIBM96qBIax+03gjTWxPoqDPqO3DLvvRzxyMz8ggNLkljqESNX
	asJIDbbxdLhETndHpeyR8imK8/naYoqWTXRcNlrYRxLnSlOSVvIpN1L6oEGS+99UV1QganmM2RG
	paqGU2yLMeMOtpeORSn2FKymORGBXIqKwqh8/zwdHMs0pK23ESSPjY0rXprmuoki4xCowtDDDj9
	FZ+i4jR9MBMY45Pn8bfMpL22hkGXzcKxCWM87LTZdrHNU9ux/AAyI9wD4/MwnuviF/BznnLkJTV
	nbA+3tbR7M3oqZpUU0oc8gjieN+TEu2u0FT/d2TnXeCQcMD12mh+DgFfkQRms629/RSDho5trSs
	srL3SvWjdp2RO5oJ1N/ZSPVAqRlt//2w==
X-Received: by 2002:a05:600c:1c24:b0:490:c2a3:1782 with SMTP id 5b1f17b1804b1-492333f8042mr133951675e9.35.1781781274936;
        Thu, 18 Jun 2026 04:14:34 -0700 (PDT)
Received: from [192.168.1.21] ([41.140.50.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923a1d2d9esm35375345e9.1.2026.06.18.04.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:14:33 -0700 (PDT)
Message-ID: <60f91bcd-49a7-4c9e-8488-45608184b20f@gmail.com>
Date: Thu, 18 Jun 2026 12:14:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/410] 5.15.210-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260617080316.111043001@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260617080316.111043001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/17/2026 1:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.210 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jun 2026 08:02:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.210-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

