Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359ED225C3
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwu+OQ1N"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-690bd59322dso4462942b3a.3
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961849; x=1697566649; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNqHJZlLp2DlYv05rHCGAAH563+Pb/c+Yyrz4TDUeMU=;
        b=lwu+OQ1N+08Qg+W40vYVnVGgbMld4znn+Xr6DhPd7NuxnWUCmq3P0WRYqDeoz0a8Au
         I1/E5VNkqxH7ud3tqvp4ObnIvF8MqPvH/p8vGPvCXLS5t6vc6AGaHh5k5n5MLcOov0+S
         tHLUdBeSnIDlBi/Y7xgShBsJ8RNnTaLAKrWl/djaur7xklatFIXjNF2m0zqwoUrQWCXc
         oLIXSe25XGU7ZkbJpciymeBwmNU+nlO0Bp34lR3w12lT2y2acp1Jqmjf/wQP2Hz5oCkG
         2prDt6uWKTBwzGExpTY6M1iY6FQTFg8R9/V09hENaGL1Z1Zvk6A5SxZcGGq5te8PFqGg
         8AoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961849; x=1697566649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNqHJZlLp2DlYv05rHCGAAH563+Pb/c+Yyrz4TDUeMU=;
        b=cwp0GeophyBb4myP0qFEkj1zc1fgM0nqZpZYNkBQSqYzTqV4fb5zv/Q+bxv9zQkkdS
         jMBKEwYJuWvqf0idsCFpQxo+iE7eqOzyiSCaDWgzAoi3smumk8Ucv1v4DK86ixwhULUX
         FreVNvqWvcFRWEo8H0CYG0ogsVc70KFAiOsPoOoPp2svFmy3GviUfvzmJVDXSlTyZFC2
         ph8RDI1wRTEibDozL3Cvb/PfOSwiOGRpcaggJKH63/B2Z9ViY+quT9W7FbKtCDGVSuEw
         ItN/dq1I64rQK4hz/6VC5hf36BnWJHJR9cOtxYnEZiW7q9f2SZDuklo/d0HgapB9HdEE
         mtKw==
X-Gm-Message-State: AOJu0YzLAqmMYrQ+/2hC5p1vPY/yhC5FNtiJZwYfr7LT7MFqRkVv0NiP
	sXV71IpRpvT4nBw4qq1AIcg=
X-Google-Smtp-Source: AGHT+IHrEjxq6/EpCricAhgVsA+f32HbTd1xvqgooxheYAq85G/opDhU56POYroDxWaoKRBqGO9Gng==
X-Received: by 2002:a05:6a21:181:b0:165:186:1560 with SMTP id le1-20020a056a21018100b0016501861560mr21206963pzb.53.1696961849279;
        Tue, 10 Oct 2023 11:17:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fk3-20020a056a003a8300b00690ca4356f1sm8573946pfb.198.2023.10.10.11.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:17:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:17:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/55] 4.14.327-rc1 review
Message-ID: <19c85171-e189-48e0-a9b2-28d718380422@roeck-us.net>
References: <20231009130107.717692466@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>

On Mon, Oct 09, 2023 at 03:05:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.327 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
