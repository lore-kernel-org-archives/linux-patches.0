Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C9358A4
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 22:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccDwHy5l"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6d9ac5bd128so77955b3a.0
        for <patches@lists.linux.dev>; Fri, 05 Jan 2024 14:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704493150; x=1705097950; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jEzsopUw3KlXSSQNrQJ1Qhdx8uIJ/YgpReJRgYkVS+Y=;
        b=ccDwHy5lRZlQP6sXoFPAinWWZHmOJeQ1OAaz+NKPfXdx0FOEjbKZoMdU8alSaBCwpR
         T6H3yQAXBAaDlR7wFnuVDwxB4fvDAKiaCho98BkSvCioWnxsNFh4clqY99XLkBnmhldd
         rjbKxee4mjkT3Po8LGAj3nq0SrpcC3bjQGpvCp6cM+HuLvpDpvA2/c4LZX+EQqEV2btM
         UiF5R0QFIdacPJbEf8Q55GoMaCGNtJOtyi82p3SfeCsXXmH+k1lnU3+G0DF9HHnbwXhy
         EmJW6qPbpMrrm+m9zPpm5JNygRlofaTecVE/sYd1WFK9DHRBKaXYPrF71/6JyBQLMiqI
         6d+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704493150; x=1705097950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jEzsopUw3KlXSSQNrQJ1Qhdx8uIJ/YgpReJRgYkVS+Y=;
        b=D3+yirBLzNXa7+KF5DBJwlkYlCS5hYzvAy4zSKKWlUMOvlc9JJZ8eRy9yCvYONJ+1q
         17nVxvjzPhr7qMg0LJ7GYg4Yn4fLBpc1A/ePXuiC25wIiZp/BZ/tRTKiza5TwSedKYgW
         vn541+9DkP8/mUBcBPMKYDYneJaBvYfo4eivtLQFmGDcEZDkw6Z1+JFY+vuEnDvK8BeH
         fBevgAwrPpJPu7P4xRdKB9DzFGaO380/53OqGEwHOLDYrrxAdoSYsK5vnFtskkwNqZgI
         o/PxOr+JEyV0Egp8482HlxCsGVp6CfobwtZh9UzkWzbqxv+yANdfsMxu5Woap4xzfk6m
         s5sA==
X-Gm-Message-State: AOJu0YxJcWG8drCqyyVkV5o/+BjzEhN/iJDNaQ+o2jWszFpTx2jvlfaf
	nI5/r19u9SAY3mEx7zsKyrY=
X-Google-Smtp-Source: AGHT+IHYaVUvDYTytHoUAgoh6ibf8bs4vasMNCYNnWAsi42vIgp5xLNGQPbQlS6nTSo1LgxdHfcYRg==
X-Received: by 2002:a05:6a00:3d44:b0:6d9:bb6b:f418 with SMTP id lp4-20020a056a003d4400b006d9bb6bf418mr30109pfb.2.1704493149774;
        Fri, 05 Jan 2024 14:19:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b006da6b404e7dsm1856783pfm.63.2024.01.05.14.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 14:19:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 5 Jan 2024 14:19:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/41] 4.19.304-rc1 review
Message-ID: <72a5ad9b-4e10-4e8a-995d-a7450ab47a5c@roeck-us.net>
References: <20240105143813.957669139@linuxfoundation.org>
 <ZZh1MloSmA7F4Z2Z@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZh1MloSmA7F4Z2Z@duo.ucw.cz>

On Fri, Jan 05, 2024 at 10:31:30PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.304 release.
> > There are 41 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> Best regards,
>                                                                 Pavel

Odd, I didn't get the rc announcement. The same happened with the e-mail
announcing 5.15.146-rc1. That makes me woner if my spam filters are too
strict. Do others have similar problems ?

Thanks,
Guenter
