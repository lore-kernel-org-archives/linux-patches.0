Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6789455887
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 01:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736214007; cv=none; b=Wp/qkXc+x0XU1w2w1rdf6Rxgwmk0HkHe7l4Jfi0v8bF50Xr3oetA3ccB+j0OmgJzMgYj08NBbqQ8nEjIjBUsq748a9nCHgxXYpNGcEOhVTHzPB2FBSv8Z21gKugyKtjxtE/LkNgRDQo2DOD2Ii44mXVWBSFE7LTZOKDm86fwf7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736214007; c=relaxed/simple;
	bh=OF+J7g0eFvi55KwHOIgcuXCNICVmb1rqH16nwsgqHRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xmx4pvLEkU40j+kYkQqfH6bidzpSw5seFMiS9NO62ZHfFLgPSgNrv/Xp6puA3bQxJi1PKrMookbtoq7b9782fypWdRyRlFqPkcqscz1PMkjxNgh2kQUEqyMiQt0+VU/+OnnScL8mlYuqrEomJ8vLY8B+JCal8CmQUADVulWl/Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jWbqwYQE; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jWbqwYQE"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso3118926366b.1
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 17:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1736214003; x=1736818803; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/9YvSvr9lvlL1SrVAn2MD16XQSwHxJWkO99vjoXy7W4=;
        b=jWbqwYQEP3qtROq3Tj6FlCWMuhUcBx2kkWos7HtBuJNpeKjcA8eN95K8d6xDj5xBQP
         BFnXRQvnn11HjGI5wPb8lUhrdhXxi7mGoZSdF/fw1WMW4GRjE6euhrVhorEPYk6u+MMC
         rTRg21Gvaa0k/GNvBlBHorNJvBDhyoEiYuCnbIOw0HEYeapiQt6nXm5xI/Ev3pagKeUk
         Km/YHVdoojs90J8bmZps7U7hCtB2koNctbrvD9jgb/zDz2rc4azLPXhtmJ0+hozO+JoA
         ie5Xu38q+CeqLHvyu/xi0TMvSklSbRf8bMMqQ//T8quIGjDDTP+bQWzIG1KY7wmfQxGd
         /EZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736214003; x=1736818803;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9YvSvr9lvlL1SrVAn2MD16XQSwHxJWkO99vjoXy7W4=;
        b=S9X6BOe++8MNQe1o3KJp0sw/cD560c9CHL4du+4kmmRjilH3I5qwPmmxpZQfXrFbqk
         D6gk/aANf/60pxgxETvxmbik8KEUb4O7RuxLwJpnwAY04Pl3TKQav4qQ45LOvWC+14OD
         CY4EOEnDopoi4iTm/KIsRJoqM9upjElg8nGqRP4fi45cRdTmklailP3ZYvdQ+RLlBC/7
         SrTM6AL1iv5+Ys+oRWHxaoDmO6Q0XP2aLTXvx4XYWKZcH/Vxw6xU6YrXym0HQonwCfBm
         n/HRFUTNuzzq55dZuWsJGur3GgJtLoWrSUz1ZnoGx7tOk1l4zDFiej7B1KBQg5EIC+l7
         figA==
X-Gm-Message-State: AOJu0YyTXsrB2XLXd2v+i5iARSWYmxDhyLbje6KFJnlzYW2CD8VplsjP
	VS6dwucdUQ0PATdwxKITb2xgAMaZOmi+2AwkDJUIGQGHLKl6qGKqRwvhghQ=
X-Gm-Gg: ASbGncuvOZFUXnt6jeDvNrmBslSkv8xRXyg45YAGCCN8ge7J0v7EKl9lSk/LEuFNWPa
	yVFPOGmTyrRkgKiPfPl9gx1yfHRlfCmJ9dvmzsP82yAUthhFYhm8Pe3k7eNcrJalm8vwW5DbvbP
	T0SPJ9jjR/XPbaohQBTg+K2SSS6mM+GE+p7EPW/vsSLr8De/iMtp8nRI8vs7jDbn1xFCZ0yGzSD
	6n102bEWCSWWE2Np0XRtfvNs1gZ4NuqwrhSZ9vZloFdHZMgiwYdkjev0R+ItGC46xN9IjF+7DjO
	NrJijbFi1ZuHsuQqmMhbCK2YB2dgi9fX
X-Google-Smtp-Source: AGHT+IFbafhfUykgIwrlGa0j1wLPfIKEiPAMneKWEdjawIrQPwGm191CuoAuWlTu+ZSrL5VsJzb0PQ==
X-Received: by 2002:a17:907:2cc2:b0:aa6:a501:9b3b with SMTP id a640c23a62f3a-aac2b28ee13mr4447377266b.19.1736214002473;
        Mon, 06 Jan 2025 17:40:02 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4110.dip0.t-ipconnect.de. [91.43.65.16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e89598csm2305748466b.56.2025.01.06.17.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 17:40:00 -0800 (PST)
Message-ID: <25e03704-e05c-46c8-be75-de4b784e4d31@googlemail.com>
Date: Tue, 7 Jan 2025 02:39:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151141.738050441@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.01.2025 um 16:14 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
