Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00E9158875
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738334880; cv=none; b=j0qg3S2/qvvIwEX5IotgjiZ6RuNOnXUWipiIFQgJsaLtPYxPWJ6xxATqa9uvh9vj8XLIrDG3u+I9rI0WEY4nXBunbK7lVpHuwuhl1GAyclWPOgZFSQ7r9DuNZHmjDPOyCZ7hZMgsqfMoKx64T/HGgu4qDiU/QgHqr3fpT4BabCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738334880; c=relaxed/simple;
	bh=139fh3fcoJ+jnV8azA9f7I0ohKYboEntB3GaFVohabA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2LKP7CDATgKvGure0zLtZgbxrY/HE/9to0BGWZ7/ogk2CTJxW9lEnUY34OLpbT3yj6a6S/BaLKCVjiTg//XJRFpTz0i5GJPY4IBitr12T4Dbhk2megvq2QRqm1jNs1tWufftJOVmbYu/8HCsnGWx7ySrWyOc5RQ4N0/a5bvGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=R8vjhTET; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="R8vjhTET"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-851c4f1fb18so44062939f.2
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 06:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1738334877; x=1738939677; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FVsJW1ToeozcfsJdJXyb0ho5kmAeY8ktfdPcDsZN22g=;
        b=R8vjhTETwVb39Pxpwp/0AHbyuDfobs8CpysB7SnoTsOAD9QaoxXNlfy62txLhclE73
         XNqbRhb3vbqxdABE0uDAToIZFj4D3JhwbxpNdsEaRUgEjVRmX077NC2IbDUzeyuoACWR
         Nx581VKbp6pl7eCj+WeyIYZ6I21gfkT0djkyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738334877; x=1738939677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVsJW1ToeozcfsJdJXyb0ho5kmAeY8ktfdPcDsZN22g=;
        b=CofaYYlb0Niy6nESJGle0kLwExPK1s2o7lnBaMmPkp5nrenChIFIrk2d3Nn7LVGBdz
         x+LKX9fFRrZCdMgRczUYj3MdN2xYjMWshbpY1cYBqd2S5yNsi5ZLAIczgD7gWTwlNmvD
         /tMc3X+iPADersaQDR7Z7W1Y4SgrR0tJ15r1m8hlqE3zii0BwfnMWhSLT+g3BuZigoUG
         JlWIWkwtFW8vnOpbjRpnOAr1Cf5FprAQ64umRGDCLx7bD7n+xyrje+qwhaYkLAeLLnRd
         dEqtbJf+M7uOM8WaBCItgaDPsT+t7j6pI9tshBvz/6eUNG0VEn2zkfQL8UdLwqBqKSIn
         aF6g==
X-Forwarded-Encrypted: i=1; AJvYcCXTe4ixp1ZQjtCD2rXAa+Gd3LlxF/japH48wo255h27JMhT9S56hInXUWIgCrKUODVPGRReq2xV@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0/7w6wz/8p9WgDM9FucLJ6ex+RiMqp86udgVc7Z0rMsLH7mcF
	2H2ienH4dCm/zbI3W5rnjM0GH01KEWL5PTN4b2EQm/z1XjXDjXtGjcz2O7Oy+w==
X-Gm-Gg: ASbGncub18JraohgIu1sZkYHwtLPq1HbmVi0QSz/V7FKvmfACYb4kdeoFF2+M4S+uT7
	pQIhCk3ikx6mXOP24txnW+iL0ww7r284elN3Ehp02bPwQ0VSxLarCYA0OvKeGBPaLY6Lj/9bQ4S
	H0w6AvT0x1exCOrRmC0JDqOaGDup0FsL9ecPOEvG0J5XZSPx1gZB61wLHH+8Ez12yhUqI6VylvX
	ZpxCRV0egfsPuoTgWhnZF0ZFNR0UOM8ZZMCASnyiL+PVAQWzJ2MclVHkyNNYfzFXw9wkD26YH+3
	sL21uFoRp10cP4JiUidGS9sgogFgodYu
X-Google-Smtp-Source: AGHT+IGZaDTT9EUvo1v8tlEIqj3aBpmJegYAnz4Ao4RasNP2H8e6kOMiE68F/LLfpFppWu0l0DzaOQ==
X-Received: by 2002:a05:6e02:1707:b0:3ce:6aa7:fe96 with SMTP id e9e14a558f8ab-3cffe4bf3c1mr114496615ab.22.1738334876856;
        Fri, 31 Jan 2025 06:47:56 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d00a5968f5sm8540025ab.49.2025.01.31.06.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 06:47:56 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 31 Jan 2025 07:47:54 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
Message-ID: <Z5zimkDt3Y9ntRMZ@fedora64.linuxtx.org>
References: <20250130133456.914329400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>

On Thu, Jan 30, 2025 at 02:58:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
