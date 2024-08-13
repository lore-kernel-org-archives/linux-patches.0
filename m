Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7F219922D
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 11:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723548745; cv=none; b=b23RUuJlkb000pmB76ipYz2kMe7Sd4T7+xqfuLvZmif+YUmabJBzdtxmkUUbOMU1eYGSin+f7pEXcc9P50ouxhdW3uXZZNeDLdaOIX4P4Q5m9LzLWkJ1M026JH1Y++3jRVnSA9SO7KKmv66bYE5+fo3eHL2ABz8dwMGQAmyj/bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723548745; c=relaxed/simple;
	bh=KvjJGzz1xQNHWNACafMPW1Wkpkmc0RPCTQ8VSp9K8kM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oZlmusTL9LU4bSnptC5LQB1QUjgs7bp8zp/t9hotaKNW8MQ66eVTESIUxOwrRv7LlSUkE7djD72hNrR6hvMLQt89FQ0IuDZ/ln6WXZ6rOASryAeA59/Za7bMbSzSi376nPqG9zQzrpOQFVmGzJUtcFXu1XhSqqT+Aj+rQVZGQuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mCVqb5qI; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mCVqb5qI"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42812945633so42211345e9.0
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 04:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723548742; x=1724153542; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQABmyNW1RlBrkRbzNCFM1S6Y1XBMV0+uzxHW7+CsqE=;
        b=mCVqb5qIkpEZTsR0ocfgrI+k01588WtREryeWRrCXf4qfx9ei4VjuiKaqMLCBFPC9R
         l2RJbZZ2kdnJ2GKF32kWsvA5PmkXSfeq8WTC0AJWSFOo7DLTl2pjOuF+/5kLD/soZrNq
         DDBlphPE3AEz3219lOYFgmAdjuUbs8lz6Lvt3pSYr/KB2RUI+WvCaw5X+i1Flt1BqQzF
         QP4CaYoF67SDD4yEQJxsUD3XAeo6nJT03WGggQ0njNriVFk2b2Mg9+KpgOekgQxQ4O4W
         CbVxmv0GecTmnz862n3wqzV2jwYkhr1T/Gn7djf2QG0clU1VDK2p8vtEPi9x2Lacco4r
         KSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723548742; x=1724153542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQABmyNW1RlBrkRbzNCFM1S6Y1XBMV0+uzxHW7+CsqE=;
        b=dbTQiygI4+9Pmbs8cNdFy6uDUAb2Dkrr0sjOlLk8HFmHFfgaiLTD/cRC78Tietew6z
         qbbUYlMsp/EsToJtiJsUZ0eG5ME2Y8hpQszxWOfcxnIspSwFK+StRW2CfkJ4yBTOOfCy
         fO8jyB82YUxJa4EZNzi85F0WHdoL8YSz4HU18gSR+RwN5qurq8FNVrcyWRoem6gkRXJP
         wY11iEren5Oyvm8EFCcCXQWAUwIrm9zf7bbudSKiS/0/Y+VSoZV9flqC/56MLO5RP+d8
         DkG1iRkdNorXX8vcZV9FRQrZ+O5ugCu8f0SM2qVWKNW+XGsuiOqjXl5DankiEj0zK7bB
         xFEA==
X-Gm-Message-State: AOJu0YxjNfybhwzR1O+RBLOetVw4GsEuzmRaMyXahOwBaSVOOlTp072j
	PlMIvIKy9jnhofm73Zq2owykk8TWQJQ/oauE+p3r+gKPmp4MPLE=
X-Google-Smtp-Source: AGHT+IESryEa0asHTPnoFS7YMhj5meOeCzPgPfOAkdjqUQzXXWQtykthSh3Dr83QzmofWloKvGjzeQ==
X-Received: by 2002:a05:600c:4713:b0:426:61e8:fb3b with SMTP id 5b1f17b1804b1-429d48738c0mr25837595e9.27.1723548741894;
        Tue, 13 Aug 2024 04:32:21 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac34a.dip0.t-ipconnect.de. [91.42.195.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4290c739083sm215211905e9.18.2024.08.13.04.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 04:32:21 -0700 (PDT)
Message-ID: <0fa4405b-deda-4761-bfae-973676302282@googlemail.com>
Date: Tue, 13 Aug 2024 13:32:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240812160146.517184156@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2024 um 18:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
