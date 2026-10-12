Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BFF4AAC74
	for <patches@lists.linux.dev>; Mon, 12 Oct 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822065; cv=none; b=p4c6CP/quT1oiWAhMBBDgFEM1QNw7WxN7kRKZ02tMNVsSXJZQphrA9yGV79JID/W4JinyV5XGnr6OJP3bQ+O0hG8IZrxqllW9iZt7HNN9RuaFNP5O2NO1E3Me3NpxUZ30v1gNub2bGlyz5U1pJzMNnhM2txeuGCpw6NrTKxHqG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822065; c=relaxed/simple;
	bh=M0JGwBW7mrHwnbqHncSpPEi7zCT+FqGhYHkZknEXRtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1FyJLw7k69ep6PDm8hASO++Tg+uxohq2039gQuOT/mWmCaGFxlHPhrrr93gI1HWBBHfqOzONw4hKF+K2880Ja9cy7+hL1/n6aCspd99bWZli8VRvBi4IBQEBlfAfuNJ0GCA7s/8T7KeTJAFLPRHwKJ8mGCyvk1jy5XXDrXEzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jAjpTfV2; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAjpTfV2"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33e6279a1d7so282043eec.1
        for <patches@lists.linux.dev>; Mon, 12 Oct 2026 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791822063; x=1792426863; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=100dkfxHGFXdSa4nJokPxTSjLK3e/Vooj6icmrrZBFU=;
        b=jAjpTfV28DGx0rP2ND+Q4/UNbbrr0NEi4PKyB2nbSTZ9PQJqz3bUgSYBkTxJPF7+tv
         IscGznBvKZZi+W9yZbJgIBoKmy/EcbvI2N6juH5StHW2TNsAheXlPyYUjVi0FLPBFREa
         SXb9CthrvH/DKX3I4cHonrliABRS+iaAHjruT3c0tNaVlY7o2kbUU6F2zbp9AdzJQYya
         v4htD9ito+y8Za14fupTKQjC5DkGsKkL+J9sc2r22xdIWQRnyJOzssuzPNjxJb4hbdg5
         anKmNjtzd7kPXDWa3VBcOaowBDzW3awRiF313kZSAnUshv8aTtASCHREUkpY0HkdjgiK
         sfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822063; x=1792426863;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=100dkfxHGFXdSa4nJokPxTSjLK3e/Vooj6icmrrZBFU=;
        b=SY6Fu9+5mOlq+lawAgZyhv/ynYBn4ld1NJYfXUqruqFQrdUVNefSh+FaTywnLnJzHp
         orvq4HY+pXCxNrt9XjdAgEg/+S9yV0Kso0317E8z/82Fa3ydeWXTM0RSle3Eg44/zD/l
         Pj9FoEC1dS/EBJCxfuEqf52zswb5n5LbpSnebvDdaRuTkXCk14bZSRJkQHVmVqLqpOYG
         L4pwHOfmwYsEZVNOb9KoWx7NWdxTiJ7CBb+XYVERURoAJCu0gmMTOSQ6PIpJ2u+6lI45
         HHxtvgTzArZ0rlDk9/VScdyhx90SxRKgAvk7qEINflWcPMRCEmz3Aif3faYU1IUIib2p
         FZHw==
X-Gm-Message-State: AFq9FYIlklb8pBGnMyf4vsrnc6lJ4zraMzc+uVuPfwzbQIWpVnoZr/aV
	plIp2rpSz3aZSParpnHhoAEszdRhLLsiMRRg9G8Mf38reaPU8uCvIZW9
X-Gm-Gg: AYBFou0HvltVF5d7dmQ+1Nk6LtEPN99cKqVWy3UzuyW0olJ03YUSPpIN+d4VeLVrljL
	B/8DM9IhzHleka8/mN/TABiT+caSQuc/ZXHTwjXboGSYeB3WEjqrTTS2SnGjcGClXqJcZ56O2Ys
	9PR5/tq9+HMIWBm0BoDO1MG5neqJb4sLE3ZC0RyAalHn1IUgzY5uQlcRH0YUPWyuozAWcu3BrPu
	aoVveb44Qoz73f6F5P+Drhyds0aGmgxJfpBU3PXX2w/v+1LA08m4opy/4p95EuGOi/cBGvcJgwW
	+RYZIQoczt0l2Gb0C1dnNVLiFBKjU2SArlvjm4/jBhSGJb8Trl28ApXw8IXsISjw5LTldwqek8x
	23Fjj4UCJNuDoRHoei/5y8JWGnhX6um9Aik/eDGF+p4Fel9N2P8PXT7j/uKSp5ZDSWiGbaQYaZk
	rkEDhKMtndSV7CbO3G7ffMXKouAD78sK12REreCPfVtn6awr1LcUl6M1gz8VQDQAR71Ih/xLxJ+
	k5KqJuAhLJ719yFJV8XEQmg
X-Received: by 2002:a05:693c:4002:b0:35b:232e:c0c7 with SMTP id 5a478bee46e88-35b232ec517mr3252116eec.13.1791822062882;
        Mon, 12 Oct 2026 09:21:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca1b556sm46550456eec.9.2026.10.12.09.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 09:20:59 -0700 (PDT)
Message-ID: <f29aa81d-80c5-4ec6-9117-f928230b35b5@gmail.com>
Date: Mon, 12 Oct 2026 09:20:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261009140946.008206689@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/26 07:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Oct 2026 14:08:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.10-rc1.gz
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
