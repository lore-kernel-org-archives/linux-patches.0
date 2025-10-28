Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0665355810
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 22:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689484; cv=none; b=RibOhWzjEAoejowYbuhtvxSCag+voZkTCG8DYWmPCRlO8Hs5r4tvpdDrU+8Mp7UHEvH+BlZJA8MLfNXqh9Spx+NNeNID6P1/7J/T5kQE6llPkuo3OKOl0ntwjArgXkiTp8c0tgDZKJSHBLZYVWet5BfKH4ebz3Qi+hdluCKp7b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689484; c=relaxed/simple;
	bh=SajjjPU7ooHm9j1bcOZQP2p2t6mzMP8oH0w3pXmySUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OzXnkesYykgkSmi0Fq5YRqtM0wHIaBEzOv0qIHj80T2lfgD4SJe8yU64eTIRtHAqOmUf6j7SMXAkkrgT4hii+ccbar57y7l8pXgY1cotVeAHilFinJC7dIgphLQOB/LltLA7fbYAFWkBC5b/w280jkp0zjtdEF9Zsrncc9qCLKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=LhvaUcOg; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="LhvaUcOg"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed101e8486so13680171cf.2
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 15:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1761689481; x=1762294281; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JtLU3JE9Y5OXHhXpJkKXkmYHPl8HTetY/QdDWBoDdO4=;
        b=LhvaUcOgQ2j4b32IO+1atsRdz5fqoFplZeq9wAW819D5sS/Tj2+ACZrh+UloXHreKW
         k7XfIttiwRu5Ca6m5IVPh2E1manTIKQD+UqAnrRe0XE/XPeNrkDh83yH3OHEg2I3odOg
         RfgFhFQL7gz+ncWelOS1ORcesSD8sC+yOjPXiHR1EcPwswC/CkiN8V9OCFyB18RTaKLK
         n0tQCc+oFddbdY7bTg8+NYoF7ZVvopr73mZydo/UvvdNG6UJdi0SnJ1vS92e/qwro+zq
         YMFz4qF3aIWr6PSrm2SijjrBDQce+4e5TvGYpKQThQEvoGz4vq3+qPoB+lxsnVZ6YqpW
         VpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761689481; x=1762294281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtLU3JE9Y5OXHhXpJkKXkmYHPl8HTetY/QdDWBoDdO4=;
        b=EqHdBMF/s+9vcIlbOkiXdLzU7YFiCk1dXUxXiv1QuPtMZ6A1EEPPQ4TYGPPC1GCnkl
         it/dRfnfS/VzltjXNbTFnebzKGjAk17bPx3+9RPWOpCP9NFZVPg0d0zDkOuEnsGAKurG
         uu4kcyaX0NWHxQe4qHb6myHCnEi9kYjWQU0UlRtWzg1TZu7KFBOYkSsstzdAx0+9vBs+
         dv10FTsr44dRlhO3w001U6CJzaHskYsqJASDKJFjM1vMz/U+MB3eTexGAZb+bHHrqUzC
         pQtq0bNyPYapFBj2NjmNL4RaINtpT+kooP/GrsTvWyUQmBhsRyRCvtU7sQfpw7w84UUp
         61Eg==
X-Forwarded-Encrypted: i=1; AJvYcCX/5MFq0F/aPO1UZ0e4zDZveBsoqUylre2MF7+ochxd9rWsaUGxXB5jTqY2KTCUkiMvDS/20Yw+@lists.linux.dev
X-Gm-Message-State: AOJu0YwBcimqO+1GzCp4z9qo8xZAR3lerg4ZF23yQ4Axv++dRTMkxxlv
	dH5zu+/e7MD7IcVuBVvmt+Vg6OlLmhY3m1tX1piZFT6hiUR88S/H2MmJmeheDbD6QQ8=
X-Gm-Gg: ASbGncubxdNzzB0pIcBOyO6cxpv+rRwTAOLiGIDHOtd/ZS+LGhPZD9HONG38SkRffwS
	rVQiyBlzOo9pjFVUC9A2We7aHt/d/qwpqSH+xicQYQzSgjDQdsK3vmnYmuRPwtacZWVsQFam1x7
	hl6C1X4X/vPkHvWHFYBckRMCDBpx11ytAqFWJ7qmXqmR3+7BsPuuzbbnfg8+ePpmowDS3t0Om0h
	l93+I5Rraqrp77KJP05n0jaITxdzKGx5aYW6GR59VNwnhnimklrsQ16s7u2i6d0J3xCyzsCrTQN
	SP3Oxvm3JL02GX5po8mCEMM/Z7DiXo23VT8voSUZGPxBIOTSNobkA9uOiyZLvnnHXJSUpS8aMYn
	glpSVujItzz8HVR/oxkHLho2CY1gvCyhbMvxIKkW8TI1exlYaKYNtnDt9wK17ydim2QpKHmYIdb
	0/8T4GNu8AOtLYDbY9t0hvD8dc
X-Google-Smtp-Source: AGHT+IH8IqWGuZZlKiFkTKML7svZTrrSeVNnrFoedT23cSoLdRm4s4MqFN2yRRflIL9ChyeaLS53ow==
X-Received: by 2002:a05:622a:1f85:b0:4ed:c7f:c744 with SMTP id d75a77b69052e-4ed15bcbfd6mr13483461cf.42.1761689480630;
        Tue, 28 Oct 2025 15:11:20 -0700 (PDT)
Received: from [10.10.13.73] ([76.76.25.10])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25a8c492sm914103085a.41.2025.10.28.15.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 15:11:19 -0700 (PDT)
Message-ID: <da504bf7-c9a5-4a29-9404-6aff5a7cda75@sladewatkins.com>
Date: Tue, 28 Oct 2025 18:11:18 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251027183438.817309828@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 2:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.


6.6.115-rc1 built and run on x86_64 test system with no errors or
regressions:
Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
