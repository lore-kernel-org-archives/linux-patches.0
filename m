Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E857F136E
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 00:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745021647; cv=none; b=NEsuZf4HUFKms2Pa+wsG5jdpPyNR6v5myKM7DWp42LBGooH4ZQrQsm7B7VlshIQ6FZEpRLorB7w76qZ4+u85FsNccwED9P98BTrjRAPZlnr1EYImT+El6NscFkxuCmzjwNkHc6uVcA+76+1BZ9EftWnya8/85YWxVHtE0fdz6SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745021647; c=relaxed/simple;
	bh=yJgu/Dhzu0IBN3vhc2eYs63bBunMr5TNjKKesXcVz50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xzv0qqJb4sIBMTwC42zpPhv02UzlaftBvohiwO40WpdY1eQAkSfAvn4266VGLlfurwSPSNZqQ2PA28nP0Lxrbqn21lVn/WAS2AE1pPkzCAHMvCx1ifD29oFIimnd0bJIiPHvb/y1RwUXrVu1/pKNUhc6bDPoF1Mhhb8hVuTdv7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=KVOyGAwH; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="KVOyGAwH"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d900fda7bdso673785ab.0
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 17:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1745021644; x=1745626444; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pOeVBHov7VKB5DDUBSqDYO930hNH61XeY5sxFZIOsKI=;
        b=KVOyGAwHVtQhDNoBxjHYAwNbM22sVwPtGB+kbuAvuj5oqsZ2axMPAShy4S9gYl76oL
         7KTUAkPK0VnUJcLEcxdIlVYSACrHYmLBxf6fEeIga6F8sLUkM7HtGneJSsmcGqZ3cbaw
         TL/2f98tlKs9ovHmK425iaK+YQC/5gY4iLDrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745021644; x=1745626444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pOeVBHov7VKB5DDUBSqDYO930hNH61XeY5sxFZIOsKI=;
        b=uRdKQtPMzCtxmeFhhpBYUJ3kIuKElJIMhmyqEdniT2JwX9fN+lfkGUT0Q6s4+bghzq
         pgkEanr/eKVDWln0PK6WJZTiNpeavy7x/1OF53SYKP4t9RdUTBKks10eWcmpUrjAGBQ8
         Cme41AwGOPuWahwNnCE65inST/B3Vv1gRP6Ip7FK4gL/cwj26DqvH+jRMax1F8DGLiVm
         NPetEyFbd/oBUzbuwYeRbiJhqorbsD+M237Ya1uHxVVohGUm7QoiuByay4xAtDD7IbQa
         z3kWIKIIaa8+tjaDeEEo6GR5+xuPyNW2FuTYDz4Z2HLTqLyqi0SeJZ8wg1e9QgUzjS2d
         yvTA==
X-Forwarded-Encrypted: i=1; AJvYcCXTj208Y24c8dLroSM4yg/yA6st0wga81ITiv3QJo/WvXjEfcYtfMnRTsb151468oYTXPnKiD1u@lists.linux.dev
X-Gm-Message-State: AOJu0YyDAFjd+7u7WqG/DIF0EfA+5cbqa21PaaDYIEEraE79sd4b3O1b
	6kgCcydMdJBQqKE3m8jckzmetCQ4FoVyLkAleGETNLdpoJgwMHhNjRTBz1XBSQ==
X-Gm-Gg: ASbGnculmyZmaEc8H9d8GmYU4NMec3lLHCg1zzev/kIPUFd5AtxzuCAVxEWyBLA2QOt
	8qRBRh4Y9+pGoSMN9PhpR+V3BX7dnlBiESaNJj23y+D8VH+j1Xh5hqaK88fGsSUNCDY13G9I6di
	XFPM7rmWw/KX2wvdklRmkTZBmoTKHYq84SdIBhmnoFCInop642+9es2AKL89yI8EYrUU+N/e4k9
	sHvFIf9kBbcXqq3OLcrBHyw/6dED5oBXQRPl7InkQel8x3qtuDx5vrZ0WjKu2bG/yooY89GK7ch
	iOhlvIvQZK7QDRo5VUkc0UT/Z6OeAlA6wZI9PqdijQuHxr7Ns7vYyKcYxg==
X-Google-Smtp-Source: AGHT+IFOJCeVjmoBLR8EM84DP/SEvCgRXJtSxJ6KIQXOM7wzlmTfsBHJKFO0ZpklJTM30Nv0Ca+1YQ==
X-Received: by 2002:a05:6e02:1fc9:b0:3d3:eeec:89f3 with SMTP id e9e14a558f8ab-3d88edc338cmr41184805ab.13.1745021643992;
        Fri, 18 Apr 2025 17:14:03 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37f934csm682098173.49.2025.04.18.17.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 17:14:03 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 18 Apr 2025 18:14:01 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/447] 6.14.3-rc2 review
Message-ID: <aALqyf-hy4-_K8f5@fedora64.linuxtx.org>
References: <20250418110423.925580973@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418110423.925580973@linuxfoundation.org>

On Fri, Apr 18, 2025 at 01:05:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 447 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 20 Apr 2025 11:02:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
