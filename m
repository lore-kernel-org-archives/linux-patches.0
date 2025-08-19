Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C966343D72
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 21:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755637848; cv=none; b=OuQcmopbsKZxci+g0SFFejeU2YGKobQGl6ig2sFlhQSeOJf0m2+Dqn8QydRmwYwiywGq994DZIjxZIHRgqkvDr1lsm+UsWRO9nZSayx5TfCWhnBpa9AXidWafu+/J6NLqjPsojmEDUorI51mm45f+GzWsRnD3hbNc0JQ0UrvOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755637848; c=relaxed/simple;
	bh=txX5jr8BxDd33Eld5ynHoiTnCcdsuh04s9+CPfvKpNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oRjQ5vR0IZa8zdCVSKUwDTjqIsJkuo6Z+gprEEJYa+Jy9hs7OoN5GJSrqZAsBX5t9AGoLVH5i5Zbnl5JqTm+D8LtJa9dyfx60oClkthuqqDjCbkfEJkr5eGBEDKCKRiSy2ZZoIEy66vIySeFnhwlmWWUVFwef/khUdapyZC+b+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=OefV/F/x; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="OefV/F/x"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3e57010c2bbso35315835ab.3
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 14:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1755637845; x=1756242645; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LDkKsSqVswK768y6OwV/pwm/Qgw8vqSdXXmpv1U2m9k=;
        b=OefV/F/xosW56/wjEHdA5KRy8UjB4pEi8ee5n3XVdx6JR89LjQ8dM76e4d9RsKYy/H
         rlShSprEPQoxPbOOPi3wb+HvwJdzsvJFr+SCo9usMGA5Bu35sasu5f8tDGPC7F1O16qx
         EW+VxxjIW+B8phIRGNTH7XKzqDfPG4sfHNeA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755637845; x=1756242645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDkKsSqVswK768y6OwV/pwm/Qgw8vqSdXXmpv1U2m9k=;
        b=f6VZ6BBZQjARxfIkZ+EszOtwgTVoc96actnO5VMQjjClsd2te7BVt7LQ4CWU2sdScI
         jDn6Hfyhq7L2dJFvc/X6CENKHjEM0k6zui6m2CjDn4h/702LZI6f1bMW9W5N+cUElKnx
         teRXoxhOTnBhkjWeUv0ZvoriU+GlUCyTt8/g62Vc0elukp6n4pPrK1YuxbfSlpWnY/Mi
         5uRk9LtQ+PF8VcMGmpdg9m5tDXMgSsvVzZKLNkWBZ7g/AxqwFlAR73TXeCbDGzFVgU3I
         94psIUvkSrUDrn/a5ETpBTcLKId/50OWZrbDdn8LF93Wb6D5q9dbl4eIx6uWNKbWWCCM
         tDYw==
X-Forwarded-Encrypted: i=1; AJvYcCWkiUE1d9AtdNlw0Ru5q1GyrPqD16W9Q5Ue0AFixPefhZ/2MoDAXDGAqbgZLCtlXuKUo2hlHeNg@lists.linux.dev
X-Gm-Message-State: AOJu0YyTIO9RN9pvLqbVUj72zZFNwCVLo1YMboE5+rUg95i9YHJsr17N
	x/Cj9jZYnPVmYIaeuk7saZK+19bs4h0K+9bYl0o623JUt9HYqs7QVe8X9k0sCKTgrg==
X-Gm-Gg: ASbGnct0wtkfY2/SH+xEN7iYnpH6mGBJ04N2OSSmkeqXJD6Fdk/KGiJUC46u7QpGWc7
	GbsqdxKJ55L9uGjCbxfI9HqMaOgdmk9ktWlA3VgsF0G8EPBhXtQDdlPN3Gq7Q7lV7f0qIexlpsO
	ghElrmW+d+wG6CErGyjEhXewp5Rjy0Lspv6I7D2fhO67eFwTr4ooVY0GURfkkmjdHuKV7aFbwJA
	520wYHk9Iisix2fcYMjn8KdwEa1tjpVrmvinm8X9mOxAOAT7UhXs3UNb+fzUFOatyeiPjfndDXS
	h/R5MpTCQ7CF6Rn8wsRPY73fRI9zLnHO5+Ab6I7ZcGt4sr3t7qVU3+vvFAJwEujRKq1tmg3Q4kb
	jYXK7i+eTp/6mFImMNG8LBcfAGz8mSefMCk1+c0N4
X-Google-Smtp-Source: AGHT+IFkgVqKIKxgw+wzoUg+k46rcgWwLSYjImXVctH+FBD3hju9b7c9XVOKir802ruFQAxf9LZvrw==
X-Received: by 2002:a05:6e02:3e04:b0:3e5:29a3:b552 with SMTP id e9e14a558f8ab-3e67c9f4910mr12050375ab.3.1755637845295;
        Tue, 19 Aug 2025 14:10:45 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c9477ef32sm3638741173.19.2025.08.19.14.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 14:10:44 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 19 Aug 2025 15:10:42 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
Message-ID: <aKToUqhLaqzvaSUF@fedora64.linuxtx.org>
References: <20250819122834.836683687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819122834.836683687@linuxfoundation.org>

On Tue, Aug 19, 2025 at 02:31:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
