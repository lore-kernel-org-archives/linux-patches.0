Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813DA360722
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770994488; cv=none; b=sZm3XyaAt7LhCdbMRXZ0idMWuHK6h2cuB89cdpBNnOc4CV4lrw/9yyo9vBFXENi4DQBsMEafa5FwEjJBg9K1lsAKJYBhkNcGd7aXUIrHdTJsxiWapvklJclSEIKpWT0uOxEgEDobcvDppS0voGuWAmKo6zmuXeCCE75YQaRe1aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770994488; c=relaxed/simple;
	bh=rCQXCA4sOgMqBuNz9h5ym+EIqDPcH2T+bV5q70m5J84=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ZRfE14p5DRew6natpH8/4AY7FEgGk9CtIkSvHaDW3jH+hVtyfxKPDN/SPPhR4nau+qguRwmvRx/xMM4xIYY3W7ph4GpmJkzg2PqnFBYHOrowhIoGAIF5Ng79bd6jdOZIB9J4qGN8LuAvPiT2BSH+nsipn7+EsegaOO0CJpuZ+uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=ROlp6K7b; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="ROlp6K7b"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 8FE239A2A07
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1770994099; h=date:message-id:subject:from:to;
	bh=rCQXCA4sOgMqBuNz9h5ym+EIqDPcH2T+bV5q70m5J84=;
	b=ROlp6K7b2TW757tVGpMlY/IM75wHugAecNv2XzrEviC/XCoz0VL9j7UcAT1VZzBW8+fTJ/TD/W1
	zPX7WnSnOGIXT+mQIV6F+aFdPdANj/+mYoUWZYPxzYDdCzXOGa0gFIbSrWwIPfKTrw8noMw0cjydy
	HO10CP2yi3I+OFy6vS9+BYd4mecYbklllI4LNoWnhT1U8K3IvsnbW+x+f4AjFdk4wcrMWerZ1pkj3
	KdL+mRknINFm7IBJELJpFC+muSnhuFLfkyIAHxOxelrWSBX0u8jfEXNO8qIcazWKNopL5aZWdOVzC
	XZDZHtQIfonL/mh+VbSw9Xjug5zsT8lhG/Jw==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Feb 2026 15:48:19 +0100
Message-Id: <DGDX0HGRJJ3N.1F1EWJEDMYZND@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
 <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>,
 <sr@sladewatkins.com>
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0
References: <20260213134708.713126210@linuxfoundation.org>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Fri Feb 13, 2026 at 2:47 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-=
rc1.gz

Hey, the link to this patch (and all other stable-review patches from
today) seem to be not uploaded yet. Is this expected?

> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h=
