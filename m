Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3AF2DD5EF
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 18:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751999853; cv=none; b=SlhX9yx1xVuNp7sjHeusRqjie31u+taeWlo0WvnDUrR8abHl4Le4Xi6n4bztYfAI1rz9cCiV5LV/6LwR7nLWVLjFY5bjEoyTCSswYK7kPqzd8tj/XEyWG5X3LuAPouzI7gkXsZ2XbUaqcQqayvHzZfN5Uyq3exrqCh0U1te0WDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751999853; c=relaxed/simple;
	bh=un4jqr41VWnF4oK/40uHqoHyG+jR+1QJuARpkPxDymI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pAA5RyGQiNTcexqRtGKhhjYWxsR5TsjX0kE+BkM/PMnCr5bBanHvkgFWyRODWem9P2X/WFHoi72I53lFNODp2KL16ujOoZdRdAMOiumuIeQ1GPxGtg3PthS9/7LdjILqgJwfySgN9WB/s7AqgKfN8YbGCtJEMaPOxFHqkMnuGSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XPTGmrXV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XPTGmrXV"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-237311f5a54so44627905ad.2
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 11:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751999851; x=1752604651; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yFq5U93lGfg6l2vT4qFW/REi+QnjIyuVbXAzMMJ9buE=;
        b=XPTGmrXVJcmxooQ81X/RLpOE+VYmlY37GsdLc1+9vZxwuuo8ZoMnGX+IZKlXSG+Iqm
         BJLv3d5focWm5gH9ytJJs+1SnrYqy4ETS1KDnmgoHT+5vyWQHfALfmQmhZPuXvvobkYH
         NX98W9XglnScEsx6IA25bU1tzDYYeCEKkaJH4DknBjQ812b8eT6IQjvqksFO8hllKHsy
         w43ai/ybZpdeOo9VJwcAnHkVtr/Z4M5ww/s8y3ij+ukA0uJdMN+zWqqMoIThib0N3xiC
         InSbc66Enb6DYUlp3i7UEIs6xVA5TomBXkQTa4CSCB6ZqoPYkIVfV/zUUo5f0x6GwZWn
         MLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751999851; x=1752604651;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFq5U93lGfg6l2vT4qFW/REi+QnjIyuVbXAzMMJ9buE=;
        b=MHAOCKhxFYWrVeUvIeIQsVSCNY13Gbg9KjKiDOeTsjogNNV5hsiGTvXje281mWS9sl
         4THgFHP6PdIFQPJftVLOGVgZAr9ZYZseu5oYvSaeLAlepa6TgkY63bJ82kPdGTSi07kD
         T8DzD/mX9G9FtxizOd5tje7FJikOrfnrMjqNq3B8PtexhxM6MpwCQWWIlBF8trDv44Ba
         yy68oSzZOaSKeSGOQE9CFOzO2jH/vY42MytgK9MwQ0WEas9piiGcD8gHQa0Z34k4zSwp
         OV66StbaTFldDKuCkda1pPMg7t0Ga3X1SRtp28jZ8owuumKrITDoPUzmiD6JMGqohDGr
         OxvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGGwhYxIOyaFhsc80CG4CVA0wViP0kDsWwUetDs3ZzHacO41vvdlw5+9/c2v1dM3IDuCK9pxZa@lists.linux.dev
X-Gm-Message-State: AOJu0YxMpubptmvkXAup5POaVucwDo0RiwOlUbmu8nxBSnyBs/4kIZhf
	e+rkujul+RLGd08lYMuz+HeoGlQilXUR+j9NiR6totE2C+rzTBxgsFWI
X-Gm-Gg: ASbGncszcFq7DzCCrAL406DMUKCQ1RP/x2cVVPRs5EX8IEqxmMC97SdoGW0E/uYnjbY
	vyM7yYZiKhuqgC7kdIDW3PWH6Gpjsi2NGh/l7Xs12TAX7w5CIgXgJkam+AqGQfD3yvnCf0Xp2Gn
	cZ7NdpWl3PjWaagVjSyBDTf2W9NmVd39l19+xTgm1dPah/7k1ULqkKG7ke85wHvioqFO7IKDyJe
	gUysC4cI6T0Hraqm/pdrkzlGeffn/L8b00pCKNfTIANZudtc+hOxK6D3POoKmea6psuV9VjRTBF
	vb7+HmldbSHEWHnppTboTZjF4/gNqc0ruuNB9nV/d4q619qb11d/+bADOwxvL1BV0OVrLpwbywm
	7YYmthQ==
X-Google-Smtp-Source: AGHT+IE6Tp1/WzRvpW55BQkqs3s7L2F6IMLeVntT2MgmwhleqyQv/9dSyJlzGlUXDuJ/0RxU1xMlgA==
X-Received: by 2002:a17:903:950:b0:234:c5c1:9b5f with SMTP id d9443c01a7336-23c8747274fmr263138545ad.16.1751999851392;
        Tue, 08 Jul 2025 11:37:31 -0700 (PDT)
Received: from [10.230.3.249] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c84581113sm114374185ad.183.2025.07.08.11.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 11:37:30 -0700 (PDT)
Message-ID: <7cdb1dd3-2993-4bb7-bebe-e9d9a2fa6dda@gmail.com>
Date: Tue, 8 Jul 2025 11:37:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Borislav Petkov <bp@alien8.de>
Cc: stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
 <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
 <12b05333-69c2-42b7-89ea-d414ea14eca0@gmail.com>
 <20250708174509.GGaG1ZJSHsChiURgHW@fat_crate.local>
 <20250708180400.GIaG1dkGnKYAS1QOu0@fat_crate.local>
 <2025070800-staff-expire-a6d9@gregkh>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <2025070800-staff-expire-a6d9@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/8/2025 11:09 AM, Greg Kroah-Hartman wrote:
> On Tue, Jul 08, 2025 at 08:04:00PM +0200, Borislav Petkov wrote:
>> On Tue, Jul 08, 2025 at 07:45:09PM +0200, Borislav Petkov wrote:
>>> Right, it needs the __weak functions - this is solved differently on newer
>>> kernels. Lemme send updated patches.
>>
>> ...and 6.1:
> 
> Now applied, thanks!
> 
> I'll push out -rc2 versions of both of these now.

Thank you both for the prompt reply!
-- 
Florian

