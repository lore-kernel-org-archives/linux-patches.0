Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF3652F69
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705672139; cv=none; b=D4zUF2O3aIWQ+9T1K7bRBVmmDthywY0W2lG6yp2hGNJa4kkIBwAYvoYOQPsAJ2a/cPpRxOR06nAw+qatko0TdQb3mUasu3hVCUhSSZGHd4s8Yky+/bcDmi00or7Rn0qhP0IA5HJTZ3jsGj+HUI8C4BOdF4NJ6iH7rZyruCK4pTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705672139; c=relaxed/simple;
	bh=B6tArqyOlxI1H47kNCNJM0kXaH+yQwNZI7lr3yQI7A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5mv1quKrNv78d1iqe3YQlQITwst9KCIckb2f6vhIkZHZH1ZxIIwmaVG3ITDDOnFjo2nww3CTeXtjZbxm4A7aVj94qY0rWZsGb6rHI9RrsQrxefC63y0JuKTVhHwR+yuheQ6QDSwgvkybsZqTwSRXvvN6FpBUG7ky5xwqN///GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=fail (0-bit key) header.d=marliere.net header.i=@marliere.net header.b=gMbEWgmj reason="key not found in DNS"; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="gMbEWgmj"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d7232dcb3eso2630075ad.2
        for <patches@lists.linux.dev>; Fri, 19 Jan 2024 05:48:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705672137; x=1706276937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=44+0PG1XUq1Z6WTgtSqi90k4/IQaacVFaI25/F2OJSk=;
        b=okQkyUd6S6i7VpSi3lOK8UxHLfXUKZCJXjfwatfOrY+ueZ5vh/xA1oGYCWdWoHa9r3
         zyIBaI14SFymaOT/rc0/xYUYU80Dbj49XZRfVatJwDwO+9z7ir6XywZ/qOUTvIytGvYT
         QkTFHqBizbb4bTv6/t1n1l0g9s3tLUTM5UPU42HfGsCzSag/7g6uC/2taBNB17OSyzq7
         9lSPohfh/rt+1uZ7eebmrgO6mvyZMAhrHPnm2dgGCW2zxhjP8Vrb5MIiv9JI88CrvpqT
         O3W1cpGS+Aq9tbuTeHcMFjoYMbGKXJ9dXnrsFXA8z6Q9hk2Ql2r2HTDhlf74pqEBwSRm
         KtxA==
X-Gm-Message-State: AOJu0Ywpmws6jcRfIDftGftO4R8NzwbyEXhZxTBHV0sXpoK+xY4HbrGw
	T9EoaLRe3v87Bxnje6j3IsJQQDjPnzwrETw9eIBOEc1m2wwsCexmHuO3Gkr9EgU=
X-Google-Smtp-Source: AGHT+IEZnmYFzGUAs/4hjDfJ5v4w3mjQG4gnmyhxLexgFOz3I6DEGAPVP6AtfgsgUeL/uz2KmHPZdw==
X-Received: by 2002:a17:902:d4cc:b0:1d5:e722:1089 with SMTP id o12-20020a170902d4cc00b001d5e7221089mr2886716plg.122.1705672137295;
        Fri, 19 Jan 2024 05:48:57 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id ke5-20020a170903340500b001d33e6521b9sm3084090plb.14.2024.01.19.05.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 05:48:56 -0800 (PST)
Date: Fri, 19 Jan 2024 10:49:03 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1705672134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=44+0PG1XUq1Z6WTgtSqi90k4/IQaacVFaI25/F2OJSk=;
	b=gMbEWgmjHfcoD6mgwuQzJFkOJmLVtAza2zjo82TzrA/QEUpf1AJh3GwQKxWnsnSgb0Mq5A
	71tTR3GLtOMJcPTEZf/eItM0mSmHwamS/r5JCXqiobOl7x8sSG4boUxjko8Eq4lZl+LeW/
	xHrzD9Z62Sd0TbAzhwYCSiUEN1eSlkJsdRJqarwhZEFaeGKa5LVo9fNNZ0tvdLUu3jSMiq
	iYJTyWhbldg+iI/2Zsd9FLhATouLH2JkBB7wNCpgKrPY+riCiTYoTUrHz0jj/q3ukBVRVN
	3l1TJPl0RviKGYzzcksIlippWavqWozz3pVt0vO8EXjVE7C8ctZJHW5wu4ZVaQ==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
Message-ID: <obbv2pprfnw2gvgi3lo6stvlmrumwgak5vgmmp7udqvqmgqf3z@ierap4ymxfch>
References: <20240118104301.249503558@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>

On 18 Jan 11:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No noticeable regressions on my system (x86_64).

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks!
