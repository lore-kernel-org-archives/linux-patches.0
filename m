Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8566A331
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfhyo/Mk"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1cf7a8ab047so25139285ad.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 09:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701798911; x=1702403711; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5aQzDqrMnGR3HhC2VkHqL+RzFuPOaohR6QEKBxpRo5c=;
        b=kfhyo/Mk6UVlExFICl9e4PxWRjmUTpF3uN8esG8rMxBtR+z5YvL0oz3xCTGHUV2eT1
         AwveePD3TuktZ2XH206tppnu2QBt+x0Fc6mqCLyG66bgJ+f/N1EVL0sMYI6rlnFUHCQt
         yIUP598fZbX3khcG+rGVCE1dsY6ejccEFyFs25Bc1G6AwjyPQhLP4GoU9CRcXJ5hnQj4
         9rDJEd+atOeVozA6+DydfAmcO/iJl8MHJKBX5G8CWcxcKUSHvCTinm5hiejZEPwGQumR
         HW4SbyakJbHB85xAeGImSNlbABNnXyNk1/5zhVGYxqWbJuiAu/9lCthY0gscUsqZUm6I
         A87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701798911; x=1702403711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5aQzDqrMnGR3HhC2VkHqL+RzFuPOaohR6QEKBxpRo5c=;
        b=vquLsyZ9tTIzMrVoGttVSs8whKAkrg+1I9ffCkHGK1BGrmq+XYOpnp0eQuVYTHZ09E
         RvpM0b8f9hXjq0zMzS/DZ6MXlMgCg44ursAY86sItizRWtMU8VxfsoJ4P1naX/By+N/J
         ZZqWbreSkfyMBykKCsEMikFaK/Cm+IjHDpoZTyGwGvEXlLHp4Wd77te1SC89MHIEj5lN
         ESvWKykeJhB4d4R0yylj0ozoBz4ienLtzOEn2YGPIf/TE4D+pDCggq7Zv1DoaGQZMV8k
         FzyLsa2g82kxplKiY4n0XCy2wzRQ/pIefaCWYpz1ZBp6maMbpbArd9aFHe6K23IE0S01
         mEqA==
X-Gm-Message-State: AOJu0Yxj//rNovCnSM+IQM13MCTQnV/IgTyMk9y/1gPhQ7H50hHZCW2W
	y1nQQTdElM6LM1NrziCCc78=
X-Google-Smtp-Source: AGHT+IHCktGeaSiYt/e82PibfLHD1tZiyfWrdmNFtXGQag4quQZb8GQfJW6+xluJ+z13CTu6wajF2w==
X-Received: by 2002:a17:90b:224b:b0:286:e5c0:eb4e with SMTP id hk11-20020a17090b224b00b00286e5c0eb4emr708796pjb.50.1701798910589;
        Tue, 05 Dec 2023 09:55:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090aca8100b00286e618cdfdsm1335544pjt.27.2023.12.05.09.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 09:55:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 09:55:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	chrubis@suse.cz, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
Subject: Re: ext4 data corruption in 6.1 stable tree (was Re: [PATCH 5.15
 000/297] 5.15.140-rc1 review)
Message-ID: <4118ca20-fb7d-4e49-b08c-68fee0522d3d@roeck-us.net>
References: <20231124172000.087816911@linuxfoundation.org>
 <81a11ebe-ea47-4e21-b5eb-536b1a723168@linaro.org>
 <20231127155557.xv5ljrdxcfcigjfa@quack3>
 <CAEUSe7_PUdRgJpY36jZxy84CbNX5TTnynqU8derf0ZBSDtUOqw@mail.gmail.com>
 <20231205122122.dfhhoaswsfscuhc3@quack3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205122122.dfhhoaswsfscuhc3@quack3>

On Tue, Dec 05, 2023 at 01:21:22PM +0100, Jan Kara wrote:
[ ... ]
> 
> So I've got back to this and the failure is a subtle interaction between
> iomap code and ext4 code. In particular that fact that commit 936e114a245b6
> ("iomap: update ki_pos a little later in iomap_dio_complete") is not in
> stable causes that file position is not updated after direct IO write and
> thus we direct IO writes are ending in wrong locations effectively
> corrupting data. The subtle detail is that before this commit if ->end_io
> handler returns non-zero value (which the new ext4 ->end_io handler does),
> file pos doesn't get updated, after this commit it doesn't get updated only
> if the return value is < 0.
> 
> The commit got merged in 6.5-rc1 so all stable kernels that have
> 91562895f803 ("ext4: properly sync file size update after O_SYNC direct
> IO") before 6.5 are corrupting data - I've noticed at least 6.1 is still
> carrying the problematic commit. Greg, please take out the commit from all
> stable kernels before 6.5 as soon as possible, we'll figure out proper
> backport once user data are not being corrupted anymore. Thanks!
> 

Thanks a lot for the update.

Turns out this is causing a regression in chromeos-6.1, and reverting the
offending patch fixes the problem. I suspect anyone running v6.1.64+ may
have a problem.

Guenter
