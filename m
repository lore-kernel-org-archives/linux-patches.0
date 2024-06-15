Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32CE442C
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718412976; cv=none; b=GHQxjXZyAYwC9+1Ok1AW//9arxZZBnfUT/2tvKGzzcOw/ln/Jsg+H/d7CDzGeawv9imcBTOyv3BYwsZnKjWZcqLIZj2QBAR1rPdKyhh8ZGDZv/6bG1qkd97IgYj9cXtfGPmqeyLbbPgzKxKZYwLu4OlOrQg+d5m4Wr9+Y5GR51k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718412976; c=relaxed/simple;
	bh=xAOUve96nzRjMjGiUPA98atnzfn+8zSS2djXh7HQyQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qxKns7NdGgL3AXYheD7BQaKvuBkSTrUSzFYP0TrGlI9KSfCSKx2a8NyqK4/9XVbZCIs/Fe+cLdeRP4eXxwaDnpeIyIWHY8EhaSpHRl1ttz8IL8kqmqUfFkLSPZQxqr0EWGFFKNuB5xjDK9U0UjeSpctXO9TDfr5t7IB0vKPiPWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bzZljztY; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bzZljztY"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6f177b78dcso367557266b.1
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1718412973; x=1719017773; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MhPhQCOOoQnlUOqGQeHnLIf9fsvszQNArbvyi0UDoYs=;
        b=bzZljztY73Bry29FqT2f/LouPZGuB8/YZ/+71gwKNcLYLvb/10jjG6oyEKa1bPOg06
         U/4XZChunYeFZ0j47rk/7uKFh1L9xGYzwLO3+5ZcLH1LsqfB/tuGbqgBXridTnCid4Ae
         cltKaxOiJPW0NmwA2ZGG2JRxlIngEFPWQNzty6K7wj2rQEfT9MTQJcIHQRRzm1HEt0sg
         8VPRVji6v1zyFDcPDDQnudopV6UJ9XK+KL8M54mU8681gIKW9IsjcRCttVqzp8QsB9fG
         C1FIhEIX8ZQawqdckbA8skH69jzk2LLkQ5OCpGQl6R66LdWmzL421jh5jHiC39t+bIwW
         qRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718412973; x=1719017773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MhPhQCOOoQnlUOqGQeHnLIf9fsvszQNArbvyi0UDoYs=;
        b=S3XG+k8gtwiFUYTUNVhox5CwuT14bmnxJ//yvU1j/IU52jXmMky1oBuqnuSoha6Ahr
         LU1Tqs3LFT/OeRvVCjAhZ1WoOCB8GLVzDIeSt/EQVpHHwGI5IFkNYOooWTnk6LoKnFiK
         OGHp8JLF0o1ncLRn1g6lGoNkuEqT2dU85pEfyNZxaUmbPrO4KYP3VHwACYjQh8Ua6k3N
         fX1A3pEU8ziUGX8UMDLo7hSjUn+oF37u0t1iuYb0CWKOovaCVD5ez6fPaodA+2+W6iB9
         zqYQpTT/sVLcltZQkawrlVFT4YanygCx4wSrbz4dbZ6tKInO2i4xtwsPHp/FStFJMogr
         7e5w==
X-Gm-Message-State: AOJu0YwOCeNwvvSQoBD2CrAx1xam/+fN9KtNzJX7Ty0Uf4A5F3UH37OM
	GCo6wLhxopdGVVf+8vzDzOFhuXjwn1Qx+h/6cNH/GOl5qgrM4b4=
X-Google-Smtp-Source: AGHT+IG0B5lsBy9jnULieYgLvmnLrftGOgA3ohOsKOLCHMupilq6C/57dHPtGnk4QzxY1gtFlrfz/Q==
X-Received: by 2002:a17:907:1c05:b0:a62:1347:ad40 with SMTP id a640c23a62f3a-a6f60ced4b8mr292509966b.16.1718412972742;
        Fri, 14 Jun 2024 17:56:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4225.dip0.t-ipconnect.de. [91.43.66.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56da40b7sm239580666b.22.2024.06.14.17.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 17:56:12 -0700 (PDT)
Message-ID: <3dec1820-42d8-4c76-9424-ff73fd7e5643@googlemail.com>
Date: Sat, 15 Jun 2024 02:56:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113223.281378087@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.06.2024 um 13:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works w/o regressions on 2-socket Ivy Bridge Xeon E5-2697 v2. I'm 
currently test-building 6.9.5-rc1 under it, also 2 idling VMs running at the same time and 
I don't see any problems; everything running smoothly. Nothing unusual or suspicious in 
the dmesg output.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
