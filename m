Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A50E31A57B
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230344; cv=none; b=HE55QDSbii7RBDA1IiSTCpSLUiSpp0VtFtAezclglTw5CG+9mDIZkG2kiclz/SAASX1R7sMnCu3+85O5wkc45o95Pa905R36SHJWD4u65uWDvkJLLv2ReFvIItZuJtdrA+114r6Pa+FNSt2FSaHX1dMYI90w6CWqUyfwmUfZJeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230344; c=relaxed/simple;
	bh=RoS5AJ3nIL4LViJhPP9OiQzK+IyOuXHeDZrGkYUX3GI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q37F2+iNtptR0l+dMatja9bniFHJlEJK8njK4oJCbgipEtJ6x3AXb4yP+4oivM8YX7HtPt3PJxE110Z6QIj0jDSQ9D+Ieu9MfIXd2UStCSZlSs+i/uohNGVHRro5/iN6Hw+Z+8BC/XBisKcB9VU9NPb6+4pIp5INwqR+C0h1wa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asCVMmyb; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asCVMmyb"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7f6f367a1f0so17897085a.3
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756230341; x=1756835141; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+RoA35ojaz/PgTS5ozZxmtRBovkvjsUCjkDFl9uLa84=;
        b=asCVMmyb/tDo5+Kl/QxqATprO/pV8hvQrXc7ZdtJUws1SvJyU2HUpdW7LVvSl87t46
         JmHVcrDPqGDQgWAOsmTCOvXmeq514eUkj09U31QRSnN7Dkbvlk1FsbFM93jnrrIJeuyi
         kWwUbTnNzXh8KK+jlk/b/ChhtjBH2wCULw8DPK9cpfGjU6i64BJ1WjtJiDosYkLOPFMd
         uGPNq+SD6muVUII9W/dkK1u5Jo6TLplkI77FihK6soxSfp6A5VxeZ+otrw2C4wDTs8I4
         iqhOEuKdIfWSDx8nQQ3SMd8iBpq5jGdz3hxsnCxpWItqRE4p/OGuMnS6+rPlVTLh9ApX
         yWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756230341; x=1756835141;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RoA35ojaz/PgTS5ozZxmtRBovkvjsUCjkDFl9uLa84=;
        b=kZk8WpVD03K1jfMR3We66GuY2vWhKfRR4sHTFQE65pgdCeY1beWOZ/dFu04q5HhrEB
         VVVptulE7vYi3KZ0ckpHDe7pGVqcuWr8nCJwq7WuWdX+L/llKwu05wcY+/N+CpVFDdVF
         eBasoQVRIDnNcp/Taq7yu4D0uqRTcNBc6IXAXFlfjP1hkdKONLr6OgWI0ezjljAKJx4g
         gvcO5tcaWkVsdTTfV6tknAD8Ek53BtqoSxNrVSwOz3D3R/rG2Nwx3c+gCiu7Dtv9Wjwk
         VlCFxC+SJLI6DgiyA0o8JKdgurQ+2GIZTIoPjuCrjf17TS1x5i0q45SgADfCQHoIfvhn
         P4LQ==
X-Gm-Message-State: AOJu0YxiLFQ9I6F8pg2m69vA/yGa8BjXHwDpUAjNPdxWPZPZVDVfdDpO
	T6YDkmFXKKPIazvYAVmm+aiizCcwYjvYj/8b5bfL9Ih9U06VZi64pb7t
X-Gm-Gg: ASbGncv67sVfmFES/KxXwKI6NyEReok/6sFEFsEksoGfQEtbn00Ex7vf7CXR3lCJzxv
	8CXceDQ4w1LexwvbE6qRk8h6Nu2h3JIBD43TTWevzSlUukOCEGljX5RAC4cFmFJ/rlj8LIZaMzV
	75Ty2oBFc6IlpxHUSXNpsZilOgkpkhV3OTfATM9zyqZEx/TnNKYzfy/hVZ3FpF3Q3c4mHdWW1yI
	EAGljXm9ZibTUpkOsBPWvTMmEK+ByOw1shhzwcqOkCW+uEgoJUhBBCefCS5B31FnDb0gmJAoOAE
	2PjQfKJsmHUVu6o33a4AHoWQYAh4Nogrfg6N1MxiMYrmCizMp7uhjI+7lnZdYZBypcz6MZa8rIY
	6ukA+yTcq+jgT5i6XNILkN3Ckk496MQqSp+6MrdznGzzn6pl1wg==
X-Google-Smtp-Source: AGHT+IGW3c39mf1AgCXfHtzpioy+8KFkpzH5cUNUK0ll1A27gIebRlGFBsz8lEe/Ps4Mn4KpemR+lg==
X-Received: by 2002:a05:620a:19a2:b0:7e8:33e6:72d6 with SMTP id af79cd13be357-7ea10f53863mr2149516585a.6.1756230341085;
        Tue, 26 Aug 2025 10:45:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7eca064dff9sm682166385a.47.2025.08.26.10.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 10:45:40 -0700 (PDT)
Message-ID: <8da510a9-d705-4744-99a1-7ee78e196d13@gmail.com>
Date: Tue, 26 Aug 2025 10:45:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/482] 6.1.149-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110930.769259449@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/25 04:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.149 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.149-rc1.gz
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
