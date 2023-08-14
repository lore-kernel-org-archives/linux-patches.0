Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AF7C2FC
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:22:50 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7911dfc9824so180509339f.2
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692037370; x=1692642170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYcETzBFWwAKvPAbWEGprtuAskWB+Cr6l4b2K8yGJWs=;
        b=noXwODNlHTQMN+1eT9ySBSF43lbvo6cMVNWQ5Q0O4PmHTB44YYI04fjoBfABRjAB3d
         zKvHIWr6eUYC/L0vJndlht0YazrZZBJe023XUFe1doIoIMPKtANPpsqT9XfEG1QQ8R10
         vscN+6lG5Ju8ULdPyeu1X4RZ+4UnbZix55mJZLf3jAeo8RL4HABSpJgUq/N3eiWLFoDn
         fTUo3TpOB3hM9J+GWTavHlCr7WdP1cHmiF/+TV69foQZluwnQJCyEKyLNUmTqWdo+Cot
         DeG4/B7qcfbTQqP97ztkh0NB+L1XhkvwAv0JCd7kt5ZdJsZmCVly8ePEKIvnKwOhh5c7
         xyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037370; x=1692642170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYcETzBFWwAKvPAbWEGprtuAskWB+Cr6l4b2K8yGJWs=;
        b=CzOhkVzYYRDB133mE3TJbIrpdqul3U72dSGj0qX6w0a3UczjfPyvK+ACYiTHKus1sl
         m+kQJxHQWZ0c65raNvlLbnzu8lhRYww7EQzEsPgSEDmYzeb8hOdHwIFfR3huH/Ri8wnl
         WTGrzNuxkUHxi1gA3GAPx4GJPh3i/3zlWm9hUI6JTsYJXIfERKrHn42/MK4ZmJS3fKQY
         df6z2fjNitXrGn/3XrnfUalK3BEqeeiNUq3qW+rYRmGctXwCxCZsCjRSLIHxiUywVu/1
         5dUQUTPI43KzojRJlQ/ChACUB+PyBsY96WEjlcnl+H4oohnus2o3XSaWp1xW1xdCr/D3
         UeNA==
X-Gm-Message-State: AOJu0Yw2OESIqJNCYhF9nRAibLHPtH02GjPQzGGHuqVsaOPtkRbZ8EzL
	i9S0HPo+/B6aQVazcoJNsww=
X-Google-Smtp-Source: AGHT+IGC12MWuXC/Nk5U7L1u1QwDYxq+TbxG19bYwKIQWuZpGlLKtoWADsKq5FsB+Npfj4fMPoYJjw==
X-Received: by 2002:a05:6e02:1b08:b0:347:70ae:542d with SMTP id i8-20020a056e021b0800b0034770ae542dmr15205901ilv.7.1692037370010;
        Mon, 14 Aug 2023 11:22:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o14-20020a92d38e000000b00345aaa564a6sm3340898ilo.44.2023.08.14.11.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:22:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:22:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/26] 4.14.323-rc1 review
Message-ID: <8d9b70fa-25af-4481-822a-aa52d42f2554@roeck-us.net>
References: <20230813211702.980427106@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211702.980427106@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:18:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.323 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
