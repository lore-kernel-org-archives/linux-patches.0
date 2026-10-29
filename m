Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287081;
	b=jQ8da1dUFMMmjcAnNn0xIE01tjRgtyYfdrXxUZFyMJ9g8dqUVw/Sm1k9PmIlusLRybh9
	 llWzThRxeuaFYTgtVMXE51YcEKgFbSLyr+FNZAo3CY+UpEJD3TOCwq8UUoT/3ku/fr8Jy
	 bKKpFnFTFVz7YsxQJM4GmO1i7D0LYvlUzzqqFTsfhsrEiSOM27Hfr7qTCjEToFhZGwZyz
	 H4Be6vPH4NV+LreHaQQfJRzzNIPOfHxzY1trxUyY6vbr+LqHzshL4kwCJmg9seaxl3KSn
	 alacWPILmhwC8Hb2aaf9on296nPqg/Milgvfn8ntv6EBPVmPJ+fYmevTw7I9IOGHtTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WhrGqebO51xfUsjiZH9anbqm9PSjMbH6Lkt6vVEX+10=;
	b=HoDXIxqZ/aWTga3mNPc0+KdixfvroUym93Q6MyYxtOelQavDpgrFGrAyNN2R8IIh1g30
	 LWsHZdoThrB7WDyFd5Pb7xLiQegpW52Zkvy+ZtK4jiDvk9lLNbLx4nI6gCD09dYOojIFB
	 88szM/NE0Ys3DTzsJxxI5JIpvUyhouFyC6/QeXdUXkWXWAejhdJyZVPnLtKtpRLiS7vKp
	 peh7+1XcXe6LjVJ7go1ZJHOqnKMsFQsEmbasYNcxN2nIz+ttE8bKzNva2qrx7JVSEbI1m
	 lbUdqia2WLN9YHomeP07A5cx1O3i1Rv6cv4COIvXl9jcFgQPMj+sKvF+C5z6zWXXyoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=GajI8jco;
	arc=none smtp.remote-ip=209.85.161.41
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D08B606A320
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:18:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D08B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=GajI8jco
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6df5e315bd1so1635115eaf.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793287079; x=1793891879; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WhrGqebO51xfUsjiZH9anbqm9PSjMbH6Lkt6vVEX+10=;
        b=GajI8jcoksTeK3ORD3FiI4YRlCk4xuo4YbTFJ7icOD1GZp7S0rrklI0naiUJuFurMc
         n2IIZ8A1FEigqJU169EFLYtnPDNvTqYQ+WaIVvYFZ7+CZMux8llWPmt5BH3xZMXLe0L/
         xg2m+G80TZuo1N/cPu1TEJNyN4HCnSLYiNX7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287079; x=1793891879;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WhrGqebO51xfUsjiZH9anbqm9PSjMbH6Lkt6vVEX+10=;
        b=FDkZtURirI7H7N20CfKeDQcEFDy9yY1QZ6C57BFLnObCd2ZlE4flI56hLjeBWH271A
         BRFfgFyNzAXZU9xfdps8NJBvrzvRV5T6BPK27XHgenTGdWiCa/uUInEJZ+C8n9XnP8kC
         bTRdmOAMrzsBYoWvBeMLOl54QZASflelGwF1sTutjy8iBLj4q/VihLcJYQsirbiHMwEG
         ifQ/LZcjccoN+DTouqPOulP+QqCywrnRoXABpZKUUTnBqTghk/nKCVykBkIzOjG4aw8h
         aQahjPlHzU3PPWdRz6TGF9tH3jP+ZWo2P6QTVf1U4c4PL5IvvdMY6TCORc3/X0vJSdhF
         MxEQ==
X-Gm-Message-State: AFq9FYKQzScG7yRJbo9xhJHKsaKDiHaZAqje2vRp/+iRu6E+8g5wVX6A
	DAa4vOhnnhXqqjfAeFq7BTng4EV45CQydo5QupEtAcXrTvF2Nfmh6bHTNkc3RyRi2Us=
X-Gm-Gg: AYBFou2NfhGpU1AcoRsG628Z9rtJ+uQSujUIsc0arRowfEcb/EpkLUQh6OcBWTa1gf5
	J5318jPcHKMv8S0k8hn9oIaEj/dabwGdiT7YbfFcNFbz9GeCnVABG20HpCXyJWiTdeXfRJfI8G3
	sfDALCe8rUlnYDdy5OVc684LvnR3a4SlzJeRyHXDE23cs4f5tn8QyBSVXDdKG17rJRED/SkE8vd
	kC97sC23y4zisgVdY0Jm+UTBv8vKfwVVWW9QpMCBZfDGCUKDusD6/dmhClQnpjvi+XvwtL4grqv
	diIKX+1a1+nyaPX6V/2qTAxWwpJqfCrKDG/TLE/y4IdhWNwUiIjxmzGFu/RmYhiAkUbq4aW9Vv8
	nqAndQnasFFr7y+XkGYsZLLmFBN5JMP04c+xkiN6t/KkZEz0skfmvDy9a9aXxeBBWnHpRtjHFs5
	/wkExui7y0H/RMOoCdhMB/hyJvww8+G+WL1+JStOnvq1r3hSL4l4LErTjVm8tMnusY2irc3hXzn
	lAJOvWrLc4xJOAjYDPnOVyMVwXStAX8U7J1O4LacuttqllsCbS9jX6/uw6Hy/x6y2XNzjbZ3lZt
	nbdm1un1S3Xw/Af2RRdI4oZSJEVHIlMmM1KoN8fC
X-Received: by 2002:a05:6820:1343:b0:6c9:80d9:5f0 with SMTP id 006d021491bc7-713f195f778mr3311997eaf.49.1793287079139;
        Thu, 29 Oct 2026 08:17:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d33fdaad7sm43385a34.17.2026.10.29.08.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:17:57 -0700 (PDT)
Message-ID: <d61a42b6-b92f-485f-abc8-0808fb395a87@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:17:52 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
