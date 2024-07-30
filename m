Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF13190489
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 23:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722383550; cv=none; b=n/7PYG1iGL+4AIarij0hwqqRHb6/C2yVTlzoHIATd7tUxIAWsj4gkRJ5d7JCwwmxCnNq9biZfYZrTVeq3p9DReQnd6X5r1+rl4lhgN2sjLYZ2ECKYShcKlMhXt1GYRBD1BZQZsCmeJ4OqJQ+MG5ZteIbpCjiXKMNh6EQPJcLjjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722383550; c=relaxed/simple;
	bh=vWR7eaB2ziX0DQZ+eFOVqHJGrdk55GJujcwPPE799oY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g89pClvqu1ALmbLYAXQdIie4sI2Jod/UOldxYpDhS9qRehIMfIGb9agNt4++vdB6TnkI0625h98NW8s7DXJxYLD/Hbl4EzPuNCBYvztAr7yPaSXANRXktKEQ72wnStj/Lw+g9nf5Nq6PSGL71/mLIkHqXtYinXnBeZBKzsf9toQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxEBbb2L; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxEBbb2L"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-396d327b05cso1234195ab.1
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 16:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722383548; x=1722988348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vS2WcqLfwwuILiFNO1YcUTH9wMYaCwcHDsqOO6vbtSQ=;
        b=GxEBbb2LZm0ZBIDRYfg7SLohuiDQ5HgWtoXQERzNwUG+Sosx/QYeu1G5EE5H3Ffoxo
         XxYieC9CzP8mlzSiGyaZcXKrU1LEeonYBuwCQzl/l8awK6eiM61Dt/NWqb3/mEsHGyrp
         b8DSqFH3gqNitsO+y4spPKtRADzThDm+fTL+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722383548; x=1722988348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vS2WcqLfwwuILiFNO1YcUTH9wMYaCwcHDsqOO6vbtSQ=;
        b=gBEvSxuEJodSfp5kS4KXmRmsNUDaJBEFZlQRaeivQwk44CsOl6ZMOsacbpRINk0NfD
         g91AWeL2lwJThToWfNdTZqMmka7cQEkgiZToMX6JjU1iatcQXIfE8VRxgRvOFjeEH6g2
         8Zteqg8Q7mYsDQQVFrFbbAY/CdKdbytXTJBFsxGias8XEZ5HVmqHJrJyHjakXfLs1obf
         49+cE+OSaXnjduLQ6KbIGxrHcGmElq4y29Xwd5IdVBIV6GXgFprz1Ycti31IVC6yMCtY
         7osHCbsL4fnCjX3I79aaa67XS53a0Y3ZDLY/UpEDqEabzS14I+/7yP750zRYjt7H+gkp
         b0uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZFqqxliAE3etHdP+kyS5TvzixO7JYBnvYeeeZFWvIk3jt3LbXf4mETlVKxoXBdl6i+QuwoIoi@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9j1akz20aDqtItkqrpc+buxRJYWFrBvtr+94+MXy/swaiAYt6
	34I0CuDjpND+madS/domI70FvIlmamSGZwEV5NnrIaZqspksmZPRJE+AJqg/xUo=
X-Google-Smtp-Source: AGHT+IGX3WJ0TMHz/80Kr8J8XRAJeVloO4pdMttS6ct5idJVS8UQy6Bnk9x2cGMv+tLMdMuWwyxNgw==
X-Received: by 2002:a05:6e02:2185:b0:39a:e9a1:92a6 with SMTP id e9e14a558f8ab-39ae9a197a0mr98874205ab.4.1722383547949;
        Tue, 30 Jul 2024 16:52:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b0b51ee4fsm5841605ab.28.2024.07.30.16.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 16:52:27 -0700 (PDT)
Message-ID: <29aa906b-a026-46ca-83a9-43d0e8d6e779@linuxfoundation.org>
Date: Tue, 30 Jul 2024 17:52:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
To: Frank Scheiner <frank.scheiner@web.de>
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org, Shuah Khan <skhan@linuxfoundation.org>
References: <061886f7-c5ec-419b-8505-b57638c5cf31@linuxfoundation.org>
 <017486e3-2132-44a0-ade8-94647de78cef@web.de>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <017486e3-2132-44a0-ade8-94647de78cef@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 17:37, Frank Scheiner wrote:
> Hi,
> 
> could be the same issue as for me, see [1] for details.
> 
> [1]:
> https://lore.kernel.org/stable/de6f52bb-c670-4e03-9ce1-b4ee9b981686@web.de/
> 
> Does applying 6259151c04d4e0085e00d2dcb471ebdd1778e72e from mainline
> (adapt hunk #2 to cleanly apply) help in your case, too, or do you maybe
> detected a different issue?
> 

Thank you for the tip. I will try this first to see if this fixes the problem
for me.

thanks,
-- Shuah

