Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6F23BFE41
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781781821; cv=none; b=WtjKBa+n1ncgVVX1tGHphYPyLmRn0piz4A6x1NZ7O5EP1NMxWu8NyPKX/nQRQToYIuxI8A6Lw/SXQMO3fOAiteci/ssHs2MF0ARApp/qSugOGJ02T94rRMK3osfYd93YRssIcpI66NqF0ziOkYzZm2PSvjP6sHtOdh4T7wpBvGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781781821; c=relaxed/simple;
	bh=Kdo03FWGHsloa+ebkfj+J1rIruukAmQI1i7Xhe1d7c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDiUaczJX2mrvNRVgEjbJ/v9ScizI9QsNbM8ijg8WpcQgl7qrkH0k6gdsRu+lh5rJkYhUygzVI4N65oCLf1t4N+czEwIf8BBr+y07lVjXPEEYh0HEzvak5X9+npZUU0aHOVvXAca0SoQm5SGfOffxzrUw9kgAmGdCUmqdITt0PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bViBL7R9; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bViBL7R9"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4908b92904fso10953385e9.0
        for <patches@lists.linux.dev>; Thu, 18 Jun 2026 04:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781781818; x=1782386618; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MDy9b/yhQPJBeTVG+UJTnPxaGac0NnatlIVMD6aa6mo=;
        b=bViBL7R9CbJiyTgeCixnOR9WAvorEBx8E/mWfkaoyoq7INHOx09n51Sju+5LhjT/Xn
         ZdZg6SheBNdPlJK91t+zRRHIAezwD33ThtK3nYTmygemBLiqLMoIFwnPCL+tUMjuWDOh
         qdK68AIAuIH1zIDp6bx9b5nww07EKrSAPyCFZinR1UcCi3ZucXMYA4RQU+N1Bb87qpxB
         0v3ek0epg8Tl/EsnveX7FzHT9egr2AUh8uFaR6/qcqM17rQNSr5mgL23YOgvSq1V1NcY
         nSK56EWnFwzGr8uOnnRcrZplIk7Mb+pGufexX3eFjJ4eSShGTm6fUF26FR+LrSg0UiuA
         g0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781781818; x=1782386618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MDy9b/yhQPJBeTVG+UJTnPxaGac0NnatlIVMD6aa6mo=;
        b=CywsCVUIk/JRz7TtcGHlkTTpgnqRKbHvlDlfs8hnTBD1SgivdXaR25eXlSLwNdarub
         jBRSebM+0tIQJzGerjhhK2tMmxdxNQJrfmS/8zenZstOWM8mx/L2CqcJNq0D1xh+U0ka
         Ae+b6Oz2327M9eHLUuwuf9fpjttwTIFaYVIbXFPWQuILj+6xBwz+mr7WC2Rpt9jHu0Rm
         3v1zHJ0g348R/QZ9IXN1gCiX7hOm7Owc0Fxt/M3DXtUywI1zJ7P/RqgwPVmomu8Hf9gr
         4Jqlxu4CWjk6D9CH0nsE9dBUnhMwJZSaiiW+7CZ4hwlxE9gQiuwHA82YXlgbJJ1+n2+t
         7Mow==
X-Gm-Message-State: AOJu0YzF+CqEKhAGmarPn+c2vPMKMMu5q3YgYUZp+V4o6Pbqi14vMGOD
	Oy134US/tj7YAA3cwkaBHooQmRVZE/1lX7pr3CCaEBPFfDn18zXnFoQB
X-Gm-Gg: AfdE7ckdWDcKq+DKwIpM5XMQqIKh/jHmFqy8f6cR/rJut6H6ssITKceE+lj83qBJR0T
	7xPIvvBN4velaze+CzXxrukJ1wmgcUS+gSHqKsmdxi5iw5w06JW1A48k4U7+HYiPCJxWA+kFteL
	T4g98eTJxaaZeaBkZdYZnMzSZjoRT5zfr/JZo+qaAJ/b1Ckx/ie1PKL2wKp9Q2tc9ikfaXzBMa+
	RpP+vGjfJ0aFR06KBfYMNNDbDZJV6si8lghrQvczy7qcmYZqDYxWl4E+5DOIFFWkF7auic1zqhw
	aw08bn2Mi3PbRy8+zmH2G7BVi4/eXGYfYIWMx5EssOq7I5VE36sFSPKQXkab22Myde4J4L1xfw4
	UdHbCOPXD74HhNJZP3iWNYtYqTnxYu8E+YwDfNQJaRX63oWlrPoxI5xFKyfx24JO/omuqMJgW3L
	wi6Hz22eIFARnKhxuZtgPcs2yG2S07dQ==
X-Received: by 2002:a05:600c:528c:b0:492:39b6:5a30 with SMTP id 5b1f17b1804b1-49239b65ab3mr38563545e9.35.1781781817973;
        Thu, 18 Jun 2026 04:23:37 -0700 (PDT)
Received: from [192.168.1.21] ([41.140.50.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a4601esm262106005e9.1.2026.06.18.04.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:23:37 -0700 (PDT)
Message-ID: <05fac223-92f8-4c1d-8699-43b105214b9a@gmail.com>
Date: Thu, 18 Jun 2026 12:23:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145125.307082728@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

