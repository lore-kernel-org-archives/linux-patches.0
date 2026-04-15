Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22F1330330
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 03:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776224987; cv=none; b=tIxapuU4uUfHkrCj8gudMzr2bHwPB3UsDcsuV95f1gtvFnjNNyYknkLnOKVPpALr7SbZyNfdWnd+RubXocM3d+YKSgbukta2CPN4OniKy+7TWpwt/Gnzu53WTvKsH0BfFZ1r0QgY46wCYE5PpSQym0+F/sknft+MTTLHNA28NRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776224987; c=relaxed/simple;
	bh=ZijUqXMpRQ33RknbmDmD059T52xA36aGwzSZGewDrxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gcl0O1JSOifMhtOxqwWQc44XpJqVqrFVu84NCROOW6kfmlJWdl4zSOAogI/RnE+TVwpIdbD/rsBpW3XzmZI6vFsPIE4i4ONK7WMpZT5iN+0X6wBE88Lg2pBsmGPgNPsRYFwKKzx+O9lsnmy/fOiP/b9kdINXXnVsLW9xlcB3OUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gu5ENiAi; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gu5ENiAi"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-482f454be5bso65927435e9.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 20:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776224977; x=1776829777; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGOvI5OHYbBtjjKEbHS0QOhfaoIWVWTKqWQFyvcz2QI=;
        b=Gu5ENiAi0n9rbKXF5qo16tzhyABWRCWZRkyNHEBXC3Rj6Qr5EJlBzMPk3Al0oPzamZ
         q7lmyIbSrM8nbQaR2P/7R8Oc2Pj0IngTUh928Ahwe9HtceydI/wB9/KJ2eeVkHOq0vBq
         vun2hFJ7wTwm2p8rjC+x+ScBKynz/7LxEKty67sdcNvrkYSHvDjeGBSEgZVNv5K5WRz7
         +8I+U/7FyjDmHjriGYjhdVjfUslcg0hsyPD5xogfuIgsrYzAxyW18i9hn/JkKY6RYxWk
         F7Q82UWON3AGW+SMXJI1X1AFzhtNpYOOAX705EFg3txZWGQwU/IDeSKndanlHC0jHff8
         jbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776224977; x=1776829777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGOvI5OHYbBtjjKEbHS0QOhfaoIWVWTKqWQFyvcz2QI=;
        b=HwLYE/ap1DPCx9ytdHVCBqD3mKJJvxTMvsEiKoaBXBoZ0kUdSIOjbsiOuOgNblWVVp
         3LuPwiKfFJXd3DfiHFS2dSG3s1j/1WKndG4dBohaRMwJXp4CnV25+12J2SQyuLfp0AR+
         vTcIdvChSiqAktsyIX1+wp6c5QfuRvRWr0LujWMqIyuixmbKyT39yXUPaH1mtXZs4f2o
         HpTzqUZCZQCOwJasjOAzNrJkJhBPU9EiLd2lfASBX5oPXzfjqW6blw/o5RXowRdlFuNv
         ZOu4vKQh+4ltPAT9sSyOVwKJXZhIgxGbUKcVgPx59R17bySfWEkJGn+E32w3jnBZaeXI
         mkqg==
X-Forwarded-Encrypted: i=1; AFNElJ/PnYl+FO8yoRKlaiJ+EzLRctvCx9p+7R/el1nXlWlLHaxpl5ZVFPIiK/+ShWohtAGp+oJA1x+K@lists.linux.dev
X-Gm-Message-State: AOJu0YzRETWv0/KiFabyEhBRSbEEbRRaSaDVBvnkT8lUzmI/zhCtlHJQ
	v3K0WX71LfckBaYcBsa0UkW9m0PFOJHbjSQYFxaIj7LZb6VLCUa3CcvBxPv0MjRKpQE=
X-Gm-Gg: AeBDieur4TUJidFibfH5LQF4UfN4EnEQ91OUZN3B366cGYeewi2kj6WMrMDUl92cRoJ
	kg1Pmypdj4X7AkVkpOCVpqzceJcZVtEYNbxymdwmCdSnDBaCzKhHS7E7EaBMEBKMJmLzACiAacD
	jKXqJuDqaZwdhsFQ6AdXuCqe6tdFGViqC/g8mIwCg44IjkcXkS0ojlKQTt4pETmYYgFA2AZSeyr
	tMDdq79OZ2l/gpvHXKMAkTZwF7Skp2av0PEJUg3gJq5pMlo0Z9KFyVVKyZNWNMCrL2/l/Vt+bd2
	xTclGnqTKSd8F+nUrA5XsJcDqFTT666SsWrVC9WrLYV8jEcBDLcSRcqh7wrbgTccvj6WRRoKjGf
	E6YFttvh6JizxyjsKLvXdkP0ut6hoC80BEdlkWlItWHYld+atelvE9xLNy4oc7q3X71HJiy4Qf5
	IeeBCwxUCZ2xNow1CKai0iWkZ4Cj5EYll1Thw8MUHmzADjIa5uMXI=
X-Received: by 2002:a05:600c:49a1:b0:488:a502:8955 with SMTP id 5b1f17b1804b1-488cd4f4a9bmr228282245e9.4.1776224977392;
        Tue, 14 Apr 2026 20:49:37 -0700 (PDT)
Received: from u94a (27-51-0-223.adsl.fetnet.net. [27.51.0.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2de8eb8443csm926559eec.14.2026.04.14.20.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 20:49:36 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:49:28 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
Message-ID: <g4kr2vhnsgtnnurn7cjwqe2louy4joys5pv6fmvqbdbj7illtv@u7ze2ovcaplc>
References: <20260413155724.497323914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>

On Mon, Apr 13, 2026 at 06:00:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24418242274/job/71333106580

[...]
