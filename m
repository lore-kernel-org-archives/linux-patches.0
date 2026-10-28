Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217297;
	b=CqJBL25Sp11dvWJDz4nqDc6M7y8bpYZPKnFlTHXMK3mj3e5jCg0BN+tNVcArvu+HUuNn
	 6X9+XhhES0d4d+gMGVjkqRVwV639kL9AHHVeLiI1TcxQVvzixprtmKjxix6kOzXM7iqLw
	 uHQpsJICniAjAbhbC+veVqmH+hm1VzTAkQ4T4G4/OgseO70h86R+PvKoHD6RN/nL/lXua
	 0EkMR7mGoZUsSqJz3CTGZ2HCxq8qWacp6/84EhXod8EAmFxcY/LNKG+CKVncliarP3p7g
	 y/P61nmfPIEkjFTrXp4muPh3zyWRXOUw+ByqIYGbdgR2FPQBsgFKUEi2YGJiWZ+L43A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217297;
	h=DMARC-Filter:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OR4OZ/CVOhQxo2iXfRtr54IOD3jUJSSNnHR4jkZg3cg=;
	b=B1kbHfzJSTtf60TrU2ODgqfFAtD252aCtP7HyV4SytgWNCxtfxaVX0sJNzHc85KKFb34
	 lGVs88LNqpzA5yA6hbttvCM69b4kLcEfCa1UQh0CEckZBpgZ7vBLfW29H80Z5dIDvzWqc
	 LSoXgaGq1ks+7rI2ezopSvyJHUGF4NOM2pLasLWeBJY7GfSLSSptL21rSuBdMk/K+toHk
	 MPjGTprwlloNWYuDYqnhMKsFnWQLLsG0KT30zxzeiz//nOoClpMeZk38WTwsu/UJzIUKO
	 9aMowPJH3aToz3PLw8pceXUApgksRpa9mm9emppOEgWjzJVD9EhMlp/QBGQT861W7wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36458606A31C;
	Wed, 28 Oct 2026 19:54:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36458606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Wed, 28 Oct 2026 20:54:49 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Message-ID: <auJTCcqMDEmAS7Q_@karahi.librecast.net>
References: <20261028170459.200466217@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>

On 2026-10-28 17:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build failure on amd64 with amdgpu:

  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
  AR      drivers/gpu/built-in.a
  AR      drivers/built-in.a
make: *** [Makefile:2040: .] Error 2

No time to bisect just now but will try to have a look tomorrow.


-- 
Brett Sheffield (he/him)
