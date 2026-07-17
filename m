Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B191E5B68
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302268; cv=none; b=hTVCm5J6ah04vtsDYv54d4KUlNDqy/d8+kORnqSnDOkL4HAaepM6YGaxBvpFELke3KLaVXF/kwOi4yJI+McV3UvgM1oir+79UXkowabXij42ztQnJZEOW2TcUupE6284hF+HIeuyIMdMIdHoI2GtEe36dyvLXEsK4+j6f2wX0n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302268; c=relaxed/simple;
	bh=pK4XXBR+u90/6CIhCuYQsfAmhWhgqVxseBHb4pQVOPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WO27tXb5ohK8rBvz7N+1QtX0y2TQewRuKzUqTMYWpVhL5lOrA27tWrPnUZzJY5VWUW9HJuKJum4+5NpvHUxmLQOVDGTHIC/QNTJC+cBskijaHrvLK1Bv51m65ahzLoe2rhmVutZXpbBJ/yb0mewgAIZyCjvzMnMdpaONY5qx7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zb0UImtE; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zb0UImtE"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6a1888969ddso4700189eaf.3
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 08:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784302266; x=1784907066; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RKK5xINrVK66ISMnlbs7FLVeWDScDkulOp15v8I+8+Y=;
        b=Zb0UImtEyMiAXA0fWO1z1HqrbYuycASZq5KqsMQGqOYQ3a9ItNwwLmQHGDXBS3fZNw
         4NnGdP6mlt6BmymF1rcA0Tkm7gNVhdzPVcPaOl1J2TbrmiXoLGk7CrfUIwqLuOjCljcG
         JShmFB1GL44Bl52GFnlHmzo/Q140tQU5RsCfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784302266; x=1784907066;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RKK5xINrVK66ISMnlbs7FLVeWDScDkulOp15v8I+8+Y=;
        b=E+yppLJY1JY9BZgsL/IgUZGLqFgSt3Ej3mqIFg/zQeSIVZtOgXlpzRJtjtIRk3Pnvx
         YmAgFtRKGNCB+Qmr+klpxwobpBNoTkMsOadT895kRZsIhZEDH1QEnIgzY/TuRpPz+9L7
         Q/GPY29gVsV9GtPxKMUDX1F9//zEQFQCR67V51GeCIF3lZO2RSIzO0irxc5oUqkHgGp4
         YzQ1uYm+GtMvqr75JV/LlMNzjx/VffCUfkJ3tT8LA6p5XRCc++k17TkjNKaEMN29ctfP
         mviuD889LW6XtRIsGhl+DlbOHf2ft30EySrZ1pz9PXdvm3/X5o06dqvTzD/bAuA2Vo59
         RttQ==
X-Gm-Message-State: AOJu0YyLcELyDfuZ2H2vA7o//dxt5wohntWH+YzRIidP2L9XsJAwVXEW
	9BP6oWpxd+l8WBnqe8Feo2tFW5DVn6cEkP8dbbCQsruT190vQVIbFQZkuYjDw/buMxpwGBbWBNO
	ZlxqoeY8=
X-Gm-Gg: AfdE7cnZ+EY/E6FKo5hUEWbNf2MERfVXnwBoFBdLtdWI8cdQneMY9cwhdgmjymlqP6w
	MjpIsH4YziTREN42b8A/FAGdmodxOm8nfM+6JnObirxaviZC6mxgDizA0EWdz3FIMk1G0ga7KuO
	OaBZWQq1PtxNbakVzcDRpQeUt6p33M9XpV/MBnHMbY17nycKzhZ3ajZT62PVqrHNprwY9ldupFs
	MzTInuFKV9YuOQEd9Gw+QIcdoBmsuuRLZT28MQAU69YyWeRH2/rwKdShxemzOkDATJizxu96E8n
	RYARohWt7l7tPMSdNkstdwSEUt2865l08JcXhBYIiZmJutzK2IYq0nvubBHEFcArwG4S/02GwjO
	gDfBAsCdrued2PqcHhDyI+v4tAbIcqwxpViXz6d9z6Q+PbwHdTFQcCiWN9kgh2qcDs2aJ57vcQ9
	VQUcaIP/4DjKkyuT3sFXXnIw==
X-Received: by 2002:a05:6820:4d01:b0:6a1:5756:10e1 with SMTP id 006d021491bc7-6a53686e043mr1286853eaf.55.1784302265869;
        Fri, 17 Jul 2026 08:31:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4568e141e9esm1471256fac.5.2026.07.17.08.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 08:31:04 -0700 (PDT)
Message-ID: <089b8b1e-a546-421f-bfb3-8c3728f580ab@linuxfoundation.org>
Date: Fri, 17 Jul 2026 09:30:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.96-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
