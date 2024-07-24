Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0AF15ECCF
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721839386; cv=none; b=eaW/IRQ3mSuxfTI0phhoAaMNGX/6x3lCgTqK3nN7AOb2AF6rOD5bdQA32xVajz0/60pW3qJNNL9PUUdOhOaCtgHeGMbEodeSoAcjJsi7obfm6el3ykLiT/EnSwFtLG9WZ7rHSTZ5+Bio5HXcCGksEoiPUAEzxUwPwpnBuafezK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721839386; c=relaxed/simple;
	bh=XnBSi4lJYwqPS7JvayepIZdhilljl7iydbSuuQDgHeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEbK00Qo26ExZQIth0ai5qpdpOz9LB1rWV+NHP9kmuQprs9IGW8OjkgXhM/b0fE9EexwNeclj+mN+ZFmbycOoL6u6BzJqha9j0lSvexVb5CHiem19f1JA0OI8ocjXcksKqOV9TlTdPLlVX9ic+zO7bC0mESaQbyXK93JIAFXhrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=anyEbsAn; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="anyEbsAn"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7fb93b2e2a3so160039f.1
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 09:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1721839383; x=1722444183; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEJs/m1LfDi05lj71qThBLJVfg82KFHAF0JSUzDWDf0=;
        b=anyEbsAn6t+FT+vdahLBlLZo1i+aPC8yn2MRIIjodDu1BK5NJ+/+rIFF4TDY+TS+J7
         jX125QyA6VDZEIYHduqy+JV3sLvtl0KFLNQwmK+FuTWdzl/ZdhZHMhuQn8hTT/nw5+Yh
         sEzJ5IBDCunDmo8OSR8VOk5tOj2ltIO7RETcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721839383; x=1722444183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEJs/m1LfDi05lj71qThBLJVfg82KFHAF0JSUzDWDf0=;
        b=DTlz5mH8nr5rypqH7r2DcKB30RsThl2wE6/14mDzMasnfQhrWL8hDuncVc9Ler8Hwb
         UGrVjOD1xrI5JxmGvA/LuIPhEXibM7p3uoj7LLQSMHhPoByh1THlxhnJFoxdYpCA3c1+
         q5KnQRtXF330a2UyQKxi+MqkFqyE5LDKg1WWKxLVGm9FXBb6KD5fiVri9ak74XML8ADQ
         guWfMKaffzVG0kpSg3ONs62qfB75o3bz9kv75+juDKl3Y3Bfb5M8oCVgrO2nLrAJs1Ae
         6u1b9FPXPRGBd3hjeHhHtCjTrTfvGPtdIC5Z8glHB22VkJq93PDsU9X+ULGh7yU2rrbk
         koDA==
X-Forwarded-Encrypted: i=1; AJvYcCWTRZ7udqd6yDBdz8zXlFBzXacAjCt3+lAlV3TWRrTHUTsv20qzq7pCq0XdERpKImubysZVRtTMss9Ofu6SaopSGo1tX0FhDQ==
X-Gm-Message-State: AOJu0Ywh+VMT01mARkzCijfm6+3jsoV8qXafuUarJna1ob94KpFpZVQp
	gI/i6r9s4TPCBToLS3FKcaevOjYPOlqPkTusQURSVrajguazCF6vUXptCK/iCQ==
X-Google-Smtp-Source: AGHT+IEOh68yrb3+/ES/BDsvfk4lSOZpn9NTCMqLMBdmSacZPA1m1SxGq6eHvO1XgEDls8X7NMrdrA==
X-Received: by 2002:a05:6602:6417:b0:816:ec51:f415 with SMTP id ca18e2360f4ac-81f7ba78fb7mr63172139f.0.1721839383230;
        Wed, 24 Jul 2024 09:43:03 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81f7158d719sm56744939f.8.2024.07.24.09.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 09:43:02 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 24 Jul 2024 10:43:00 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
Message-ID: <ZqEvFNTOyOEgyAl4@fedora64.linuxtx.org>
References: <20240723180143.461739294@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>

On Tue, Jul 23, 2024 at 08:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:01:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
