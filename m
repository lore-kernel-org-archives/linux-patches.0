Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956523112DB
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 21:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755637895; cv=none; b=OiqSeigEspOteIE4cNBk6vLXbDICg1UXjdPWjgKz1+a4hpRgmWhQFLh8qTn6Vm3ewqCye2Z9EvTTvEOOVsLZ8qRTeduWa5h5xY5BzxiQMr5ZvLiYW2y4XurTCzlYc+idOFNc/8wZ+6Q5Jah8EWFwrx8ZOduLQRth7kY/XgI/VOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755637895; c=relaxed/simple;
	bh=I/3mWa+i3KERSamxNOpw1Jf3cJLvxbsmqYH+/Lbkfpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYkDaJF1UHjDJE38Yqqx+8xR8ybQuor/Kt+zAQ9nb4YsMEjgtsKN5Z56fueiIgayovZ/zOtoCdQBgXCzuVUjdzOgkIZE/CD0UpKmUNUatBbROMJBy4XwL9w2xdQ8Iby9zUfQcINS/tMslNroKJ9Z/tdDVbdXeZNDsQZCzWsoxIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ELVNqk2w; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ELVNqk2w"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3e67992b343so4084265ab.1
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 14:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1755637893; x=1756242693; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8q+y1CzQiuYlKsWREpLAsdkMHshX9bTedI6C92fr3gY=;
        b=ELVNqk2wsc3KRgXPm6wd3zmKny+BeXKFp1iVbu/7XRLlOdT+oVlpo5b+nTux8kSwo7
         e1W6wlDJSUGRqtCwNbGr+ccoRxEr1falktriaTYI8hBth3WFupAS58EtReHPiVXLUk7/
         /vq0Y5oCUVu5EsoQLXBOuTjLstAqqOCr9FwpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755637893; x=1756242693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8q+y1CzQiuYlKsWREpLAsdkMHshX9bTedI6C92fr3gY=;
        b=PYqOeAKmTQYHLZQJGXk9qpQ2lf5bEPKPgpmDidZ+HFaJtFTTsv6vyD12QZLoIGD7nX
         4fxv/8COxLQKoYLaSL8pNq/+niSwS9hXVL0MPsorzn2rkuVqlluZHY6VNSZUFByEcpkk
         0ytFhkV1Iw5yCYOMz46KUugjEWd7b53oQyYh2sZA5D6uqwSjCNcf36QtbtY7HOMGcANH
         gvCOh1npaJco1LHvTrKEo4+z2msmezlIwlKuArKJTo/4OXft3A/VRsPdhhyWg24Yq1KO
         iJM0WygKzvGoA3cs5dB9N6GQgq40QfCvK5Phm97290SrsgN5/IKqdwUymu6N3TXUzlf0
         rVXg==
X-Forwarded-Encrypted: i=1; AJvYcCUvi77xxmIlnDcUjp/2Hb0qeq98QHXfBzqBMETBjM1BcvTF4H8sNF23uIy0G2osxMcMVNCKwzXf@lists.linux.dev
X-Gm-Message-State: AOJu0YzUAWAlwzsTJzhgS2EnxKSNwBWKE1Dtm2ehImLr4MhgLe9YjGWd
	IDx9Yg/irf3EvUDPAdidEj3+rxlSSNtilITRYM9goAIKqVap9zmXRAelxO24RQl0yg==
X-Gm-Gg: ASbGncskNbsCEEhzPdxeENGh5Tnju5tUuXHneDz62s2E0NtKwY6KWCOKxsxIEqMoSlX
	BOfSzHSPG4EvskMLRT9TwbGt0armwbmLzBPAlyOrxa8IY9b8j9oo9LbO55mtqjx3fbB0cP1kIrY
	OOcrbBh9zZ64HOvRc3coFcs2fxrnaSYttOQ9aCcWeBO3fjDoRHyqmlOn+L9u5p9IHR2VoSemjbo
	Ug7RZh9IujUmA+UBhDnZTyffWuvLDAWmmUxcI2hGcnCP74Pa1IPQpkXM0ILGCUAiEd/hvG7MX5U
	7xSNhuFcRmq/qGddPuEC0SfUThzepfSdLr/1Z3EbYOmxks8g3/Q2tWWS5SmtWm2acjwPPu2HBC5
	uwrPE4vP54MehkO1O2bhiH0gTA+lND7AaUhmG6gHbRSuWGZDKbEM=
X-Google-Smtp-Source: AGHT+IGTxbTK35PyIo/Fygy0tLFwzQOJr9aOpFhZb3m3EzsvuRZ9OgR3OsPMRlr1RPLn5Tpib1E+6A==
X-Received: by 2002:a05:6e02:380b:b0:3e5:62a1:c9dc with SMTP id e9e14a558f8ab-3e67ca67d91mr10240565ab.12.1755637892657;
        Tue, 19 Aug 2025 14:11:32 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c94a2cca0sm3719083173.86.2025.08.19.14.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 14:11:32 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 19 Aug 2025 15:11:30 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
Message-ID: <aKTogt5fSaCpbeZb@fedora64.linuxtx.org>
References: <20250819122844.483737955@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>

On Tue, Aug 19, 2025 at 02:31:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
