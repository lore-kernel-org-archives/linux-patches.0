Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B04AEC7
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 23:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712879478; cv=none; b=CLpPtCPLwZFbxztED4d7WW31JT39FJ/OBdWXcI28zP8RwKjMGHhM27YMo+nhOHlpeTBahngQqaRiPo344gj/IfnO8nQ1gE8FLiTQAs8GCCiEzk+9LMJaj9hhoC15jrxqbsp9UNP4avc22QBy/s51hZf+ZV1vnYSVtVSAs89IyIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712879478; c=relaxed/simple;
	bh=5n/c10tZw8i8ramDDL8gGaAfX2dPojeKb0kPmPkSSRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4hmBcpJ4cfuvTECHwhyxIJXTUipnxdQ6qIGhMQD1c5qtdkfKhPvTeGC5mo1i2Trv+d+CXrzd2eB7QiyBM3pdboTn2Fvjd5HOC5adq3Whn2ckISq9LiVwqlMvv3Sa7k0smjZZRQqGOZ/DamAtOkZch6TRlxUNc4rKVoKicvH+E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfwDgGyD; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfwDgGyD"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-36990f24098so83265ab.0
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 16:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712879476; x=1713484276; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BTOuSbb8hB+vYzGueSyEZMnAtdrSDuj/9HdWkOKBA30=;
        b=NfwDgGyD5SrihuApLfclGW5+u7GBabABw97BfECl+PVrT1wCEaFzj+H8iiYV0oJy9J
         SFZvtScoSIjnZ3LX7qNrpXeB+NJFdgnQvCejKm/3c9yN9GTqXHWKwRDv7TOT4iCJtYf6
         u3CiylaFUhoyG+ottfMm7wgua+oawCl2eY61U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712879476; x=1713484276;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTOuSbb8hB+vYzGueSyEZMnAtdrSDuj/9HdWkOKBA30=;
        b=IWVOOHsPVAtDlDHQrUvZwia8zBbn1vFZGE3fSEc2aajbiDghf+huOXNKd9naTibikp
         uyLc6L52XXO8onq7qGwSdxhC4ksV9NoY8d6fSTojw+nDoeqnXteYinBaLi8mUAsOa75N
         Yla1unsgX/UcsddZFOgKjpcEUJ0MIVmlge8rxNo/zCrYyX2zJX08y9+AeQrT2Ycu8sEm
         pucB6yyeRJ1wXjwWiPbP8cWvlJnCWaJDbuwqm1pOJTatzBr15vggtdgv8falnNq+L2Bj
         w6cekP8jYBXav4eoUtaFyC11CJ0YvzE9VF500K12yXX/J19f1KBx4SkNUG+cQGrUAjn9
         Xiew==
X-Gm-Message-State: AOJu0Yy08geNR8DfAaRKo6f/v4g9Odq/pDqGMpv8VUJS8wkii78nOXZ3
	xAYnJuBFA7CuCVYAMI2z0Obx77FeoB2JYZ4IpVuNLaYoI/K+otv6mqgqSaKi/Uw=
X-Google-Smtp-Source: AGHT+IELDyd3FIIEpM35tZjAK3mc3g8KNLKNwq9rZRUw1w9eybeYd4+fTEfh95HgJWqypKO3mqmkXw==
X-Received: by 2002:a6b:f312:0:b0:7d5:de23:13a9 with SMTP id m18-20020a6bf312000000b007d5de2313a9mr1352400ioh.1.1712879476075;
        Thu, 11 Apr 2024 16:51:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id is13-20020a056638850d00b004829581b0d4sm680676jab.111.2024.04.11.16.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 16:51:15 -0700 (PDT)
Message-ID: <2fc1e5fa-07ef-4045-ae31-654a14844efa@linuxfoundation.org>
Date: Thu, 11 Apr 2024 17:51:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/215] 5.4.274-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 03:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.274 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.274-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
