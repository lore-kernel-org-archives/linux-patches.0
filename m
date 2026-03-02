Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC312773D3
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489757; cv=none; b=ssor/i7xH9gRReKruE3cD7jNohtjZBk9UYAas7TWepxbnUi3wYEZw76l9juMJyc2KzODybkl/hTXKh4WAcpx9D7RMgigi8CtMfhyCYYF0kj04D1z1mcQZKDBX/hrFgFdbOt6mYXM03HcDDXr9W1dNZDuFO5mozlH2xzQUgRdmy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489757; c=relaxed/simple;
	bh=3PWGNQWyNk/t7DuU6EFalPDiWOaZR6qb0ZgKj5rQyP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LO+qbFD1X93xP7sUyIdc6aR2RwteWH94ZOtEGZ7L4gcMihnoLFdP4MUqQ7QjBtv9fD6J+7jVr4ufwuDPgzG+u4cyUUIUWKKzmcYWZjOdH6NMtq+ff+CkLIrRESleuvPJXocTtUPBsfTLbokDrkxE/dorRuVrKfgGz+IGeTbppHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=OMhdwCsN; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="OMhdwCsN"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1275750cf9cso3987720c88.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 14:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1772489754; x=1773094554; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ztIYWooLOO1cwWd3Kc3iHmLMLIi+yIAsGLzg2kuGjrw=;
        b=OMhdwCsN10VIDVfUvrXX85ey/bON4BhNhJ+5v9leNb3OXKmjUb8qnpSvG+7dO+hktS
         QKnpez2jUWGpGLvnzanSYfahr6QITEJGuvs4H5ijLUnfw04mEteuUjvIjwbiwqIer0fZ
         Ac+O8vkT1YVOPp8thIP2HVXX5vRoKWZ0l/QrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772489754; x=1773094554;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ztIYWooLOO1cwWd3Kc3iHmLMLIi+yIAsGLzg2kuGjrw=;
        b=s7CzPqu828NrlgUb1hBVBQo7Nwslfzmv27z3hED/jtyjWAz4X/GZJfcJes4G8gm7DG
         IZhOM5y+E3Gd0SXilUbnLTx8HU/B27yRO0MhmRs8MVRR58dS1dRviDztlwNx+2bXbYoS
         tJKp/UKEcIicurCL6oTKENSUbwL5ogab2kBYZmNxqOJh/IMl6sZLj5WmpzDbCCuGvlUw
         ApUsKLpwmp+o1XBOl5av6mmb3jb7GnGLSJu2+3nQe9NM5c91oPdPeVPovTpszEInqRuI
         ZDJZASmq0k4P4ZX1Baic3pNb8SmeNKHrmo4fP/pH8rWFVwpaj6TQh1GQIKN5HpuGYoK1
         MS3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkYkZhDmdDKNj7viEnIrIce7Lb+0YMhBp5c/PtPABuxfxm2n0uobfTVzfa1TrmvV5r5YwrKCEO@lists.linux.dev
X-Gm-Message-State: AOJu0YwWQf1P/5BWZU0k5uS350BWdKVa2u0S1du/h87RRyp2PE/PsUCT
	qOWyV3nvQoqOadobc0WFFEtdj2cGzjqMjLLO13FSK9g2kr0mCPUO60c33FBl9W227w==
X-Gm-Gg: ATEYQzyLqlPtOSG5PkB6F4Rt0ztHAFo8D6B60zFVFnZQkApaMe7rFbErfmP47f8xzwl
	TBTGSBDAmbo87RAmIVM7k/U9WLduhb3AqZar07c5khlR6VWo1GWU9pK6Tvd4LbOl8WnlZN6skVD
	CbBD60LdM6jKKnS40X+g83mpKYc10IY2U/bmb2WhAPL3eQATZPfQbx/KtLx1ugCVtxxaSlMXy1O
	HsqYtrL9z6cij7o99K5/7m5MWDQ2yZSRazN4dLcvUSPy1eqy0F/0zxyxHPzjZ38oXfMgCPNOLD3
	f9vB1OXe8R6RYPNKLAqwe5F4y0ZPd1GlQaLVLZdKEVKO3q7XPWIbQ/eSY7YlBEiG5aekvCTvtnL
	8BfW/KhYnD7TdmL8hGGt2lONgAj1qvrCfUqKl8JUzvpTpKkRmBFQHeSHlv1JEMK9ws9Q3YhIlWh
	KVnSu7MEyf5+sDarQTICwmA6u1ymBaVC7E57fRTVbRctkfQ/XYLrBOO70=
X-Received: by 2002:a05:7022:4591:b0:123:3488:89a3 with SMTP id a92af1059eb24-1278fc24c3amr4689181c88.24.1772489753735;
        Mon, 02 Mar 2026 14:15:53 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.124.134])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12789a43a18sm19182815c88.13.2026.03.02.14.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 14:15:53 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 2 Mar 2026 15:15:50 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Message-ID: <aaYMFrii2n0ZhkeR@fedora64.linuxtx.org>
References: <20260302160834.2518716-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:08:34AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
