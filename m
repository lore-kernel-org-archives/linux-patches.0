Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C813134B424
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673247; cv=none; b=sWX05P7pDEmB1AbScAsgLjJosh3/OqDHvgUYtKPG9GHxujgpFa0CLFlp0L5xF8JuSPB0tIGavUFwXFKZC9pP+Undaviz3Xe1fNNFhICdoSNCiITxjIOeSb60r6wEh8Qfviwv5pktZg8uh8thOIhHg7XbwcuupXtqF7Ilw/Ghaik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673247; c=relaxed/simple;
	bh=k2oFcW+F5IbZatog7pgx/F1s8i3ixYSpqpoKtIdHFps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhDeoGUS4s37MxYhL/KEnORaKL34oEXFvTEHmO1yXCekWO++O3fQ4GIGGvCWLHlNPEwPViyy4SItDB5gNVeRWOiiFYEE0MXtsEvFS4PfL8LINJ/iS355v4tZjqPUQEf3Ch33tsubLwkmHGemMJmodnMmcgygSo4NsYLXyy8IlUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=New6MQ0H; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="New6MQ0H"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33bc2178d6aso4604422a91.0
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 10:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1761673245; x=1762278045; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=luiyWuiRrVRfhN7JAiac9EdJ6Gfejadf8kzjmyI1PuM=;
        b=New6MQ0HgPeCuGaP+ynSTzPzrhOQX3Yv3wch+ueGr4VIXhAg+gRT0/UhDSOWOKb5/m
         DpgwrhnvO95e7vlziIEb03Ch/0yoYD8Fgn1CghCLyIqCEmcF6TEk4+Uv2zdis/HYycxn
         A8xUrGu5EfalPcJaUHK3ZydXuS8jPJJhn4UVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673245; x=1762278045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luiyWuiRrVRfhN7JAiac9EdJ6Gfejadf8kzjmyI1PuM=;
        b=DhwtBAfLNevjtifkk+8yyULnbNpIJJ81pEHCsqY+T7kLi5HTJcylYUe1VDqKR23cnh
         A9IZjY0wpBlz9bFp4Ah1zrriVBY1j23f2TffZamf0nycAiE9vsxZSBsRJc6ZE7GTnTmo
         L2mPV6cx4qMZgAv3rJmUwal8W7b/spqdbOnNs1e1MqtoihNc5IM5JXesaBQYDrKxeLRV
         nB99Hv+Sme4H35etNY9fMDSdmbf/OsJY4bfIOHrLTHN0H8ZtQRg7MOV7ewqpXVqTGo/E
         zlVdTjs1M2CE2kSwayIxa07WT5KO0H2Hu1aQ4Yvyl/oGx1wRi89pIFdlqMmlG4EklSTb
         GWzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6fRU7z5VOIn7hyKhb/8VDuXrSp2OkF5qm2WNSHn82ivdvcC6yF4s1hdW08kEoQGBIi4WYQF9z@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi0N1SuVOPacDa+eBAHEzeHXVni6wTRpsue0loiLKYcmHvM8t7
	Gqc89v7vBI4mOohRJXA2pR1L+2KoTHrEBeSvyxVNlZtmApHBiX7HEEEcYUqladTwiQ==
X-Gm-Gg: ASbGncthp1Xy6vRGlNrcDYYd5DqpH/yyBKfdbPT1Bkb1pBA2JXW1aFzP4bQe8UGm4YE
	XLTYG6Uc85u5jVebdSrtypZoB8nQhhkQ8i/3WTz4Xz5DgWfmcvMyuh+zbMon7hL4rysjd3ylksr
	Izzy9W9jypFJyzNetoptLICpKyTVWadlR0HOCtnf91P9OfTeZjp4uzLV1nLmoQC9uAoxyiGZObG
	JoWoIa4Pfu/P5pp7+enYjG/g3+gS8rgozrz16NMOvGg8zI19xSm4yaMRO4hpqzNd5Eto8A2s4HH
	aeEzukuw2AKY4whpzNrEDKINtz3myBKWvUSIZj/vr6DXeyGCAQMHDvUmT6YVPafKtQ00Q0ApmAg
	XzxraPPWOii5/Di9aoBds/7kjHdU+BSkBbkqQIkglAOx1IgdgDioxMMnoOeerwvuYaRnZSJDutF
	Z+VsXsfM/8rb7Y6PAzAUwD
X-Google-Smtp-Source: AGHT+IG5V4vsb7CrJYMRIp5V3RyRMADScln5MWpRKhmnO7Ie2PDaI8M38ch/Qo6ITFZL8KyPH7+JlA==
X-Received: by 2002:a17:90b:37d0:b0:335:228c:6f1f with SMTP id 98e67ed59e1d1-34027a06cedmr6107636a91.12.1761673244857;
        Tue, 28 Oct 2025 10:40:44 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.125.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed70a86fsm12863100a91.1.2025.10.28.10.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:40:44 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 28 Oct 2025 11:40:41 -0600
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
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
Message-ID: <aQEAGdx7n9tjCu1v@fedora64.linuxtx.org>
References: <20251027183514.934710872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>

On Mon, Oct 27, 2025 at 07:34:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
