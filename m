Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE39353ED2
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 04:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770783988; cv=none; b=KUMUf67q0c7+6Osrbp4DMQZiDcQmZqkqxKfhtDr4FbQnI4+XD1KF1+wRgnjsiolRZcnRcntqqsl97O4S7LlH3VOKo9eTqAdD3v+cvjNWwNnhjZbS4CZ2idTfpyPUyljhW5eeGg4sS4dqgzpNx4c7qqLrU2igdRQeURmqPBdN7CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770783988; c=relaxed/simple;
	bh=aUATCmUK+ImgQyyZDRNe3IkksmdtwUU4keHLmfDrwOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udpSYElAkF7aj6Ry6kdMQdqHOneebYFUpQxZzDlQagofONN2sJV4bIXfbHeRNTNPcEnzU1NIUNr5iES4zbwT+3vDt8Bw9YFcGZkGpWuVHineKL70WYBfk6tjZjQi+lbP77iOnS9T7k+2GzEuWM9CSsojygk9arUKf5ggS5VpuIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L1fdsDQK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L1fdsDQK"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-436234ef0f0so3682123f8f.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 20:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770783985; x=1771388785; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M27ieyh6BJjIYTvtp5y/r9tffMjQn+yYc+9hsKGR2Vo=;
        b=L1fdsDQKejNpEcrCz94Fi18mXU6ppqBb+SdVsIyly8vyCVrvMbc288NEUuouV0h3oq
         vLK/AuLvR8op31u2MB7dPNlTJMCa6QNq+YZIZulKE+trWVydj6uDVYcPfuhTJU3YX5pO
         NDZ6QMsKKM7ylOlNfK/hi8psg39zLRBvtRMR7tThJBfGsZeDcc74t0cjQS5A4c9beGzD
         P90/6hcyFOEff4AfeRsFmFu/RuPsKNpBEgvnaF1Hr4zfcKVjR34KmvOgjPzyliiehZOu
         5fXrCzJR1jIBCY1HJvEGecjHOh5044obHGRyLlJNCZQFMiXL44iWm0U6RT02BQt/0C62
         bGuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770783985; x=1771388785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M27ieyh6BJjIYTvtp5y/r9tffMjQn+yYc+9hsKGR2Vo=;
        b=SKVM+UbaYZOb9oX+UxDxGH4Wd+vSXjryl2KDQQlF8vD2eo57CdaurvVMY7zBLgtPDq
         wtonGFP+TQM3u0Jt1aBYRQkeO10mLtQmNmWSqkT7k4kn4qr+kwoD8ifjY5lUK+28rHHi
         yAG9Ws5t7htYp9sVT7p+K83bGbM763OL6Ym78l8yC+VktP9zZrXiWCicaCzh+6HZVGbv
         TuhO11DH25ML4KuK00vDJECqfwt1BuTfrFHjNh9awXZmTaGHWW5wdUdEbJwcMPoPN/zf
         SgZ8pnEInZV1PDnLPFunLUawx7bdBVsGbowXA7vUYFzn+ceb9n/AOm7n8ATgWwgJrxju
         SHBg==
X-Forwarded-Encrypted: i=1; AJvYcCXx1IXacI6yxQaQZqvp3/4X83j97OtKXNWYg/TYaSYnTWbDoMdi1jU0VPoac2CL708Zjf91Oy2m@lists.linux.dev
X-Gm-Message-State: AOJu0Yygwqo0Zubo8Zv2un3/zRV8YoKILs5wB28vQYkzNBFNHV10wX+o
	oXzylOvWOZlyzc/p9xVmmujXywfst693kYLU8DHu0W+WAbTCOfkNUM70iRNej5uZgNg=
X-Gm-Gg: AZuq6aJd62kejCAsAvUau8LQlpRJqeboeIYp6lN0hgx/YIqwM0kTomBr940J6Ul1meY
	5frlblu6FccuDKmPvUGHHYrIZRyi1bdIS6IWhPbThi2tZ7QtIBGunl31qevDuK0FDLg85qeJGUb
	X9PyZGZ6mwp9r6cuqNMno4hBr2Gzp1wtHDCPwLVGoBYqah+ictJa8PqNL5sZKDow6N82lx8gy/H
	MAvXvmXk5rBKXDKw3Xs3wbttJOOhwczcBQ8FqFlSgEYaz7mh7K6XZcYipGUGs8YUQq7TFr9qzod
	1y2YLj7Dw9uHTJrBoMWXp2CfIdKIbp/Ua06HUHjgn0x6w1AdQsOwojyBJMyidHqYsdH5jq8PxrV
	3LXjCyCI2gIGTHa/WRb2dqusuRu0razEdsUa6AE0KCK2JjGTHSJzKn6od3Jh+zzIoM4TDHtXR5Q
	VSvKKZK5FQPEWKs3gWlvQkUzDwhu0G+VcJC5/gwGujknI=
X-Received: by 2002:a05:6000:2486:b0:436:42cc:25ef with SMTP id ffacd0b85a97d-43784521a35mr771156f8f.13.1770783985293;
        Tue, 10 Feb 2026 20:26:25 -0800 (PST)
Received: from u94a (110-28-16-35.adsl.fetnet.net. [110.28.16.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d30d9csm1543986f8f.1.2026.02.10.20.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 20:26:25 -0800 (PST)
Date: Wed, 11 Feb 2026 12:26:11 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
Message-ID: <3jvhhq4ve5uj6im4lc4evewjfw366uskajazh5f3e4wvoc7ssi@velf7j3daxup>
References: <20260209142310.204833231@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:22:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21880634049/job/63161819208
