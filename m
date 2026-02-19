Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B11B3925
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771462864; cv=none; b=UhxMRUAZTCvcHwkZp8zyX70Iijjc1WHnB7IEP2EZwE7Zwn5cdDsu1snyHMh6q8PZFB+50n0C2BRLVcOxze68/KbKXuMmD5GUTqg/l0IyNT31YT83cd1Z+bRHWD1qy7TyXycRzFnaCqvgzioAkGmr+bNuz3YqXkPTmRQfsDuXr5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771462864; c=relaxed/simple;
	bh=/rklSOklVShg1Ms1JBgLGjAYt0RDT457jMUSWB7x1yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q5Lld03A9hkKTonZCbYhZePnUReZGQ9Q1GPjUgSK4KK/KoE5gOsanjOXBvLNYgxHat4FPuI2bXfKyd3d4fJOjn2QwZDw0hd8bI7Oa0z2SxnIEioP6VKEOyzsrirg6NMyOOV1NuqUWAow0goRKqnXQxfELeS0UotwUQsyKe7vf7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Jj/x+JRY; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Jj/x+JRY"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4b77adso479498c88.1
        for <patches@lists.linux.dev>; Wed, 18 Feb 2026 17:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1771462863; x=1772067663; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L0fIigkPidDvjSh5Ky1RT8qWJY9gJmCvsoqlzOL20sI=;
        b=Jj/x+JRYUxXFTwF6WxGPBCEeY4I/6AnUJnxpR+gkU1sGmaGDpWjBGghirPb36WbHHU
         mNODYz/1nFwaW5O24VG6EL7VvP4+OVX++QE9C19RQ1gZOlk6tHvA8IdYJqAPU/s6Cqpp
         L7fS9eGZVP3ib7CgGIiU7tPmQDjbYuLn96GdI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771462863; x=1772067663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L0fIigkPidDvjSh5Ky1RT8qWJY9gJmCvsoqlzOL20sI=;
        b=IkYWZUJ9AtsZDKtkhmeNZYpZtddx1z3MJt3XjdF4PDZ+WgxQVKzosDJ5FzF6VoQjH2
         qUWblrnKPHrwTHbaxQkV3Y0aD1WkRKpW+zTVweit9Jyp1TwXMktSXy8/dgkTGoBT77YS
         ANE5tMJcLZjPbZrNZHnURiLnqH9l/zRMYV4sR5LCcx7xomoWB3W60qjvlW6VekXxpPUx
         3sXWO6zf8mrOO83qA5G4jYYk7FO63SKqpxj7DvXkFh8ztkJ213TsjJ8507DbN5ytvZ6z
         Vc7ufp5FHyN4tDUsu3b0FZWaxrS8vJF6qapQH2NpOmiLYbcZwxBgKTzTmpG2kAyjRkyj
         5UaA==
X-Forwarded-Encrypted: i=1; AJvYcCWJso5iVRjN8TJbRKsGXDNFLZHha2sd4ICkUXDbEUCxYAPIwBBlkfz+YwVUjkbQj0+bm4NxND1n@lists.linux.dev
X-Gm-Message-State: AOJu0YwDqOKO/pW/0lg+8No1u23g4g6YQV92PlyZ5r9w/sG7NVl+VoTW
	zxtXhdZNxWwQzSA1xe4y1EaWswIKUjaDhGd1VulYpcsrofKBNAx+D4zObPm6eBbCZg==
X-Gm-Gg: AZuq6aJH63UiJgyFxOBoLiwKcGVVUPNQByX7A648ahPe9rOlCwLTIkVgJ3/5sj2MVvF
	+h8LQJyeOWS5n2WldZMc8EbQaExNJwCluvowM1OQr5yrXVvKLBGuap0voHbMErfGeWzARSx3yfQ
	7iYSi+yVZNXTlt9eTrl2/rSgjbbK6ubFeXK+YCDs5Q2Erh7DCSsXPO70Vz1bo81QilTLHCCSOwU
	X0eCkD7/UUVI+tLHF5Q/S8cIWdlNh+ZrRZXm8WrMhQc/cK8Cdep7XXH7J5raX2WaYyPnRdtIE/j
	+e4IQAIsuGY2svmvulxPfrtpjk2pfdWa6Y2UY9cU53GRCCW085Y1/jQKV0IOrex4sCXUfetL/Ye
	ECHbFnB18uqtEXYz6xdUklC8fdtauXFo+J+rzPidE7+v0yeWrO3XT5xhdtb1lLqHR0Tb6s14+3q
	labPARSYmakLxEH+RGg7cVJamI/OZoRsvXEJ4noAIN0MvM
X-Received: by 2002:a05:7022:f87:b0:11b:9b98:aa4b with SMTP id a92af1059eb24-1273978ef67mr8632200c88.6.1771462862759;
        Wed, 18 Feb 2026 17:01:02 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.157])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12742c64282sm27112268c88.5.2026.02.18.17.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 17:01:02 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 18 Feb 2026 18:00:59 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
Message-ID: <aZZgywN8tickS007@fedora64.linuxtx.org>
References: <20260217200006.470920131@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>

On Tue, Feb 17, 2026 at 09:31:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
