Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BD83630B2
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 16:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775060555; cv=none; b=M/gJoQsCqY0BwWNB1EeR6cn+JyDeGf3A9Vhef9FKb53F9djN+02iyFG5+ehOaLr2E0IvzYuq+fdteNlrKzaL/Nw+VXmSBJxX7eTWi88hAGEX9izx0z7XbbhUQ5rxrlxP6eDIQRAT3rvpFXZM+GwuklzqgKOtj+FANCME5Sb1UdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775060555; c=relaxed/simple;
	bh=nrlXyztA8MWJ+v6CmJ+vWGuQSyVAluyfqvC62dofhu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C1OIOgj79/u/Bo3lhjGXNN5OA2RBgv0PnA0KTexyD7BYaAFTmg8/Y4o8kQDRkQc2YaC9kvZv4yUSMI+23yQA6/7VewkcBW9pAwe7+YFhn0rlImZbH840/qHJsjBxx5QGkkw5XJg0cZpNnAEyCpbMjGa/3wcI5NqFnknHUpnLgOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUtP1CH+; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUtP1CH+"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d7e5e8c907so4516364a34.0
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 09:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775060552; x=1775665352; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iSx3jtFH3mTErNH7oGB+AD0kG4DJzQyPkSYb6TGDY9I=;
        b=GUtP1CH+fWgJdOJVSBau/JJg6DHLJfLTD5CKNZyItqkUIlXwbHCdHVaNic5G73Iub4
         rnKNv4Aevyv6m8xEOTwrf+ApP8z171tcNIslR9DNILHemTSgD6Wcl2QhuHpqqay5FEL7
         Soc+4t70F7mJtrmhuIu1Zk0rvLG+EW9p2v3jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775060552; x=1775665352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iSx3jtFH3mTErNH7oGB+AD0kG4DJzQyPkSYb6TGDY9I=;
        b=ZIu5bQWmoGE8OU4u0PGx6KGuqAdDiAYn9xepzPIjw4vikwEYVRz4sjDikvgfgpA9xL
         cLG/SgrFxjO9R+Z4jRdRQCjQOCg62evgTjo9KG7JvDt0VzU5lwIWF2uMgUkVkbdSMDyL
         xlT7bSx3ofCv/OawqaIXdEp1cRylXxBkh47ASQLHr4M/asG0fKtgiSYm5SNZ7IsbY3i8
         5W2bB2uMndEH/uCm3/roPgTJ1773YLpuZFTv3z8pn6S99ZnEkVeILFKMKLbNPSej60nu
         EMTxGArhCtKgRe4OmrCkkFHLlG7kf+yujEiHSwWiMavnKfbRTDsttPeqpKimYDQBVvhE
         Wbgw==
X-Gm-Message-State: AOJu0YwDzcQq3fApjNUbK6W69a7DRzGhMYqJm2a7AmQgdrMJLtxuSVH9
	UlMqeLuczHziy3OWEkLQh8Hg6YQi8FSJsy9DFQJiF1Ukb12jWRlmWP8uTdKMV7GCY5ph4SeWVsx
	UCuXVXK0=
X-Gm-Gg: ATEYQzzlKFTaz8xM/xbrOEHEmqOMbs27eNtCL7lAgvH2pOEnQnISk+asGNpSo0WkRth
	3+SfEPL+zg1wINKp/m+NNeJheBGpESCb/NX7sl2CtPJfwI/WXAf7OKhSeNKSScEkHQIJVZdeelc
	s9ziuKN0G6EgDOFYo4NjdyvCRkWH72AA0uBuCMRuEQj+b3ZTkwA9O3Titv6aovzlqYmw99KL8AO
	J8FWdGTZKvKCdxFEG83e4HEbE+s4aZiTFSC0Ilet1qDdl2M18NLfgQ1ITECoN0NRGUcIWo3XLQK
	bxXml/gbnLtfqfBYh6PGoTfI5QSF4frDYRe8EzN+jqlwGQl1Gv2qLClNtKWW2f1yEsuAC2KYrCp
	rIReJXq7OBv1+lInz9CLa5bpGOCwCq44n8Id5ak7c0bTDIiTXctsHnOLdX0nUr3jOg1mFjhOEcY
	ohgYZobQe8Gfxuc23hSgBJcsHzKfDQdyo8ix8=
X-Received: by 2002:a05:6830:a91:b0:7d7:c92a:1d73 with SMTP id 46e09a7af769-7dba7e3f516mr119012a34.8.1775060552478;
        Wed, 01 Apr 2026 09:22:32 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba7356653sm166818a34.22.2026.04.01.09.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 09:22:31 -0700 (PDT)
Message-ID: <baa2b4ef-2959-41da-aa62-928f00b16ddd@linuxfoundation.org>
Date: Wed, 1 Apr 2026 10:22:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
