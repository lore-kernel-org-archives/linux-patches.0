Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E360DE9
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712064758; cv=none; b=r5+nD94Dm+acKPgEIsuu04x6ddqKSzqJMk39IeZOJu0YlDbc3R14dog4q2mYZLV9zoIzLm2sf5lm8Hrt0re1ywwW0OI67HFIqX9zE3hB0JotRCPhSIMwCnWXbeaI0HgchH/L1NP/HFbPiZ08lduXRFx9LpdcPiugphEWLK/GiAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712064758; c=relaxed/simple;
	bh=bYMjyk4hxADDHJfM0n08rS8SVAMEDwCn1gh7K6kIzjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vx2UgGMHYTowJVg4b/O/UC6gGPQPkekZJWEFnpebfV2janElHR3yEP80W3xZHrfCO2GB5RZGkNPdlQ6cKviPSQFRCNqLTO7PhFB4EfgvUCR6WqUpCXLQUrWyw4yq/EjUXv/Sr/yRdvWjado8xYksqjdFIQq80o0Hkj1hmW9Hq3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=KOUSOkoE; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="KOUSOkoE"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3c36dcb305cso2151850b6e.0
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 06:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1712064755; x=1712669555; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rFk53LgoUmRncPhQOHRWVLYTVzn8/nw+iy7GK4q/aeM=;
        b=KOUSOkoElsWTTW8fQHQBRmnSz7NpxS03eMrR+T9VZ+phL3+sgmfoe3zZ4nPABuAf+o
         DpFjokZlGS0W/yvaT1f+ITTOalEg5058juPEAB4+mj5iPYbmOSCaJydc1Ve8pqxY4z03
         /IHSLq5ldnVd+Czwl+kJMxeX6KYD5+01IzYu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712064756; x=1712669556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFk53LgoUmRncPhQOHRWVLYTVzn8/nw+iy7GK4q/aeM=;
        b=hGe0hzL3YmcvbwnuZkH72ZwIqnwWlpkuZDJRxYA2JhUXt1sufZlNExp1Hq9PXemqyu
         /H7utz3Jkdz318JfwIURgRGX93TTIYif5BeT0kyFtp3mKG48ZFOE3XGTr7J0mqb1sYTV
         lb40L+2+FWI3iawSHctW6ajUgRA9Tvm2occv82hyHiChL190NxUvNiojjaI5HpgJZNat
         nDacBUk4joQ4o5NwwoShEKEjxsFeU3oeItbg+2ofwxpSNhW2HVlj20tQeY3jxyfCweeR
         JIY6tWoa9SYg1eaU0cFpLQoBoGje5Lhe1T7TtTMG1EF+xA9Fb2gslTRAtsxQHtKEpedx
         ARkA==
X-Forwarded-Encrypted: i=1; AJvYcCVnlwg1DWjvZx9qkMAew823CG5i0YzK2JPKccdlBZecRNmTLlhUbS4nGR9qeHwCQZy8skt9VF+IWL9z47BHPRCJPEJ5nCppyA==
X-Gm-Message-State: AOJu0Yw8+d5DB4ZQ4bLQUfosHaydY2YY+J5XkesBJB0OlXRFUG8T5wEf
	lheqVGmpIUO+IPzZ2TQ0K+QMvBCaYb8wOsvxKl8KKRTkeVLXtAUAdnjfUu3xCg==
X-Google-Smtp-Source: AGHT+IGwAyzVLBJg6cCeBEnPPvIFGhOsxaFmkiLKmxkHHNwNG6Xh7kFK8xRSsAXbk5e0fkCkA1YUzw==
X-Received: by 2002:a54:4788:0:b0:3c3:d203:2081 with SMTP id o8-20020a544788000000b003c3d2032081mr2609629oic.8.1712064755686;
        Tue, 02 Apr 2024 06:32:35 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id eu8-20020a056808288800b003c4f4873bf7sm224576oib.29.2024.04.02.06.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 06:32:35 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 2 Apr 2024 08:32:33 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.7 000/432] 6.7.12-rc1 review
Message-ID: <ZgwI8ZzV7OgNezw6@fedora64.linuxtx.org>
References: <20240401152553.125349965@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>

On Mon, Apr 01, 2024 at 05:39:47PM +0200, Greg Kroah-Hartman wrote:
> Note, this will be the LAST 6.7.y kernel release.  After this one it
> will be end-of-life.  Please move to 6.8.y now.
> 
> ------------------------------------------
> 
> This is the start of the stable review cycle for the 6.7.12 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
