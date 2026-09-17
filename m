Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC6502576
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667317; cv=none; b=OHGuFfPfLkRAwUWUV2/Qs4aJlCbpghKriFSL6Xazt+VxmDuRmE//GTtZu/b/UqNsB252/Ml4HcffgJLjEYMnMxC02bDjEnDddrkdXqpS27vKjlZ1+FxDtJL5yRodItp5SRtmbmkCh/WvRaUx8HcO/wjAJAmW8by0QRd/sNIKkHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667317; c=relaxed/simple;
	bh=tG+fI11akea3wSt6NDDMVs1aLWaYurwM1JJh6xLITCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RPItC2jsDEb9qvIIw8qv6RT46BAIAyzbfjPkXmOsV2m42+JN12iDQhfyD8hbXepWwbJHuww9e+/E+3YgxpXobCT1ecqbJRPJunBEZ09n/2oNbIYRR6WV9/7W+gsNoJAX6mW8W5GAMOcGXwYKLFnrfTjeS/0WISQWJwCz+l6i6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DFZzTOZr; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFZzTOZr"
Received: by mail-pz2-f43.google.com with SMTP id 41be03b00d2f7-cc433d52421so709715a12.3
        for <patches@lists.linux.dev>; Thu, 17 Sep 2026 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789667315; x=1790272115; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+WJglaSlo/017XuHFl5nKEZgkW9Nb7XN1yne3AQp+sI=;
        b=DFZzTOZruP9mhCrnb++1AMvxCtzM+BJWoT2RG+3bm7HH4TV4dOCHC7pG6t9na7S1sA
         BKo2X55Y/j67duSVAGTdhPicuruJkQraQe2soLmtta+Qay0fU8Azp2RWHwSgDXWgojVB
         nQRr7954D5fNw+KqVmr4eZD02pDITBkmn3vCobf6yHn2xU7VWZemMioXXdwNIAltXFKn
         dvPgd5DXu3FqJsVFiBQMI9Vl6O/9M9ORv2FcxyWFedR3q8NDj0Wq0cRw4WG/FTWSXGl9
         CMyCq/M3DMYsiHZA1wFhyWJT8oINqaFVmUn41q/7JFZtmOXFQlSnKedHaHAkBgonJuN5
         82MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789667315; x=1790272115;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+WJglaSlo/017XuHFl5nKEZgkW9Nb7XN1yne3AQp+sI=;
        b=DLB/AMAgDhsIPkH0uDzyahlXsplGRrTTRoCCBIRnRjj95w/Y0DUgM+j458sXnyjF79
         Q7zYc/TK2P9mRK1BHv1ox2QgnBinhZMaXuHRbmV0To/vvr0RHA7eWfnYy6ZG2mQUYRtT
         yWmUV9mkmgUe48WwR7NaQ5SXnuyRCdAUc7kukFTtdt4WWhFwIyTk20Zq2jZLyNKemvXY
         LUQGLnrEsqWFi4juJP6fR4z6zUuNfZFX1FGe8t8+FBqr4ySgyoezlwqKoOW2ogzTvs3i
         h6L8OPexU1/oianWxfmlxWO7RO/av4wP/lgBRJYNLfO+ugucTulFhHnv2cick4RhhY41
         EjSQ==
X-Gm-Message-State: AFuF++mDeZi44bCO/9u9el18BTwXmAQQaMOuwBjKOd4Dt5cKRnatzHas
	yydQzzcYk+z0J6aUv2X2qOocWqURHvLPusD0YsaWKoMbypd0n7eFlqwG
X-Gm-Gg: AYBFou1h9SqNPuxrwhkiNmGYdBtPEyHDEYWtZmmiCiH3PfkrYZbHtSFc85tcYGj9kmd
	A6e0zBRHUHEkwX4/YF/bb0+Dz0BaVOTA969/euY3ha2x8MsRFhucsoQR/XTCTMGv63QHJACkL9E
	X9Q5aLN6G1N6EWttXHrcFB4EthEpxtDRx6COLRKZIk8x/YzA1nKrnjUIM24lkI3lrREY12Y8lWa
	/Y2ZqFWn5f8YywGF3hm6+2fW06BWo32BGB/jbQorpc5X7alx8vBjHxwkph0eTNsyWFEMsLKWAgA
	eaNzc+QrgCEpDc/1AfX1ehJCrKnbOli8z0aetgNb/7XDSGvQ3ou+sN8MHR3TUon7ZOWMCv/HVUy
	pMMlFaqBjP08zJrSk63Mhdzy9Pqrk5uS9LjKNEPn7yheiOQv7MDyzrLGajpylQdBXtM7krixgtS
	cPLf/CZsKRVdfWNGhZiEjalsiQEOqzVqo9MPa2Vtd3kpLhn59pW7z3LKqJGfQh33pdOVasMLeMS
	9IABIsAFZKptIzkFFlnYX83lw==
X-Received: by 2002:a17:90b:5383:b0:39e:4c80:f682 with SMTP id 98e67ed59e1d1-39e4c80f749mr2185907a91.33.1789667315218;
        Thu, 17 Sep 2026 10:48:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e52d5bac3sm129238a91.2.2026.09.17.10.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 10:48:33 -0700 (PDT)
Message-ID: <6145337f-5350-489f-a5da-84cd1079ac78@gmail.com>
Date: Thu, 17 Sep 2026 10:48:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260917151551.901433442@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 07:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.53 release.
> There are 1250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:13:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
