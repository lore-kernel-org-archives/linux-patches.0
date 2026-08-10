Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092973B3C01
	for <patches@lists.linux.dev>; Mon, 10 Aug 2026 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401651; cv=none; b=PJJGYvvQhHPz+h/kWrWd3saL+8bHWV69HaFHYL37OyiL9cylGuXSM95e3CkNCJeseRmAHQqF43ID2mntDf/9o9tTbWRbZgnpqGZBzja7FuUvHbap2Kr0IiAtqHUPI4wgxGwWlyUTlj5o1Ug2bF/n7xOcDMEAy4dFWGjFvW+agk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401651; c=relaxed/simple;
	bh=RqZ00Lwt59eQqtrWfELjRgeFke/UR6w09M3T3ynK/9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ae/wvNEJkmh2ysGVKSyUw5aj83NfMVQAQ9B3QkA2Z/m5cU8tX+L8ikhyLwJizYm/MoyvMRZUvhf/lPsgGAm2ljh09yU2bx/nS+b1/DbaS4wUvpnvln0UI3IYaQSFIDVYVskiQmLObPty4KxXUGtsUIXt+TFnEiDAeYOT+gNxA34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFruNCZT; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFruNCZT"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c2a449c57so1657261cf.1
        for <patches@lists.linux.dev>; Mon, 10 Aug 2026 15:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786401649; x=1787006449; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WsE2s3pfDs2VrzXHHCACS8hxsvv+gu3KAaZUVts9x8M=;
        b=jFruNCZTcMz+VVWz/dOV3YEI++0ifolM5tCx5OlFixFLwmwWEcXXIiTca7vNne37zC
         0mgTXm8c0AIB4oXXuMHpr1fmICZJsKPuq41ckgk/Lv8uEzQ4Fc+bY6RLn4QKMQO6pati
         hSPd6YdaNaqg8EbAhR3iRaIluziwrGcYRumBEdcAU2wN36IHM4eFZ3Lmxv+P606ofA0G
         VA2xOOGV8tyayyJsgwL4uGxKSuFQD5AdxbIlnp1KdPWqnKdimJFBZ5OnILvVwl0ZWDXQ
         oG5c1+xIlDrHydBPVBjpfBGvx4AfB2vQq+OwnG/U099/q60DGRfiA/JuumgXVma3dERx
         MVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786401649; x=1787006449;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WsE2s3pfDs2VrzXHHCACS8hxsvv+gu3KAaZUVts9x8M=;
        b=dwpy4CwP3NkRQjb6Qbn9WTUnR3XF6qBP/76aYcmf+BLQlXg7EqsVo1KlSGsHtBwRuE
         rLDTw9kR0uofWAAH8/CNbStjs64xP8ks1D4yB23/EkltOjVMOugqiIymCsZhl1+9rBbO
         YnYEjVDhlXA3w61umWmpX+KpsKLNKDBd5is+8RSelry43Q0cs4jUn8kkFisr0JpJdEN6
         eWHJdSOgX6cHXeliTWOGYT2ASUTZ9N6cQ6PGcqpgYPRwWfRwwhuIde5l4TXEbrdnWFRq
         sl6UhfV/h0HHgDg9J9tneSPWTDVaj5dXdFlXlq3qHkYtDYGGyR5ogUl3lCdBDlHud18b
         zrEQ==
X-Gm-Message-State: AOJu0YxV4z3866zjdVS7C9KU+JYg6kaA9xM16tpH9NP6m8j7aWrPCR4C
	gaqXYyv38l4QUUCby3W/NJzLiyxW+gfzJxxNsq9pQgwSzt35E4mgEs+F
X-Gm-Gg: AR+sD13cPx+odw7BMK38dWH64wUF7XqFmyz1H62K/woynZAI1i4XQM+FcN26UvTRPPP
	ZdaOvXCTGPupk9yXTclnx/Eu06ZxjWGqxnDvwi2Hr4XKiY4osoiU9xmCK0OCmh3AWhJ0SaFtRfF
	AR422DpfTOsZGtQPkIh0uEA+PMf9NfOBMlnmiWjKez6KZ+c3DTwdrguqb3pfa8Ad/FQ0NDtch1g
	BWHLl8XcN4bYMxTvuOGd4NM8Msn0Fj0tcHiMn2jjMghvtuCg/xaUMXeNXUvch2ZIf70L3q5eUiJ
	N7VyhtFj2U/bi7wPyCZkqKsuIkAJhwCrmIL8sG8RWlw5rvGuqNTIr+F/qQuvXH9Z3VwoTgt8zWh
	ZcnN05tjhcRfGxW5zuvXLm3T+kwpJ01c+XmYVsNNNFg/ARkzs1EEL82Vd8Nlr9r1jlLSoH8BRGh
	btzmwyRgL9JRwcB67uaxcyTLmDOWZMmMCyP+t/r3vj4wK7ebfUGl846GWZgzDB9uVBIYt7USUus
	vo0VCV2cKy/9+U=
X-Received: by 2002:a05:622a:509:b0:517:78c7:d93a with SMTP id d75a77b69052e-52ce602ce1fmr476338761cf.16.1786401648817;
        Mon, 10 Aug 2026 15:40:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d1659c1d8sm82836961cf.16.2026.08.10.15.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 15:40:47 -0700 (PDT)
Message-ID: <e59a44a1-1724-41e4-b766-bcb03ad98e04@gmail.com>
Date: Mon, 10 Aug 2026 15:40:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260807143424.272339768@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 07:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.44 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.44-rc1.gz
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
