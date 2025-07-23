Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2831208994
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 04:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753246678; cv=none; b=rIoPfWN8EbWhPtfag7Jr/O0bt5wquhtzpcqiSZbTeIL3qpYQiVXkal0sTNonMT8f1sZ4CBjv10frxWSdiOfjr09ZK/XhFBTwAhctpTlpiJHKc+1oE1JfAtrntx4oB0kIkoArKFlIoahRrAreCczipSCYj893ODaR20W9amT3CeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753246678; c=relaxed/simple;
	bh=d2mxgsFxyvMH3F3I+a1W2pCTRdrC2KIPCY3jn2A59s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7BlpUrARXmqdAPZFT1QadsycFi3rymHahkxZARCTjjDvYrSABQshn0FwQYezcaWz6EeNxeU7KuqUmk+z5U6+avNKa6C/K6by4OCp0Nbvc17rdbS+roX9UnkUhDj4gBxW9UVTLwm9AUTWr7WAytjeSZwnPfINxZDu8KPXa6TmUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=I+FOhlAE; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="I+FOhlAE"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4563cfac19cso53373915e9.2
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 21:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753246675; x=1753851475; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NepAH6k+tY4m1L6v0rtz6kWuAIA7DEfti3zsdAQIUXE=;
        b=I+FOhlAEkkPoqO5vZizugydF5V/kfSvbgH2BV/BF4GIgSo0mh7KRiw1ZtPTCgn9Cp3
         +l4koLzKtfAbRk00+Od/w7pAzRutWYM0fn/EUCpvpLZEvM/Ty0hh8zzrXze7PsmT+GuO
         8ZTl+QBrLm10PHPkIM2eewnvcmBhIbfmYEJiLucbdBV60Je1L7c+BtMrfzILGVxijCu4
         55TscRwLmsG8OJ2iuybz6pZvoTQMJyYv/c0XgxwJ+x1BIqf1f2aMXwMbfpj/AOwUSFEG
         rtMIoxth6UuG2YEVfVWAKg1PejRDT9rH+xAy5E5IwiU8ndDqvN7ENf1+x0Iyn2bPeJev
         NliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753246675; x=1753851475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NepAH6k+tY4m1L6v0rtz6kWuAIA7DEfti3zsdAQIUXE=;
        b=u23h2s9M12uIRUEAvkyBK7o2QZJvy3WZeCTOp0pCEG9lm07QVoaQ3SfnKF+WutWTYA
         Ug11vdgh5JY3X4W8nQdQxRHZMc72L8aJkTTebD/z2D4NnTiUzhC52RCOXCM1tN102T2N
         Si/Db4QT4OO9J14jiveFy3AYO/gzu/OYhciWBRWPpQDZ2SdSoKDQKjFVwf82sgM7vKKF
         vTaQMJdoju7DonF/MHGQBrXtH2+9tx4KkPtlbBc2GRG0Sbakg5RQRO5IZbkMOGLEjqWZ
         xpJKZcD6Rl3w4E7Dx5JGdZiq2rnUpWQmcbtVXOl5IG8cUExTGQWJbDLIdGkTs8GntyJk
         sHqg==
X-Gm-Message-State: AOJu0Yz5NdKeKAyDwv6ACwoHRkhprk1l3bYTP4rYthTbzJzTLCOSRxUy
	DYgs0sB3T1RMkulUkdJUhqXgWZ4FvJc816e+M1BuRF2/7l6jXAMW+fM=
X-Gm-Gg: ASbGnctAVcnWVIjLo+ytRsg+2oGGR6rCs+Uc1AAuTjjARgt7E1rTVaqPdWur89xJQZ/
	NUId1urHmlm9Ll0ElSGI+rF1L4NPq7gBjBVoYuDSPsoUjzyHuRhI7QW71wpyuGr1H+m+cewCBbT
	htobduTrxzMDbyBqBjYZU/6dVtiTI9O/sXFVGhTUekfAuFgFkuf09k90ewod3ScoZv3vHLCAtyV
	dUHBpY12hGqUOnLfrB7rZa3UP2fRaJzPgwgg8HQ8fcVkABeXDUpc/NDZX3YdGppEUdUg2Syu7TF
	T2fv3Oy4hnaXCpsWc7p1lf9zIjbdrm6qDeFVSQ7o5VEJNEqRfUhcKTgyaGh/lcz0UalZbZkpZea
	2Xhj5diLRw7SmkSgdqfIlRhdGprZ7qMu9oz7Dfldb4B7TgR1EM68TrDihYZNv517A/ML2nbozOu
	sH
X-Google-Smtp-Source: AGHT+IEyCVYFeTrjAkZbl5GbRRmSRJvoRd2ribReC5DlPosAv3MiatO5YKWwNATHBBKo9G6oh6sj4Q==
X-Received: by 2002:a05:600c:540e:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-4586af28accmr2697525e9.4.1753246674840;
        Tue, 22 Jul 2025 21:57:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac7d3.dip0.t-ipconnect.de. [91.42.199.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45869198e23sm10119485e9.11.2025.07.22.21.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 21:57:54 -0700 (PDT)
Message-ID: <5b1b8297-7251-4e7d-84e7-e6102c712699@googlemail.com>
Date: Wed, 23 Jul 2025 06:57:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134328.384139905@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2025 um 15:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.147 release.
> There are 79 patches in this series, all will be posted as a response
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
