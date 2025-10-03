Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C670E23AB8B
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759512300; cv=none; b=DTc17ui2hCJ9UGEig396gX8TE/e9L791F6D9xEPLaTvZQXq0BeeyJm/cYoLPMw38sHLOcZnsbqMZ21RTJmHX7jrsOQdqlKFVM/Aik8x192RaHKzQPpjUmr3XPFOGJk4nT6lm1tgLwGUT7Dgm9icQ9BW7B6qvBrLKBaSAGOlCreM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759512300; c=relaxed/simple;
	bh=iXwlO5Byr5+3tTepzQQtGjhw1VcFYQ4q42yDdyS+KS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MV3KZ/02ltCQMAMzama02oYugjAs1bcNXraY//HF2K8qblKarV54HJUqiW0DokZ/c33pGiyfn1lj0SbKqj77BrVV3p3lK/KXIFM44+ZJi+BZGgwuVDlj9cscDi7vuTNfe4epnoMvh48UXECydMkO83XI1ip//pImhegPegNZPQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TA3IKIiz; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TA3IKIiz"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b609a32a9b6so1708326a12.2
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 10:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759512298; x=1760117098; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wf2RDIzbc1/UWl5V5JoHRJgluyXqCVUIWccG9q/hEz4=;
        b=TA3IKIizzZvM/dkao5QmOP2VDxtXb5yPNBPsf1PgbiIDcaXx2P1O444icMvKas9T1k
         4P59hfctIRWOi0cXPaqXgEUEudHWbKsckvXmKJq89Yq9Ktu4Rp5yXfe9un05+8cqnHRP
         FAN48bh+/ddMjKs2bfC9X3t05QxDT3t6z5Itho26QCovI3rzxLDVrW6hbRY4YfcyRqkR
         g+KSlgF55mRq6a6+b+XAhAz5kB6hVn10c5V3pnwy5umSNSplipTWfnjE5+rj9zeqP5pq
         YWGs9feLRpYNGlmmD5ep2X7eShW0lDVFPsl6IdOJdoURxwUiJ2UUnGEpHETAdWZp/HBa
         DQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512298; x=1760117098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wf2RDIzbc1/UWl5V5JoHRJgluyXqCVUIWccG9q/hEz4=;
        b=jGEXhwxlgvxAUBMNOWe5I5QdBNkfGT1ioPRjguwIaqdE3q7jvH8ntQ+VrDo5lPkDvo
         zLAsF8eif2tFO94fqJy5edT5rdPPg2kaXHdNWIxk6kREuNX3edAHWT7lzIe4nGuaYRZg
         eKZNo3w0eYMGLRHjR1aYLYoMM5qKHAFrwIy5OOOONJ0RgJ3+EpP4ExKgEk4v7ke2iNzk
         jXkoJGYaNI2ZpQTKDsHC+c4JsN4ku4YBdXame9zWLXM72bcc+XIoLZCEW2/r0/p6RWve
         DBZxtwiSF/HnddODXy9f0i1x2NDtlWwUAvzcAH09MFsY0TZ/+qXUPDIcYVSeEm1WkdVL
         DMDw==
X-Gm-Message-State: AOJu0Ywj3cObGhjzpLfiGdMIHmDiuUYbiU29MvjwUnPwBkOKQO1WpIUr
	QUd2OGsd0C6KgRasU/8drPDxrn+0rHLl9H1fU9dV8fY8S6hvczsMvJUm
X-Gm-Gg: ASbGncvbPKKOrHLS8wmMNLcZ7xNdghVEDyE+nv51zLc1L89es1CrJmEt5t/pGTZzj7/
	aGZhpbLiSsSX5IxcJNKQv1YmsjngX/yiCABIVnZh3ky+xejGc/VQomtMJ22be9PcJoMDSxugWHS
	gDyIAxC7TXRV96IttoFayKd2B82Kgu9ofv6pUUfr6LO0IPGpF6I5M4GRI6b9GoirmS74tWrLzYr
	zHTLSa6e+G1qmz35BvkUOZWSsEnv3jlMI6PBhe+uyQa5TwcIR/wYM7kmxZUAqv8LIZSBuHJYmeR
	+OAy2zJcLesEqIf/hbt1+ULVlG5ld1MeAHHxRF0sEtPd4VBBZTW68A3sIDZrlQ8smcFVMZRaB+B
	xsB6PP/1okY4G77o19cjB/GY7kQ1LlSrWa/+ZEaRKh9xzn7+eH52O2KsmZ2hotVyNb/LYJPEuSt
	isI1a9Aidh7E38
X-Google-Smtp-Source: AGHT+IGu6R6uprgvErpatUKHGJI87mCfkt2tz7OgEQQ/oXHjPJDBYboLI8mkRgU9mYx/YaDsb8dkcw==
X-Received: by 2002:a17:902:f78a:b0:263:7b6e:8da0 with SMTP id d9443c01a7336-28e9a56660emr46576815ad.15.1759512298071;
        Fri, 03 Oct 2025 10:24:58 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6e9d00csm8751892a91.6.2025.10.03.10.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 10:24:57 -0700 (PDT)
Message-ID: <cce588f0-e358-4786-bcdb-a39904d1ab3f@gmail.com>
Date: Fri, 3 Oct 2025 10:24:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160338.463688162@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/3/2025 9:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.51-rc1.gz
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

