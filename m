Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E95F2D739D
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 20:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761597781; cv=none; b=IOxqT0VJwG3ebXEynGZUUiG3gKLahzlAPyoilKjAcEtTsPz9GxfCc4yFRepiylS4YRy69rdWZRvbSSO5uQ/1SYxhNRmAwbKZNqZA6bZ4OxQ5elweopvSdnC1SwaN/zR05krf7YX2WF08If5NGXlNO0iFPLBV1x39RaSHUYuCK7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761597781; c=relaxed/simple;
	bh=gWWe3paV3a/kYxDO1EPMAPiCjS1sugw4GH1dIZqDEUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cTZSbwp3jhsWkfuMQNK4sWz64sLpBxYz+L7imQ6d7g2vKIVeOUjda/GX5qfy4cmx4p8AupPsGfdRXEWhLBT5aXfXrBjraj4LD9YkBlDm6cqLjFnJkKatieiq4sa5uhrh+72okWCmlJ10HGpfhTbIr+EoxzgqWWHLbi759nUPhvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gES0RWVP; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gES0RWVP"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7f04816589bso569937985a.3
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 13:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761597778; x=1762202578; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zODHDgIVcThjNTQxncSaZSJNvBOcC1ZxkNJs06nMyxk=;
        b=gES0RWVPdrT+cbxdHtrTvepTknoAn9lBCxPQG3d78DA7pTn+d5doiYQhbFZ66FHGx6
         o1cD1U1+kSE2KncK6f+tSxCuXqSW47zJhfT44cB2vB1AuMex5tPLZgUvVbBzWfYvgjGx
         ztj8Ag4PpQAdMSqRdrtFjHXih4u50xTgKzxpgGH+4sPo+Pr4MQ0Mcnv5WJYI8yyqrzy0
         2ooUdtAxeQ90icqW+4J4rcVzjadDTUJkFlVSGgwqUXFe0iuL7ihi86djE6pMGnHJI4t9
         FYFEH2Xt0KGI/lh21Q5R0IC0hb5Ib2VXExYLa036OTeuXHvDg/IjFpC1i+BLC8ww5UBN
         GhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761597778; x=1762202578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zODHDgIVcThjNTQxncSaZSJNvBOcC1ZxkNJs06nMyxk=;
        b=SGG29yLE7VZ+jsygg5LriE3N30jHQaO+9G2L20rFtZI9KmSZi82gX5tn/VvUesp0Ew
         tZHzBQZtzHrenu7L0tXR5EdF2RSo16r4q0+wAknfyQ3pthq4dykly3arztoug6kCgRtv
         UOgooTm5kCmMWNFoDxSCzUKmHkvpw5L3Np48XOXeOCxNUgQ6YWZsNZEx3ludnZNbUqem
         1JGpLGUIpS+x4lR0WQhg8FO0tRN7/V1SexkX0RUUsOwRnBYHLmulCbKS51srAwmsw3oc
         R7sHcI0not8pUhLco6jXSA52vJ1RI4uyw72x+ago8e/m8yAwk8G5xHa9BOYmSu01LaNG
         rsyA==
X-Gm-Message-State: AOJu0YxXU+50LFXRbHYOoFdXn/4s2za2j23YgVO/469gQfgl9qi3RArj
	xWtyhek9dItPzGjqNB5LfbcMy61s4R8/dsB3ODd7T7NFu591t505SFmW
X-Gm-Gg: ASbGncsSPcDzjmPDzwaJ5BGdL0yOyRsN4yRJPddT4qSesQvpEXFI2UOpEq2PYwCieFK
	/CtPrUD0eMyYpuN+B89DXn90duVaGnfYJAJoO2F9+FM2tcACqKkcxgFmjygjtCSouYwbeXI13Iw
	JauYWWSX5FucqpiXtbAyuMgPee9NLHibZElkFXNe5tPwCQWiEXapGdiP11AUNIYcXv32m1Rlp2c
	qoAw6SzlIfN1rAM7SqSKSuDJwrpb6/BTw1lOmw77P9P5j2AxTuRq4hpNflvnHcJ/hxkM/1eCUBq
	TxlrGejYQ6zeYmsaRwnorFLLzJI6HHaFzKrjugxKBIj9el9gm03sBsmXkPr2kqP2g9WxHre/Yx9
	H5Q0rRsAkTClFXWtLPtOnXrXxsPrr7fuhmDk3gEkcW5a7E3EObLm3+drZ371EGRSIGzouuU6Ok2
	XjWL/lKbMfqvp1U+UmtwdPAelE+aM=
X-Google-Smtp-Source: AGHT+IHjY1h62yk27PivH7Y+anegVGVxs9iDSQpJ7ULwNyIzYPD2WxXDfIKBytoxE1XNdGRwtGRCmw==
X-Received: by 2002:a05:620a:2953:b0:8a1:b5ab:bbd6 with SMTP id af79cd13be357-8a6fa37ded9mr168442885a.71.1761597777922;
        Mon, 27 Oct 2025 13:42:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f3497793esm657733485a.1.2025.10.27.13.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 13:42:57 -0700 (PDT)
Message-ID: <4d3df05a-36af-4e1e-b904-a995a3744e55@gmail.com>
Date: Mon, 27 Oct 2025 13:42:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/332] 5.10.246-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183524.611456697@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.246 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
