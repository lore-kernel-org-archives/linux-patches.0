Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2894DBD62
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693745; cv=none; b=b6sHy+sr61qNpmNxs6OJeWiIXsQ7ShO1F63G1UeYwlblA4bGliAxVIE1e6YkKzo64sgzoWbSdVFEP8SfS6Wzx3n8+7z0Sn6Lqji/4kXiByPVOCsOgQ0yJaJKtIvEY3rIfGGHknnjdocgDWR/S90wO+gdB0ooRNvqqJBdzjO/iRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693745; c=relaxed/simple;
	bh=KCal7kzqZI8+0VK4uQJCVOmFtclj032kNAYQovwtFr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xjq0qGDhspuuepT2UYo3Oj6EQDpSYrhpYUmbLs8inDSXqigZk1umxf+Ml64v/OfHxeQ74eCMyylUIDi6Db/KFrBe1Zy2XVolWUiFVrcH1zpGyWWEdPKd7MUfwYfui+RJQzWGrXQRHfHGohTXBGeNg6lQldLGQMUTAgbIq9Rd9j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHh1tgjW; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHh1tgjW"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12c8f9846c8so10521260c88.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778693744; x=1779298544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ul0Nd+LldB2hhhsaIn510nAc6p+u/VtWN9+3RBSesGw=;
        b=SHh1tgjW/Xq4SZ03AOm5K6my6DJ+p1jR43uXc25PsTJWP9O2AZyF/h4UO4p6FBUNuE
         OGUru7j+sU+7fv5A44qnAMMDkzq/He+IMcC6xLuEWioJzCxUsxvdo0qFulAdvkShPT1C
         cL8XbuhNixQlxLvTXDkpst5zvXCsavCxFxOM1MqMIxlpERJbC8QAg38iEAxDnldTBYYf
         AT3gajkH73lQfZx96R9ep01cXQa6cWs/puVxxdzv+YltcKeEDIuInZaVZCglmUn3LP1X
         Aspq0yocSFvlR5Ht1v9frKv3Hq6uGTJAqblXvFmoMIUJx5RXEE5LHmXHf7Bmtg6lUEdS
         1BRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778693744; x=1779298544;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ul0Nd+LldB2hhhsaIn510nAc6p+u/VtWN9+3RBSesGw=;
        b=EwLo0yj0Ckuu/0nf+3csNTlnp0G6V8yC71B4JyiCu9bDznmvhLdhGLwIvPiP9/btKt
         /RBsLt1fLYT3fb7JdSM7j7XO1Oo342DX6gy8I883tiGGGYv483lbyqYCyRUfe0KCr3Yj
         bWbIddddq2in7c6LQDdEm3FSA45EF9EzKunKdTbCN5UJq+TSxp07Ey376R3S5yCsl5Hf
         eud4QaISEgkYq7xfzCszfBLn4KMFhD1yjSWVGRhm2/jdntsymVoJ5fHZzHn3M28GsXsJ
         JVYkx16SorDi/QZdDRV1etO0BkirGJIbuLHXhTv7jQNzxSAzs6ZvKVr2DmlgYijsVzUd
         CFcQ==
X-Gm-Message-State: AOJu0Yw9L2w87RrncPxVGD1P5Lecf2Lh6rlwJ/7tcI1ynge/PS1HZcqB
	BFPU4qzq2z0PhXBC9dBcNi0egW1ijn+CyVmb4Gl5IcJF9px/p0bBr8Rl
X-Gm-Gg: Acq92OFlQcYKjxuBHtSe+3ffMU4ps4j9SWpL8b437VpYIKKTZqvxoeog4Q4cBUWMxCz
	+jEsmvMhkj8PFZ47Gja5Pq2fCR4Uwqa1ePman8TKcoQv80NbEFcN62ZVNVuhah9ysjscDphwshk
	hgGhqRdETXSdc8IhdHXvYYrh8vD2oxOj1ITYaaEQP8zu6nJMMDC0gyDqJSJ+slfxCx/tReJzwFM
	bqdLu1R2fC0w61vjGv5OtrDYYXvA0DByxrCjTNeeecldq1Ge9O4drkutuvA5gJ35ASmdLGt1pfN
	DfG6oxpi1GP8Uv2dQtPbl2hHfpMo68LcL/d8WiEky06pC6bI50GfhLgreZ4/ex5kk9xZvMzKi9b
	vQ5vPDKqxAI82XviLKQV8Yubrpd+QIVV/G7i+MOH4BgJynd2CNqS+sZyloHaMTMXH4tIaY2Yai0
	TFcaG/68qjdd2yqXfz3qmrzK1INIUmO/GTJyfubHkJZF3vnflPjUjavtZT6S4tuGFE
X-Received: by 2002:a05:7022:21e:b0:12c:34b9:61bc with SMTP id a92af1059eb24-1342ee3a02emr2676237c88.5.1778693743835;
        Wed, 13 May 2026 10:35:43 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc33aac9sm51967c88.14.2026.05.13.10.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:35:43 -0700 (PDT)
Message-ID: <199abc0a-e5b0-44c4-a0f2-11d1f959e606@gmail.com>
Date: Wed, 13 May 2026 10:35:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/268] 6.18.30-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260513153744.746440810@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260513153744.746440810@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/2026 9:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.30-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

