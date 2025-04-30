Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D9913957E
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 02:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745981885; cv=none; b=oEQe/oQoi4A7HUgmbA+G/1E/fv2KOlseZi+JyEqJ8SeCAurvaXzjamkddzX2s0MMexmXPJQbcblngGfMgGRcxalYB0JchH+enESvxJeQC95PQ/7lxqtPTYFK3im6TkY4orbrHR1P4mcU7g50tPyha7wxyKg3VLG84hwv33tHmk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745981885; c=relaxed/simple;
	bh=vSVqtBuB+jDZR9oAppVW3n9jSJJUZ7Ihd2hGUqwZ6Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuFrpAwlFx9cU74k75XcYlqvuUIyVq/HPYZ7VIMzD1ou7mRJN5YJrQKyKvwrf9DPT54UKQ3SRC8BqznlckhPmXq9IakcouyfCOThtj/YZUrH7NN3xwRv5vTt5mrcm4VxmqpCfaPH/wSq1Y/JmA1h+xa2BPWvVOS+qDewW6qenjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WskegakH; arc=none smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WskegakH"
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-ac2c663a3daso1342423666b.2
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 19:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745981881; x=1746586681; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=orERZRi+X77AnHhL2gqMTjYmeyPepMy3FKT+ifyIpL4=;
        b=WskegakHNRo0f3KN+Xu3qOeywW5Yhm6KUWInbZ0P43SJkyOLUcx7Opj6MsPhJEnTfg
         bzqFlKKjTseIKbKACjbtC9dbGy4gnP0Nkolcz04DIyc4PN4PX6VRDHwau55Mwy/wnfME
         VSF0HbfhaMK6dIQ7BWyOd6JN76IspRhXvpjop6v5op1wK99ZTWWK547sRM1Kp/lcVNyu
         yDA9GAYk9+1dsCNnGDUcH+nuAQzLTaWtraz39wPDoDpzHpEW4JJb+p0cnVV/xuYViKH8
         KRwP9Flyd7POz8zfEW128DRZc8Lry7/qbUS2rgMhi8eODYIjFiUcY0m9peAczFD+zwfn
         bS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745981881; x=1746586681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=orERZRi+X77AnHhL2gqMTjYmeyPepMy3FKT+ifyIpL4=;
        b=dyHKM1VEuDVmNOuwa2EtEUQD3SVzAgDUZg9CsTRc1uzsX3KPDL74pesItT7QNBMpyX
         huTgY4HJFrylK7FHxg/tOQNy/f3I5jpC9OT7LzPLBP+6e+4j/yMOlZIRi/6Yk3+nn44x
         ihv8/MayjRj58Cn7Kc85lWlJ0nEUiOXLYne8KstoVCgDxCCkZlowARnJUf5brWGh2qB6
         B/hrsGPy019za24QRKgxvjL8PAsUx47UCd480sk+NnqsBejPo2AWzbB7AkBGYvBdFby6
         yAlclB7OALAu1/pbXBMfkR6DmbJdmBA3YhMp9EKPmvTjBXM7XMHFaZ/gq3aPyiPNY+Gx
         52YA==
X-Forwarded-Encrypted: i=1; AJvYcCXHvU7UnJ0qBJIZxRu8XZbc1hz/eocfkyxLlj43ZSvTyJ3B1fGQZho4QB4QMRFFsfK0dpCIZRuS@lists.linux.dev
X-Gm-Message-State: AOJu0YzkGbxhCXawTrT605Q1WSsMIHCS9MLFjv4XG5wsR+0efz/fRRiK
	BV2Du8xK+Uc4HHsv3Wbh5kXD8hHEZnw49Pydt9bIee/X4Mj/X7b+IvgXQRQKrLw=
X-Gm-Gg: ASbGncs/wmcQeoMQgkcKsBe2UDswTHce3Zu0XaNupTl9IHtg8nLbsoMZNkPZINkZA6N
	SKJ+2s+IEv6EErz+/SyI4Q84lWZcp4DLAM+fFgXDdC6ABbEQFs9sPqTOVwgraF6+uR1YsuAquAY
	8ReiGRJYuRMCwTpFj4iApJYwpQLmHsAIuA9ReY3pl0XYVvkpa6le21ZWcH6GJEgLH/ckCj3ei/Z
	Kl58FmxcobqkkUTk56VMjSGeq1Dsnb8NACy4i3uQEDwUen4R4Qu8VyScNIW6mkFZBT1UT7kotmU
	gs9sw3TU3acHO8zmNaG+vJD4nW6UUjVU+Z5fcogoLkDH/7PpE598JOBPkLDk51AHvAEfcZWCqR/
	E
X-Google-Smtp-Source: AGHT+IEWjFrMLBqOV/1rb7M+m2k06D+kpRwrzKt1j1RkJYk/ipaKYAiZsHrqN38WPJ7aRNgfa7eHCg==
X-Received: by 2002:a17:907:6d15:b0:acb:4cd7:2963 with SMTP id a640c23a62f3a-acee241c417mr87778166b.33.1745981880926;
        Tue, 29 Apr 2025 19:58:00 -0700 (PDT)
Received: from u94a (27-240-163-208.adsl.fetnet.net. [27.240.163.208])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acec2e5ad9fsm246073666b.23.2025.04.29.19.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 19:58:00 -0700 (PDT)
Date: Wed, 30 Apr 2025 10:57:48 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
Message-ID: <4vosggktdpxcddwlbopxxfzs5nscgllrqrhyxfibzd74wur65c@qo26jck7ok3q>
References: <20250429161121.011111832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>

On Tue, Apr 29, 2025 at 06:37:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes (with 82303a059aab
cherry-picked from bpf tree to deal with sockmap_ktls failure, it will
be sent to stable once it made its way to Linus' tree).

Link: https://github.com/shunghsiyu/libbpf/actions/runs/14738691393/job/41371100920
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

...
