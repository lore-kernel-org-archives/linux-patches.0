Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D77F13BAEE
	for <patches@lists.linux.dev>; Fri, 27 Dec 2024 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735320472; cv=none; b=rpTIZtmmfIAsY1jfzUmONarpRtS11FdPlorRuQV4Tt5nkszAZCr5jWMtGcGAj9BLy1kbGaLbmOONhcKDvA+JTJ1r1WdZ83hKYyciEBb2OszpFoaC/kSW+WuBBaVPYBmkISjvLrcGT39V38uOIrMEYspJq4EQWqv2Tv8tRfrZucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735320472; c=relaxed/simple;
	bh=OVS+8LwDX9Vlv5sgHzcrai/X7AZs0h5bC1ibqLSKIlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZIglXFSZexGnRGym1yU1OYukHfxtCTYAPGJcOksW01FdYZ1G0MTUwljCOZoc37F+xdL+1BVvXnjZ/Wybr6iXAz9YG9PkGxLk1+C6iZ6oBoOnfbsY9DEubX7zOJ4KMqJqxG0MrwHlelP6YiShKIsNGpHB5BRVbEswaVwbRfqe64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O03Vqbe2; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O03Vqbe2"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so7682924a91.0
        for <patches@lists.linux.dev>; Fri, 27 Dec 2024 09:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735320470; x=1735925270; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7+bHJo91EH/ascAZ6YxEM5ft3sinT845bIpMBqq57mQ=;
        b=O03Vqbe2VFnYlpv5yyXc4cyu6O62hqj/52LQsooKo7n9MIJBsElqD3rVsuP0rj2Arh
         2j0/46gkm0VEjKMgfPf/Cd2VGjJQdnsfJqJiRFWAE/KkbaV3f8AdOCJIRCfVIkXh3m8Z
         rcPcaljFmoQ5eEiYsV5z6bmkCOnWDXGUlBXHxvsqzCQiZt1KfdKSkCuw4VmP6T9S/3cY
         Md3dbJaos/XhpKBQ88qlkwfEPqQprNaVkeTr7m1Qh1d/Ow3LL4suSmWKpdTTKObfjWNh
         UEpZarSR2WCkaJQq/6Sc7STJlH2vWgsgMSA1SxMIo1NKZIhY0kPY7Aj1abFS9HdmPJvI
         ZspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735320470; x=1735925270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+bHJo91EH/ascAZ6YxEM5ft3sinT845bIpMBqq57mQ=;
        b=KfAWqgiM48XVMwnv91rMMPl4EhuhMFpqd5oY7sM7XjrakASNXRBEFHPfBd4wgJ7S9t
         Sk6OAmXs33IDqf9hkCr8Bx+leSXun+m6Im3QSpNGwUyBlUqDCEfopCBv2u3JKaNXjh+D
         tcZLh+jpktJRc0UUKQIb3FxTRj6an1Lek4wWWbR7Zg/EKc9gFMkAVD/kz6SIgvxZfPr6
         SZm0af4itdEmEbD08Mo3YYg+wYigSDCxKWb5vaLfdofmRYilKeHF+upEtVbwzJuU9DU1
         E1UgRQMnccovRJbI8580KdWSsnV+M/FZzilHhf+L6MbvYxiMN8fhb0Ahz1deTMnhNsMK
         RNGg==
X-Forwarded-Encrypted: i=1; AJvYcCWiiuArbssyZic9BhMyC//oVfkUQbtipQa1nFZC8FQAPHVb/YmN0Ev7SIUXLBHUzbuXnKfeHOIH@lists.linux.dev
X-Gm-Message-State: AOJu0YypKzkPlGU/yluZXgzPmEu9HnnK0ZGQoL9ImbnMd1kv3QCYRv8Q
	zM60whWZELFVpvM76dW5gzEE4a1KUjlsSUn1k2pco6N8mOHnZNPD
X-Gm-Gg: ASbGncvqvUKxlxT277hW5Z3niCVG+B5LWxJ+U5tk4XkbQjcz3hvmM2qusMEK5BoorN+
	JaMbDVU11s7WNtAlwVK/5hx3BXaJHtAt/0u+S61C/KDVocw0vPJxrYlQAwkZTJRAZgyl6nsnFft
	wM8Twyy+i/x83YTceEzSS2pGoq8qJKQHlbLdn+9JZ0ZaZqdwS+mnJqh7EZOshQeDn4Fisvv4Fn6
	iYyNem5YR4SMr1f03ODxSGKSo5uhERzrTVe+OyEphsxhV4/bnb52kXIzF9qjPUrOMvMEQ==
X-Google-Smtp-Source: AGHT+IEcqaWWJIa7cYb3sKuIT0xLunW/WjjlJfvMw/GbWHpzmMh+tksDqSTOoXNet14yhuROqWzULg==
X-Received: by 2002:a17:90a:d64e:b0:2ee:a4f2:b311 with SMTP id 98e67ed59e1d1-2f452dfae72mr44824483a91.8.1735320468951;
        Fri, 27 Dec 2024 09:27:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4478a92absm16142935a91.44.2024.12.27.09.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2024 09:27:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 27 Dec 2024 09:27:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Marc Zyngier <maz@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
Message-ID: <52873782-3b21-4e53-95fd-1288d5dbc024@roeck-us.net>
References: <20241223155408.598780301@linuxfoundation.org>
 <CA+G9fYt+k1m9oTuuZaGyTXqg+EKsSTnmfsc2HYijDWmEjx9xFg@mail.gmail.com>
 <87y102r27e.wl-maz@kernel.org>
 <2024122713-vacant-muppet-06eb@gregkh>
 <87ed1tp8df.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ed1tp8df.wl-maz@kernel.org>

On Fri, Dec 27, 2024 at 01:23:40PM +0000, Marc Zyngier wrote:
...
> Additionally, these tests are mostly pointless anyway, specially this
> one, which really should be deleted.
> 

Would it by any chance be possible to remove such pointless tests, or at
least mark them as BROKEN ? Having them present suggests that people should
run them, and feedback such as this one isn't really helpful. If anything,
it is tremendously frustrating for anyone trying to run those tests and
getting that kind of feedback when noticing and reporting that they are
broken.

Thanks,
Guenter
