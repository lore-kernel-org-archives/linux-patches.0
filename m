Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE930242D61
	for <patches@lists.linux.dev>; Thu, 15 May 2025 08:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747296613; cv=none; b=abJfJbzb4YBIOv8EjNbhUemymoNa7l0YisfuxJnI7mRcqazc2Mm14uU+432iL9jmvsQ1HSHT6r9UxJlj2qcBmFeS0OcwL8ynOeh/DsZCA2YBQcJpKIQkifa8QqusY6/d6+KR6+tEz18Kdvh/5kgsDce2cnviVqhJGETlSbz1klU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747296613; c=relaxed/simple;
	bh=RQc2H3wzfKeurFGucjVwx2n45yxv7JK3ptxwIE7kwfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWhmtb88zz2xEKePJ2WF2JJBxeKWkF1fcBZ06HPQ4dn+npsOTVrqcg8Xo+K06uSEeKWMDZ64Y+X59cGF/6BuD9PpLK/ku7ZyAEjuvTs74VtzcfpfbrhhyC6R/TvVQFr42etNCT2ItuaOpEN2XJx74mYHbL4UrOo4nASYwXZfpOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUqYz7bm; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUqYz7bm"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-72d3b48d2ffso622575b3a.2
        for <patches@lists.linux.dev>; Thu, 15 May 2025 01:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747296611; x=1747901411; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hkYmL7GiNnw+twcKceex7aJBPsWCYw83ZAJqdfN8BEw=;
        b=CUqYz7bmkxtNS726RG+GuNP0dU0ZZ/RUNf8iv9dQLD9LeuVnDbtcKN5nEbb4fwLmxS
         rRj38xUE/qXijBgZcHFsw6CKczPWLd2KQWjn136+bWOBnADRw72sVN6f9a7S8e7EJ2Vm
         n7TSiMQuB0+haqAw2MqqVkExmALSZinxnesoI9TRozEY6h9NU/Xm7SqdzZjblB3PF5JT
         rMMCJNatiejZz5pm/uLVqxpOoM30w6gvAm1BTB7u9AcmSJPsfHVU5BLP4BCh4xzG8hWz
         7X9Fxgb5pWHM4nV60g5rd+6x2t06Ychw6ht432vAnUZBTBl5Hm81Ld7hlObIQWoLXBub
         l1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747296611; x=1747901411;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkYmL7GiNnw+twcKceex7aJBPsWCYw83ZAJqdfN8BEw=;
        b=ZuEdiJyvPpYwmlCxknagVKyd0tM8lFqNJXcinl/1lxp9hCwIU4bNr74qVE4M2JSb3t
         EBEKP7+sQGhz155GUMZWMZ2fUydo9BHkO4nvsOTzr4y8OXkmTUIwnd0acHlhOAmPuTCz
         oKJd0TssCzdmypjIjRgv0x7pXgc6Y9TwOvcHJG55/4ybW9GxBKGjmSSeHZ/t18MJLxV2
         zLhU3yoOzWOGvFHgvOTEA4bPXv1o8TaOHJ1rXD60LQO7kP7+VIWZ51gsrDmyfv5/iu0t
         gWG5WCbSM1+CgfwISPi0kvrHgXCOwaLh9R7VsQok8nc4nNt4EuDEdoNP87E7JXy0zbCy
         4iJg==
X-Gm-Message-State: AOJu0YxxkCNM3/gPacV9icxzZiwyNw6akNiC0HCABrxQM/fLcVOt8yCg
	oBRYNbVKf7nDwskwQtNxWiX/Pf+PGRzkS5z9KXLfFxuoeN3CFF6P
X-Gm-Gg: ASbGncs/hZLMtjqNaDbFgpjXU3Pg7Y6EOVJWx5rLueT0cXwoaCNBUDBYqRz8XowpQRs
	yZhvBdvqzwajopJJJFUeOqa/bn9uuNbYsGYaAfUQe7FHyu2ktUYGU+ueBUSnUJtnrfcjMn7+jp4
	30VfeshRzeWuUu9iGjuhVDBEcD64nv7Whhrmw8mDBUkTlA1+ByA+MF4KaYb3Yu4L90nPpwa+Zlm
	EGdPik1u0NJwBvQRjcU5r9OkLvqn+Cs1Jip9SU5cUjDFgxsW49lKnlRdLouwHBGlHY6VwdYTba3
	CwX0HIozJMQhL5fYipcK39Z7KRzxgZskWGZ/ETrK2Y8lsgMIoHWDNS3DDqSz/3Au1hihD5ZMobp
	TvaFKxCYHE+fLys1exRa+Ou8H079BT294yuLCxEEP9FRkJuGZ
X-Google-Smtp-Source: AGHT+IHaq3HlvQPD2bJNa3oBk4FJVvqL6doSsX07j6J4ytjuO2mOMBQO+tv0aHHRM2qExR+e2rNx1g==
X-Received: by 2002:a05:6a20:6a20:b0:215:f26f:90e9 with SMTP id adf61e73a8af0-21611549c82mr2223817637.22.1747296611056;
        Thu, 15 May 2025 01:10:11 -0700 (PDT)
Received: from [192.168.48.133] (mobile-166-176-123-50.mycingular.net. [166.176.123.50])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2350ddb6e8sm10074271a12.57.2025.05.15.01.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 01:10:10 -0700 (PDT)
Message-ID: <089c9c94-183c-4929-8669-b76b643a34ec@gmail.com>
Date: Thu, 15 May 2025 10:10:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250514125617.240903002@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/14/2025 3:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernel, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

