Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEBD25B312
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755100737; cv=none; b=QtepnTt3nrb4c0AWBrfcsZbyR0I3s/zXPbwyLMV2GSvIrV+HeYxeJa6BewXJv9YxIpiygnj4D2W/+JQnMXVRHqeKCyAg2I+H6ojE86OL/qeA/xAk/ZWzkAF1dxcGKkxgpafkFT7Ro7eVM2RC9M27TlBmzguef1zTnt37WPcMpk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755100737; c=relaxed/simple;
	bh=JCJTW/Ucx88U/k5zzDsfVlKugMbj9mbeM3mUGqS/nCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4ed/d61zsDd+cdSoKxRwwVOfPXoXY89l5zZY/sxIgD52gXgAJ7S4JipiAE8XdJ+/GWSoIzRdH15Q34CxbyHnY/YHTCS7ieyLgZJN/ILNuoTb0CgibtxKjQRZVdubxO04J6696gzVAEAU3cQWbQYyZASYv1TJ48KRGzBxAQAzzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WT1OVq+J; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WT1OVq+J"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b792b0b829so6791456f8f.3
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755100733; x=1755705533; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cp6XeG0MyOuXPRX2EUNgzHzmYyd18LTitGQ6mKDCv5k=;
        b=WT1OVq+Jg/8JLNzhzi+fKSaVYOBXRMAxTiC3V7Nj73oQ3TyOX9SrmJ2Jk6wPMFVPQV
         RNIYiWAxxR06veubsN+K9Y5LKyvqNYHMYU2myPnbGLN1i8uepm4PYBZD/efh+6Zwwnkd
         v7XjTsYHnlCOS7n+k4ENMuwNvw9bJbEysz+Bg8euxeh8mH6pxcwbczmUaTiHCPOUgk6T
         C31SaqJOy0qvjeubeONxGgE3qg7grMkqF9RTwus3HKHk3ng3VwtC0qAGDhiev7y8Mohn
         q1UfR/pcq3x1Z15jBgBXuo0rDbazC3CAv54+CdktdBA301S/aUttRn7qsCL2mbyyXkja
         Y7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755100733; x=1755705533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cp6XeG0MyOuXPRX2EUNgzHzmYyd18LTitGQ6mKDCv5k=;
        b=e3R20JgIMHo8wAGlbpWzZ7H7wXUQZ1jhw7aq0rlFt7Qo0DxZVHLBH8cjhWyrdLmIjW
         aZHafU7KelpP/nLqwxfJ6rRtzlY1h4GFGYSqpFFNqvLQi+Dm9T4lsqprJKUelwjHkTbU
         Cj+O6xEfsE+EEG2uYAOkNAc0z4RCifTRBKbHA7grWJYzjc1CJ0nuWezSeIPUuOCWuRH6
         bToxS9k+Gt+QWEuYKtcDxcZHx7tHiVdyKCVurJym3lFEFcBYEKxif5j0k1cE9cl4psk4
         BKg4vCp4CNfGHy+VYomt+dwkzv9euGBDtHSktq4xHQQGuX25F+B3aGjFGKU7f2vGSXxg
         3NIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVh+zHdpJ0bRQoYjAYk0xcAvaWd18gO+N9RVADMm0NlnF2+hRK5YxU4iv7E3w2/0Xo9sLkjyKMW@lists.linux.dev
X-Gm-Message-State: AOJu0YykLSEmxh4esKpczXD5enP5lUk2uq8j4FvA13nqBa7vaOPoF47D
	YZLHBGSW8KZqQtiUgVATv1f9NJm2RYKhqwFhxIqOcyXaKDhP8xtFOWHjy0RVo7LChsM=
X-Gm-Gg: ASbGncuXmGlTi3c5tGb8/MUfe6St3vg4o7wFl9nRv/y9KTJvLhxauSN/tJI45XWbMB1
	NorlE2AeDxlkUzowaVFUONaXNs8vL7S/s4aNnA9+FlvegYsiaAHf24KFNe2PWiPHmwUsLutu/Jw
	AhkQHrE3QYOINvFdyi9cICLMyTPM3FAgBG8gzU2gVlosYtenQjmtZT7ARoSfe98s/+QyqKIifVz
	4OGUeYTvSXzgB/aP+UZO5Szi7985qOzh7/xpGFCk8F4JdpX/hdltQ7FEDqZOejlXU3mdsLti9VJ
	k9jqOqRT+HhgtSIZR8qV+UTV8KPzM2kzb4nAl1HIzUPt0R8E2uFIax5in4wrk2Z7BQ9uug4oWVj
	Dh5jUEtOtyn/m9/TuHyIr7LVScRt7OTCFreiZP8CY2LE=
