Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846D312832
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 06:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715499; cv=none; b=uU1t39NrrG2W/TyIbcZQ1UG+LuFEJo0cTGmg3iWyjOcbx4fnb8R21C6UV5PkXacz/ETUAYxp3/0YAIJQy18YFIfLv9KaWSNKyL/MtD5n0fROzmr9SA6XOwJ5rL2cGs4yYeQM5oFGD5uinaR6L2RmOGZfkMeo/rhlBxcV5hfPnHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715499; c=relaxed/simple;
	bh=kVXvFGe9L6u46qed+MFtgkH6neBNgmagQjD88dYdKiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWP5RZJc7axG/O1pdvgv8JKwI4AHuaPDYwftICbIF8NY/m4OmQynJmG76d34ZIQftca3scSouHIPsdbu1VMpUhUsSRhoqQYMRdQE9N7XYzF0840jk7yJerK4z/zxAApny1moAwEARFax4k9i4SXyFQjptMrkmSoBLFL5R+jEmSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZFHOUTcR; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZFHOUTcR"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso4350815e9.3
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 23:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775715497; x=1776320297; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yNQFCDdUTA5OqcEojWYL88oTkm2Z4y0PLy60U0CSlxI=;
        b=ZFHOUTcRJAeWrYxTrgr3gETycRCEs9OLmzFKykRGRbebWTEcpSUlmm3hVY/ssaTWO8
         uwMZXLSFtLIVO5tBudwsDW8QsoWCmQ90hX0cQTEd1uQErg0oAllR7n3Q2baHv1Kbz8Pp
         vmI4oZyjdr09XGQvORwMPsWdX4C2CKFXR/XBYysezx+K/BjwhTU79fHH+vqVPThQQhYS
         9/1ExFgaBlUfYWteioN0MDvojVysL3Oc7n2qeNIl232Sbx0ZnNNWRviIS5kS2rBcscT0
         nP3PA1EaMF9DCyPsxB+7HEucx2qR1c95mqB3Mq7Y2fr+qK602ulZmyAM9fHLQbtk/3Uy
         nsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715497; x=1776320297;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNQFCDdUTA5OqcEojWYL88oTkm2Z4y0PLy60U0CSlxI=;
        b=ABH/Y2VKIuDpQqIM5rAG7xeN2N2uDkzxbEwQVFzD0NUZli6nyghqKMX4hEbk90GafN
         izYMY0yv4ET7zJuOTUIy8xcXIoX1QzGW6OWiXnTvRqimSBDK0i1F9nfuQ+K4HMQgiZHD
         wunBiWBQan8jr4ZJrcjQIps1xn1gjobDBDFA11r4LUYHHJdwmL/5M2UPjtq2XlJb/y97
         x0Uu7AF1ti+gmyox0nF5G0/z+9vKPNPtXr8rrVyDA5UCwVKVZRGSZ1kTYtwRph4qxj13
         BJ3l5/pX54y6tYf2/tg4ldj3MIjIR2/oH9Euyr4XO06osfRNXf76a2F5I4Kw1Y4A7elD
         oiYw==
X-Forwarded-Encrypted: i=1; AJvYcCUQ6vAfYsF9vQ8qgkxva4c/9Bsq93xIh6UBTdIGJzSQXYjKjwjeMI12FCRJ0x6SpS4ieMsUggd1@lists.linux.dev
X-Gm-Message-State: AOJu0YyrDEnN3TA3nPZZYwfCxClInAz45o6enWOXEO1oEFFiA1mvVjCP
	TBuqUDCZnRKWNjklnsK61BZxw14ic2y3Puv/uGm5mm8vl3Op1nBcOveRXC0VZYOyAhg=
X-Gm-Gg: AeBDieuxjsSd8Yin1PQ15IEGXhHlHmyLp73M9KwxsIeDQUJieL+hOrswvE+GQ+udNAw
	CRljcEM+56zpSDkLQCzQZYFJPHEFRaHJN5Y3RMOYgN7E4yE0K3BkfW7Yhav9CcNx5zFrfTNOXMg
	JAvtbtUhm5zPK6gJ0oiI895q8qvEUPrxYCC3N2hb5SiJZAIk7lpRKca7aA2brSrAAdOPDYbGqP7
	z4TmxBF/4lzDwbIrOtPiq5IOCR7c2TNNRBUIouCcCFtKdGD9losuCnzw2xOqJKIGYjacYs/VFv4
	uURrl+jmgHk76InNCwdxPbXa5fp+fkynbe0V/Jozmghidtmp3fVd6fxbwLTS3xE/tSf7i3Q0C0G
	+YiR1nz1Y5i/3lyJQIyJSBm7xjcAHvRBCaaY4sOhNPhlmgbVL5BqX3h/1fMJTD9NgorRC5ZeMxa
	Qo9ZbE+rTbhepZJTe2G3TSmZNO5aNbNG9281PntbXCzjoSZSCmRnVmHC3tgLE=
X-Received: by 2002:a05:600c:a303:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-488ccf3a65bmr23726995e9.4.1775715496799;
        Wed, 08 Apr 2026 23:18:16 -0700 (PDT)
Received: from u94a (114-140-130-35.adsl.fetnet.net. [114.140.130.35])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-953fba6da8bsm17516433241.10.2026.04.08.23.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 23:18:15 -0700 (PDT)
Date: Thu, 9 Apr 2026 14:17:58 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
Message-ID: <dozxr24wmpnj4k72ojbvtnhdgi4ekkgkfjdf6xaj7eoupboyg4@vnefmfsdk35m>
References: <20260408175913.177092714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>

On Wed, Apr 08, 2026 at 08:01:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24153838933/job/70487760092

[...]
