Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1C426FA77
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 22:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772057396; cv=none; b=javlZ6Ue2nlC0b0yWsKhuHVGxdhFeXJRwwxpN1gvkYA6vx8l6SGI5kYwNdOU+YTxZhhRHmseGGsd1CioeJIiMOvrAjnHaYzsh8vJ+8qLSE2GcnN/rksy1mBpsxl4YUDcr6NI3DkZzBuNY1VfJsepw/JFqJNGnwkNlbnmnYX0lCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772057396; c=relaxed/simple;
	bh=+aqDKHQIoIo8BphXqOLU6XY00maoVWIt4iFouXDlyLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPhEok6j2qjwegBBP9gbH31wifLAp+xkdYBwkRAvv9G7MuH8VBRT5hX1PN5iU9a/jAYstEKRo0of++IeUNWCEbdVgRy5TyYOaXxOV3J9xgq5oaEGBOIXWMhQ4lC+hXdRzh2GFUanB2bYSUplN95ikyV+tZGFoD7SfhPrxdMVvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=MhwoZ28d; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="MhwoZ28d"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b6b0500e06so212041eec.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 14:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1772057393; x=1772662193; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G256DX+1yT0GNxn1ErCWSygmCOMRR9SHISAAw40zlyo=;
        b=MhwoZ28dwc0wI4Jz3lTfm4dGQfvtkqcag0jRZzyKo2Up0i9n5LK05mw2JAnv+8lTLO
         oxGB1QadLWJA93yKY/Qm0UY9W/aatQlOjXzsrUpQtyIN7vx21dfR9jnfJSKsVp3wpVF8
         QTvzsbNdur5Rei+SXj28Ru6dr9RaCxjCCMwD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772057393; x=1772662193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G256DX+1yT0GNxn1ErCWSygmCOMRR9SHISAAw40zlyo=;
        b=g7pnEUk3Ymdttl3d4zDWY73qkoFA658vkCM86B7Z7Ma6wSkF+X1phAoYBdJSTTEoe/
         KyCFoQmVIHMpR9kAbrGYAy7faKzD4o8CI6MnkyeG6P+LH1L1Q3bKpI6Ag052XbfFVL1z
         mFj79sQ4X/+j0ZlLxEcCziilXGq1D2PeLKSAF8zoEBzhK9x5X0T+YczUgKC6l8CB78JF
         fwJnPP2mczC7Pyms3l3UQqfLjP7SW3xevG2mEDbotzMYpNDrJX+zmgijO4yafMD74O0Z
         6nHxG75TyZ5EhsIeFpBLO7IA2hxeCyQsTfuVY03Vbf1FSNrdH/qhXPbCEX5PhtCUg1SM
         ajqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgS8BRgkGeakdlbxoiTET3aX0ejqM6EiHBhE1PMz5rTyscFv7p+VzXxwvcBSItuZULU9+LDUuS@lists.linux.dev
X-Gm-Message-State: AOJu0Yzvqp0U6GIUze7rWuPckJttBUY5llhpmetJFuSo5GY0OeoYTyH6
	tfs7s0D8ZnBzq4i3tnPzRy2cF9uRBBusAGRwanXCZQ4wyQfFNhQ/nYaBUf0QQoG3xA==
X-Gm-Gg: ATEYQzxU5CyOXe7nFrUiUhrFQ65EId1L8LXxKBzHH+aSPEkzAk1fByZtAdtC3oR93WE
	AtDQoJ3WohJwy1vi5Chi/AewP/fqB1/1aTeHgk3oQKVCjahetLwWHUV7sYF77iTK71Iofb6qh5t
	xSiVf6DBIQoLXqSeUBqf9dd0OlJc3wfnQqtCB9CslcXNn0k2K8NlvV1wn6ldg0gSmkAx9wg+G10
	HQgRNm0B8onMd5mK82AZ3yXdEVcSrkJ9h1T11GH/V75aOS2/+BQQPgkiucJsw5KNbO2tq3HUKGR
	/59kpBl8yPtO8WRbn5lIwEm9NuGSO43yKu/UV6cGR17UXUsvFsyt+S9G/HDfQTriOiemfu5KDaL
	X/Nb8qezUlzgFkRupRLVlb8Uf6A0Q4kdas56i4Hl9miS2P4iNI+s4UMDnyFOiL+2dfsyHqbvpLs
	gU2jMUHGObr7+IFbJFSNB7+52+pVpSQT3wibNnF/+wdBXT
X-Received: by 2002:a05:693c:2288:b0:2ba:9cfb:2744 with SMTP id 5a478bee46e88-2bd7bd3a027mr7903431eec.30.1772057393503;
        Wed, 25 Feb 2026 14:09:53 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.146])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f23c3csm304755eec.17.2026.02.25.14.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:09:53 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 25 Feb 2026 15:09:50 -0700
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
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
Message-ID: <aZ9zLoO44ER0uDLx@fedora64.linuxtx.org>
References: <20260225155341.094945851@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>

On Wed, Feb 25, 2026 at 07:54:11AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:52:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
