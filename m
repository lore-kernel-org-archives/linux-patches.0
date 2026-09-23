Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603D5625FA
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182818; cv=none; b=ojdhTHnQEiD9jMajz2zFxAunI4qbWOAX673HXeo/yHNebqceJa69jVknIMTpy3TOFZHuAOmp2HuDtucg3gzQ49Coq1spfPSkWhh9SESeQ3Gs/4y2v7oax+F1Q7An1h5KSkIkciQkinRicafLoLpkbARUb7suHTmoZFFRSLxWfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182818; c=relaxed/simple;
	bh=sGc6PJ0ESI7aHX7FRKJfITiyKS1azlW6j7agq0JY1UQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uy80GYFBCS7xxbWQvDKU8SZenTVtvhipbr/iIUJ1bv0YFHPGRzP+nUatot2MPOxz6NZbcUVaC6AuX8zaQg7Y2X/aQC+q69pbnnJLOYSzy0HfJIRVLXhY9/TKfcu3HFZqznGHZjZLhFdubmQbk/1/rG11kxvdNBLANbheFtR5Wis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o+zxqWx/; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o+zxqWx/"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so702724b3a.1
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790182813; x=1790787613; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zS39PJcT1oQj1VI+hAMdqo5YKZWOz03P5HuPkkDO3U8=;
        b=o+zxqWx/wWwg8eNtOKQZR5OZuyrC9rRZANdKBfCG04szVN2eGwFdOF6+aO5djdVyHf
         YpMeYIdKhCBSVwDiBKR92NlrlpxRDTwYtiJnzZsiXQGoc06MTLel0WmzZ2X8Ea14gjV0
         bIxiV6Htv5eOohyUxCP7fMvxBnx0QCaPh1o15zgwlE3rurnh1aD6Y18u+23pjALV+1JQ
         uCe5FR5iMdGO9sOjAnlLW58WeU0CpwpMec33TsfDwyAxbCNPeFaRPYgB2Iy52Cjy/aKE
         KRcdKAOtcK0l1QRSlCQl8nxdoI6DyrX81+E9pT6rSt85BY6qfQnSPDDa96F/AhsOaaA6
         4DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790182813; x=1790787613;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zS39PJcT1oQj1VI+hAMdqo5YKZWOz03P5HuPkkDO3U8=;
        b=UvMqBy3q8YPHWLE0YKHaXEMOvGVwsYK/wqKdCOwpX5D4haI4sf/uiJl6e+QYWomm+C
         i3pWCIJHPyHXhuCYZBO2HQgDdGBYpz/6AoFMNR9eJkiKoy2QiOm8dUDpfrIw8gMtuakb
         shjfzmLndMUNy2gf4k5zayyiJNAObwIluG7LZqCkrVydopC2E7tdXzrxyAXDtqAnY4OZ
         VYgxRpchw33AqsiW2OuqwLeHVszzuLHrhOlqoKR7Xwg4VQywIWwOY0UaN9WCQTnnkyOr
         SGPk/uQZaA+sMvxeO01pNKeK6p8g3rRXsDC872wc3nMaFlIUf0WPHaEQqdNUMinXFx4k
         1CpA==
X-Gm-Message-State: AFuF++kt6YYTfAC2N3gdugafkpAiJ7g2+wQ/4VbGi172H/n/DM3NqYWw
	I+2mQPWE0/ghj1kTxEwWHnGagxDAOWUDQtiwGEoAGrF/1rbnZeTn725i
X-Gm-Gg: AYBFou1yHCuWCXXHAIE5ul+nILeUCPUfiSwQ6Xv7qk3NNd9hyBLMtJUAiy4m0qYpezH
	U+p97qFMOXTQ7gbf0AZpj9iZ/9HPXARzgA+lRLBnnNalfjkP1hFsWWE8Z/BMkRyo3oAGLsd4wOQ
	IdfRnwr8bwO6c9VwV3W08OKn+iwKjB4JQdn1F0WTAMLumKsbrMCNMKUGaFQmriUq6C9RFuOPcWh
	DxOaQ1ipIO6c+lAzFjRWbRW1hXytAS3c8wXFejCI3kodbE+froYQs0feQmizolNYPY7pwb3iUjx
	uCd5RHkYsGLLjb6MzbrYhbhbqBTgn581yyRmGl8Yq3okJdgd2tjoWHcDLWy5OYjr3pOouz6/26d
	JEbanEVAX13JNVeYxptZM6pFjk6VPeSuOjiUqsv8U6IkC7Pb7M+LgMCC7qA6xD+1AehOjkLB0fB
	h8+h7E37XDi9+aVYfjDhmMvBivDs2iuMKVcM1o6TOAOXtIQP2dIlUQvyZq1iw5QdukAjrvJ8gMZ
	/4G6KiHIE0M
X-Received: by 2002:a05:6a20:d529:b0:3dd:a197:cf22 with SMTP id adf61e73a8af0-3ddf82868fbmr2949364637.70.1790182812807;
        Wed, 23 Sep 2026 10:00:12 -0700 (PDT)
Received: from [10.14.5.0] ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1dadae4fsm1630251b3a.40.2026.09.23.10.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 10:00:12 -0700 (PDT)
Message-ID: <8fbc43b4-c38a-49c1-b6c9-77899760ca71@gmail.com>
Date: Wed, 23 Sep 2026 10:00:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260923140644.756254324@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/23/2026 7:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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

