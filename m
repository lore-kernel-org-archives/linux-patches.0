Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D0920B1F5
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756910251; cv=none; b=dr6vb+cj3aSxR8MFVAcoVbau0TfdNIuLmEFtwx3fcfeEOgajhtMJgHu3UfYsEq7GROMqAkz1oqvkF3lCARhx5I5S2fYpnPtHGMTbWNme2VUjA2pvDIccXVlNajEbRN3O7u//tehvtBlukMlhsX36z3BtPrhOBsOzyZlh6JWZqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756910251; c=relaxed/simple;
	bh=Aq4SHoJGJIP8AYS0ZnZjQsp63YrAalqNoxFoARZaKqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lkuOHvCeqDl2uHdK3ipSVcvHBBxUvmAyB6UfXVVDG9aJVu3Wg+mQV9qDso+TOisloo3kNgPxyXIFBUUap6/trWCsMAl0Kn0IdOT43RCz3YfV6wZwLqlL+kLJlrws00a7TrD5RtHKjxh7sB3+7bRLO4EigNIFzCCgTpoEBFU10no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=EjfqmRrx; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="EjfqmRrx"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3dae49b1293so3589f8f.1
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 07:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756910249; x=1757515049; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M3zaWeppSnK/pHW8BPkcRdM3L21v1uIAD/evE300Qt4=;
        b=EjfqmRrx8mQUkcPdbv3pAEhyenC/r3+S0fM/NHpV3suJXrQx8p23rRikNFGiK8RD2p
         IqfoTzdGfVjC9qZnsIxb6SqJOXbpqjESywIFwL9efZyytVmTU8eDzp9M2JPOnC13zRef
         LB5zytEkZ1WutGOvYCL/pK4ZF5e/RIJgp46VgAQRkUlfgf2QCkSXYTz/JVD2uCoqm+uP
         l54wnE6ApN0xt4JMOA66GyLamOEz89VklARTTvHjzzkttetyTepCaNkuPJ5yMP5CflVc
         3jD2O49LpVB60iwfni3cBTUfksTLsQvwkd8mdZMO3Su3tUia1BOHLB0TgdUIWbhjARxM
         EZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756910249; x=1757515049;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3zaWeppSnK/pHW8BPkcRdM3L21v1uIAD/evE300Qt4=;
        b=bKHmo1BG8rOo6AlI4ZYZeMPVaEvuUHdl/AXJKSXKM96ZaF/PJIRXtvcI8GgbUDM41N
         3heryrhSFbnEjrBfP6waUvcwACsVuKUXO7r7NVnOHkPeILRAw3zj7NyhehN0Wk53hTug
         Cs828Co7NcSiA1O56jWuVkWCkMe2ARFEnr7rOK65BkvCrRHS+eyMM0fJvD1g8ENssxot
         pR4XAJe7gMZ2Kwa+WsL0Hfp620NQgiBjpxNqmPM2ADa8KOs0Sr0HiRS3zvX3A5xYivvb
         9gcIIQEP2811Y+ssw0qlyf0+bQ6a6MWKL1Q8EUT+3AjPwm/Hn6OKDVMJzsRa3R6V2w8v
         Bk1g==
X-Gm-Message-State: AOJu0YxMtdoQcP6IjPBQhuRDE9FH9aKobpwXh9IH9dETqLByqansqREQ
	6beJ9HdK8ELk/PkXPxF1hEFpp96OBFJ6bmcj2W/i4/63OMPu2MVwjqA=
X-Gm-Gg: ASbGncsjlJyIxQJzzQeMDu3jZtuDmL0gBQkgs2jXe2flTK4WKhpLPvDFAAskeVGUWZg
	/29hP17XyMEzfkAx3Qaw5zjlDgzpVJAlg/N4XUH2LpVd/oIzjQPBiq9O5HTpaF7I/+A6fMQ4qQ/
	futrz+AARiWYb403z3+uTsqG5ZWj6yrs7BoOKituqIyzZYQaore0v5VUI8XMRY2c0awfpTnBGuq
	yR8t+pF0qgrwRg97/6jJReHIQzld3mQSbgL2VSa85MB3WZxCGlNG2WlkUqQ3qTDGTaiWIRVaSBh
	OSn2f98kENeL+09noV/5wv/RvUhH4FmjKq2yFHjY+4TbevVoMugNsqKtNZL6jvRE8gIaSgQ92Ib
	ar2UrKtByLS+AuwAktPA92zcUs1RpeEJWSkWeVI9sgppfOITyBneKFVksx2Q6uZNQ43nPNFmA5Q
	==
X-Google-Smtp-Source: AGHT+IG7hE9bsPPkY8ZAxJMMDGP6woK6Gl560RIJ7jfmU8rmZwkXeHrmtsXRvMw2WB9rBjTmU/0piw==
X-Received: by 2002:a05:6000:2c06:b0:3d6:b35b:1539 with SMTP id ffacd0b85a97d-3d6b35b2241mr7954168f8f.6.1756910248434;
        Wed, 03 Sep 2025 07:37:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f3e.dip0.t-ipconnect.de. [91.43.79.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b8525a94bsm197021425e9.15.2025.09.03.07.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 07:37:28 -0700 (PDT)
Message-ID: <c861af96-9d44-49cb-9cee-741f133de504@googlemail.com>
Date: Wed, 3 Sep 2025 16:37:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250902131948.154194162@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.09.2025 um 15:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
