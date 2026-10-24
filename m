Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.227.220.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857669;
	b=o4JHfnWV3ZrY34CPxAnsv6auZcFTpUhzEQ7V9My3hdXDgyH2PqfOEY8jEhxhlWHqdOX/
	 GTvUGF1cOcXxRnLgxi4FpYuPOWGkJfmL8eKMZL/F4k3X0hC/DUbYiggphHbdHuc4aNHVZ
	 t7JvG//tUirCa2RmIHuHfdbPKFpRTZyYyr49g0p40K8czetHBvDpKUp3lgaGG8WmDGync
	 m/ggViS0wrA3O1O19knsVtJjYA6HXAUHPNgDPzXBuxfLSD5PkHbclEPGrZ/e6koXttrXa
	 Ri6islapo/pmjlaMHSL7auTO/lYP/HF3iVKj3NLo+ztVpaZMkFWm1ut/wlbZaSVi7fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857669;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=9VUWNDXDLWI22LfuE127DRMY8CKNuNe10EKH85xtJTk=;
	b=JD2yAq6jV8TZhrU14SpOWWhHwSIqoxG/ZMwEqnxFewSp/khqSBIIwAYqX8J1Ohdcz6lc
	 nEZIKSWoAnjniZkY4ens9XKppXzMhuUv0C/yqLjNiUwN/FY2mBX4rIyhy3YD4cNkNyzF5
	 2ryifGMTZVjr3YX+Oi1GC4sJUdj4p+1g4EcX3L+lxs+X/OyGVcP9svrCF0i5t7bh7zxpm
	 Pe4YvilFexKdlMA93hibgub+7MXF67yXdZiu/TsVk4ESJAdO1/ipP2z7jKy8VP+uP8QBy
	 chkJNpJmcxgte6fiY381MrZ5l/Gq8MzwEsgjCAmUjyachyvk+XOk3F5HpdkDQUCMn7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mareichelt.com;
	spf=pass smtp.mailfrom=mareichelt.com;
	dkim=pass header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=Lk13lX6P;
	arc=none smtp.remote-ip=91.227.220.155
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0309606A31D
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 16:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0309606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=Lk13lX6P
Date: Sat, 24 Oct 2026 18:01:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1792857661;
	bh=9VUWNDXDLWI22LfuE127DRMY8CKNuNe10EKH85xtJTk=;
	h=Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:date:
	 author:from:to:subject:message-id:in-reply-to:references:
	 mail-followup-to:openpgp:mime-version:content-type:
	 content-transfer-encoding:author:from:subject:date:to:cc:
	 resent-author:resent-date:resent-from:resent-sender:resent-to:
	 resent-cc:resent-reply-to:resent-message-id:in-reply-to:references:
	 mime-version:content-type:content-transfer-encoding:
	 content-disposition:content-id:content-description:message-id:
	 mail-followup-to:openpgp;
	b=Lk13lX6Peb3CVxp31jW/R8xFQ3uESvBFrzfXKqYsrd9zO3mqjoHttPawGAyf7cw0F
	 3U9bkGrhNm+etlfr1Cax+JG/i0RNFL2hKcEamFn/Sznuu5tdFrSoA+skbGfYalmczy
	 CTdnUjzTgQe4hTKKa1uIXwhlvTNfyRJFMFSFposzTR9oLvb7tjCpz0DNHSkIuf+1gb
	 nDH2YibxLyOAD9tIEvEGJyCegL2DsnngKgVER2kdN3h+qmsRfIzY1WJIwbkhP3Wq7G
	 bh3PQBpFMhys4HuNmkloi84bMSWIzwy57OicKqgOYqOFGmPJ2fcttMow5nBKRVSWjs
	 QuDKwF+sPJ4ng==
From: Markus Reichelt <lkt+2023@mareichelt.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Message-ID: <20261024160100.GA4792@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
References: <20261024064731.125251200@linuxfoundation.org>
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
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.

7.2.13-rc2 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
