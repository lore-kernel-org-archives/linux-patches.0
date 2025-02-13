Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F4E203703
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 20:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477047; cv=none; b=smdnBtD7/aTBlMu3OEA6DTJAQQKVrfPn6e5pJLp2xzbZdBose8CbZC0Zx0D1L7gMpuCyy5jFGm2e5qJRhCLb5SB35i7fBwy9If3UFg6PEZPCuIToR+gINWM9fdzcuZInpGgUr7uLrVt0Mmwwnb0BVZFhF18vbSaGor5aYGbh65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477047; c=relaxed/simple;
	bh=raBgMzdHvZYFnLe/MOr5SS00UMiRRXq1g0Pg9ZUBHao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LsPpFfqgLcs69q+7jkDa2WrAgvJcBeYGHftHWjgo3Y7LynsELAZEV7f23ABuuSoOEaTvlA6pqPq8XF0+qi4cMRDaLRvcVet4wYf3H/sO+xVU8lq9y+BrT1ByD01nk45YfsSXYJpNf2d8CUmRu7bF9Bl9SwPf1uWl2GtNy5OyTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWw3uD/z; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWw3uD/z"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5fca61c7e4aso441503eaf.0
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 12:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739477045; x=1740081845; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bSYf1ZaaN8s9q3zV1/0JPduMcrRw1Gr3g+Qgt0nTVG8=;
        b=GWw3uD/zju79rqfpFlvXV8ucsjOCjefX4mwFageuCwz7fKn4z3Fdg3JfrC9VpZ1zX6
         mdrCMqs3MYiHXN2u1V5Js2knyQ+IPYLh6xckuk9dDif3zqUCDdJO9sNZ+PekjiJiWNKH
         ID5Bt+jCemeHQqkxulQrr1jq1tf7g6mZiVKrfiu3siyr0wjqG8I/RnZGMUOOONZcKrXT
         Pf8Sa+/1WwFmoVXqEix6ROqb709GDzjVSl5K0mJkxNU+a8U7PxJM7oR4O05hX1BPjv4v
         zTlqAwkPUg8cbpVHyCLwsROV9nI1ipS5ydS5BakXoMP+G9R9Ln5cliCHHBaP1AtvxRYA
         Q19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477045; x=1740081845;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSYf1ZaaN8s9q3zV1/0JPduMcrRw1Gr3g+Qgt0nTVG8=;
        b=sfHU0fRtiZSy20ZiDZO4mrNSikRgz6d+QGfk8+jGvClVGdTUnyrNFqm49X+H9J25z0
         eBR4OASXbjgVqxFZhXlDxlALLp89yubQe7luOzSswSKCxtpf5w/IdAqIaeOuBxuSl2FM
         KhiRCtPeYen7P5QpDfKMZoG2WeiznPBuNLAs2Qby3kEEzVrBPh7O+YkZ0LOTHdmk7uMq
         GkWZKqHtfGQOU35ygwfp+1FbuQfWGVh8CnDF4YLZV4MLcPC2umdsTqSklDlS8wmLo+8O
         UcRtrJRei9juizlsLKiFLJBnbGnvzwWA4P1nCnJ7VTjgQ06HruIUlYE3Zt6Ml6vl32ww
         QZ2g==
X-Gm-Message-State: AOJu0Yyv0YMiBLGe2WrBAicC0VwKtHj9H7Fg0INX9nufwsiBrBl5pHRZ
	10pmbBTBhcMlLA6buyKXOctP5krs0tYAjj7+0wWQZ3nnBiY1dtQm
X-Gm-Gg: ASbGncvPoKS8knQiU4H0yYbhPCMIv5+D3HFR+anwj4RrUzRGnTIs8NU6VLZ2RcKNsJS
	+5AAVujc9sMhYHHkwsHUE3IFkgt4/j4qNSLJ+Z/oVNGoez8NAwZc4/CQIGwF3KOWwytacwBy7sf
	ubHnlmRs+uEdkbS0te7ga/dxq1AuhHKG927QtLWwQICcI+BO3u/Qgt5vgWKumwDvc5WWg1in82c
	F1biTgPAIAuStUex8kyR/TbJoR/IXImP+Q32taurZU17iWUBYZec3vrCITtp6GrZQ8eO282QqST
	cdEWF+gNDAQZwPv95VIARCbpdO9SWCYhXcaWAXucdXw=
X-Google-Smtp-Source: AGHT+IFR4uxJVSa0DFwHRw9uvDylKzafe26K/soTWpR1h4ANO8M2A8750RxcXEDq86fH370Gq8fTXg==
X-Received: by 2002:a05:6820:260d:b0:5fc:b418:8cd1 with SMTP id 006d021491bc7-5fcb4188d23mr1777116eaf.6.1739477044612;
        Thu, 13 Feb 2025 12:04:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fcb16a8de3sm817670eaf.14.2025.02.13.12.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 12:04:03 -0800 (PST)
Message-ID: <af611f69-4844-475d-84fd-f1c781dda73c@gmail.com>
Date: Thu, 13 Feb 2025 12:04:00 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142440.609878115@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc1.gz
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
