Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3858B388368
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 08:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526169; cv=none; b=k9dqe7kQsm3xquaXN6k1GQdK0TiJgJUhPN0yAwimkW7iMPaEOjW55c1upHQlJfh6XWPXg7XYwAZ3gSZEzrHp+LZ5y8ZdP0PSPTO5TUMo4AYN13IYB4FZZrwnjRc00az8X0Om9CvmujmcdaMqxs/E4SIa5KCBqXd7a3qxBJ9be/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526169; c=relaxed/simple;
	bh=2pzfiEvembVWOd2rmjbpprYL5xAVtPtFsQbmAaS8XgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKV4OEAim/MkBe/fA78FHlVVtFxoOjJb8gF8X92Vs2GGUsh6lZcNi+0Yc5D1f/2Cv9YsJ7ErypxiQWV4sHWjjbL1mlOyyT6oy04FKIWLDYx4Dwngjh0o2DHEPMnUaoK8OMpdn+OvBj4EiH9NgGiMRW5HdjP7SIueFKGsZWXuhAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BLqT49br; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BLqT49br"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4837584120eso38351765e9.1
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 00:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772526164; x=1773130964; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mvi0nR4T/PJtTXiEjnIGfh777g0CKHWsBdC1JuohcwI=;
        b=BLqT49brWUGTDHUbAlTaBfGv15m9tYvwOKRyl3guIDzEtE7M9ghypjauqTuiz1D2vp
         8qQjIXExGVocGcIDwN22eWGNbk4E5dVJug8adQTdT1wFKzLtj9lxdw7YPQxLr8mQ4xVb
         UfIrgxMb7OAVRr6Jm1kQVSXdUOs/YGn/IoOkZYIL5GPJvT3cOfA7d/yfAKOyWo2SIUzB
         h/d8jXcjvD3Q1gYQUq6My/XM99qqv+2Xwoj3cDyyz+AdU7KWLRifn2hth5yUR9G9OBgP
         fBEV6ltIc2YkqTI8/+Qs/Pqhz+oxtbiSv2qgttJVwG8Iy6C8hD74YVsvuw5adROgx9BW
         bzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526164; x=1773130964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mvi0nR4T/PJtTXiEjnIGfh777g0CKHWsBdC1JuohcwI=;
        b=vliQ9H0oiXZPCVfoXi8CjKDluXFgDNpORc/otT45OVrcG8NtKul/0MXmqMxFScGZXr
         ID8RfypgLs8s6/JK5t4DEe5ivNKuibvX5+2/mHMgq1yBtnbmbF+IoRmI/Z9fL/QwCC7k
         DeAtxOQTEPRY6MoY8tLk9Yob278n6cJQyYCtEIsHGQ8WoeSLfFLoUADlN+P4l53nHW3b
         aWNZ3b6kFaVUCcdvFHJ1hwJjrJoP+Kiag6IGhm/RugKhWGEuYlpTmiqlkiJKcSEf4o0v
         rYRbn4nONFXkogLzwNeJ/PYwkBcC4i0PPXIwEbp+/xqldXMRx0+5AY4yYO3ffFxApVpv
         zbtw==
X-Forwarded-Encrypted: i=1; AJvYcCXsu+Kqy9PyAU8Lk/uhxDjti0vObWLBVfaVYeETguvIRvqB3YfGozX33lKvWnFkM+tINWxnLUBM@lists.linux.dev
X-Gm-Message-State: AOJu0YwaP8MsPH7LDLtTu8+sIkzwUMvWeH0vfLQaak6KJ7vq+4VKuFcT
	hpU5Dtj0C/xa0B7iF51r0IaeyzMNM6+bHV85Wyw6O/cFd7XkW3vHtthKDbj2SAvg9n0=
X-Gm-Gg: ATEYQzxJd1ymMb8RjuCApOqHjLWdHs2JcX6oAYgVKwxTelqwOSttrQCzs0k1AMQ22/s
	/4u5Qf1D6tHgBDlx6WzHa7f5t80P9Cmi3wFtQolyMy+5nz/12YDtL0hbsPGRb3+EqJlZzbTfyUm
	yRPKbmMPs/6/yGvtJgrQmxAu44pSwsI0JkxNLr2wpU5Lz/8y35Neg9FKGzIWu22iM0I8pqHMVvK
	KVNcCrd6HMwjMl9p2LGlBQb56cIQot8fRr0JTCeeS+lXTMyufj5gNwfWaMrDp0UAQ8N1IZyaipK
	cBOhc6GYZEEfF0Gh8AmDqFskn96AMuSIVm+xfRKs+kQfk5KAhvuWE31pRGS6S7u0EruIM36433B
	pRlTaNi8MBoUrGkmhxmd6DhOlL/2oWt1vWqSMq/tGr8pK4KPU4HJRisszYUvqBuktftPTYbjfaf
	x1jIL1pxy9x9owqCDBeCY=
X-Received: by 2002:a05:600c:a085:b0:483:badb:618f with SMTP id 5b1f17b1804b1-483c9bc5b7dmr254857295e9.25.1772526164364;
        Tue, 03 Mar 2026 00:22:44 -0800 (PST)
Received: from u94a ([2401:e180:88b0:32b4:4c71:af95:b813:9623])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa6203a6sm13792189a12.8.2026.03.03.00.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:22:43 -0800 (PST)
Date: Tue, 3 Mar 2026 16:22:36 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Message-ID: <h2yeyybqfi35jnjft3d4urdh3e3z7ua4nrvgniqnsmajxg3ofz@bpzx7f5dih3l>
References: <20260302160934.2521545-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:09:34AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:32 PM UTC 2026.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/22590800040/job/65447954942

[...]
