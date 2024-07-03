Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890701DA313;
	Wed,  3 Jul 2024 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032171; cv=none; b=AIfcDtKf8KSl4ndKhkTnZWDMTwio46ywqG6uDhkQPqjxIoXVg5quXqsFJfzUlwKxBv/DrYfvyPtqEs2opbmrB3Nl8q/MxDu4lg5OZMT+Am2/kl5vvNlUbcfKU+NkmBUuJfpMQfkMCJvZEU4gk4FJgI5y1i6K2wf7gsV44fuzuao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032171; c=relaxed/simple;
	bh=OEcfoHYg331SnTSBIr49/Lcvpui+wt3h6L8IrnhUas0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YIlqSB68LvMxJ7mNrrnIQQsCMWFmT8fD5rr5tokzDM49xshXpq8lZFh+pDZE4G45jC2TJeefvXIokkdtJO/MMuA+6f9fjaEs+hoxh0//faniVrMaglv1lI4Bq3lBthv46VXmuYcQraD907f2PwikDQ997hrSJFoWlKmF0kTlFi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=FMY1lUHY; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="FMY1lUHY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hlu2sr8vi+BtevOGugMkazgCQNpMIBu84AwosKjyodE=; t=1720032167; x=1720636967; 
	b=FMY1lUHYO7l6EjS5UFPxqbKvnkELtNGHRRoLjzTOsLz9ssTiHrfIUZJXcuL9JvvX+/TJEDQsk6S
	VNOoQo7Sk6hFqD1QkJu53/c4EbL9NrGSDVF80lgcXU1EicwDM8nJpIzbQgzSYoSJ/SId3uDfEYH/s
	Y8LunTOGjSRS/IZFTJgKslWm5391mcFR3KeVQf03pe2AwRdkw6BJ3ZdlCFj+Gub09Ai79PRMFctXO
	e8tGngaGE2y6boO5glZEF+AQTB4BKUyslodrr7j4Y/EHIbwNstSDlaSJvq16Sc6rx9U5fZb9kxlXc
	G5QYJK8FJqvyo6aqFQGPjHJLT4Ch1MlTKC6w==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.97)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1sP4wF-000000039OK-3g9K; Wed, 03 Jul 2024 20:42:43 +0200
Received: from p5b13a475.dip0.t-ipconnect.de ([91.19.164.117] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.97)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1sP4wF-0000000070P-2WuS; Wed, 03 Jul 2024 20:42:43 +0200
Message-ID: <c497d1abee4bf37663488c3a80e042a25303c0c4.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Arnd Bergmann <arnd@arndb.de>, Naresh Kamboju
 <naresh.kamboju@linaro.org>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>,  Andrew Morton
 <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, shuah
 <shuah@kernel.org>,  patches@kernelci.org, lkft-triage@lists.linaro.org,
 Pavel Machek <pavel@denx.de>,  Jon Hunter <jonathanh@nvidia.com>, Florian
 Fainelli <f.fainelli@gmail.com>, Sudip Mukherjee
 <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, rwarsow@gmx.de, Conor
 Dooley <conor@kernel.org>, Allen <allen.lkml@gmail.com>, Mark Brown
 <broonie@kernel.org>,  Dan Carpenter <dan.carpenter@linaro.org>, Anders
 Roxell <anders.roxell@linaro.org>, Linux-sh list
 <linux-sh@vger.kernel.org>, Rich Felker <dalias@libc.org>
Date: Wed, 03 Jul 2024 20:42:42 +0200
In-Reply-To: <72ddde27-e2e2-4a46-a2ab-4d20a7a9424f@app.fastmail.com>
References: <20240703102841.492044697@linuxfoundation.org>
	 <CA+G9fYvAkELSdWF1EYyjS=d_jvCJD0O=aPnZFHUGnhYy6c1VCg@mail.gmail.com>
	 <72ddde27-e2e2-4a46-a2ab-4d20a7a9424f@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Arnd,

On Wed, 2024-07-03 at 20:34 +0200, Arnd Bergmann wrote:
> Rich and Adrian, let me know if you would submit a
> tested backport stable@vger.kernel.org yourself, if you
> want help backporting my patch, or if we should just
> leave the existing state in the LTS kernels.

I think it's safe to keep the existing state in the old LTS kernels
as most SH users will be on the latest kernel anyway.

Thanks,
Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
