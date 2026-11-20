Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795213876;
	b=h2oMshkbmPTqJW/P2lQVm0um6gtsz2iJPcvtmuSrvsqaEmhkOQPTj6fcFI9eoYoarIyb
	 fW4XkP9rb/UOILMc3Jn+JaiuCEg9sF6/4JhI9aW9mUZH9p4rTfK9DZM4bLDaaQuy76i2a
	 AV23SQYqhgkkoQQlsC/GRln8c53ZilhKtwlmYxLan3xMicTiHhdCD5H0PfUVcc9bxa1xE
	 UooRiFcP1+YiGYLtjp8UDxANLOD3B/AjFH8rl1OijGjLMMLHFpXspQA7NyYKe1zAMx/sb
	 IJ8NaxEccfo2XbZTEknu18V0GISWHIbDmNaE1UAIv5es7g0HIN0m6DYiqIiY4KFS5Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795213876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UK3B3lWP4def/hq2HHCr0r2FkWoPUs+SuSypRY007Ic=;
	b=B4ZLbBrlqRhaQr5Mi6hs7nSZLCg8UcCbJgJ9QnTIjijjkMCJj7xvTRuAVSinfRpSbtXD
	 P6rtMlWf5+fm3/2Tb9hXKyZFKDZp5lOETX7E5MkVvas3zWd18E4FhoF2OZ1YwLo1zbkBS
	 xBPizcIFrfWnJPS9wybH1+eKcwJE58qlJ6dSEk9JfHugn2qQ1UgAnEJHuzw4Y5kKoeLcg
	 n3RO7rwkqj+gUW+DN3W/wL1GqwyonUsKggZq+D+pOjiBaHimtCXM6eUbeC4/WO5k1Y++u
	 JdUazCmPD80VHt361EECt7LGJ7+2MS2Iyjy+SwTZxAcy5AkI1KMHmNoe3zaMklDPl/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="qi6c6FH/";
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D951D606A6A6
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 22:31:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D951D606A6A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qi6c6FH/
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-382f4710a17so2317313eec.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 14:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795213874; x=1795818674; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UK3B3lWP4def/hq2HHCr0r2FkWoPUs+SuSypRY007Ic=;
        b=qi6c6FH/xtxnPmVfERQEBYxjJlKxqM4u6ucIaXH3I1Q1FZSx+ZlbTVtcJRgSAmd2Hb
         fBRnpSXSfXP81XUBgCLjM+gxnimgGFcd9zU75kFZm9BcFqUYmOXBNw5ysRuBRke+we5M
         FvdU5AiEh4RWesmLzX/NOapZ0nXJ5hsoaC6F5FrM7p/a6ZWa3HU0FMc/A7FufyyseHCC
         CJ2tmD7zrpJ1heX/8YNIr1FhiHkwaKH49c8DYX7tE+E8fNkW8rbdDOAr1Bg+7wpWsfiD
         8/jo/fpUoVGGv35aUU3AWcWX5PhWeN7ORnIksIX54t989+mQ6dvdjHtPJlSUxA1pBLBD
         MJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795213874; x=1795818674;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UK3B3lWP4def/hq2HHCr0r2FkWoPUs+SuSypRY007Ic=;
        b=18SZOOHU4taOrSToY8zBcKtRD9Ct2RQCYgL4MG9wIJnIzulm0QtQWmcvAF+mdBC6i0
         ITeZ1pe1RE0oiW/CC/4pdUn/c25nxZy1W239a9g/rwVWflJBUMUxvXQVX6FdqYnG3sFm
         JYJ/vHmmz58nzwyhALAHmJs4t4Q9GEfPlJij9UESV6YlkRrlvRMSQLmy+a3GXQ6mjqXY
         aCCHYSJo9xjAEtSMzTvLIJQfLF8hLT9ZzZ3Z6mGIp0eMOoK6Gww6sH5ecFYtG5KWYSw3
         YHfhUbEeeMp0fi58PBzKPxPfC4KGQujmcX/4dp3rWYmdlCQwa1TqrH0lXGH/IwGbXnaH
         1zxg==
X-Gm-Message-State: APuU4Z/NeYVu/85yi1F/m2dF4fQDOrKDLgNV+XxLxpPhuO9JUGaZfexO
	foiUgzXe/2kTcSVl/Zd8fOZN/59DwMYfPL9aQi33araIEWvGQ0oJDyCt
X-Gm-Gg: AZFdTZdPaJboOq8W+vRF3c7/6RZJL+yMOOAS/fssu4jnqR1s1obNtCdd368C1odZBTd
	UwkWHIOwhH/K35zDCEcPpC4hJ+aweCyneUEoBHyXcCoVApnj9I//aRe9YRkyNNaQDC1jia/tMOh
	Q+kpeiBoK5jvgfskK935zgLMvhyyvk0awWsgC/pLr/IELYaAapWONocCJBL1O+f90ATGzYhDGO1
	R2K9zpXTowPSLTCHsJoQM4AfQfRXhaAN8gNPbDh0M6nvLVNJtcWG9Q1JHtNWGg3vvLwx9w3LWLn
	IjPpMv1UxRCo7+Ntpqcla7yobq4q4MQ43t5kFPbdtd6C5oM2uhngwG+C48vl9tVKokJ8v6j7cJy
	aHVAXFK9NLehyiS2CKAHNdJCm4D3h4mMYlu2VPcKuDAwRQkTvYvFQm4qRZEINCMBsFvlKbqv2PW
	fvJXIeRFci7jLne/j5ad5dUwt/drIHZ7Oy1mHl5Um15owMAbceYPYLmdzfdNCzO8x6TWwXCtgSe
	yOhbSnblcNtFOkwbqaRIcwH70fk8gCz51cHI87Zh4D0Pwr95XMqRRw9cW+Gr00VIEgumbBEKYuh
	rR5cbstqn3g1Ji+V94N9FqwvtmvK0cFK75L2oOIiJZam5linYK6l0eqt
X-Received: by 2002:a05:7301:6908:b0:381:1926:dba3 with SMTP id 5a478bee46e88-3856983c0ccmr3823683eec.0.1795213873842;
        Fri, 20 Nov 2026 14:31:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3856456e6c6sm10229177eec.2.2026.11.20.14.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 14:31:13 -0800 (PST)
Message-ID: <a7c43521-79cd-46d2-a82e-01f784cfc596@gmail.com>
Date: Fri, 20 Nov 2026 14:31:10 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120054951.366579794@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
