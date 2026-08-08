Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D139792A
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786211009; cv=none; b=fd2lqTWkOpHlHcKyGudWJ6nBHbaSv7EtM3wtXkJLvpcboelY7AcItEqlK8x51jWITSI++E75MOrx6sG7oYhGN4+av+JTdRtUE13Gu+W8ksdbIH+VLGu7dIJFQTUXw34sqvrAsDaQsNKLGNrFxQfGkxMRfZ89WBa7tpp6iuiLMlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786211009; c=relaxed/simple;
	bh=mNPWHO3u8YNjRnTPnJXaRB7br7scZ66jpkkA9bLN+yE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGBP6yWJO48UbvYdOUPvfJeFGfYbGa7rKce/PbsQXrDAF/kDYwO3U9RqGk7JYzlgsuSsFclAvlldq4WRxrgWqaABjuud0hHQmEo9lptNySAiEXgVyYKtvrzc49Ly69+SYL/BzNc5kqlSWQB+yLzgoFKcsAAQn60FjmoJ0b6TDpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=iii5xz/5; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="iii5xz/5"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9309d4ea213so45240185a.1
        for <patches@lists.linux.dev>; Sat, 08 Aug 2026 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1786211005; x=1786815805; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4L9T0gS9wO3bG4LXruqEBUbaoDyDnucdPr+CTkX3TcM=;
        b=iii5xz/5eLBfcPBio0bFBUCS+GZ0uffmFd9bL80O530tUIfrjBNeiNP2eSubEyPbCD
         EzWM00w2XlgO9AVbG2JwO43UQmNXwr0tJ9ynU6GiYfOxrzXCfIszlxiXQlxEdPWkxwyU
         idUjYSbBbXGkzqzArKCMAr5zSAR03V1B+qd4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786211005; x=1786815805;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4L9T0gS9wO3bG4LXruqEBUbaoDyDnucdPr+CTkX3TcM=;
        b=ReyPdyIXOJpde5q2l/lEg6N1pXzzqA5PbHSvK+HmHz/kSxfMnDNHjL7en7Sow5kgNX
         WGXqajxOKgT20r+brkSWuIRCq4bJ2ssXu21Ykgt/ncf4XyhK3XZ1cNxwAZRfYQMiVYHF
         ZiUhhCBqyNmtx71y6i3+xXvywygh/jBhbybwTmoee0G0gCstiA3Qco2fWBzZQWeX05O+
         pftyxpFcUF6ZvvCjS86UeFaD7NS2hok6qj8Jpj2ZBPSd8nHWqadXHfoKKU9SXZZXFYAP
         zkeuuWC59TtLzVaLSp837ZuSiLurc+58iidQNROIDM4H7LIp9gGhkQC8zLhmVBXoAU2y
         rY3A==
X-Forwarded-Encrypted: i=1; AHgh+Rod3gQfgWnRhbToWjfMQRYlBpJRzhgWscY0sSx5HOurt555k5/ptPwKXBBCHdt+t3vq8NTdU4hc@lists.linux.dev
X-Gm-Message-State: AOJu0YyK4F7iPqMf2VOxV/ubFcysjc39ZaYEiphpTxyVW4gi7Wrf62LW
	+xNWmpZy0uxrTDD68c7gLDN7zWZ35iFCr6zE5K5Gt3+WxwJ3J2rheW10iYbUNuv8dA==
X-Gm-Gg: AR+sD11y11vySVGn6zGfeOriZ6FjgjecjrDwIIa7NOr5Pe1W4xRNiTIC4A9V+xuyuyU
	0BYYQ9QUnr902sGhA0Dgb/LS91BA4SU7zQcH7gNcTcN2Iyko0jYa7xA727/6rTnJLYfM5Ik0vRv
	aR9YBMx+mwZ+D+ab+Shxa333in/ZgDGL9bEIXl8ezJeXNAd2UpCd3KhDK/5Hk2kpb5q4bBwL3OC
	VLnfSjE0j1p/+Eh8h9yWf9vzQb0mYApJlO7rCx/pGTYJUhIRs2dnFB6HoifMxxZRUpW3MJ/nBD9
	8fxRpx5gk93MFuhdZSfjQE4isFBsocIrlrZDpO6RW0X/2Wi5zvPw/ku0vQrWxhU8ERf3GOyZPbm
	2M+Ar/xX+kV5rbMlnKW9+Sw50qawqq4A2boSOm0HeorIxzLRJqW0MiBqvWYC5H4Iy7mP9aFyUx0
	v+CFEACbrYkOBodLCkUFRHaHzy40zks8/OTMyJABHOg0EielkPVSYWGhxLTiGhNZsZ/AJGMC3dZ
	Gq3DQ==
X-Received: by 2002:a05:620a:72cd:10b0:932:d92c:1604 with SMTP id af79cd13be357-93649190884mr2597851785a.23.1786211005341;
        Sat, 08 Aug 2026 10:43:25 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.33])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e09dc07sm412856185a.15.2026.08.08.10.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 10:43:24 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sat, 8 Aug 2026 11:43:20 -0600
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
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
Message-ID: <andquGZSWMCApb4t@fedora64.linuxtx.org>
References: <20260807143428.008222056@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>

On Fri, Aug 07, 2026 at 04:33:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
