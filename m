Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD71B0F23
	for <patches@lists.linux.dev>; Fri, 18 Jul 2025 19:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752867372; cv=none; b=sDUMJ+4jzPsQODrYvx/mVuX/QvY7pU4SVngoIfvTj/ZKKNmIbtTxlZMVeBaM5dIt88F/z/MJN43N3BCpW2Hal2f0smztRi+U91I4440KMX7MltJXcnKvC31eN2C4PbjuwzqSw1pJXu+w9yi8SENViHRlzV7xzvGYZaQNR2+2Cm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752867372; c=relaxed/simple;
	bh=zUocV2Iu/hooWg/xLrFDmecpoQnj7H08iDbfiOXKH1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lnj+RL/GQu3WrS1ZkV+mLEnCXjyJlj+ZRN+wTxv4Dz/OBDXTTnN5VTNAGeYmOZbV9XtdmN/OdVKwUY4c7x/K8Pw2TGjsnWYBWL6JqNy/QRjlrUG5OQiqjwJGoo+mfuryThCoSh7MRtktvMhnxhxG37P5QaTGcnLb6a3WlBJeiik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZE6NGp1q; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZE6NGp1q"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-748d982e92cso1821164b3a.1
        for <patches@lists.linux.dev>; Fri, 18 Jul 2025 12:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752867371; x=1753472171; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=i7dfdxOwUi7/Jyy7cCnG3+Gt1jR1w3Vp0HZDygyI/NY=;
        b=ZE6NGp1qLK39X6KKkafNoY5W3TGLHMBDH/qTzIvKUaph8DbTi/1WBM/MmXM97TktgY
         OEfNJT5cmGCyUIAYkDZqutXQmjr9sLCOhMkK5BJ/8pGGEgDVb0/bKAysczPpM7R9nRZg
         9FdGvhzSDZu8TyT/jym2zSLjmJAB1M8aONU35yNDS8jiXJHoOXBQTbBhpUm7xnE0vZ4h
         Rrzfu0ZImcuub32tzqaOXElNbSDGnKzd8MAN7qfXK8qeY7iMVuma5JOmpuI6Cj080vny
         e10bt+DAFimaI7/+/Dr11s8hxaAkRarXgj+OCDqbU+pEMj6p4PaZWjEoYemReL8T8nMc
         KvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752867371; x=1753472171;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7dfdxOwUi7/Jyy7cCnG3+Gt1jR1w3Vp0HZDygyI/NY=;
        b=aXIdoYXbMPNBelhOs6AORvJ7Vc/Qz1RF1uVXy5SOW3cEyw9R34QFNqZnMX6cYS8y7H
         yhFX73lrHD8eSlyfYLcwn9dYg2YG05Imt9ouFQm1JyhLlKs/jess3IjDqhjW6Max+zlf
         dYslvYLXH/ULU13eTmpwbAcJWdx80eUsPNt+6wYLXQ3M8JHnVKWaQ0TiUsAf+lrQyuKU
         WRL7MRylTU2wgPb7uAMSvR+r/npZhHq2yzAIOrco/wBOseYFwWjjwHTSUUo1YrYEJx0t
         gmCLPUEbU5vGrfpKrJZb1b0VSMmoAeg6QGXjvb9ZKULk2EWq3woWTfwqZWEUQ9ckSDuH
         UISg==
X-Gm-Message-State: AOJu0YxmMDmjCKqTErjvRKZ48f6LtVs49t9VXDb47Ea22XlPMUlOzDwH
	PvHiv6n+ZwzxIJBWdQN+qobz8lauUsmjf9coxHl4E/oIKrNlyG3f+xbc
X-Gm-Gg: ASbGnctOlbsHjC3JsaQwgTGWPPX4iFZLa8ChtKeZbVjZ7U5PpKg/lQjY336sj0nY/Q0
	wbz8DcK/el5OliW+4Sm71LNzmF6b4p7DCBUyDr/VEdtsfPZF33ThcdWWSsBVlK2//CI+xSUYcB2
	0c2ONOH5CHsrUYSdCns0y9d/Cljr60lyYO5xSgcD7JyjaOh9AZq2IpVy+0oCpz8cvvahMJzIQBg
	wEVcMszl1ZJMnq4C0Ym8tLm7ZtLzURwu95OcBtRMqXKnjTpg0K3bQHBEzMaMfiHlKXG9BGcNhJN
	if3vxjqxb+uRZGIRJVGHzN9q+uvmlVOY2oT5g2wJlMuJCmG5zzBbisVl8pnNk4ZzW5mNnAArHr7
	UyEZrFsDV0Qwpsq+JY//q3SnW31mkAZ5Igojnv8LB7SW2SuR/ABBqeNzdzMCyQw4YcTwasA4OO0
	ZtPjy80Q==
X-Google-Smtp-Source: AGHT+IEFt5JFRpw2SaWW0SAOjjSSqwKJkWZzGcnDb4+fRvxZJQVCkuPc0pKJg628BJ+N6RgSZb4I5w==
X-Received: by 2002:a05:6a21:4598:b0:232:63d7:2738 with SMTP id adf61e73a8af0-237d5f292efmr20202057637.9.1752867370655;
        Fri, 18 Jul 2025 12:36:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2fe62d9fsm1629328a12.1.2025.07.18.12.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 12:36:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9aae2c65-47e6-4fad-8b8e-d9cc89d69602@roeck-us.net>
Date: Fri, 18 Jul 2025 12:36:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/78] 5.15.189-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250715163547.992191430@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20250715163547.992191430@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 09:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.189 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:29 +0000.
> Anything received after that time might be too late.
> 

arm:allmodconfig builds have been failing since v5.15.186.


Building arm:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/meson/meson_vclk.c:399:17: error: this decimal constant is unsigned only in ISO C90 [-Werror]

and other similar errors. This is with gcc 12.4.0. To reduce testing noise
I'll stop testing this configuration for v5.15.y.

Guenter

