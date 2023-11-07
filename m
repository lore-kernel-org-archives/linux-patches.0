Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7903158C
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 18:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIHzWnJW"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1cc2575dfc7so44619345ad.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 10:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699383428; x=1699988228; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JfOOzo8iylvtwSLRlUhW2XY0pCfvt1cHpqZ+0lY/ivc=;
        b=hIHzWnJWUQ/FoNyca36ni/w2Eu975NqqjxWbiKpxgoQzKgy17rsn7v+b9IQz9qh8Mf
         xCGb6+gO31JRq7tCiHhEJrYyEu1VA6aFmi7g493dwlxV+p6qug8HlbNGnLZexKKqj4mg
         rU02PDMwNMjB5z/rcZdkpGqy5YBCYhrke8UYePCjIH4SlmsxokRB5CMCsaTWUtm9OwHb
         FzSI+YO6hW98qs5MhMoqdLRa9aA21OvYB6hnEr7a7DLSpDZG1lLCiVfphixKWqWawtC1
         elJagFvMCQB81v4Y2nZdcsB43t1imx/uyY5BQFNJdKaUmPIiEEVsqHbSGeBfOSLFgQU0
         78uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383428; x=1699988228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JfOOzo8iylvtwSLRlUhW2XY0pCfvt1cHpqZ+0lY/ivc=;
        b=Eiinb47xwBT3m9VZNXu0tAJptIEc0Crf4TamKBOHBqVA4jGAZqOsso76KoKKx5LQBf
         AZ93fc+2vkjD2oU1TVniGccsf9N3SFqf6lRVZBhp6J5fZLqD+OlnuQ0QkGUE8nYvrptD
         nWA/YBjxhsw2CI5aLb40l00u/gWuAlwLzar2nM+E+WG7fIYStwG5wwCWUk3V/OizNrfy
         tk/lyWzCA7a0Ut3WnOpkX1R3GJ/O6St2dkKbkfvOB50wws6SJpx+yRgJY7896iFZVMBC
         5H9v719DzVzsdeIe3WtTGQ78eRZbqmoGYo44+fhXkjzkktESwyHAAZa99OCpXV1apDxp
         weDw==
X-Gm-Message-State: AOJu0YzNh5ucyF7tEQeFPH15r2ZJ/SoCRJmXexWT17H0FemBcUPdNBhR
	ybea36qej152cAFRI/AW04I=
X-Google-Smtp-Source: AGHT+IG6fmhenCu0zLqS20cK/h8oh6S4QBrlV65xInaTaQqY6ptqoWYeW0HRjD6hDd2rJ9DxnXVpAQ==
X-Received: by 2002:a17:903:41cc:b0:1cc:5dd4:7cf8 with SMTP id u12-20020a17090341cc00b001cc5dd47cf8mr25212675ple.27.1699383428016;
        Tue, 07 Nov 2023 10:57:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020a170902cec300b001c57aac6e5esm168944plg.23.2023.11.07.10.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:57:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 7 Nov 2023 10:57:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
Message-ID: <a8de34ba-0be8-491f-b4f7-a9d233526380@roeck-us.net>
References: <20231106130304.678610325@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:03:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 149 fail: 10
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
	<all riscv32/riscv64>
Qemu test results:
	total: 495 pass: 456 fail: 39
Failed tests:
	<all riscv32/riscv64>

All failures have already been reported, so I wn't go into detail.

Guenter
