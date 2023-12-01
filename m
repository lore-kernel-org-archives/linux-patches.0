Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F004EB51
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="XcGMWUu4"
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-3b84e328327so539572b6e.2
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 10:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1701455091; x=1702059891; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YReR/ElyLsL0HPHj+5ElEXiMYpqxoQVx7nZynS4QGhQ=;
        b=XcGMWUu4wu0nPcFTtGyaxIHcE8t0EFGsnuqQbk+Fd2qSfI7pKLP93iAJzJIVAHt/o+
         ghL9Q9j/Ocj0MXv9DYat7MwEwxG2aV/hHGKLODc6y38qjwEBwvZ62XP5JKz/cvXIbcJ+
         86Quxdqj5TuikyofkOri+tf4F7v3kzPuOWAHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701455091; x=1702059891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YReR/ElyLsL0HPHj+5ElEXiMYpqxoQVx7nZynS4QGhQ=;
        b=WqVN8HTcBzUm7mQ6N2fiyzKCROgNcmsyVDVec6gi7yjYRdyOIAWTn9gFVuCkZ4TakD
         tMrIlzodJAkMWLiDzSWrtzvdxyiqfM3ovDjZxtdxlEGUmJ0g02xEEZcxpEtwzXk0OP8I
         ijRwylwWhiUwj+mqLLdH16g9k/BYlFAjL+VpDR7eBnFfu9U0BgsiiTLDlaaY3k1FnbSS
         CFd+PWdC+M6R1etiEKB5pqVu86SGfLWyRpR7pPo0Iec+pTOUXpUzw3gsMf7/w9Rt3HJW
         vvhQlaQbajMfmeY2B5xuWbjdRTN9itHOghIb8QpaJLe36kSJVvaNEbuETRx6scep6v0T
         /ZgQ==
X-Gm-Message-State: AOJu0YwyfqQAmPyT8gzfukTviZXE4QTtthz6bFYyws+DNOIUg78LoYpk
	eEsble6E80o9sB/hBEfPuAlJWg==
X-Google-Smtp-Source: AGHT+IGPgafOly1IVWDEaRcvfphGZBGLi4CqUruCxwY+paDAHENLzM84AGvunQeaAC0WN9Esn1lKIg==
X-Received: by 2002:a05:6808:2c6:b0:3b8:5e9a:b2bd with SMTP id a6-20020a05680802c600b003b85e9ab2bdmr3632976oid.15.1701455091793;
        Fri, 01 Dec 2023 10:24:51 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id be25-20020a056808219900b003b898ffd8fcsm631188oib.50.2023.12.01.10.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 10:24:50 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 1 Dec 2023 12:24:49 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Message-ID: <ZWokReR-lD3mFIIo@fedora64.linuxtx.org>
References: <20231130162140.298098091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>

On Thu, Nov 30, 2023 at 04:20:47PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
