Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7518515B3
	for <patches@lists.linux.dev>; Sat, 29 Oct 2022 03:35:11 +0000 (UTC)
Received: by mail-qv1-f41.google.com with SMTP id w10so5301844qvr.3
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 20:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FjBmGgtBccJtbskrXHQtFtqOZzyo3pagS1tNLq877uw=;
        b=dQBZDvvbTJRIocCcNKYFpRAG8f3FPqmW5xlTZxu1b1Kt9QdigSmudrY0mJ3NpZ2YAy
         3hyYjA/IHZZN/RNZ2YI3MnwULFdNLRGYDRag+DTiKSZVTQ+KIMxdogdFt9kOSCIEu479
         f2G4YLwnoR0qnFYuMMThybaRPRmmuJNJv0qnEmNHmTYsG7wGHNtNi8QvkDM7+9moNSBp
         hc7+CfhU8MhhzPgE9X2AWlNpvQeThqIYCvgGjwjjx9t3iwJ3xbvoGAIrpV4rnbZIbeJV
         NmkYu8maHTe2tXes4Hwrak3+S5t/KTu6zu6b6WTNIgVLNMjpm9NMrr8N4/alEuV2vcpl
         MYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjBmGgtBccJtbskrXHQtFtqOZzyo3pagS1tNLq877uw=;
        b=etrRLwXyskCJ0B1Kbg5zxhzLr3ZZxyJCqL83CF3/RaD4Tr0Dbjj9T8fsoFVd/Noo0g
         AtK6/as0f1kykX6hN7jZt6XCYoAmz1rq15bW/lcOGa06igMxasn8s8ZybW2+Uvf5HOtV
         wfVjKqe1FncSRmCpVF18gPBDYahk8kk8aZIrb/57l/uHraq6Si/M/RSkUaggHLkOxPXb
         sp41jxygGsIM+tvnr1dHo1hNjetQ1b3aV/9iLuL+TUCqBUVJK6h4u1upBuQtuQokBNHO
         fRtZnToiBWrzbjPuOdVD0bBVjgCsK6+qW+Z9PCwibgc81z4lhvWHifhKclBwMrKV6RGW
         wEvg==
X-Gm-Message-State: ACrzQf3QEu6+BDjtYR2Hvrx7t+ICyDt2bfGsZZ5TeNToGlj+JaCDKmMR
	DUgrBR4B1/GgpF1j70Ee7LE=
X-Google-Smtp-Source: AMsMyM6hiqPMyvNX1PGGZvvo9BhKay4u62k2qFEnjNwZmC1ICRsjYvvgqJFWDs6c94vJgmkePhBt4Q==
X-Received: by 2002:a0c:dd13:0:b0:4bb:664c:5aaa with SMTP id u19-20020a0cdd13000000b004bb664c5aaamr2344167qvk.121.1667014510427;
        Fri, 28 Oct 2022 20:35:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q20-20020a05620a0d9400b006ec771d8f89sm309238qkl.112.2022.10.28.20.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:35:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 28 Oct 2022 20:35:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Message-ID: <20221029033508.GB53002@roeck-us.net>
References: <20221028120232.344548477@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>

On Fri, Oct 28, 2022 at 02:02:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
