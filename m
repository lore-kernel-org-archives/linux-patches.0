Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EAA4915B5
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789048325; cv=none; b=aVihZb2ZK/fEurTCLg0Q0Z+p5Hy1j+QlzqOCaNEDRjXKATGIdsZ6Hd6eu0L77Sht9Ka+VShX9lNU6mYd/XzWPebpaUtkiEXSRfB6tc/L5FZ1vnKX0QBg1GI7VjcOs/KDhcAyOtGyGn3+lEfw7XSVsSJyykzthK9gkTazTDNcCjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789048325; c=relaxed/simple;
	bh=QlSh0lMba9S7x+7oC4iH2LRXRIl+WzSV8mlor0TBLPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aa9jUp13x3Gnp5x3XvlpZtKniDvt9VKdK4PdLDuxCHrITAMEwuSmtIBm0dOCwMie3W7ZsPEyAGJTut6D9PIQdIaYYXdaDzQ7vU6ACMP724zi5gK6IFPrg+nZIewY81Mdbr5AeqRtaBUvLrj/iJ3RkehwYmTvcsnFfrPYUNf5jfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=PBx4Sy7v; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="PBx4Sy7v"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b568dae0e8so965195e87.0
        for <patches@lists.linux.dev>; Thu, 10 Sep 2026 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1789048319; x=1789653119; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=M1fkFxR9UHjQTFsOht+nEf8zm2sZ01COQeC9Wr8GY5w=;
        b=PBx4Sy7v6L2OpT7eBXsmLtlQBJpIqNQJMYoUKJZ9fCnPJOjhHDgN9FdUOw2qYOWO0j
         MzNIhtb+CNfGSnuGYDU54lLYPuhqgYdW24E5NcfHv7Azn33G4NJnvxoz7pxT0myNS9nN
         RGVZIZCKP2jjw0bjss6E8IUPCF/kyRwxfcJUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789048319; x=1789653119;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M1fkFxR9UHjQTFsOht+nEf8zm2sZ01COQeC9Wr8GY5w=;
        b=X2vEbEXa00MZJLGAidAGv0jm+flGEZbDQC5DYx9nN3Xp1hTg9k/5dBCztWNwX5E9SM
         lC94hxN46OSLHX+wdAA0FZiK1XUecNAeT+eENaokCIA4GZeBpo2YxD3OXO9c5z+Ig0Rt
         R97lfodJXb9XjSPUYhhvtWRn5LY15tfDJPWGjNzSXxsb8bm0KCiSzWvC1A5Hh1PMAcsp
         3Uppjt3fay1l+IlgjUDx7vUvPg7itNX164ktx7f3UuYIBMaJoPTbjzfFyhXyI6K5ZYmb
         LbP650ebJqrooWnIKnCZpypg5/gOQbZDh7diqwNRrEa2J62CVeeJW34Ts3L2TPVHJpIe
         2+dw==
X-Forwarded-Encrypted: i=1; AKwUvBx66KZhErDi/G2IycQG4vqxTUxBN1pKGp3A8NIBu+jiLzVwSUPm3VFMK3FyZjIUzhcTxDq1QK+b@lists.linux.dev
X-Gm-Message-State: AFuF++lrOlX283MbIgnOGm8LSTi0hlzZESUbfwJZ7jKl0DhrGuB9jw4L
	lyN5QEGSfpAyijb8lD6YxN3jRCoHH0VupvwPEJn6g46nqRtSSHWDC/wbidR0nvAb5Q==
X-Gm-Gg: AYBFou2dzHPXbM883o1+e5cbL91HG9hRoOcKFLHpmOgJ3ab2tfH4Iw89k0gOLx22fME
	tOrlFBt/wQeGL7Uspw9YmCZx5GvncxXQnoWrJvel0EDAjOTpJLl9KmT1Jt69SxY16wdmkE35h1Z
	rzzCjDM0kD4J12T70yjcILUBwvF9Ajq5afWAlDRfooKsk4smCuQzOEoXO03VRk4GyMB45lORoe8
	BeC5PfNTLQzegU+/ZDc0pLV6xwifmX5u5OiU4iAqKNh0c7ujsT96OBxRSovKgjVpbU4qwudX5mI
	by4bfu+eR3nAOGF2GX4eA3FZCb5HeUXm4dC1Wvvn1SaB3CyozuLwAq9BS3rbxc+VtE5v813zuB6
	BJoIYyfxHyjqM1egaXDZqJXD2EhvRav34fzJ9rZO9a/BgQCdoZh/hCB/BjnhEe9sXrDDVucqkFc
	DAOym+F+QQU9tlVjmWzRVQa5hWsFXyz7INeUUIakYZLg3wFO4z4jFJOMc8y3uo1GVwmjoKur1Fv
	vICeqI4ukksH6PWUYCyDY8jxOE=
X-Received: by 2002:a05:6512:b9c:b0:5b6:1a7c:fd87 with SMTP id 2adb3069b0e04-5b61a7cfe93mr6974483e87.45.1789048318560;
        Thu, 10 Sep 2026 06:51:58 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.164])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b6167027dcsm4473627e87.58.2026.09.10.06.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:51:57 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 10 Sep 2026 07:51:51 -0600
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
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
Message-ID: <aqK19316rNBHIHg7@fedora64.linuxtx.org>
References: <20260909134230.441546314@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>

On Wed, Sep 09, 2026 at 03:34:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
