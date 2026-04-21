Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E626ED46
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776788148; cv=none; b=DrSBcxeRlLfDM3Eym9Gjvx+wC57PBkncKemSW4qDCtbssnWXvETymqovmDG2DK/pQNe8OEKMQLQ+ztpw13iFQ7p77YMtp56MRqNCfm09PaMcVK5SvkjBzzHvqIvQXXpdeunEmkd4MaKMMg4vPSuLr8qcBWcTumuj6CN4uFKaQD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776788148; c=relaxed/simple;
	bh=kLF2LcSyU4zJ+YCdge4/3hLDrdrELljSrKYDbqyHqj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PM1v8kvWlZNqmwT7UKIww8Ghfb7gLGbskZD7BVYWC17UdOgIs1Bybjsuj3tmjGM/WVd0OQNPjwRRzaSn3Fry6hbD/V9L06vSDuzo3XP+vZKHQLRbTp6DrqLXps8YW83xMJ5UWDoAfecDURGfK1XT5XzD7KIkl8SaRq8uBYrT7qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hGIYN1NX; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hGIYN1NX"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12c8c9c4cd8so1126475c88.0
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1776788146; x=1777392946; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A982EMvWd08NRtGResjdhAZ4Rp4Rh1A/m+2DTpYS8U4=;
        b=hGIYN1NXSiJY9MTSTBSymRBCyo3ELGXqst8I8b8F9eUmd3at0ToBVfoJUTwj7AlM7s
         ahJh+80l5HqJZq22oPj+n08gAzco9vyJIqB2JEF6RJr8JdWbyD4b032RV5T/+cd4rL1V
         io9wEd/Ip/vBmzu+YkRx8MAZmwu3xkLsW43xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776788146; x=1777392946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A982EMvWd08NRtGResjdhAZ4Rp4Rh1A/m+2DTpYS8U4=;
        b=mOg5Co29Y5NXXhOiYbBDkvqTEXMmxkPlmm3Ftq7plnp1RmxgJUq6wVXrEx17Z/1Rao
         CgV15RKl3fATd51RKrJLQn5vE8XWXsXvECSawBIrGstaHod9YA3nIm/zR9dd5+KTL2g0
         JXPjVwaWB+j/3xZ9GN74FLhu10UluVMGmjcYqVUlxS1K8J2FiiP5gs+BW5wuSHPq2eAB
         TFLz3loT/bnYi/glhaUQJA6wtwRS0aQ5WBuK+fSNQk0Af6CtIZByBUNCjYk2jnBzAK8e
         fnD+ja+BdlEmuXx4h0Fs1izZiXcgzDrpZOWhtVewTGkpZADYjb0bPMPGBahEwY2Hgzzl
         vumg==
X-Forwarded-Encrypted: i=1; AFNElJ9bCAtkzynjQRx6bt24Rc5AmRLzC7Kcl3lNzx/eAZXQqaAWiuPa+GgDKjxjKiJ9J4DLurkQyTHc@lists.linux.dev
X-Gm-Message-State: AOJu0YwZjdCpXqus0jPPR6d8vi3P1c/AJYiwSs3TXEkKAT0wh/OntSvt
	7QanOdcwOxfH6eOj5p4X6PL9+JV+WlaZzr7ByE9v5CfDiWip3RZdqhJcCfkDVzfr4Q==
X-Gm-Gg: AeBDietpYe4bU7Ba8NYLKZp1zchAtudvvUiPKeRj6SMS9Qv4aj9mQElQfoVK+oi/dKr
	ePzsrBsqTuHJVgRY6S2GHsKje2cviURpRc5XTE527GLA6LVpSnAf6/N1X6GNgKK3oCXGp5zMvZv
	tbseZvST/wo2eqvVuEco+m6X4KuvbkpY0/7m0cPmc52oLnKiJO8T2POrLUahqQ/s0gbJdw1ZuIm
	VEv0Adm90cnxFMmgq+AhOCLMdb68kHOmcpVt1A5DA67sL7w2WPjd3ftl6wc/JtpwAeDeY2pYufW
	oIZkQDwaqeNAx+IIKvd27dj8BJ6nk9xfPvqkRl7KbCYRbFxPH04v99Quu21Poyd01RsXc4eqWZq
	V2t7mI6pVS18ctO8DLYhl2/e2HuZDJGyN65ghBlqTNubPa1tVAw3FXB+ofQ+xXF9xSC44ElCuc7
	mVwxAP6GttBd7PcIaGsPCh4tY6zDUieHnQmAxqImATblU7VNWc+pN1
X-Received: by 2002:a05:7300:e12a:b0:2ca:bd22:6102 with SMTP id 5a478bee46e88-2e42e200939mr7251603eec.14.1776788145693;
        Tue, 21 Apr 2026 09:15:45 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.127])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53a4a64e5sm19528239eec.7.2026.04.21.09.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 09:15:45 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 21 Apr 2026 10:15:42 -0600
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
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
Message-ID: <aeeirvNl6Ia7yFFp@fedora64.linuxtx.org>
References: <20260420153934.013228280@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>

On Mon, Apr 20, 2026 at 05:39:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
