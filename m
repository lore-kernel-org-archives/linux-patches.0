Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFA918FC90
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 19:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730145044; cv=none; b=OjjNm/cqE1C0IjxFYnjiP3pRzI3fMmIG1qK7iOe83m8w97Dnw/cHAoXRmr2Q8izIr2x+nZlHYkrtn23SJLSR82wI98aus7Hjito9QacN0O39E0zWAc8dkBAu/HhW3Sd79pFPDxhbTNf91zz0gO5d1qBOuPElpPmVg8fqcVuPLW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730145044; c=relaxed/simple;
	bh=R1DQ/KMwlmEJHrayoEuqobr4p9d+H1MRATU9t2npvC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ke/3BdKcHWMjcfae5DuBxvkwCBLyGbuiz3bCacEbzdFXwPqKJhsjs25QSwX9wmLOAtTOTg+FHqfAs3fNMATrFKfw8q0ei5ABR9QS9nyUshdUpYBFCavaw53fActXWiAHliF/KPXvfUYz70p0LS/o9Dufi1uKDGVW96zuzsOuos4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OVNRw25L; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OVNRw25L"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d55f0cf85so3529730f8f.3
        for <patches@lists.linux.dev>; Mon, 28 Oct 2024 12:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1730145040; x=1730749840; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cfFITBV1myRi8hbtETvsv/FqFz4x6fCNMl87D1UqCjI=;
        b=OVNRw25LfLCSxItBH/T+RY+LxUxY5jOtN6fqDpg/HXawatkEPM7e8wCPv6DNzGsLOk
         WD8MwF2YIOppgbFsvmDFjViXcClvVsKD3GoY29KUbDeCMpoj4sqI8tiE85f00TLNnF/K
         cIn1gc7gvPrOY6F3BaHOnivZ+jQDr4BNmPyKxuXP7MjE7zgdYnh/YKu9BxgBeEPbr3U2
         NAqHje2YaMaKbLUfohJi6Otyhmu6pBNmg7QYNYh207Try+lN2+oZf7JZvR/lYH8gINlO
         NsCJ7JSGXv4f4RQ/XVre9Y3yrp5oFE+FAas/OrE6cGFalqmaKyv9HHJxgEg6bpEndHBy
         p+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730145040; x=1730749840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cfFITBV1myRi8hbtETvsv/FqFz4x6fCNMl87D1UqCjI=;
        b=vhhkwjqpPIaV74w3+RGLhyuyCE7XModc2oqKu6t+/OGnHGDt/gE9zHuVg7w6X+4/MJ
         /qfEVAxWgGgnRuW62Jz/NJdRHINN2WzOxVNpeHp8lHuLmkMkQZQEH1kmORpSCi3VNhYT
         CNt3Kg8uLVLo9ExvgWkjcXk7B4uurF4I3MZyYRu3alcS0a/PujU3fBRJCfiCRYWZigfq
         c4DizAFmzHYzSKrv1GCyBUx+F6zCrmcpMPVfUn/KjtMmuRPyH8sFq6631NB3886nD4t1
         D7S/D3zK/XvJoMLu7wA/1/Q7XXnLwx91Gn0/6WE1QqK1HrDCw96JrmZXa3roaxYq674F
         +VuA==
X-Gm-Message-State: AOJu0YxcczBC35dupvzdkQOO4DkywwsePA0BxboWFygT3FZcACimxiej
	qkJX/6MNexkwvN69U99Unh4nKuQchz3457Sju4rtQ5Esjx2bXDs=
X-Google-Smtp-Source: AGHT+IFQlnYqBOiIxhzO/n77Z3bG0kNkLNCXhKIBxoD2+dgyOR0Z6gaZV0BvDFitzSFNe/kS94R+2g==
X-Received: by 2002:a5d:4b0b:0:b0:37d:524e:9431 with SMTP id ffacd0b85a97d-38061224a2cmr7063225f8f.57.1730145040463;
        Mon, 28 Oct 2024 12:50:40 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace6d.dip0.t-ipconnect.de. [91.42.206.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b9d70fsm10390697f8f.108.2024.10.28.12.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 12:50:39 -0700 (PDT)
Message-ID: <1e751a01-01e1-448d-bc72-71a6fad24278@googlemail.com>
Date: Mon, 28 Oct 2024 20:50:37 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241028062312.001273460@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2024 um 07:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