X-Google-Smtp-Source: AGHT+IFmDnHCSl5CKkyh/D1IvMDkhgbQzh6CQ86Hu6D5gyD/dtG5m2liXMYcw3pmw6tZ+PFrvCebxA==
X-Received: by 2002:a5d:5f95:0:b0:3b7:8dd7:55ad with SMTP id ffacd0b85a97d-3b917f14804mr2882432f8f.39.1755100733462;
        Wed, 13 Aug 2025 08:58:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b91b05b28fsm1789186f8f.21.2025.08.13.08.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 08:58:53 -0700 (PDT)
Date: Wed, 13 Aug 2025 18:58:49 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	LTP List <ltp@lists.linux.it>, chrubis <chrubis@suse.cz>,
	Petr Vorel <pvorel@suse.cz>, Ian Rogers <irogers@google.com>,
	linux-perf-users@vger.kernel.org,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Zhang Yi <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun1@huawei.com>
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Message-ID: <aJy2OVhg4RUYbHHR@stanley.mountain>
References: <20250812173419.303046420@linuxfoundation.org>
 <CA+G9fYtBnCSa2zkaCn-oZKYz8jz5FZj0HS7DjSfMeamq3AXqNg@mail.gmail.com>
 <2025081300-frown-sketch-f5bd@gregkh>
 <CA+G9fYuEb7Y__CVHxZ8VkWGqfA4imWzXsBhPdn05GhOandg0Yw@mail.gmail.com>
 <2025081311-purifier-reviver-aeb2@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025081311-purifier-reviver-aeb2@gregkh>

On Wed, Aug 13, 2025 at 04:53:37PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 13, 2025 at 08:01:51PM +0530, Naresh Kamboju wrote:
> > Hi Greg,
> > 
> > > > 2)
> > > >
> > > > The following list of LTP syscalls failure noticed on qemu-arm64 with
> > > > stable-rc 6.16.1-rc1 with CONFIG_ARM64_64K_PAGES=y build configuration.
> > > >
> > > > Most failures report ENOSPC (28) or mkswap errors, which may be related
> > > > to disk space handling in the 64K page configuration on qemu-arm64.
> > > >
> > > > The issue is reproducible on multiple runs.
> > > >
> > > > * qemu-arm64, ltp-syscalls - 64K page size test failures list,
> > > >
> > > >   - fallocate04
> > > >   - fallocate05
> > > >   - fdatasync03
> > > >   - fsync01
> > > >   - fsync04
> > > >   - ioctl_fiemap01
> > > >   - swapoff01
> > > >   - swapoff02
> > > >   - swapon01
> > > >   - swapon02
> > > >   - swapon03
> > > >   - sync01
> > > >   - sync_file_range02
> > > >   - syncfs01
> > > >
> > > > Reproducibility:
> > > >  - 64K config above listed test fails
> > > >  - 4K config above listed test pass.
> > > >
> > > > Regression Analysis:
> > > > - New regression? yes
> > >
> > > Regression from 6.16?  Or just from 6.15.y?
> > 
> > Based on available data, the issue is not present in v6.16 or v6.15.
> > 
> > Anders, bisected this regression and found,
> > 
> >   ext4: correct the reserved credits for extent conversion
> >     [ Upstream commit 95ad8ee45cdbc321c135a2db895d48b374ef0f87 ]
> > 
> > Report lore link,
> > 
> > https://lore.kernel.org/stable/CA+G9fYtBnCSa2zkaCn-oZKYz8jz5FZj0HS7DjSfMeamq3AXqNg@mail.gmail.com/
> 
> Great, and that's also affecting 6.17-rc1 so we are "bug compatible"?
> :)

Lol.

regards,
dan carpenter

