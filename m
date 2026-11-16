Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.194.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840783;
	b=wpKaGYduuPLb6G5OQmMoBgnTBGdRlymu14AcgsrDMCerP4q+HbXqRKdGLx3BxaZTPufD
	 rVhaoqhJXRlqM0h11GovdffHBEQCq3sOP7zcQQtLvhZIz0rpqd1e3STjyJ66e+oDTduBb
	 f5P/Lbh8YmQjUO7eF+1ae6gTeWHd0JIoD3H/HCMzYiLTrACIl4oYyJr/H/cFqcY2H4Xyr
	 txgvuLAUSKt4WUgBjKNAD5bwIq7GtQMxQm4N2l5S3zAIU4cKPdVK5IRYEeQDsvO7gvSsO
	 OLZ2uAwuUb/VBjGMpSdPXmBRW9Oz2um5c6CvKqpfXaDfIPKpl02Mr20R0gBg2MhiqkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840783;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=kCbDs/PTZqvVl29463lZKPYGGkvJ4rxM+gPSBP9h9Ac=;
	b=CZG6Tnul14smanAe1ElDBmLnWiiSYl26TCY/HJhhrijoahEo7DF8ETa6zTAm4Ajp5GCv
	 6TOyz69tYMbqsPeO6uuyI4wCBm0V0urWfG9uf5SRD4aGtT92/85OadLQRW3fFdqsOAQIT
	 009gii/SuNv9F9VZpB0w2RcA0M6e2sIhfbeoSuXGgWMhoyGFQZxkBzIQ+NmIFePMqnKMP
	 COHeV0hY1iP4n9tTjL5JsS//TtTtucSYalctMAi+ipiJG6/SDdXzyvWarg3r2up3nc+q4
	 mtaB3kuZX56WlwtM9ebdHzpGPi85AjvT6g/YedMg4hmZrr6BOIpClkHUZ9RIxGXRAJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dolcini.it;
	spf=pass smtp.mailfrom=dolcini.it;
	dkim=pass header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=MpUJhYH9;
	arc=none smtp.remote-ip=217.194.8.81
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1230606A338
	for <patches@lists.linux.dev>; Mon, 16 Nov 2026 14:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1230606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=MpUJhYH9
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 8A9E122748;
	Mon, 16 Nov 2026 15:52:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1794840779;
	bh=kCbDs/PTZqvVl29463lZKPYGGkvJ4rxM+gPSBP9h9Ac=; h=From:To:Subject;
	b=MpUJhYH9MV9F3UKvchqP+e6+KXOHLRNG1BlD6d/w78+7Hhdw+RjUT4Qjlbqd8OZoS
	 Uge4wu82UAor1rjuEt/SSz+dQtbLEYhqMoUeXF9l1Q9psnTRdQabYy0+8eDio+mnmz
	 RrDH7lUXM9qRVyNbJ/GzIWF91ZiuT0TJeXo6bSIMzGXELXpXMvHxV93Yg6c0s4V1y2
	 O+/JqbVgeje6j8R/SE5neglopxid3aXj5fLk5ogwtIbHyrSwAEvwFIKToJJLsTwT6I
	 RUwlSBudy1q6ElAHL4Ow954mkIYISsrzc04AlPxMxcjW+k5xKMYLD+O79t9c8Jojvi
	 nswMH9F7C27wg==
Date: Mon, 16 Nov 2026 15:52:54 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
Message-ID: <20261116145254.GA198694@francesco-nb>
References: <20261113153820.902362109@linuxfoundation.org>
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
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>

On Fri, Nov 13, 2026 at 10:42:13AM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

