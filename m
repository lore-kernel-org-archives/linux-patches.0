Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com [209.85.167.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8DA1CF96
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Z4uRCyMc"
Received: by mail-oi1-f195.google.com with SMTP id 5614622812f47-3b2ec9a79bdso3141508b6e.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 11:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1701113775; x=1701718575; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1IRooEsUin5INdOJVJKOU/vU4IncgxmhANWRJafAQM=;
        b=Z4uRCyMcsClJt6bXYkaRFqb2vqE1VXvRAnvoB1Y5cHe/i6NWQXrPXRF/3/NcBW5vKm
         8agMeD9BjDv6V/LHlAQ1OxF/sqaImphoFsV/KDoO67ueLXz7Q1LcRVU0+jJov6I9sPlv
         A7Par/HEeDDbSS3jb/KbQy5RDaaRPH88uCnzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701113775; x=1701718575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s1IRooEsUin5INdOJVJKOU/vU4IncgxmhANWRJafAQM=;
        b=ATetDCtt+nZMk4I70nWP0WvjUvBieE/wyp/SRHXYDh+vx4fpOeU9YEhZoQGDKZhmoY
         kBedKDHvKPxBiuCicfOboGTgGgVXzm9N/tU5Crc7BQR74xsmIt4ZBh8wnzArk6KVjVg/
         XPSlkLyX5HzSpz/QSqZQzzn3SGAsgkFB23C/XFx6W+oZ1YTK23JHcF1mrKL1cIUXAQJp
         nkThGM1mgr0NW7czkiQON21egTZtYqGY2PGyCk4/tgrfRJenp3I/wS2Acd+vjG736YZA
         Bp5fttZnpFWwEu6yuhZ31P/2LIDqzOsH5YZyjmPLUxFAeS29RLjxmwEjyCyfCpdp499V
         1TaQ==
X-Gm-Message-State: AOJu0YyQ/re4ruAcejWBqd7i91Kc7HqFKjOg3Hsg+HYwfPxCiG+kVVRI
	zAsWLhnKKAeHxovolePKo++H6A==
X-Google-Smtp-Source: AGHT+IEJ3WupWcdW8AN5qBBpFtWvb9iXJuzI4F91nYX9vpETnliJBN68Mz4orAkz85eSDwTlP02vkQ==
X-Received: by 2002:a05:6870:6c0b:b0:1f9:571e:f80f with SMTP id na11-20020a0568706c0b00b001f9571ef80fmr19132032oab.13.1701113775612;
        Mon, 27 Nov 2023 11:36:15 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id m2-20020a9d6ac2000000b006d81feaab3dsm521897otq.69.2023.11.27.11.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 11:36:14 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 27 Nov 2023 13:36:13 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
Message-ID: <ZWTvrVH5kSM-o5zE@fedora64.linuxtx.org>
References: <20231126154418.032283745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:18PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc4 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
