Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9A363B4
	for <patches@lists.linux.dev>; Sun, 27 Aug 2023 11:21:43 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1ccc0d2e697so1665637fac.0
        for <patches@lists.linux.dev>; Sun, 27 Aug 2023 04:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693135302; x=1693740102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KH1XfVhLQ+YXClBpeGjKkGNc6ymX8DTVe/Xp1CqkEPI=;
        b=otdRgVw+sceV6uhU7bXKON6Wpv1U1Mo1VhUD9ZiH4LjQ6cPELQmuNpdI+J8t1A1lbG
         zpEXeN3naRKKo2ZA4WzLJ6KdZJTldgWLulD5aweMDNFIe2aw8YOI3Myi3dm+TCpN5whk
         1X5AunaksUTRBeyMmZv9pSHD320aIDdEeI15sCBagnCj15AX8x5JaeEX6TfUwaG6FS0Y
         vvm+qvLYKNUseolE70/WH1dserrHBh3ztDHk68l3C3WtK3etepl7mf5h4w1/S8l3vr3d
         2pfBk8QfDTWZktxn/pXg7GxSsY7f4/Wny2S3cW9EircWQC0f4nn9fLEGjB4wJhKrF+Ri
         Cv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693135302; x=1693740102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KH1XfVhLQ+YXClBpeGjKkGNc6ymX8DTVe/Xp1CqkEPI=;
        b=AWnO1ctDP0Rd/aVh35YB4zNpuzTiWWa3hXWSwKF3jPFRmonqu9BNG7MOGiRHXu+8gr
         POLbBFr9EuK+n//zY3sptnfWZ1dlMz9OcJ6NlIxI3tA36ek/ki4M5wJbNHy7fCs8M2hj
         +B++TNncqHef0knNwc6nuiHK4UGNpddK1N+CONpthY4JX7bG+SdEbo6eNiSr9x/E4awX
         fZ0XUiVf6tV2DB+zBtc1euNvKsyh8huoU55uKMhVdaba3SU8DH2mDUnWMc2xTTc0HGHm
         mr1faci3KCe4PNlCuZ2iJYdADVuoV3iv5rnXzYVjdDGwASi5uucCnXV2PnFi07iMx9B6
         rIwQ==
X-Gm-Message-State: AOJu0Yy9bfttae318EOFRGpJmsZ+wlslmzMw5LL8rVx7GKy2pioTHb+j
	easxphJLpmV/dRe58D2ssPg=
X-Google-Smtp-Source: AGHT+IG/WbYrtVz2hOVgtBviLanFYvLODYr4gH8DRIO2f+CZMbSdHJ2rQgvp7FF51SXEA/UWxwqqjg==
X-Received: by 2002:a05:6870:5620:b0:1bb:9907:451e with SMTP id m32-20020a056870562000b001bb9907451emr8880558oao.52.1693135302068;
        Sun, 27 Aug 2023 04:21:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ci24-20020a17090afc9800b00265a7145fe5sm6721940pjb.41.2023.08.27.04.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 04:21:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 27 Aug 2023 04:21:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
Message-ID: <7e5c80f0-45a3-407c-8c2e-e85bf97f5483@roeck-us.net>
References: <20230813211718.757428827@linuxfoundation.org>
 <b392e1a8-b987-4993-bd45-035db9415a6e@roeck-us.net>
 <2023081631-uproar-tapered-2221@gregkh>
 <2023082627-tabasco-concave-1366@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023082627-tabasco-concave-1366@gregkh>

On Sat, Aug 26, 2023 at 05:48:59PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 16, 2023 at 06:26:47PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Aug 14, 2023 at 07:04:57AM -0700, Guenter Roeck wrote:
> > > On Sun, Aug 13, 2023 at 11:17:25PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.1.46 release.
> > > > There are 149 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> > > > Anything received after that time might be too late.
> > > 
> > > Booting with f2fs root file systems still crashes in this release
> > > candidate. Would it make sense to mark f2fs as broken in v6.1.y ?
> > 
> > Ick, yeah, let me dig into this next week and figure out what went
> > wrong...
> 
> I've now pushed out 6.1.49-rc1 with the last 3 f2fs patches reverted,
> and a single objtool fix.  Hopefully that should resolve this issue, if
> not, please let me know.
> 

That does fix the problem.

Thanks,
Guenter
