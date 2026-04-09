Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6893C3E1D03
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756784; cv=none; b=JfMhTSKbyn/paphORKGPb6+A3vvpwPdUysuqGW7txgsEzVsdbnDF5ZzGCD79gI8yca3PBJLuHNtpmIK6sI+eZOqV1Dqob87o4I7oUhQRIc3d4HW4geHbk7Z5FTgxRUm7Ubmf+CB+q0niL13JBF64hbBCj4kHjxvdlwPFszgSLPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756784; c=relaxed/simple;
	bh=ykDTE0C2A9shNqLv6aqpIPBrSXZlZj2NGIAu3LG7WVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9GkRFFg+F6gXnDiLgLZuG8q1Ozzaip9TibxA3iAKKkQfxKhjERf0AxNnj+b4aEZgJSBIvHX5V06yFIYHVg8d6TOTBbGha13LzphZBH6Gf/zpXAIvyjCncwIVuf9pcdgJaC9bebqcNzSYn1loeV4xA5e7HeMELQAMIA4JHtsfLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEIXmYtx; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEIXmYtx"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d7f92bde91so722976a34.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775756781; x=1776361581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cc50pyFR4NFZS0UGIn6o3GQpYOGikhyAqxZHWSIJIZs=;
        b=LEIXmYtxKZR46KfYtmglCXWZdqVeETI+DwFTdoDxGrulA9oZhs3gvZAgvgpaqVAGMa
         6FgYXEtUkC7eI9cafBr21OL9syxf9jYK2h0NeKSUJRKnPH0JpZoStn67R179HA+HICZ6
         U04ff4IMXQ+x0CErDnDRaCUpbFP6vM0Cz8ZCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775756781; x=1776361581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cc50pyFR4NFZS0UGIn6o3GQpYOGikhyAqxZHWSIJIZs=;
        b=XSWKa96xwdFV0E1wdBzS858NOpfjdonbXSACl6F4vYZuutz7CKmCdHQs2fS8tEg5Xp
         2jqsdTEl+s33JzX8HEh3FfXMTHyqjU4eoXarC5HyLwLwDOdc0JN1dcDzfBir34mFJQUf
         IBs034hr4raZKCwfROEp/fJFbancPjBgRR1AVgMM0dRmvrx0R7YOuiqX3DgbApuVB+mv
         qMOjbyYoeiioIlYKkB/jZyVSs2dEEbqfSbKCVrmxEdZUJ++6pRQunV1O+021zq8hq3c9
         3NzZjRRs5/YLA7d8WcrBnKp2Pj/b3mubaJOCZRwv/LzKEb4on+qxsWlB3K6qn7jhPIWt
         WTBg==
X-Gm-Message-State: AOJu0Yym5HJVXBqZeOI7ZJfAnuPngbrV42rwgv9Idb4pRm8AYaiAtdgd
	Sjw+9wEOUWZQm2nsUtY3KxsKT27/EPMWWDbyjQ6MU0ScEjL3ijbJrVSehNE9+iMeqqo=
X-Gm-Gg: AeBDieurLvWQL+McUUFZEDAuBxI1ZGhsmAyW4/uSs/USivyfCtR8PX1ErV7FsexcZNN
	ZeWHPqcgJta3RAYRfEh+7YSd9GV8OQUp3Zi8gsWCQLJ8VY5ke480cy1s8g9nFZEttGile5m/4M2
	FPDh94mtQ3uObIJhiM11l04VgeeFdUrhRlRVEOyPhiPUEqwRge/2EVISnrcxpFjvoWyGYnfnRna
	3dzMzYb7DmXL29kUAX3cRqY1QKVFHJocG37ks2qWH0mzq/fzRUZEcdZDGghu/dpsWPJTrZvF1+W
	TLvnQ9qQ/41g8haLjDu0fvwK0/eDcjA7ERzMMCKOansllw59SqoYdZdub5UbqbS+bZHLFAfgJvd
	Cf2gNKOOmQiulPYrdwUvRsNegNwdl+jgDW7pAS53N1rV8hmV7MqtcSjXctgBQZA68Qmyy4g01Bc
	ggX7OMGfOlcLTL3v3S15Q/LVwKoMRQjy+pt4I=
X-Received: by 2002:a05:6830:67e3:b0:7d9:7201:1acf with SMTP id 46e09a7af769-7dc27c7b32dmr136157a34.5.1775756781318;
        Thu, 09 Apr 2026 10:46:21 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc2696c463sm249464a34.23.2026.04.09.10.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 10:46:20 -0700 (PDT)
Message-ID: <d290ec02-6bc7-4328-8a21-a03155025345@linuxfoundation.org>
Date: Thu, 9 Apr 2026 11:46:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 12:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
