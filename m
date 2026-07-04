Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C572E65D;
	Sat,  4 Jul 2026 02:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783131077; cv=none; b=AWEqqjoI6kIbUBv2p8rlOPCY/l6LxrBx1+LTdu1tXDrvSQ71DebyG7hYsNOPIm6eLZNc7RYVWTkHb8WDmlfKEi5aM9CrbmBrgSoKjzwGN4Pj26QrZXlBkuf/2uEQzahxlTLvFutq+tC3cWNkHPcyYpwjQOdkNHRnucrgkxx0yMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783131077; c=relaxed/simple;
	bh=OWLVyy5iVXF+/BCarDTNY5fL3X3/Nu8KuBdwOwZ+Jj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOho1HW1T8t72KwkxxH1IKu7cDHdkDwib3GSV/tiXJi/jf9h+IoK0iDNkh73MZ1oM/fNgiPOUZpftQSLRPg1hF2ofOdvWS0XFOTP6LNVU+/6bePVvrvwUXuF6Rty4CJhwR7wr9+ZfiPfdba5pn0JCnveHig2QTfgH/EODHQtHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqaCyY6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqaCyY6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB021F000E9;
	Sat,  4 Jul 2026 02:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783131076;
	bh=xhQY18Ntme9FlKB+cK+S+3z1nmjM9W9PAf7ZIqw/HH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqaCyY6aczkOTUO+7XwLYq8IYMP0z+bBj6J7Dj2myZmZOiM04WrOrMqpq+exdFp0i
	 kKBd6sEFfJuCw9hKRF/aOj79XWbUJ7RZ9oggXuminPuK2HQ+xK46sTcFgDL7lN2PIl
	 o9++rMi/MTum5yibTfirmVrRluY2vONjDxCRnLpeW9yK9W5iNY47EAKlQVzLRuAi7Y
	 xqnc7cXOhK6eI7yREUWSBoLaCMY9smw//MWxjC6CxrrKIFnx9lvxObkbgOCKN5s2to
	 6XC2ICyav2MJFmECytIHj06Hfv8+9rmYcy+7OKNTFCN3c4YfFH6wT7KMtY4bl1sMFW
	 gbkltOrkZwYRA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 000/109] 6.18.38-rc2 review
Date: Sat,  4 Jul 2026 04:10:29 +0200
Message-ID: <20260704021029.56070-1-ojeda@kernel.org>
In-Reply-To: <20260703072816.644513463@linuxfoundation.org>
References: <20260703072816.644513463@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 03 Jul 2026 09:36:06 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.38 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:03 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
