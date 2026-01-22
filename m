Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B440C322C98
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 02:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047658; cv=none; b=OtWLnQDZ/v8bX/Ijd5ugEhO1iqfzZb6T20cesVptwyJHy2QNpFftXdpiNRDpjjYCIQQk9v9lTVwgXBKdJi0ixaKR9dHR9BLagMnaX8ZvFdiUL5cVRs1SRAmi04zL8SCm/owPvDjSc8Mo35Z8qqptULix5O1H3KdWignNOpWeFEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047658; c=relaxed/simple;
	bh=t+ym/opLo6mfDQnXsG2uLVcUKxmKwOvex8NynllbvN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZuQ/MKj1UvfgVe0O0U7B+qDBkDK7x4VLNcXnrP6dEcHb/Ghn9LHUij4916wt79NOpTWHP19T4xJdIMqTpDzwoWriU1j8bD7ePnOUSJTqrW1UFoIAE9Tq6rc9263GZErGitEmAstL94nH9yxQmFH25Z11QaxLJLYzPFkR7BuCgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=DRoqQoLH; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="DRoqQoLH"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12331482b8fso1523691c88.1
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 18:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1769047655; x=1769652455; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNruM5AAazPVdzrP4iDSGumpoyRXNPwCc7bPrEHbcqg=;
        b=DRoqQoLHqPmctOpaEQ84jHV3OWUblWTTtLsl/SmR3QuxO4GWogXgizg3RF/CAfL5SO
         xx3DD/Uvs+v1egQwtCdbZJQJHJzKkL2sovL4/lIhey9rNX8sqrFdByGBwCtU/Z4ni3gP
         8e7wJy6iD+ZkBcoePLyvus1frzIICUnPEPnlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769047655; x=1769652455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WNruM5AAazPVdzrP4iDSGumpoyRXNPwCc7bPrEHbcqg=;
        b=Bo1z69UQja/2Fr3nbD1RgwUfsYHz5qo6fSLjap0w8a1ViQEmQeyUfAtcqhrpb7mxjM
         TnW7Qp0M9UkITHiNSaIo8vQwq5+t7RPbRVUntduoFmaGGP2nT8MnlHtCFd0OC3nD7xWs
         tAXjM1RVqIxkgPUzqTzdBZe1VkhkFw8luVkW/EX0Y5nxDnSLSn9iMX6IhJPz8AM6bsgS
         TOGvkdOW942+dbX38HGjYK1E4Uz5YhdAPFOGVLgAvgwS2tl+iyqpg2h19VzCN6IHAZjH
         fp0KKng58iok8vsJaW+6hXeAsLe4uKSUL3bHvmQzVCS43BYXfHGs2owvHx0mL6tstm12
         epVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7CbFKNX7eoRgfHaDEAebQowbPIRk4tX2KVf/CxbaT4EDDn4YKBOPiOvDi5MnSOySP4teEP7sk@lists.linux.dev
X-Gm-Message-State: AOJu0YyfozYfmgtdYctbas8otueu5y6om5VXeJFT9a+3jmdEiTU1VTbs
	dtlq60euEJ42wPFBid+pQPP4Ixf+0pkgCby+1yrqtC4yct7ZSkx5yydwGYHEF/mJng==
X-Gm-Gg: AZuq6aJngsfqPzUmuJr+K+z2qOqwfyWW1mI6sP9l1LPFKLm5RSHJ3DmEng0FCF05YTq
	cnDsZtHsUjMh0CT6xUtmwd6WvwTtZwehV3DyjBvlW9dTmCdWQWUdz+P8ZV0GKYvaE2Z4Op16gT4
	2JAIY2oAqkp0eE4Xo8CwV2E7DYAx1dQq0bzF7sMIN2HUQ99tpE3sqxtqb5X5pvTVZcL7wrtEvhP
	pbUSvF6R8g0p+8UmT7YS14Olw2JbSarnlsbEJPPlMvlKGJUtx15xFAobH5lJF04eqLbCD0Itq/W
	Z/2r1xbBXMg8BhQd9CeGanAVrtOUB8rvZsiUuSo7tE24w4kBFX5AN+9oPSjhv3hOUI1VFjLQsgO
	/LfH4VxA/ITxIJE6KYwM9nQbH77SNkq4QnU+ELXvj0uZ+u8CgNlG4+ODbKwU7ztnN5CsQxxPT9O
	nTuC1S/Rs+dBpjaryu6a1H6g+uUtY/jtoQtvNSbBE3pGU=
X-Received: by 2002:a05:7022:6189:b0:11b:c1ab:bdd0 with SMTP id a92af1059eb24-1244a782231mr14959212c88.35.1769047654346;
        Wed, 21 Jan 2026 18:07:34 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.126.136])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b70d7f729bsm7494035eec.16.2026.01.21.18.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 18:07:34 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 21 Jan 2026 19:07:29 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Message-ID: <aXGGYbZ6UaOTGuPr@fedora64.linuxtx.org>
References: <20260121181418.537774329@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>

On Wed, Jan 21, 2026 at 07:13:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.7-rc1.gz
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
