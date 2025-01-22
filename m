Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E582221506C
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 18:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737569552; cv=none; b=O44/15j+jLx65R27k0VjkpOkueUV1RuSrJTgSlmxrvaYF6SV3ZWWZNY50Z9l3pq5EsBE8hWDQGt3NmFBGrPMZqSTftY5f1IxF8AOuKEzJkLQVVQ9JrPCvrbGyIICsas60N07gWc+t8A1DL3FmMj+cQVCZGEv+8UGAJLVOrWqUks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737569552; c=relaxed/simple;
	bh=vKqdUV1xA/kUlfYDw/aCQUiUt7IP55zeYFN7Eec5YwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwZF+DLxy9e3LhnvjLodLz6C0xRlcFiXJ/E3f32iwbdJmAzLlkixns+IiLYxqq/rG7JdFfkZ8EAh5Af5h1Yoiu8SlKEtsWs0duGqlDsaKvdax+24mxXlgLdonDC9Ny9bj09Iazh64QZ1duuMA6fRVBA6K/pnKQ6BSuF1qjvDSLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KeiMinYj; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KeiMinYj"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2a3bf796cccso60159fac.1
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 10:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737569550; x=1738174350; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fNvGAAWWGFQC9Zo5194H+eGcmqmXeFUSRJ5hz1QrILM=;
        b=KeiMinYjt+raDLyb22gp+G/IoXErYYbhbwTWEMAoapXu4gvgHb2qzgU4Hkz/FkC5oF
         UlzMNRqZT0IulxMzOdPx3C2jXhj1BvodokaxG+hU3chQRh7ACm3JKKV7RQWx6qPTvJpO
         W5YL5196oyBKjCh/ls3xRaZLZAEH18/UH3IBaK+7GULtvfl4nTPDQAOqrwDK9pcnwUAI
         rTh4ObdYua3U8nJvxu0YdZ4Lqh2087aVUrLHQvy8NI4pdbiWPQPQgxzIAi6S4vrl6dtE
         JF77NKQ970GtT1jPDMmxMK4gGpsAUhqdT0xBSm2oFfj2OHDzHqsUyS31ytwBSvzq5Pxy
         V3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737569550; x=1738174350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fNvGAAWWGFQC9Zo5194H+eGcmqmXeFUSRJ5hz1QrILM=;
        b=iZky5hh+yATVyWESN+ecZ+8DTzaI4nbTPSWAumq0QyfU7xbBwfL/KCOcXdo6kaC036
         AAJ61pb6s7nljB4OyGISe7sqJytjz9HHrBxfgVzCGxyEHl8xzA6JP1MfJ4eZ+Rc/9neY
         qBn100XESkj1bwJrOzlxzf7Fzdyp7UWOdeoad1ecXpyQDQtjAIR72er3VhWPv7kvZCC+
         zJaBdt9zCr//IOjGU+wl4fvOZQCdWdi6FnrULQtLMTQ1zkg8VncqJtGp8odEa1oy+5yO
         ROLCDMVqqssUpq+9Eky7u7RL4DiPQ743SaL4HU4X02X2gcmjk+BPQoGDVMlNPed1dvMd
         OIYw==
X-Gm-Message-State: AOJu0YzHdAPcETzrMvcjMzq+D4r/lBrrul8RePz8uE5412S9hLytcTD3
	EDPXPPgBlOwmk1vcS5N3+3NcNUfLw0veMUkFAlLnbVQxL2pA5BFO
X-Gm-Gg: ASbGncvn3tENRvJikc/FqWbip1S5bPHTVqtf+aXalRvGwaVdhyRrRrwe4jCCkx3QwSF
	iTyaVctk0zsbzLbufA4VU9pLTwffl/77xynncWh+drr7eOESLiyo6DfVako1aug9AIqTyNUbDmR
	UH6NXAM3lQxgBap6E62nUfOW0owEuM3FCDZXil4JKWQAIh/0hsQyhjfdQq+e2Xho2V44E0hKuOO
	hNUfiTGmXzlmNRw1whWXGQ3Um9Fs9zoMEwzTCjnb+RxSC8CTQRgHnyPvFv2DDpAkY6DAHj71mAd
	KubT28sJHEUQnbz0DnY/PNiV6KvlI0zF
X-Google-Smtp-Source: AGHT+IHRrPNlZ+6TzEel53Z/cUZsBfLNG4QPsxpB4GRxkYJwe3fS38wsqgFel3dj4z2ruZvUtfJe1Q==
X-Received: by 2002:a05:6870:7d8d:b0:2ac:2937:299d with SMTP id 586e51a60fabf-2b1c0d030eamr12304609fac.39.1737569548316;
        Wed, 22 Jan 2025 10:12:28 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2b1b8ff440dsm4496753fac.45.2025.01.22.10.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 10:12:27 -0800 (PST)
Message-ID: <ebd9fed9-11e8-470d-860b-a019a707378d@gmail.com>
Date: Wed, 22 Jan 2025 10:12:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122073827.056636718@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250122073827.056636718@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/22/2025 12:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 07:38:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.127-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

